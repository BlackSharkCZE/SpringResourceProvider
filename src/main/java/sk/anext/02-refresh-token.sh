#!/bin/bash

#rest-dispatcher-servlet-security.xml: oauth:client-details-service/oauth:client#client-id
CLIENT_ID="my-client-id"
#rest-dispatcher-servlet-security.xml: authentication-manager/authentication-provider/user-service/user#name
USER_NAME="admin"
#rest-dispatcher-servlet-security.xml: authentication-manager/authentication-provider/user-service/user#password
PASSWORD="password"

DATA="grant_type=password&client_id=$CLIENT_ID&username=$USER_NAME&password=$PASSWORD"

URL="http://localhost:8080/rest/oauth/token"

if [ "$1" = "--silent" ]; then
	REFRESH_TOKEN=$(curl --silent -X POST -d "$DATA" -H "Content-Type: application/x-www-form-urlencoded" "$URL")
	echo $REFRESH_TOKEN | jq '.refresh_token' | cut -f 2 -d \"
else
	REFRESH_TOKEN=$(curl -v -X POST -d "$DATA" -H "Content-Type: application/x-www-form-urlencoded" "$URL")
	echo $REFRESH_TOKEN
fi
exit 0
