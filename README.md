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
