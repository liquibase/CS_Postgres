--liquibase formatted sql

--changeset amy.smith:test_table_02 labels:v0.1.0
create table abc.test_table_02 (
    id SERIAL
)
--rollback DROP TABLE abc.test_table_02;