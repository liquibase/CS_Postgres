--liquibase formatted sql

--changeset amy.smith:contacts
create table ContactsNew (
  id int, 
  name varchar(30),
  dept varchar(30) 
);
--rollback DROP TABLE ContactsNew;

--changeset amy.smith:contacts2
create table ContactsNew2 (
  id int, 
  name varchar(30),
  dept varchar(30) 
);
--rollback DROP TABLE ContactsNew2;