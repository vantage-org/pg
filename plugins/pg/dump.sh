#!/bin/sh
# ---
# image:
#   tag: "$VG_PG_TAG:$VG_PG_VERSION"
#   network: $VG_DOCKER_NETWORK
#   rm: true
# environment:
#   - VG_PG_TAG=postgres
#   - VG_PG_VERSION=latest
#   - VG_DOCKER_NETWORK=host
# ---
pg_dump \
    --format=custom \
    --no-acl \
    --no-owner \
    --schema=public \
    --dbname="$DATABASE_URL"
