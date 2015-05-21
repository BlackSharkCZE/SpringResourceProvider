#!/bin/bash

RESOURCE_URL="employee/list"

dirn=$(dirname $0)
#ACCESS_TOKEN=$($dirn/03-access-token.sh --silent)

ACCESS_TOKEN="eyJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJibGFja3NoYXJrLWNsaWVudCIsImlzcyI6Imh0dHA6XC9cL2xvY2FsaG9zdDo4MDgwXC9tZXRhaXNpYW1cLyIsImV4cCI6MTQzMjIwOTYwNSwiaWF0IjoxNDMyMjA2MDA1LCJqdGkiOiI3NTU3ZTQyNy1lYzkwLTRjNDctOTM1Zi0xOWM2NmZhNzBiNTAifQ.O-KdW4jwWdqfm3sMoWMnFIlRWyqmBiuAbjlVzi1CD8wKzV4j25aezsHwLLvlrWSFKB80zO3E2dxFEjUfv1wFzEuU33_AJQV4hRiOfOqfcDfD1-1ofNnVbsKM20LFVqd3Z9Fq2-gE3OSmF7LL1FFzBXQQD2_Xxk54z9deHe6_t-I"

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
