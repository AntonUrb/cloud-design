#!/bin/bash

nohup /usr/local/bin/initial_queue_setup.sh > /var/lib/rabbit-queue/logfile.log 2>&1 &

#Start rabbitMQ server
rabbitmq-server


