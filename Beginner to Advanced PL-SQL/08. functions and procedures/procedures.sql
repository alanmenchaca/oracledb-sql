-- PL/SQL PROCEDURES
-- What are Functions & Procedures
CREATE TABLE employees_copy AS SELECT * FROM hr.employees;
DECLARE 
    CURSOR c_emps IS SELECT * FROM employees_copy FOR UPDATE; 
    v_salary_increase PLS_INTEGER := 1.10; 
    v_old_salary PLS_INTEGER; 
BEGIN 
    FOR r_emp IN c_emps LOOP 
        v_old_salary := r_emp.salary; 
        r_emp.salary := v_old_salary * v_salary_increase + v_old_salary * NVL(r_emp.commission_pct, 0);  
  
        UPDATE employees_copy SET ROW = r_emps WHERE CURRENT OF c_emps; 
        DBMS_OUTPUT.PUT_LINE('The salary of: ' || r_emp.employee_id 
            || ' is increased from ' || v_old_salary || ' to ' || r_emp.salary); 
    END LOOP; 
END;

-- Creating and Using Stored Procedures
CREATE TABLE employees_copy AS SELECT * FROM hr.employees;
CREATE OR REPLACE PROCEDURE increase_salaries AS 
    CURSOR c_emps IS SELECT * FROM employees_copy FOR UPDATE; 
    v_salary_increase PLS_INTEGER := 1.10; 
    v_old_salary PLS_INTEGER; 
BEGIN 
    FOR r_emp IN c_emps LOOP 
        v_old_salary := r_emp.salary; 
        r_emp.salary := v_old_salary * v_salary_increase + v_old_salary * NVL(r_emp.commission_pct, 0);  
  
        UPDATE employees_copy SET ROW = r_emp WHERE CURRENT OF c_emps; 
        DBMS_OUTPUT.PUT_LINE('The salary of: ' || r_emp.employee_id
            || ' is increased from ' || v_old_salary || ' to ' || r_emp.salary); 
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE('PROCEDURE FINISHED EXECUTING!...'); 
END;

CREATE OR REPLACE PROCEDURE new_line AS 
BEGIN 
    DBMS_OUTPUT.PUT_LINE('------------------------------------------'); 
END;

EXECUTE increase_salary;
EXECUTE new_line;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('INCREASING THE SALARIES!...'); 
    increase_salaries; 
    new_line; 
    increase_salaries; 
    new_line; 
    increase_salaries; 
    DBMS_OUTPUT.PUT_LINE('ALL THE SALARIES ARE SUCCESSFULLY INCREASED!...'); 
END;


-- Using IN & OUT Parameters
CREATE TABLE employees_copy AS SELECT * FROM hr.employees;
CREATE OR REPLACE PROCEDURE increase_salaries ( 
    v_salary_increase IN NUMBER, 
    v_department_id PLS_INTEGER 
) AS 
    CURSOR c_emps IS SELECT * FROM employees_copy 
    WHERE department_id = v_department_id FOR UPDATE; 
--  v_salary_increase PLS_INTEGER := 1.10; 
    v_old_salary PLS_INTEGER; 
BEGIN 
    FOR r_emp IN c_emps LOOP 
        v_old_salary := r_emp.salary; 
        r_emp.salary := v_old_salary * v_salary_increase + v_old_salary * NVL(r_emp.commission_pct, 0);  
  
        UPDATE employees_copy SET ROW = r_emp WHERE CURRENT OF c_emps; 
        DBMS_OUTPUT.PUT_LINE('The salary of: ' || r_emp.employee_id 
            || ' is increased from ' || v_old_salary || ' to ' || r_emp.salary); 
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE('PROCEDURE FINISHED EXECUTING!...'); 
END; 

CREATE OR REPLACE PROCEDURE print (text IN VARCHAR2) IS 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(text); 
END;

BEGIN 
    print('SALARY INCREASE STARTED!'); 
    increase_salaries(v_salary_increase => 1.15, 
                      v_department_id => 90); 
    print('SALARY INCREASE FINISHED!'); 
END;

CREATE OR REPLACE PROCEDURE increase_salaries ( 
    v_salary_increase IN OUT NUMBER, 
    v_department_id PLS_INTEGER, 
    v_affected_employee_count OUT NUMBER 
) AS 
    CURSOR c_emps IS SELECT * FROM employees_copy 
    WHERE department_id = v_department_id FOR UPDATE; 
--  v_salary_increase PLS_INTEGER := 1.10; 
    v_old_salary NUMBER; 
    v_salary_inc NUMBER := 0; 
BEGIN 
    v_affected_employee_count := 0; 
    FOR r_emp IN c_emps LOOP 
        v_old_salary := r_emp.salary; 
        r_emp.salary := v_old_salary * v_salary_increase + v_old_salary * NVL(r_emp.commission_pct, 0);  
  
        UPDATE employees_copy SET ROW = r_emp WHERE CURRENT OF c_emps; 
        DBMS_OUTPUT.PUT_LINE('The salary of: ' || r_emp.employee_id 
            || ' is increased from ' || v_old_salary || ' to ' || r_emp.salary); 
        v_affected_employee_count := v_affected_employee_count + 1; 
        v_salary_inc := v_salary_inc + v_salary_increase + NVL(r_emp.commission_pct, 0); 
    END LOOP; 
    v_salary_increase := v_salary_inc / v_affected_employee_count; 
    DBMS_OUTPUT.PUT_LINE('PROCEDURE FINISHED EXECUTING!...'); 
END;

DECLARE 
    v_salary_inc NUMBER := 1.2; 
    v_aff_emp_count NUMBER; 
BEGIN 
    print('SALARY INCREASE STARTED!'); 
    increase_salaries(v_salary_inc, 80, v_aff_emp_count); 
    print('The affected employee count is: ' || v_aff_emp_count); 
    print('The average salary increase is: ' || v_salary_inc || ' percent!...'); 
    print('SALARY INCREASE FINISHED!'); 
END;


-- Named & Mixed Notations and Default Option
CREATE OR REPLACE PROCEDURE PRINT (
    text IN VARCHAR2 DEFAULT 'This is the print procedure!.'
) IS 
BEGIN
    DBMS_OUTPUT.PUT_LINE(text);
END;

EXECUTE print('Hello, World!'); -- 'Hello, World!'
EXECUTE print(NULL); -- does not print anything
EXECUTE print(); -- 'This is the print procedure!.'

CREATE TABLE jobs_copy AS SELECT * FROM hr.jobs;
CREATE OR REPLACE PROCEDURE add_job (
    job_id VARCHAR2,
    job_title VARCHAR2,
    min_salary NUMBER DEFAULT 1000,
    max_salary NUMBER DEFAULT NULL
) IS 
BEGIN
    INSERT INTO jobs_copy VALUES (job_id, job_title, min_salary, max_salary);
    print('The job: ' || job_title || ' is inserted!...');
END;

EXECUTE add_job('IT_DIR', 'IT Director', 5000, 20000);
EXECUTE add_job('IT_DIR2', 'IT Director', 5000);
EXECUTE add_job('IT_DIR3', 'IT Director');
-- PLS-00306: wrong number or types of arguments in call to 'ADD_JOB' 
EXECUTE add_job('IT_DIR4');
EXECUTE add_job('IT_DIR5', 'IT Director', max_salary => 10000);
EXECUTE add_job('IT_DIR6', 'IT Director', max_salary => 10000, min_salary => 500);
EXECUTE add_job(job_title => 'IT Director', job_id => 'IT_DIR7', max_salary => 10000, min_salary => 500);
SELECT * FROM jobs_copy;
