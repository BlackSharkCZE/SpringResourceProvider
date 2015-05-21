#!/bin/bash

RESOURCE_URL="employee/list"

dirn=$(dirname $0)
ACCESS_TOKEN=$($dirn/03-access-token.sh --silent)

echo "Used access token: $ACCESS_TOKEN"

DATA="access_token=$ACCESS_TOKEN"
URL="http://localhost:8080/rest/$RESOURCE_URL?$DATA"

if [ "$1" = "--silent" ]; then
	curl --silent -v "$URL" | jq '.'
else
	curl -v "$URL"
	printf "\n"
fi


exit 0
