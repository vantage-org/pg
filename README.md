# pg
Vantage plugin for herding PostgreSQL containers.

## Installing

`pg` is an official Vantage plugin so you can install it like this:

    $ vg __plugins install pg

The double underscore is use in Vantage to separate "internal" scripts from others. It's mostly a namespace problem, if you'd like to name one of your own scripts "plugins" you don't have to clobber the Vantage internal plugins to do so.

## Creating Databases

It's pretty simple to get up and running with a new container:

    $ vg pg new
    postgres://SRwVJCz7ZHIb:k0MZCIHJuSlO@172.17.0.2:5432/0DvSMqCe7HKp

This will spin up a Postgres container and print out the URL that you can use to access it.

If you have set the config variable `VG_DEFAULT_ENV` then the above URL will also be saved to it like this:

    ...
    DATABASE_URL=postgres://SRwVJCz7ZHIb:k0MZCIHJuSlO@172.17.0.2:5432/0DvSMqCe7HKp
    ...

This lets you immediately access the database, for instance using `vg pg shell`.

If you'd like to create the container inside a docker network, you have to set the `VG_DOCKER_NETWORK` config variable. This can be added to an env file, or you can specify it on the command line:

    $ docker network create my-network
    d8936e965c9657c26fd23c523f558c7911a936ed590b5e06a9ec50669ffc9580
    $ vg -v VG_DOCKER_NETWORK=my-network pg new
    postgres://FaFVRI2ah4nG:xNIV1MXJ76jU@vg_pg_hqj9wxXNO1PY:5432/kZysjogYtPog

This time round the URL doesn't contain the IP address of the container, but instead a randomised name.

## Connecting to Databases

The `pg` plugin assumes that there is an environment variable called `DATABASE_URL` that container the location and username:password details for a database. You can set this variable in an env file (`vg pg new` can do this for you automatically) or on the command line.

If you have a database URL then you can connect to the database using `psql`:

    $ vg pg shell
    psql (9.6.2)
    Type "help" for help.

    aUwy9RcBkdG4=#

You can also open a web interface (pgweb) like this:

    $ vg pg web
    Pgweb v0.9.6 (git: b580b2456ad4c766bfc93fd19cff0c8f904a0999)
    Connecting to server...
    Checking database objects...
    Starting server...
    To view database open http://0.0.0.0:8081/ in browser

`vg pg web` might complain about SSL certs:

    $ vg pg web
    Pgweb v0.9.6 (git: b580b2456ad4c766bfc93fd19cff0c8f904a0999)
    Connecting to server...
    Error: pq: SSL is not enabled on the server

In which case you might want to disable SSL mode (only for development, don't do this in production). Simply set `VG_PG_WEB_SSLMODE=disable`.

You can also ping the database to wait for it to be ready (this can be useful in bootstrap scripts where you want to run migrations as soon as the DB is ready).

    $ vg pg ping
    Trying to connect... Failed
    Trying to connect... Success!

`vg pg ping` will try 10 times to connect (with a one second wait between each try). It will stop when it successfully connects, it will print "Success!" and exit with code 0. If all 10 attempts then it will print "Failed" 10 times and exit with code 1.

## Dump and Restore

These two commands are really simple conveniences for running `pg_dump` and `pg_restore`. They work as you would expect:

    $ vg pg dump > database.dump
    $ vg pg restore database.dump
    postgres://ON8AAcTJ1Vu2:AD2rL4xDZTkP@vg_pg_QZMzmdrvdmHy:5432/W6DpGALayjgS

As you can see from the output, `vg pg restore` creates a new container and populates it with the data from the dump file.

## Cleaning Up

The `vg pg rm` command can be used to stop and remove Vantage postgres containers. `vg pg rm` will destroy the current database (the one pointed to by `DATABASE_URL`). `vg pg rm -a` will destroy all Vantage postgres containers.

