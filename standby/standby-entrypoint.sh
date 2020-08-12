#!/bin/bash

echo "Going to take base backup..."

sleep 2s

until pg_basebackup --pgdata=${PGDATA} --format=p --write-recovery-conf --checkpoint=fast --label=mffb --host=pg_primary --port=${PG_PRIMARY_PORT} --username=postgres
	do
		echo "Waiting for standby to connect to primary for basebackup ..."
		sleep 2s
done

echo "Base backup done..."

echo "Going to modify pg_hba.conf file..."

echo "host all all 0.0.0.0/0 trust" >> "${PGDATA}/pg_hba.conf"
echo "host replication all 0.0.0.0/0 trust" >> "${PGDATA}/pg_hba.conf"

echo "pg_hba.conf files modified..."

echo "Going to create replication slot on primary..."

until psql --command="SELECT * FROM pg_create_physical_replication_slot('node_a_slot')" --host=pg_primary --port=${PG_PRIMARY_PORT} --username=postgres --dbname=postgres
	do
		echo "Waiting for psql to connect to primary for creating replication slot ..."
		sleep 2s
done

echo "Replication slot created...."

set -e


echo "Going to modify postgresql.conf..."

cat >> ${PGDATA}/postgresql.conf <<EOF

port=7432
hot_standby = on
primary_conninfo = 'user=${PG_REP_USER} password=abc123 host=${PG_PRIMARY_HOST} port=${PG_PRIMARY_PORT}'
primary_slot_name = 'node_a_slot'
log_connections = on
log_disconnections = on
log_statement = 'all'
log_replication_commands = on


EOF


echo "postgresql.conf modified..."

chown postgres:postgres ${PGDATA}
chown postgres:postgres ${PGDATA} -R
chmod 700 ${PGDATA} -R

exec "$@"

echo "Ready to run standby..."

