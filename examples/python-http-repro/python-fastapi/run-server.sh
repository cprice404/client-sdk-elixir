#!/usr/bin/env bash

set -e
set -x

#pipenv run uvicorn server:app 
pipenv run uvicorn server:app --ssl-keyfile=/Users/cprice/git/momento/cacheservice/certs/localhost/key.pem --ssl-certfile=/Users/cprice/git/momento/cacheservice/certs/localhost/cert.pem

