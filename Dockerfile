FROM sonarqube
MAINTAINER Christoph Papke <info@christoph-papke.de>

# install additional packages
RUN apt-get update && \
	apt-get install -y netcat

# copy entry point to docker image root
COPY docker-entrypoint.sh /entrypoint.sh

# specifiy entrypoint
ENTRYPOINT ["/entrypoint.sh"]
