--liquibase formatted sql

--changeset amy.smith:contacts_insert
insert into contacts (id, name, dept) values (1, 'CS', '123456');
insert into contacts (id, name, dept) values (2, 'Finance', '123457');
--rollback delete from contacts where id in (1,2);

--changeset amy.smith:contacts_update
update contacts set dept = 'Finance Serv' where id = 2;
--rollback update contacts set dept = 'Finance' where id = 2;
