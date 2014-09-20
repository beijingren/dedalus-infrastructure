#!/usr/bin/env python

import os
import sys

from pika import BasicProperties
from pika import BlockingConnection
from pika import ConnectionParameters


def uima_callback(channel, method, properties, body):
    print " [x] Received %r" % (body,)

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
