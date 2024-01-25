--liquibase formatted sql

--changeset amy.smith:test_table_03 labels:v0.1.0
CREATE TABLE abc.manual_table (
	test_id int4 NOT NULL,
	test_column varchar NULL,
	CONSTRAINT test_table_pkey PRIMARY KEY (test_id)
);
--rollback DROP TABLE abc.test_table_03;