#!/bin/sh
# ---
# image:
#   tag: "$VG_PG_TAG:$VG_PG_VERSION"
#   network: $VG_DOCKER_NETWORK
#   rm: true
#   interactive: true
#   tty: true
# environment:
#   - VG_PG_TAG=postgres
#   - VG_PG_VERSION=latest
#   - VG_DOCKER_NETWORK=vg_pg
# ---
ATTEMPTS=10
echo "Trying to connect..."
while [ $ATTEMPTS -gt 0 ]; do
    ATTEMPTS=$(expr "$ATTEMPTS" - 1 )
    if psql --dbname="$DATABASE_URL" 2> /dev/null
    then
        echo " Success!"
        exit 0
    else
        echo " Failed..."
    fi
    sleep 1
done

echo "Couldn't connect :("

exit 1
