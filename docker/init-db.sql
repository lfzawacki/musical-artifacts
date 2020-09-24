create user musical_artifacts with password 'musical_artifacts';
alter user musical_artifacts with SUPERUSER;
create extension hstore;
create database musical_artifacts_development owner musical_artifacts;
create database musical_artifacts_test owner musical_artifacts;
alter role musical_artifacts createrole createdb;
