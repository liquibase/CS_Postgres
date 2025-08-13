--liquibase formatted sql

--changeset amy.smith:sales_contacts labels:abc-002
create table Contacts3 (
  id int
);
--rollback DROP TABLE Contacts3;

--changeset amy.smith:sales_contacts_idx labels:abc-002
CREATE UNIQUE INDEX name3_idx ON Contacts3 (name);
--rollback DROP INDEX name3_idx on Contacts3;

--changeset amy.smith:Contacts3_delete labels:abc-0002 runAlways:true
delete from Contacts3;
--rollback select '1';
