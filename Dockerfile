FROM chrisipa/java
MAINTAINER Christoph Papke <info@papke.it>

# set environment variables
ENV SONARQUBE_HOME /opt/sonarqube
ENV SONARQUBE_VERSION 5.3
ENV SONARQUBE_CHECKSUM 9ca7f69cce0bbbe519fc08da7c592d56

# download and extract sonarqube to opt directory
RUN wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONARQUBE_VERSION.zip && \
    echo "$SONARQUBE_CHECKSUM sonarqube-$SONARQUBE_VERSION.zip" | md5sum -c && \
    unzip sonarqube-$SONARQUBE_VERSION.zip -d /opt && \
    ln -s /opt/sonarqube-$SONARQUBE_VERSION $SONARQUBE_HOME && \
    rm -f sonarqube-$SONARQUBE_VERSION.zip

# remove unused directories
RUN rm -rf $SONARQUBE_HOME/bin $SONARQUBE_HOME/conf

# expose http port
EXPOSE 9000

# specify volumes
VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions"]

# set SONARQUBE_HOME as work dir
WORKDIR $SONARQUBE_HOME

# copy entry point to docker image root
COPY docker-entrypoint.sh /entrypoint.sh

# specifiy entrypoint
ENTRYPOINT ["/entrypoint.sh"]
