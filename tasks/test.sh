#!/bin/sh
set -e

printf "\nTEST: Creating a new database\n"
vg pg new

printf "\nTEST: Pinging the database\n"
vg pg ping

printf "\nTEST: Creating some data\n"
vg pg run "CREATE TABLE foo (comment TEXT);"
vg pg run "INSERT INTO foo (comment) VALUES ('does this work');"

printf "\nTEST: Dumping the database\n"
vg pg dump > "$VG_APP_DIR/test.sql"

printf "\nTEST: Removing the database\n"
vg pg rm

printf "\nTEST: Trying to ping again (should fail)\n"
set +e
if vg pg ping; then
    exit 1
fi
set -e

printf "\nTEST: Creating a fresh database\n"
vg pg new
vg pg ping

printf "\nTEST: Restoring the dump into it\n"
cat "$VG_APP_DIR/test.sql" | vg pg run

printf "\nTEST: Querying some data\n"
vg pg run "SELECT * FROM foo;" | grep work

printf "\nTEST: Creating another new database\n"
vg pg new

printf "\nTEST: Removing both running databases\n"
vg pg rm -a
