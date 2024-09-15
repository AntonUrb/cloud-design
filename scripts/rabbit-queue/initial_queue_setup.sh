#!/bin/bash

# Wait for the server to be functional before running commands
# Retry loop for RabbitMQ
echo "Waiting for RabbitMQ to start..."
until rabbitmqctl status &>/dev/null; do
    sleep 1
done

# Starting RabbitMQ app
echo "RabbitMQ running, starting app"
rabbitmqctl start_app

# Creating users
if rabbitmqctl list_users | grep -q '^admin\b'; then
    echo "User '${QUEUE_UNAME}' already exists."
else
    echo "User '${QUEUE_UNAME}' does not exist. Creating user..."

    rabbitmqctl add_user ${QUEUE_UNAME} ${QUEUE_PASSW}
    rabbitmqctl set_user_tags ${QUEUE_UNAME} administrator
    rabbitmqctl set_permissions -p / ${QUEUE_PASSW} '.*' '.*' '.*'
fi


