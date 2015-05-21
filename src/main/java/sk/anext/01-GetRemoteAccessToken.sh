#!/bin/bash

OAUTH_SERVER="http://localhost:8080/metaisiam"

GRANT_TYPE="client_credentials"
CLIENT_ID="blackshark-client"
SECRET="75b82f34f6ca7074aa953e23f2d9a306a02e78276facdb2693d2f2edf7102628"

ACCESS_TOKEN_REQUEST_DATA="grant_type=$GRANT_TYPE&client_id=$CLIENT_ID&client_secret=$SECRET"
ACCESS_TOKEN_URL="$OAUTH_SERVER/token"
ACCESS_TOKEN_FILE_STORE="/tmp/access_token.txt"


RESOURCE_SERVER="http://localhost:8080/rest"
RESOURCE_URL="employee/list"
RESOURCE_DATA="access_token="

TMP_FILE="/tmp/curl_out"

if [ -z "$JQ" ]; then
	JQ=$(whereis -b jq1 | cut -f 2 -d \ )
fi

if [ ! -x "$JQ" ]; then
	echo "This script require bash util jq (http://stedolan.github.io/jq/) to run. Install jq or set property variable JQ to valid jq executable path."
	exit 1
fi


STATUS=$(curl --write-out "%{http_code}" --output "$TMP_FILE" --silent -X POST -d "$ACCESS_TOKEN_REQUEST_DATA" -H "Content-Type: application/x-www-form-urlencoded" "$ACCESS_TOKEN_URL")

if [ "$STATUS" = "200" ]; then
	cat $TMP_FILE >> $ACCESS_TOKEN_FILE_STORE
	printf "\n" >> $ACCESS_TOKEN_FILE_STORE
	LAST_TOKEN=$(tail -n 1 $ACCESS_TOKEN_FILE_STORE)
	if [ -n "$LAST_TOKEN" ]; then
		ACCESS_TOKEN=$(echo $LAST_TOKEN | jq ".access_token" | cut -f 2 -d \")

		if [ -n "$ACCESS_TOKEN" ]; then
			STATUS=$(curl --write-out "%{http_code}" --output "$TMP_FILE" --silent "$RESOURCE_SERVER/$RESOURCE_URL?$RESOURCE_DATA$ACCESS_TOKEN")
			if [ "$STATUS" = "200" ]; then
				cat $TMP_FILE | jq "."
			else
				echo "Can not read employee list. Server response status $STATUS. URL: $RESOURCE_SERVER/$RESOURCE_URL?$RESOURCE_DATA$ACCESS_TOKEN"
			fi
		else
			echo "Can not extract access_token from JSON data: $LAST_TOKEN"
		fi

	else
		echo "Can not obtain last received access token!"
	fi
else
	echo "Can not obtain token from $ACCESS_TOKEN_URL. Return HTTP Status: $STATUS"
fi



exit 0
