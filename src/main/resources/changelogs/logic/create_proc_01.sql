--liquibase formatted sql

--changeset amy.smith:abc.get_films_01 labels:v0.1.0 endDelimiter:$$
CREATE OR REPLACE PROCEDURE abc.get_films_01()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- Query to get the count of employees tests
    SELECT id FROM abc.films_01;
END;
$procedure$
;
--rollback DROP PROCEDURE abc.get_films_01;