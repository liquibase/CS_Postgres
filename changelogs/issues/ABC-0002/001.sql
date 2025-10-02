--liquibase formatted sql

--changeset amy.smith:sales_contacts4 labels:abc-002
create table Contacts4 (
  id int, 
  name varchar(30),
  dept varchar(30)
);
--rollback DROP TABLE Contacts4;

--changeset amy.smith:sales_contacts4_idx labels:abc-002
CREATE UNIQUE INDEX name4_idx ON Contacts4 (name);
--rollback DROP INDEX name4_idx;

--changeset amy.smith:Contacts4_delete labels:abc-0002
delete from Contacts4;
--rollback select '1';

--changeset amy.smith:Contacts4_insert labels:abc-0002 runAlways=true
insert into Contacts4 (id, name, dept) values (1,'Name A','Dept A') ;
--rollback select '1';

--changeset amy.smith:Contacts4_insert2 labels:abc-0002 runAlways=true runOnChange=true
insert into Contacts4 (id, name, dept) values (41,'Patty Smith','Rocker') ;
--rollback empty
