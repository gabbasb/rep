FROM postgres:12.3

# The PostgreSQL image provides this directory for additional initialization scripts
COPY setup-primary.sh /docker-entrypoint-initdb.d/setup-primary.sh

RUN chmod 0666 /docker-entrypoint-initdb.d/setup-primary.sh
