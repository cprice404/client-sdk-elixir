#!/usr/bin/env bash

set -e
set -x

mkdir -p ./generated
pipenv run python -m grpc_tools.protoc -I../protos --python_out=./generated --pyi_out=./generated --grpc_python_out=./generated ../protos/hello.proto

