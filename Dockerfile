FROM sonarqube
MAINTAINER Christoph Papke <info@christoph-papke.de>

# copy entry point to docker image root
COPY docker-entrypoint.sh /entrypoint.sh

# specifiy entrypoint
ENTRYPOINT ["/entrypoint.sh"]
