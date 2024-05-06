-- USING SQL IN PL/SQL
-- Operating with Selected Database Data
DECLARE
    /* We need to be careful on naming our variables when we use
       our variables in where clauses. Our variable names should
       be different than our column names. */ 
	v_name VARCHAR2(50);
	v_salary hr.employees.salary%TYPE;
	v_employee_id hr.employees.employee_id%TYPE := 130;
BEGIN
    SELECT first_name || ' ' || last_name, salary INTO v_name, v_salary 
    FROM hr.employees WHERE employee_id = v_employee_id;
	DBMS_OUTPUT.PUT_LINE('The salary of ' || v_name || ' is: ' || v_salary);
END;


-- DML operations in PL/SQL
CREATE TABLE employees_copy AS SELECT * FROM hr.employees;
DROP TABLE employees_copy;

DECLARE
    v_salary_increase NUMBER := 400;
BEGIN
    FOR i IN 207..216 LOOP
    /*
    	INSERT INTO employees_copy 
    		(employee_id, first_name, last_name,  
    		 email, hire_date, job_id, salary)
    		VALUES (i, 'employee_id%' || i, 'temp_emp', 
    				'abc@email.com', sysdate, 'IT_PROG', 1000);
	*/  
    	-- UPDATE employees_copy SET salary = salary + v_salary_increase
    	-- WHERE employee_id = i;
    	DELETE FROM employees_copy WHERE employee_id = i;
	END LOOP;
END;

SELECT * FROM employees_copy
ORDER BY employee_id DESC
FETCH FIRST 10 ROWS ONLY;


-- Using Sequences in PL/SQL 
-- SELECT sequence_name.nextval|currval INTO variable|column
-- FROM table_name|dual;
-- Variable|column := sequence_name.nextval|currval;
CREATE TABLE employees_copy AS SELECT * FROM hr.employees;
DROP TABLE employees_copy;

CREATE SEQUENCE employee_id_seq
START WITH 207
INCREMENT BY 1;

DECLARE
    v_employee_id PLS_INTEGER := 0;
BEGIN
	FOR i IN 1..10 LOOP
    	INSERT INTO employees_copy 
    		(employee_id, first_name, last_name,  
    		 email, hire_date, job_id, salary)
    		VALUES (employee_id_seq.NEXTVAL, 'employee_id%' || i, 'temp_emp', 
    				'abc@email.com', sysdate, 'IT_PROG', 1000);
	END LOOP;
END;

SELECT * FROM employees_copy
ORDER BY employee_id DESC
FETCH FIRST 15 ROWS ONLY;

DECLARE
	v_seq_num NUMBER;
BEGIN
    -- SELECT employee_id_seq.NEXTVAL INTO v_seq_num 
    -- FROM employees_copy WHERE ROWNUM = 1;
    -- SELECT employee_id_seq.NEXTVAL INTO v_seq_num FROM dual;
	-- v_seq_num := employee_id_seq.NEXTVAL;
    -- DBMS_OUTPUT.PUT_LINE(v_seq_num);
    DBMS_OUTPUT.PUT_LINE(employee_id_seq.NEXTVAL);
END;
