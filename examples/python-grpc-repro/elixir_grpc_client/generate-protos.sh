#!/usr/bin/env bash

set -e
set -x

mkdir -p ./generated
#mix escript.install hex protobuf
export PATH=$PATH:~/.mix/escripts
protoc --proto_path ../protos --elixir_out=gen_descriptors=true,plugins=grpc:./generated ../protos/hello.proto
