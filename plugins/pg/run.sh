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
if [ -n "$1" ] ; then
    psql --dbname "$DATABASE_URL" --command "$1"
else
    psql --dbname "$DATABASE_URL"
fi
