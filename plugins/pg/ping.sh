#!/bin/sh
# ---
# image:
#   tag: "$VG_PG_TAG:$VG_PG_VERSION"
#   network: $VG_DOCKER_NETWORK
# environment:
#   - VG_PG_TAG=postgres
#   - VG_PG_VERSION=latest
#   - VG_DOCKER_NETWORK=vg_pg
# ---
ATTEMPTS=10
echo "Trying to connect..."
while [ $ATTEMPTS -gt 0 ]; do
    ATTEMPTS=$(expr "$ATTEMPTS" - 1 )
    if pg_isready --dbname="$DATABASE_URL"; then
        exit 0
    fi
    sleep 1
done

echo "Couldn't connect :("

exit 1
