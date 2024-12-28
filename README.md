# PSQL

sudo apt update

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

sudo apt update

sudo apt install postgresql-17

sudo service postgresql status

sudo service postgresql start

sudo su - postgres

psql

CREATE USER userthiru WITH PASSWORD 'test123';

CREATE DATABASE urcs_bank;

GRANT ALL PRIVILEGES ON DATABASE urcs_bank TO userthiru;

\connect urcs_bank;

create table pricing (id int, price money);

insert into pricing (id, price)
select id, floor(random() * 1000 + 1)::int::money
from generate_series(1, 100) as id;

select * from pricing where id = 10;

explain (analyze, buffers, costs off) select * from pricing where id = 10;
explain (analyze, buffers, costs off) select * from pricing;

create extension pg_buffercache;

select * from pg_buffercache_summary();

You can see there are many buffers used and many buffers unused. You can check how those used
buffers are distributed by running this function:

SELECT n.nspname, c.relname, count(*) AS buffers
FROM pg_buffercache b JOIN pg_class c
ON b.relfilenode = pg_relation_filenode(c.oid) AND
b.reldatabase IN (0, (SELECT oid FROM pg_database
WHERE datname = current_database()))
JOIN pg_namespace n ON n.oid = c.relnamespace
GROUP BY n.nspname, c.relname
ORDER BY 3 DESC
LIMIT 10;

You can see there are many buffers used and many buffers unused. You can check how those used
buffers are distributed by running this function:
If you want to see the buffers used by the pricing table, run the query below:
SELECT bufferid,
relblocknumber,
isdirty,
usagecount,
pinning_backends
FROM pg_buffercache
WHERE relfilenode = pg_relation_filenode('pricing'::regclass);

Update rows and observe the isdirty flag:

UPDATE pricing SET price = 450::money where id = 10;

Add more data to the table to see the database allocation of additional buffers:

insert into pricing (id, price)
select id, floor(random() * 1000 + 1)::int::money
from generate_series(101, 100000) as id;

Run the same commands as before to check how many buffers are being hit this time.
explain (analyze, buffers, costs off) select * from pricing where id = 10;
explain (analyze, buffers, costs off) select * from pricing;

Alter the pricing table to update ‘id’ as the primary key:

alter table pricing add primary key(id);

vacuum analyze;

Note: The VACUUM command reclaims space and makes it available for re-use. ANALYZE command collects
statistics about the contents of tables in the database

Now fetch the value of the same record again:

explain (analyze, buffers, costs off) select * from pricing where id = 10;

Check how many buffers are assigned to the primary key index:
SELECT bufferid,
relblocknumber,
isdirty,
usagecount,
pinning_backends
FROM pg_buffercache
WHERE relfilenode = pg_relation_filenode('pricing_pkey'::regclass);

Open another psql session and run the same request that you've just executed in the previous
session:
explain (analyze, buffers, costs off) select * from pricing where id = 10;

Now, in this second session, query for a record that you've never queried before:
explain (analyze, buffers, costs off) select * from pricing where id = 510;

Observe that the number of buffers used by the index will keep going up if you continue querying for
the records that are not cached yet:

SELECT bufferid,
relblocknumber,
isdirty,
usagecount,
pinning_backends
FROM pg_buffercache
WHERE relfilenode = pg_relation_filenode('pricing_pkey'::regclass);