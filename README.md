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
    DATABASE_URL=postgresql://SRwVJCz7ZHIb:k0MZCIHJuSlO@localhost:5432/0DvSMqCe7HKp
    DATABASE_NAME=0DvSMqCe7HKp
    DATABASE_HOST=localhost
    DATABASE_PORT=5432
    DATABASE_USERNAME=SRwVJCz7ZHIb
    DATABASE_PASSWORD=k0MZCIHJuSlO
    ...

This lets you immediately access the database, for instance using `vg pg run`.

If you'd like to create the container inside a docker network, you have to set the `VG_DOCKER_NETWORK` config variable. This can be added to an env file, or you can specify it on the command line:

    $ docker network create my-network
    d8936e965c9657c26fd23c523f558c7911a936ed590b5e06a9ec50669ffc9580
    $ vg --var VG_DOCKER_NETWORK=my-network pg new
    postgresql://FaFVRI2ah4nG:xNIV1MXJ76jU@vg_pg_hqj9wxXNO1PY:5432/kZysjogYtPog

This time round the URL doesn't contain the IP address of the container, but instead a randomised name.

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
