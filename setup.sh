#!/bin/bash
gleam deps update
cd build/packages/gpb
make
cd ../../..
./build/packages/gpb/bin/protoc-erl -I. mumble.proto
erlc -I build/packages/gpb/include mumble.erl
rm src/mumble.erl
rm src/mumble.hrl
mv mumble.erl src/
mv mumble.hrl src/
cp build/packages/gpb/include/gpb.hrl src/ # required, or else we get a lot of `There was a problem running the shell command 'escript'`... unsure why