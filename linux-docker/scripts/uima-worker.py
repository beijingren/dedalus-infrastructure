#!/usr/bin/env python
# coding=utf-8

import json
import os
import subprocess
import sys
import tempfile
import time

from pika import BasicProperties
from pika import BlockingConnection
from pika import ConnectionParameters


BERTIE_JAR = "/docker/bertie-uima/target/bertie-uima-0.0.1-SNAPSHOT.jar"


def uima_callback(channel, method, props, body):
    print " [x] Received %r" % (body,)

    def send_response(response):
        print "Sending response..."
        channel.basic_publish(exchange='',
                              routing_key=props.reply_to,
                              properties=BasicProperties(correlation_id=props.correlation_id),
                              body=response)
        channel.basic_ack(delivery_tag=method.delivery_tag)

    # Try decode JSON
    try:
        uima = json.loads(body)
    except ValueError:
        send_response("ERROR")
        return

    function = uima['function']
    text = uima['text']
    lemma = uima['lemma']
    collection_path = uima['collection_path']

    # Dummy elements
    # TODO: annotations should handle emtpy result properly
    placename = u'廬陵'
    persname = u'蘇舜欽'
    term = u'節度使'

    # Check for know functions and assign lemma
    if function == 'persname':
        persname = lemma
    elif function == 'placename':
        placename = lemma
    elif function == 'term':
        term = lemma
    else:
        send_response("ERROR")
        return


    # Build owl
    owl_file = open("/docker/dublin-store/rdf/owl_fragment.rdf")
    owl_fragment = owl_file.read().decode('utf-8')
    owl_fragment = owl_fragment.format(persname=persname, placename=placename, term=term)

    f = tempfile.NamedTemporaryFile(delete=False)
    f.write(owl_fragment.encode('utf-8'))
    f.close()

    # Update repo before change
    os.chdir(collection_path)
    subprocess.call(["ssh-agent", "bash", "-c", "ssh-add /docker/github_rsa ; /usr/bin/git pull;"])

    # Call UIMA analysis engine
    start_uima = time.time()
    result = subprocess.call(["/usr/bin/java", "-Dfile.encoding=UTF-8", "-jar", BERTIE_JAR,
                              "--tei",
                              "--directory", collection_path,
                              "--owl", f.name])
    done_uima = time.time()
    print done_uima - start_uima

    # Remove tempfile
    os.unlink(f.name)

    # Commit the mess
    subprocess.call(["/usr/bin/git", "commit", "-m", "UIMA " + lemma, "."])
    subprocess.call(["ssh-agent", "bash", "-c", "ssh-add /docker/github_rsa ; /usr/bin/git push;"])

    send_response("UIMA")

if __name__ == "__main__":
    #
    # Find rabbitmq server
    #
    try:
        rabbitmq_host = os.environ['RABBITMQ_PORT_5672_TCP_ADDR']
    except KeyError:
        print "Can't find rabbitmq server. Giving up."
        sys.exit(-1)

    connection = BlockingConnection(ConnectionParameters(host=rabbitmq_host))
    channel = connection.channel()
    channel.queue_declare('uima_worker')
    channel.basic_consume(uima_callback, queue='uima_worker')

    print " [x] Awaiting RPC UIMA requests"
    channel.start_consuming()
