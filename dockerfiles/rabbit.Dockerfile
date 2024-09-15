# Use the Debian base image
FROM debian:bullseye

ARG QUEUE_SCRIPT_PATH

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y gnupg2 curl wget lsb-release apt-transport-https

ENV QUEUE_UNAME=${QUEUE_UNAME}
ENV QUEUE_PASSW=${QUEUE_PASSW}

# Add Rabbitmq signing key, add erlang
RUN curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | gpg --dearmor | tee /usr/share/keyrings/com.rabbitmq.team.gpg > /dev/null
RUN curl -1sLf https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key | gpg --dearmor | tee /usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg > /dev/null

# Add Rabbitmq server
RUN curl -1sLf https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key | gpg --dearmor | tee /usr/share/keyrings/rabbitmq.9F4587F226208342.gpg > /dev/null

# Update repositories and install Erlang and RabbitMQ
RUN apt-get update -y

RUN apt-get install -y erlang-base \
    erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
    erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
    erlang-runtime-tools erlang-snmp erlang-ssl \
    erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl

RUN apt-get install rabbitmq-server -y --fix-missing

# Enable RabbitMQ management plugin
RUN rabbitmq-plugins enable rabbitmq_management

# Copy entrypoint script
COPY ${QUEUE_SCRIPT_PATH}/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ${QUEUE_SCRIPT_PATH}/initial_queue_setup.sh /usr/local/bin/initial_queue_setup.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/initial_queue_setup.sh

# Execute entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]