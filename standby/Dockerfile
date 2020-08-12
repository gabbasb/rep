FROM postgres:12.3

RUN apt-get update \
  && apt-get install -y gosu \
  && rm -rf /var/lib/apt/lists/*

COPY standby-entrypoint.sh /standby-entrypoint.sh

RUN chmod +x /standby-entrypoint.sh

ENTRYPOINT ["/standby-entrypoint.sh"]

CMD ["gosu", "postgres", "postgres"]

