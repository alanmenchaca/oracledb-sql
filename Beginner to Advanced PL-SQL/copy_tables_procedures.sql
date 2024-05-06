
CREATE OR REPLACE PROCEDURE create_copy_tables IS
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE employees_copy AS SELECT * FROM hr.employees';
    EXECUTE IMMEDIATE 'CREATE TABLE jobs_copy AS SELECT * FROM hr.jobs';
END;

CREATE OR REPLACE PROCEDURE drop_copy_tables IS
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE employees_copy';
    EXECUTE IMMEDIATE 'DROP TABLE jobs_copy';
END;

EXECUTE create_copy_tables;
EXECUTE drop_copy_tables;
