#!/bin/bash

key=$1
iv=$2

openssl aes-256-cbc -K $key -iv $iv -in /test/base.sfc.enc -out /test/base.sfc -d || exit 1

cp /project/xkas /test/xkas-linux

# wine spews a bunch of crap to stderr on first run
wine /test/xkas-orig.exe >/dev/null 2>/dev/null

pushd /tmp >/dev/null
git clone https://github.com/KatDevsGames/z3randomizer || exit 1
cd z3randomizer
git rev-list master >/tmp/commits
popd >/dev/null

parallel --delay 0.01 --eta --halt soon,fail=1 /test/run.sh </tmp/commits

exit $?
