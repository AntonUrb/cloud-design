FROM debian:bullseye

ARG DB_SCRIPT_PATH

RUN apt-get update && apt-get install -y postgresql-13 postgresql-contrib

USER postgres

RUN rm -rf /var/lib/postgresql/13/main

COPY ${DB_SCRIPT_PATH}/init_db.sh /tmp/init_db.sh

ENTRYPOINT [ "bash", "/tmp/init_db.sh" ]