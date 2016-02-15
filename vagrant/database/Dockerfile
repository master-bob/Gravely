FROM postgres:9.5 
MAINTAINER masterbob <masterbob@gmail.com>

VOLUME ["/var/lib/postgresql/data"]

ADD config.sh config.sh

RUN chmod +x config.sh

CMD ./run.sh
