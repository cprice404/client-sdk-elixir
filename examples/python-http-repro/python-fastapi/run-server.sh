#!/usr/bin/env bash

set -e
set -x

pipenv run uvicorn server:app
