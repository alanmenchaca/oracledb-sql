/************* The Complete Oracle SQL Bootcamp *************
 * Author  : Oracle Master Training                         *
 * Course  : The Complete Oracle SQL Bootcamp               *
 * Lecture : INSERT Statement (Part 2)                      *
 ************************************************************/

SELECT * FROM jobs_copy;

(EX)INSERT INTO jobs_copy (job_id, min_salary)
VALUES('DATA_ARCH2',8000);

INSERT INTO jobs_copy
VALUES('DATA_ARCH2',8000);

INSERT INTO jobs_copy
VALUES('DATA_ARCH2','Data Architecture2',8000);

INSERT INTO jobs_copy
VALUES('DATA_ARCH3','Data Architecture3',8000, NULL);

INSERT INTO jobs_copy
VALUES('DATA_ARCH4',upper('Data Architecture4'),8000, NULL);

SELECT * FROM employees_copy;

INSERT INTO employees_copy SELECT * FROM employees;

INSERT INTO employees_copy SELECT * FROM employees WHERE job_id = 'IT_PROG';

INSERT INTO employees_copy(first_name,last_name,email,hire_date,job_id)
SELECT first_name,last_name,email,hire_date,job_id FROM employees WHERE job_id = 'IT_PROG';

INSERT INTO employee_addresses 
SELECT employee_id, first_name, last_name, city || ' - ' || street_address AS address
  FROM employees
  JOIN departments  USING (department_id) 
  JOIN locations    USING (location_id);

CREATE TABLE employee_addresses AS
SELECT employee_id, first_name, last_name, city || ' - ' || street_address AS address
  FROM employees
  JOIN departments  USING (department_id) 
  JOIN locations    USING (location_id)
WHERE 1=2;

SELECT * FROM employee_addresses;