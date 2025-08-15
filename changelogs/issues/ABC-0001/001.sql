--liquibase formatted sql

--changeset amy.smith:contacts
create table Contacts (
  id int, 
  name varchar(30),
  dept varchar(30) 
);
--rollback DROP TABLE Contacts;

--changeset amy.smith:contacts2
create table Contacts2 (
  id int, 
  name varchar(30),
  dept varchar(30) 
);
--rollback DROP TABLE Contacts2;

--changeset amy.smith:contacts_delete_from_1 runAlways:true
delete from Contacts;
--rollback select '1';

--changeset amy.smith:contacts_delete_from_2
delete from Contacts;
--rollback select '1';
