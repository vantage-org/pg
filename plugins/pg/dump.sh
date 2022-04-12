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
pg_dump \
    --format=plain \
    --no-acl \
    --no-owner \
    --schema=public \
    --dbname="$DATABASE_URL"
