--liquibase formatted sql

--changeset amy.smith:sales_contacts labels:abc-002
create table Contacts2 (
  id int
);
--rollback DROP TABLE Contacts2;

--changeset amy.smith:sales_contacts_idx labels:abc-002
CREATE UNIQUE INDEX name2_idx ON Contacts2 (name);
--rollback DROP INDEX name2_idx on Contacts2;

--changeset amy.smith:Contacts2_delete labels:abc-0002 runAlways:true
delete from Contacts2;
--rollback select '1';
