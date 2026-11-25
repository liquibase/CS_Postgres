--liquibase formatted sql

--changeset amy.smith:contacts_insert
insert into contacts (id, name, dept) values (1, 'CS', '123456');
insert into contacts (id, name, dept) values (2, 'Finance', '123457');
--rollback delete from contacts where id in (1,2);

--changeset amy.smith:contacts_update runOnChange:true
\echo update contacts set dept = 'Finance Serv' where id = 2;
update contacts set dept = 'Finance Serv' where id = 2;
--rollback update contacts set dept = 'Finance' where id = 2;

--changeset amy.smith:contacts_delete runOnChange:true
\echo delete from contacts where id in (1,2);
delete from contacts where id in (1,2);
--rollback insert into contacts (id, name, dept) values (1, 'CS', '123456');
--rollback insert into contacts (id, name, dept) values (2, 'Finance', '123457');

--changeset amy.smith:contacts_insert2 runOnChange:true
\echo Inserting...
insert into contacts (id, name, dept) values (1, 'CS', '123456');
insert into contacts (id, name, dept) values (2, 'Finance', '123457');
--rollback delete from contacts where id in (1,2);

--changeset amy.smith:contacts_select runOnChange:true
\echo select id, name, dept from contacts;
select id, name, dept from contacts;
--rollback select id, name, dept from contacts;

--changeset amy.smith:contacts_insert3 runOnChange:true
\echo Inserting...
insert into contacts (id, name, dept) values (1, 'CS', '123456');
insert into contacts (id, name, dept) values (2, 'Finance', '123457');
--rollback delete from contacts where id in (1,2);

--changeset amy.smith:contacts_insert4 runOnChange:true
insert into contacts (id, name, dept) values (10, 'CS', '123456');
insert into contacts (id, name, dept) values (11, 'Finance', '123457');
--rollback delete from contacts where id in (10,11);

--changeset amy.smith:contacts_insert5 runOnChange:true
insert into contacts (id, name, dept) values (13, 'CS', '123456');
insert into contacts (id, name, dept) values (12, 'Finance', '123457');
--rollback delete from contacts where id in (12,13);

--changeset amy.smith:row_counts_test_01
insert into abc.contacts (id, name, dept) values (14, 'CS', '141414');
--rollback delete from abc.contacts where id=14;

--changeset amy.smith:row_counts_test_02
insert into abc.contacts (id, name, dept) values (15, 'CS', '151515');
--rollback delete from abc.contacts where id=15;

--changeset amy.smith:row_counts_test_03
update abc.contacts set name = 'Customer Success' where id in (14,15);
--rollback update abc.contacts set name = 'CS' where id in (14,15);