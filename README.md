# pg

vantage plugin for herding PostgreSQL containers.

## Installing

`pg` is an official vantage plugin so you can install it like this:

    $ vg __plugins install pg

The double underscore is use in vantage to separate "internal" scripts from others. It's mostly a namespace problem, if you'd like to name one of your own scripts "plugins" you don't have to clobber the vantage internal plugins to do so.

## Creating Databases

It's pretty simple to get up and running with a new container:

    $ vg pg new
    postgresql://SRwVJCz7ZHIb:k0MZCIHJuSlO@172.17.0.2:5432/0DvSMqCe7HKp

This will spin up a Postgres container and print out the URL that you can use to access it.

If you have set the config variable `VG_DEFAULT_ENV` then the database details be saved to it like this:

    ...
    DATABASE_URL=postgresql://SRwVJCz7ZHIb:k0MZCIHJuSlO@vg_pg:5432/0DvSMqCe7HKp
    DATABASE_NAME=0DvSMqCe7HKp
    DATABASE_HOST=vg_pg
    DATABASE_PORT=5432
    DATABASE_USERNAME=SRwVJCz7ZHIb
    DATABASE_PASSWORD=k0MZCIHJuSlO
    ...

This lets you immediately access the database, for instance using `vg pg run`.

The database will be connected to a docker network called `vg_pg`. To specify your own network just set the `VG_DOCKER_NETWORK` env variable in your `.vantage` file:

    ...
    VG_DOCKER_NETWORK=my-network
    ...

If you want to use a specific version of postgres then you can set the following env variables in your `.vantage` file:

    ...
    VG_PG_TAG=postgres
    VG_PG_VERSION=latest
    ...

For instance, if you wanted to use a version of postgres with the PostGIS extentions installed you could set:

    ...
    VG_PG_TAG=postgis/postgis
    VG_PG_VERSION=12-2.5
    ...

## Connecting to Databases

The `pg` plugin assumes that there is an environment variable called `DATABASE_URL` that container the location and username:password details for a database. You can set this variable in an env file (`vg pg new` can do this for you automatically) or on the command line.

If you have a database URL then you can connect to the database using `psql`:

    $ vg pg run
    psql (12.0 (Debian 12.0-2.pgdg100+1))
    Type "help" for help.

    aUwy9RcBkdG4=#

You can also ping the database to wait for it to be ready (this can be useful in bootstrap scripts where you want to run migrations as soon as the DB is ready).

    $ vg pg ping
    Trying to connect...
        Failed
        Success!

`vg pg ping` will try 10 times to connect (with a one second wait between each try). It will stop when it successfully connects, it will print "Success!" and exit with code 0. If all 10 attempts then it will print "Failed" 10 times and exit with code 1.

## Dump and Restore

These two commands are really simple conveniences for running `pg_dump` and `pg_restore`. They work as you would expect:

    $ vg pg dump > database.dump
    $ vg pg new
    $ vg pg restore < database.dump

As you can see from the output, `vg pg restore` connects to `DATABASE_URL` and populates it with the data from the dump file.

## Cleaning Up

The `vg pg rm` command can be used to stop and remove vantage postgres containers. `vg pg rm` will destroy the current database (the one pointed to by `DATABASE_URL`).

`vg pg rm -a` will destroy all vantage postgres containers.
