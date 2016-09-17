#!/bin/bash
set -e

. assert.sh

url=$(vg pg new)
vg -v "DATABASE_URL=$url" pg ping > /dev/null

docker run \
    --rm \
    postgres psql \
        --dbname "$url" \
        --command "CREATE TABLE counter(value INT);INSERT INTO counter(value) VALUES(1)" > /dev/null

dump_file=$(mktemp)
assert_raises "vg -v DATABASE_URL=$url pg dump > $dump_file"

url=$(vg pg restore $dump_file)

counter=$(docker run \
    --rm \
    postgres psql \
        --no-align \
        --tuples-only \
        --dbname "$url" \
        --command "SELECT * FROM counter")

assert_raises "test 1 -eq $counter"

vg pg rm -a > /dev/null

assert_end dump_and_restore
