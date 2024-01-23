--liquibase formatted sql

--changeset amy.smith:abc.films_01 labels:v0.1.0
create table abc.films_01 (
  id int, 
  name varchar(30),
  kind varchar(30) 
);
--rollback DROP TABLE abc.films_01;


--changeset amy.smith:abc.films_01_idx labels:v0.1.0
CREATE UNIQUE INDEX name_idx ON abc.films_01 (name);
--rollback drop index name_idx;