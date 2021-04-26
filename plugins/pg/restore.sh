#!/bin/sh
# ---
# help-text: Restore a database dump into the current database
# image:
#   tag: "$VG_PG_TAG:$VG_PG_VERSION"
#   network: $VG_DOCKER_NETWORK
#   rm: true
#   interactive: true
# environment:
#   - VG_PG_TAG=postgres
#   - VG_PG_VERSION=latest
#   - VG_DOCKER_NETWORK=vg_pg
# ---
pg_restore \
    --no-acl \
    --no-owner \
    --schema=public \
    --dbname="$DATABASE_URL"
