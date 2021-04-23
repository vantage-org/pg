#!/bin/sh
set -e

random_string() {
    head /dev/urandom | LC_ALL=C tr -dc a-z0-9 | head -c 12
}

USERNAME="$(random_string)"
PASSWORD="$(random_string)"
DB_NAME="$(random_string)"
CONTAINER_NAME="vg-pg-$DB_NAME"

NETWORK="${VG_DOCKER_NETWORK:-bridge}"
PORT=${VG_PG_PORT:-5432}

CONTAINER=$(docker run \
    --detach \
    --env "POSTGRES_DB=$DB_NAME" \
    --env "POSTGRES_PASSWORD=$PASSWORD" \
    --env "POSTGRES_USER=$USERNAME" \
    --label vantage \
    --label vantage-pg \
    --name "$CONTAINER_NAME" \
    --network "$NETWORK" \
    --publish "$PORT" \
    "${VG_PG_TAG:-postgres}:${VG_PG_VERSION:-latest}")

if [ -n "$VG_DOCKER_NETWORK" ]; then
    HOST="$CONTAINER_NAME"
else
    HOST='localhost'
    PORT=$(docker inspect --format '{{(index (index .NetworkSettings.Ports "5432/tcp") 0).HostPort}}' "$CONTAINER")
fi

DB="postgresql://$USERNAME:$PASSWORD@$HOST:$PORT/$DB_NAME"

vg __env "DATABASE_URL=$DB"
vg __env "DATABASE_NAME=$DB_NAME"
vg __env "DATABASE_HOST=$HOST"
vg __env "DATABASE_PORT=$PORT"
vg __env "DATABASE_USERNAME=$USERNAME"
vg __env "DATABASE_PASSWORD=$PASSWORD"

echo "$DB"
