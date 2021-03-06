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

from eulexistdb.db import ExistDB


BERTIE_JAR = "/docker/bertie-uima/target/bertie-uima-0.0.1-SNAPSHOT.jar"


def uima_callback(channel, method, props, body):

    def send_response(response):
        print " [ ] Sending response"
        channel.basic_publish(exchange='',
                              routing_key=props.reply_to,
                              properties=BasicProperties(correlation_id=props.correlation_id),
                              body=response)
        channel.basic_ack(delivery_tag=method.delivery_tag)

    # Try to decode JSON payload
    try:
        uima = json.loads(body)
        function = uima['function']
        text = uima['text']
        lemma = uima['lemma']
        collection_path = uima['collection_path']
        juan = int(uima['juan'])
    except ValueError, KeyError:
        send_response("ERROR")
        return

    print " [x] Received " + lemma

    # This could be a fake crawler request
    if not lemma or len(lemma) == 1 or not collection_path:
        return

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
    owl_file = open("/docker/dublin-store/rdf/owl_fragment.owl")
    owl_fragment = owl_file.read().decode('utf-8')
    owl_fragment = owl_fragment.format(persname=persname, placename=placename, term=term)

    f = tempfile.NamedTemporaryFile(delete=False)
    f.write(owl_fragment.encode('utf-8'))
    f.close()

    devnull = open(os.devnull, 'w')

    # Update repo before change
    os.chdir(collection_path)
    subprocess.call(["ssh-agent", "bash", "-c", "ssh-add /docker/github_rsa ; /usr/bin/git pull;"],
            stdout=devnull, stderr=devnull)


    # Call UIMA analysis engine
    if not juan == -1:
        file_name = os.path.join(collection_path, "%03d.xml" % (juan,))
        result = subprocess.call(["/usr/bin/java", "-Dfile.encoding=UTF-8",
                                  "-Djava.util.logging.config.file=/docker/bertie-uima/src/main/properties/Logger.properties",
                                  "-jar", BERTIE_JAR,
                                  "--tei",
                                  "--file", file_name,
                                  "--owl", f.name], stdout=devnull, stderr=devnull)

        # Reload single document for faster response
        xmldb = ExistDB(server_url="http://admin:glen32@" + existdb_host + ":8080/exist", timeout=10)
        db_collection_path = 'docker/texts/' + \
             collection_path.replace('/docker/dublin-store/', '')
        with open(file_name) as newly_annotated_file:
            print " [ ] Reloading single document"
            try:
                xmldb.load(newly_annotated_file, os.path.join(db_collection_path, os.path.split(file_name)[1]), True)
            except:
                print "FAILED TO LOAD " + file_name

        # Send response early
        send_response("OK")

    start_uima = time.time()
    result = subprocess.call(["/usr/bin/java", "-Dfile.encoding=UTF-8",
                              "-Djava.util.logging.config.file=/docker/bertie-uima/src/main/properties/Logger.properties",
                              "-jar", BERTIE_JAR,
                              "--tei",
                              "--directory", collection_path,
                              "--owl", f.name], stdout=devnull, stderr=devnull)
    done_uima = time.time()
    print "RUNTIME"
    print done_uima - start_uima

    # No single juan was annotated, so send response now
    if juan == -1:
        send_response("OK")

    # Remove tempfile
    os.unlink(f.name)

    # Commit the mess
    subprocess.call(["/usr/bin/git", "commit", "-m", "UIMA " + lemma, "."], stdout=devnull, stderr=devnull)
    subprocess.call(["ssh-agent", "bash", "-c", "ssh-add /docker/github_rsa ; /usr/bin/git push;"],
            stdout=devnull, stderr=devnull)

    # TODO: move this into a watchdog container for automatic reload of changed documents
    # Reload collection
    print " [ ] Reloading collection"
    os.chdir('/docker/dublin-store/')
    xmldb = ExistDB(server_url="http://admin:glen32@" + existdb_host + ":8080/exist", timeout=10)
    for (dirpath, dirnames, filenames) in os.walk(u'浙江大學圖書館'):
        if dirpath.endswith(unicode(text)):
            for filename in filenames:
                with open(os.path.join(dirpath, filename)) as f:
                    #print os.path.join(dirpath, filename)
                    try:
                        xmldb.load(f, os.path.join('docker', 'texts', dirpath, filename), True)
                    except:
                        print "FAILED TO LOAD " + filename

    print " [x] Awaiting RPC UIMA requests"

if __name__ == "__main__":
    #
    # Find rabbitmq server
    #
    try:
        rabbitmq_host = os.environ['RABBITMQ_PORT_5672_TCP_ADDR']
        existdb_host = os.environ['XMLDB_PORT_8080_TCP_ADDR']
    except KeyError:
        print "Can't find rabbitmq server. Giving up."
        print "Please set RABBITMQ_PORT_5672_TCP_ADDR, XMLDB_PORT_8080_TCP_ADDR ."
        sys.exit(-1)

    connection = BlockingConnection(ConnectionParameters(host=rabbitmq_host))
    channel = connection.channel()
    channel.queue_declare('uima_worker')
    channel.basic_consume(uima_callback, queue='uima_worker')

    print " [x] Awaiting RPC UIMA requests"
    channel.start_consuming()
