#!/bin/bash

#rest-dispatcher-servlet-security.xml: oauth:client-details-service/oauth:client#client-id
CLIENT_ID="my-client-id"
#rest-dispatcher-servlet-security.xml: authentication-manager/authentication-provider/user-service/user#name
USER_NAME="admin"
#rest-dispatcher-servlet-security.xml: authentication-manager/authentication-provider/user-service/user#password
PASSWORD="password"

INTROSPECTION_URL="introspect"

dirn=$(dirname $0)

if [ -n "$FORCE_TOKEN" ]; then
	ACCESS_TOKEN=$FORCE_TOKEN
 else
 ACCESS_TOKEN=$($dirn/03-access-token.sh --silent)
 fi

echo "Used access token: $ACCESS_TOKEN"

DATA="access_token=$ACCESS_TOKEN&client_id=$CLIENT_ID&username=$USER_NAME&password=$PASSWORD"
URL="http://localhost:8080/rest/$INTROSPECTION_URL?$DATA"

if [ "$1" = "--silent" ]; then
	curl --silent -v "$URL" | jq '.'
else
	curl -v "$URL"
	printf "\n"
fi


exit 0
