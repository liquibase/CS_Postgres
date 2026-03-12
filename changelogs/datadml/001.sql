--liquibase formatted sql

--changeset amy.smith:contacts_insert
insert into contacts (id, name, dept) values (1, 'CS', '123456');
insert into contacts (id, name, dept) values (2, 'Finance', '123457');
--rollback delete from contacts where id in (1,2);

--changeset amy.smith:contacts_update runAlways:true runOnChange:true
\echo update contacts set dept = 'Finance Serv' where id = 2;
update contacts set dept = 'Finance Serv' where id = 2;
--rollback update contacts set dept = 'Finance' where id = 2;

--changeset amy.smith:contacts_delete runAlways:true runOnChange:true
\echo delete from contacts where id in (1,2);
delete from contacts where id in (1,2);
--rollback insert into contacts (id, name, dept) values (1, 'CS', '123456');
--rollback insert into contacts (id, name, dept) values (2, 'Finance', '123457');

--changeset amy.smith:contacts_insert2 runAlways:true runOnChange:true
\echo Inserting...
insert into contacts (id, name, dept) values (1, 'CS', '123456');
insert into contacts (id, name, dept) values (2, 'Finance', '123457');
--rollback delete from contacts where id in (1,2);

--changeset amy.smith:contacts_select runAlways:true runOnChange:true
\echo select id, name, dept from contacts;
select id, name, dept from contacts;
--rollback select id, name, dept from contacts;