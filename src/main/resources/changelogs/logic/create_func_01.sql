--liquibase formatted sql

--changeset amy.smith:abc.get_films_count_01 labels:v0.1.0 endDelimiter:$$
CREATE OR REPLACE FUNCTION abc.get_films_count_01()
returns int
language plpgsql
as
$$
declare
   film_count integer;
begin
   select count(*) 
   into film_count
   from abc.films_01;
   
   return film_count;
end;
$$;
--rollback DROP FUNCTION abc.get_films_count_01;