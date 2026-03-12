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

--changeset amy.smith:contacts_insert labels:abc-0001 
insert into contacts (id, name, dept) values (100, 'CS', '123456');
insert into contacts (id, name, dept) values (200, 'Finance', '123457');
--rollback delete from contacts where id in (100,200);

--changeset amy.smith:contacts_update runAlways:true runOnChange:true labels:abc-0001 
update contacts set dept = 'Blah';
--rollback
