Covered issues:

- Data migrations
- Loading demo data
- Snapshots

(!) nlib does NOT know anything about databases. It just simplifies running
scripts in initialised enviroment.


Migrations
----------

Migrations are stored as files in the `./db/migrations` directory, one per file.
The name of the file is of the form YYYYMMDDhhmmss\_<migration\_name>.js.

Each migration script must have exported method `up` with single callback
argument.

Example:

``` javascript

module.exports.up = function(cb) {
  my_model = new global.nodeca.models.my_model(/* some data */);

  my_model.save(function (err) {
    cb(err);
  });
}

```

Migrations run from old to new.

In migration available all existing models.

File tree example.

```
.
├─ migrate/
│   ├─ 20110919181104_create_sections.js
│   └─ 20120103183744_create_threads.js
│
```

### Migration Cli

`./bin/db-migrate` runs migrations from all components, ordered by timestamp.


Seeds
-----

All demo data should be placed in seeds files under `./db/seeds` folder. To run
seed, type something like this:

    ./bin/db-seed --app=<app-name> [<seed-name>]

That will run `./db/seeds/<seed-name>.js` if exists. Or, all seeds from
`./db/seeds/seed-name/` folder. If <seed-name> missed, then script will show all
available seeds for given app. If `--app` missed, then all seed for all apps
will be shown.


Data snapshots
--------------

There are couple of development scripts, to quickly switch between data states,
when you actively change DB

    ./bin/db-dump <snapshot-id>

Dump all data in `./tmp`, with given ID. Note, that dump can contain multiple
files, for multiple sources (mongo db, redis)

    ./bin/db-restore <snapshot-id>

Restore data from snapshot with given id.

(!) scripts use ONLY development enviroment, to exclude posibility of data
corruption
