--liquibase formatted sql

--changeset amy.smith:test_table_04 labels:v0.1.0
CREATE TABLE abc.new_table_04 (
	test_id int4 NOT NULL,
	test_column varchar NULL,
	CONSTRAINT new_table_04_pkey PRIMARY KEY (test_id)
);
--rollback DROP TABLE abc.new_table_04;