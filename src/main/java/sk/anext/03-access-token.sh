#!/bin/bash

#rest-dispatcher-servlet-security.xml: oauth:client-details-service/oauth:client#client-id
CLIENT_ID="my-client-id"

dirn=$(dirname $0)
REFRESH_TOKEN=$($dirn/02-refresh-token.sh --silent)

DATA="client_id=$CLIENT_ID&grant_type=refresh_token&refresh_token=$REFRESH_TOKEN"
URL="http://localhost:8080/rest/oauth/token"

ACCESS_TOKEN="$(curl -v -X POST -d "$DATA" -H "Content-Type: application/x-www-form-urlencoded" "$URL")"

if [ "$1" = "--silent" ]; then
	ACCESS_TOKEN=$(curl --silent -X POST -d "$DATA" -H "Content-Type: application/x-www-form-urlencoded" "$URL")
	echo $ACCESS_TOKEN | jq '.access_token' | cut -f 2 -d \"
else
	ACCESS_TOKEN=$(curl -v -X POST -d "$DATA" -H "Content-Type: application/x-www-form-urlencoded" "$URL")
	echo $ACCESS_TOKEN
fi

exit 0
