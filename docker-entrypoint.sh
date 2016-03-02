#!/bin/bash
set -e

if [ -z $DB_TYPE ]
then
	DB_TYPE="mysql"
fi

if [ -z $DB_HOST ]
then
	if [ -n "$MYSQL_PORT_3306_TCP_ADDR" ]
	then
		DB_HOST="$MYSQL_PORT_3306_TCP_ADDR"
	else 
		DB_HOST="sonarqube-mysql"
	fi
fi

if [ -z $DB_PORT ]
then
	if [ -n "$MYSQL_PORT_3306_TCP_PORT" ]
	then 
		DB_PORT="$MYSQL_PORT_3306_TCP_PORT"
	else
		DB_PORT="3306"
	fi 
fi

if [ -z $DB_NAME ]
then 
	if [ -n "$MYSQL_ENV_MYSQL_DATABASE" ]
	then
		DB_NAME="$MYSQL_ENV_MYSQL_DATABASE"
	else
		DB_NAME="sonarqube"
	fi
fi

if [ -z $DB_USER ]
then 
	if [ -n "$MYSQL_ENV_MYSQL_USER" ]
	then
		DB_USER="$MYSQL_ENV_MYSQL_USER"
	else
		DB_USER="sonarqube"
	fi
fi

if [ -z $DB_PASS ]
then 
	if [ -n "$MYSQL_ENV_MYSQL_PASSWORD" ]
	then
		DB_PASS="$MYSQL_ENV_MYSQL_PASSWORD"
	else
		DB_PASS="my-password"
	fi
fi

# set db dialect and db driver class name by db type
case "$DB_TYPE" in
	mysql)
		DB_URL="jdbc:mysql://$DB_HOST:$DB_PORT/$DB_NAME?useUnicode=true&characterEncoding=utf8"
	;;
	postgresql)
		DB_URL="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME"
	;;
	*)
		echo "ERROR: The db type '$DB_TYPE' is not supported"
		exit 1
	;;
esac

# wait for database port to be opened
while ! nc -z $DB_HOST $DB_PORT; do sleep 1; done

# import trusted ssl certs into JRE keystore
import-trusted-ssl-certs.sh

# start sonarqube application
exec java -jar $SONARQUBE_HOME/lib/sonar-application-$SONARQUBE_VERSION.jar \
     -Dsonar.log.console=true \
     -Dsonar.jdbc.username="$DB_USER" \
     -Dsonar.jdbc.password="$DB_PASS" \
     -Dsonar.jdbc.url="$DB_URL" \
     -Dsonar.web.context="$SONARQUBE_CONTEXT_PATH" \
     -Dsonar.web.javaAdditionalOpts="-Djava.security.egd=file:/dev/./urandom $SONARQUBE_JAVA_OPTS" \
     "$@"

exec "$@"
