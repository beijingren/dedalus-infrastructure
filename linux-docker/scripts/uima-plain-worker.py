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
        print " [ ] Sending response"
        channel.basic_publish(exchange='',
                              routing_key=props.reply_to,
                              properties=BasicProperties(correlation_id=props.correlation_id),
                              body=response)
        channel.basic_ack(delivery_tag=method.delivery_tag)

    # Try to decode JSON payload
    try:
        uima = json.loads(body)
        text = uima['text']
        mode = uima['mode']
    except (ValueError, KeyError):
        send_response("ERROR")
        return

    f = tempfile.NamedTemporaryFile(delete=False)
    f.write(text.encode('utf-8'))
    f.close()

    start_uima = time.time()
    result = subprocess.call(["/usr/bin/java", "-Dfile.encoding=UTF-8",
                              "-Djava.util.logging.config.file=/docker/bertie-uima/src/main/properties/Logger.properties",
                              "-jar", BERTIE_JAR,
                              "--plain",
                              "--file", f.name,
                              "--owl", "/docker/dublin-store/rdf/sikuquanshu.owl",
                              "--mode", mode])
    done_uima = time.time()
    print "RUNTIME"
    print done_uima - start_uima

    # Read the result back
    f2 = open(f.name, 'r')
    result = f2.read().decode('utf-8')

    send_response(result)

    # Remove tempfile
    os.unlink(f.name)


if __name__ == "__main__":
    #
    # Find rabbitmq server
    #
    try:
        rabbitmq_host = os.environ['RABBITMQ_PORT_5672_TCP_ADDR']
    except KeyError:
        print "Can't find rabbitmq server. Giving up."
        print "Please set RABBITMQ_PORT_5672_TCP_ADDR."
        sys.exit(-1)

    connection = BlockingConnection(ConnectionParameters(host=rabbitmq_host))
    channel = connection.channel()
    channel.queue_declare('uima_plain_worker')
    channel.basic_consume(uima_callback, queue='uima_plain_worker')

    print " [x] Awaiting RPC UIMA requests"
    channel.start_consuming()
