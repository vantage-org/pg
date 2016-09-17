#!/bin/bash
set -e

. assert.sh

# Remove using var
url=$(vg pg new)
count_before=$(docker ps --filter "label=vantage.pg.db_name" | grep postgres | wc -l)
assert_raises "vg -v DATABASE_URL=$url pg rm"
count_after=$(docker ps --filter "label=vantage.pg.db_name" | grep postgres | wc -l)
assert_raises "test $count_after -eq $(( $count_before - 1 ))"

# Remove using env file
env_file=$(mktemp)
url=$(vg -e "$env_file" pg new)
count_before=$(docker ps --filter "label=vantage.pg.db_name" | grep postgres | wc -l)
assert_raises "vg -e $env_file pg rm"
count_after=$(docker ps --filter "label=vantage.pg.db_name" | grep postgres | wc -l)

# Remove all
vg pg rm -a
vg pg new > /dev/null
vg pg new > /dev/null
count=$(docker ps --filter "label=vantage.pg.db_name" | grep postgres | wc -l)
assert_raises "test $count -eq 2"
vg pg rm -a
count=$(docker ps --filter "label=vantage.pg.db_name" | grep postgres | wc -l)
assert_raises "test $count -eq 0"

# Should remove the container with the right DB name
url=$(vg pg new)
db_name=${url##*/}
vg -v DATABASE_URL=$url pg rm
container_id=$(docker ps --quiet --filter "label=vantage.pg.db_name=$db_name")
assert_raises "test -z $container_id"

vg pg rm -a
rm "$env_file"

assert_end rm
