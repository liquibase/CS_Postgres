--liquibase formatted sql

--changeset amy.smith:abc.films_vw_01 labels:v0.1.0 endDelimiter:$$
CREATE OR REPLACE VIEW abc.films_vw_01 AS
 SELECT ID, NAME, KIND from abc.films_01;
--rollback DROP VIEW abc.films_vw_01;