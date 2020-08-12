#!/bin/bash

PG_REP_USER=harry

echo "Going to modify pg_hba.conf file..."

echo "host all all 0.0.0.0/0 trust" >> "${PGDATA}/pg_hba.conf"
echo "host replication all 0.0.0.0/0 trust" >> "${PGDATA}/pg_hba.conf"

echo "pg_hba.conf files modified..."

echo "Going to create replication user on primary..."

set -e
psql -v ON_ERROR_STOP=1 --username=postgres --dbname=postgres <<-EOSQL
    CREATE USER $PG_REP_USER REPLICATION LOGIN;
EOSQL

echo "Replication user created...."

echo "Going to modify postgresql.conf..."

cat >> ${PGDATA}/postgresql.conf <<EOF

max_wal_senders = 10
wal_level = replica
max_replication_slots = 10
synchronous_commit = on
synchronous_standby_names = '*'
listen_addresses = '*'
port = 6432
log_connections = on
log_disconnections = on
log_statement = 'all'
log_replication_commands = on

EOF

echo "postgresql.conf modified..."

echo "Ready to run primary..."
