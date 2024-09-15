#check if database already configured

if [ ! -d "/var/lib/postgresql/13/main/" ]; then

    mkdir -p /var/lib/postgresql/13/main

    # Init the database
    echo "Initialising database"
    /usr/lib/postgresql/13/bin/initdb -D /var/lib/postgresql/13/main/

    #Start postgresql
    echo "Starting postgresql"
    /etc/init.d/postgresql start

    # Enable the PostgreSQL public access
    echo "Enabling public access"
    psql --command "ALTER USER postgres WITH PASSWORD '$POSTGRES_PASSWORD';"

    # Create a new user and database
    echo "Creating new user: $POSTGRES_USER and database: $POSTGRES_DB"
    psql --command "CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD';" &&\
    createdb -O $POSTGRES_USER $POSTGRES_DB

    # Enable public access
    echo "Setting listening address to '*'"
    echo "listen_addresses='*'" >> /var/lib/postgresql/13/main/postgresql.conf

    # Enable public access
    echo "Setting up pg_hba.conf"
    echo "host  $POSTGRES_DB  $POSTGRES_USER 0.0.0.0/0 md5" >> /var/lib/postgresql/13/main/pg_hba.conf
fi

/etc/init.d/postgresql stop

/usr/lib/postgresql/13/bin/postgres -D /var/lib/postgresql/13/main