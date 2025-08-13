--liquibase formatted sql

--changeset amy.smith:sales_contacts labels:abc-002
create table Sales.Contacts2 (
  id int
);
--rollback DROP TABLE Sales.Contacts2;

--changeset amy.smith:sales_contacts_idx labels:abc-002
CREATE UNIQUE INDEX name2_idx ON Sales.Contacts2 (name);
--rollback DROP INDEX name2_idx on Sales.Contacts2;
