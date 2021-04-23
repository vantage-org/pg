#!/bin/bash
set -e

stop_and_remove_all() {
    docker ps --quiet --all --filter "label=vantage-pg" | while IFS='' read -r CONTAINER_ID
    do
        stop_and_remove "$CONTAINER_ID"
    done
}

stop_and_remove() {
    echo "Removing $1"
    docker stop "$1" > /dev/null
    docker rm -v "$1" > /dev/null
}

while getopts ":a" opt; do
    case $opt in
        a)
            stop_and_remove_all
            exit
            ;;
        *)
            ;;
    esac
done

URL=$(vg __env DATABASE_URL)
DB_NAME=$(echo "$URL" | rev | cut -d'/' -f1 | rev)
stop_and_remove "vg-pg-$DB_NAME"
