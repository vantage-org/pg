#!/bin/bash
set -e

. assert.sh

env_file=$(mktemp)
vg __env DATABASE_URL "foo_bar"

count_before=$(docker ps --filter "label=vantage.pg" | grep postgres | wc -l)
url=$(vg -e "$env_file" pg new)
count_after=$(docker ps --filter "label=vantage.pg" | grep postgres | wc -l)

# Should create one pg DB (with the right label)
assert_raises "test $count_after -eq $(( $count_before + 1 ))"

# Should set the database url in the env file
assert_raises "test $url == $(vg -e "$env_file" __env DATABASE_URL)"

# Should set the vantage.pg label
container_id=$(docker ps --quiet --filter "label=vantage.pg=1")
assert_raises "test 0 -ne $(echo $container_id | wc -l)"

vg pg rm -a > /dev/null
rm "$env_file"

assert_end new
