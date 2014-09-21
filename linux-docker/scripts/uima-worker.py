#!/usr/bin/env python
# coding=utf-8

import json
import os
import sys
import tempfile
import subprocess

from pika import BasicProperties
from pika import BlockingConnection
from pika import ConnectionParameters


BERTIE_JAR = "/docker/bertie-uima/target/bertie-uima-0.0.1-SNAPSHOT.jar"


def uima_callback(channel, method, props, body):
    print " [x] Received %r" % (body,)

    uima = json.loads(body)

    function = uima['function']

    if not function == 'persname' and not function == 'placename' and not function == 'term':
        response = "ERROR"
    else:
        text = uima['text']
        lemma = uima['lemma']
        collection_path = uima['collection_path']

        # Dummy elements
        placename = u'廬陵'
        persname = u'蘇舜欽'
        term = u'節度使'

        if function == 'persname':
            persname = lemma
        elif function == 'placename':
            placename = lemma
        else:
            term = lemma

        # Build owl
        owl_file = open("/docker/dublin-store/rdf/owl_fragment.rdf")
        owl_fragment = owl_file.read().decode('utf-8')
        owl_fragment = owl_fragment.format(persname=persname, placename=placename, term=term)

        f = tempfile.NamedTemporaryFile(delete=False)
        f.write(owl_fragment.encode('utf-8'))
        f.close()

        # Call UIMA analysis engine
        result = subprocess.call(["/usr/bin/java", "-Dfile.encoding=UTF-8", "-jar", BERTIE_JAR,
                                  "--tei",
                                  "--directory", collection_path,
                                  "--owl", f.name])
        # Remove tempfile
        os.unlink(f.name)

        response = "UIMA"

    channel.basic_publish(exchange='',
                          routing_key=props.reply_to,
                          properties=BasicProperties(correlation_id=props.correlation_id),
                          body=response)
    channel.basic_ack(delivery_tag=method.delivery_tag)

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
