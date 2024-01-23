--liquibase formatted sql

--changeset amy.smith:insert_test_job_table_01 labels:v0.1.0,data
INSERT INTO abc.test_job_01 ("name", business_unit, "location", division) VALUES('Amy S', 'ABC', 'Dallas', '123');
--rollback delete from test_job_01 where name = 'Amy S' ;

--changeset amy.smith:insert_test_job_table_02 labels:v0.1.0,data
INSERT INTO abc.test_job_01 ("name", business_unit, "location", division) VALUES('Amy T', 'ABC', 'Dallas', '123');
INSERT INTO abc.test_job_01 ("name", business_unit, "location", division) VALUES('Amy TT', 'ABC', 'Dallas', '123');
--rollback delete from test_job_01 where name like 'Amy T%' ;

--changeset amy.smith:insert_test_job_table_03 labels:v0.1.0,data
INSERT INTO abc.test_job_01 ("name", business_unit, "location", division) VALUES('Amy U', 'ABC', 'Dallas', '123');
--rollback delete from test_job_01 where name = 'Amy U' ;