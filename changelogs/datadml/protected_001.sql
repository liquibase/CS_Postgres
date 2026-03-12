--liquibase formatted sql

--changeset amy.smith:contacts_insert_protected
insert into contacts (id, name, dept) values (1000, 'CS-secret', '123456');
insert into contacts (id, name, dept) values (1001, 'Finance', '123457');
--rollback delete from contacts where id in (1,2);

--changeset amy.smith:contacts_update_protected runAlways:true runOnChange:true
\echo update contacts set dept = 'Finance Serv' where id = 1001;
update contacts set dept = 'Finance Serv' where id = 1001;
--rollback update contacts set dept = 'Finance' where id = 1001;

--changeset amy.smith:contacts_delete_protected runAlways:true runOnChange:true
\echo delete from contacts where id in (1000,1001);
delete from contacts where id in (1000,1001);
--rollback insert into contacts (id, name, dept) values (1000, 'CS-secret', '123456');
--rollback insert into contacts (id, name, dept) values (1001, 'Finance', '123457');

--changeset amy.smith:contacts_insert2_protected runAlways:true runOnChange:true
\echo Inserting...
insert into contacts (id, name, dept) values (1000, 'CS-secret', '123456');
insert into contacts (id, name, dept) values (1001, 'Finance', '123457');
--rollback delete from contacts where id in (1000,1001);

--changeset amy.smith:contacts_select_protected runAlways:true runOnChange:true
\echo select id, name, dept from contacts;
select id, name, dept from contacts;
--rollback select id, name, dept from contacts;