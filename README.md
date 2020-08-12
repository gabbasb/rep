# rep
Primary and Standby server configured for physical replication using official PostgreSQL 12.3 docker image.  
  Primary runs on port 6432 and the standby on 7432.  
  The host can connect to both the primary and the standby servers.  
  
  To build and run use the following commands:  
  
  docker container stop $(docker container ls -aq)  
  docker container prune -f  
  docker network prune -f  
  docker volume prune -f  
  docker image prune -f  
  docker image prune -a -f  
  docker system prune -f  
  docker system prune --volumes -f  
  
  docker container ls -a  
  docker images  
  docker volume ls  
  docker network ls  
  
  docker-compose build --no-cache  
  docker-compose up -d  
  docker-compose ps  
  docker logs rep_pg_primary_1  
  docker logs rep_pg_standby_1  
  
  To test use thf following commands  
  
  abbas@ubuntu:~/Projects/rep$ psql -p 6432 postgres -U postgres -h localhost  
  psql (9.5.21, server 12.3 (Debian 12.3-1.pgdg100+1))  
  
  postgres=# CREATE TABLE nums(num int, detail varchar(255));  
  CREATE TABLE  
  postgres=#  
  postgres=#  
  postgres=# INSERT INTO nums values(1, 'One');  
  INSERT 0 1  
  postgres=# INSERT INTO nums values(2, 'Two');  
  INSERT 0 1  
  postgres=# INSERT INTO nums values(3, 'Three');  
  INSERT 0 1  
  postgres=# \q  
  abbas@ubuntu:~/Projects/rep$ psql -p 7432 postgres -U postgres -h localhost  
  psql (9.5.21, server 12.3 (Debian 12.3-1.pgdg100+1))  
    
  postgres=# select * from nums;  
   num | detail   
  -----+--------  
     1 | One  
     2 | Two  
     3 | Three  
  (3 rows)  
    
  postgres=# \q  
