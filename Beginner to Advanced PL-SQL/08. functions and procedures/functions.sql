-- PL/SQL FUNCTIONS
-- Creating and Using Functions
CREATE OR REPLACE FUNCTION get_avg_sal (
    p_dept_id hr.departments.department_id%TYPE
) RETURN NUMBER AS
    v_avg_sal NUMBER;
BEGIN
    SELECT AVG(salary) INTO v_avg_sal FROM hr.employees
    WHERE department_id = p_dept_id; 
    RETURN ROUND(v_avg_sal, 2);
END get_avg_sal;

DECLARE
    v_avg_salary NUMBER;
BEGIN
    v_avg_salary := get_avg_sal(50);
    DBMS_OUTPUT.PUT_LINE('v_avg_salary: ' || v_avg_salary);
END;

SELECT employee_id, first_name, salary, 
       get_avg_sal(department_id) AS avg_salary
FROM hr.employees WHERE salary > get_avg_sal(department_id);

SELECT get_avg_sal(department_id) AS avg_salary 
FROM hr.employees WHERE salary > get_avg_sal(department_id)
GROUP BY get_avg_sal(department_id)
ORDER BY get_avg_sal(department_id);


-- Local Subprograms
CREATE TABLE emps_high_paid AS SELECT * FROM hr.employees WHERE 1 = 2;
DECLARE
    FUNCTION get_emp (
        emp_id hr.employees.employee_id%TYPE
    ) RETURN hr.employees%ROWTYPE IS
        emp hr.employees%ROWTYPE;
    BEGIN
        SELECT * INTO emp FROM hr.employees WHERE employee_id = emp_id;
        RETURN emp;
    END get_emp;

    PROCEDURE insert_high_paid_emp (
        emp_id hr.employees.employee_id%TYPE
    ) IS
        emp hr.employees%ROWTYPE;
    BEGIN
        emp := get_emp(emp_id);
        INSERT INTO emps_high_paid VALUES emp;
    END insert_high_paid_emp;
BEGIN
    FOR r_emp IN (SELECT * FROM hr.employees) LOOP
        IF r_emp.salary > 15000 THEN
            insert_high_paid_emp(r_emp.employee_id);
        END IF;
    END LOOP;
END;
/
SELECT * FROM emps_high_paid;
/
BEGIN
    insert_high_paid_emp(102);
END;


-- Overloading the Subprograms
DECLARE
    PROCEDURE insert_high_paid_emp (
        p_emp hr.employees%ROWTYPE
    ) IS
        emp hr.employees%ROWTYPE;
        e_id NUMBER;
        FUNCTION get_emp (emp_num hr.employees.employee_id%TYPE)
        RETURN hr.employees%ROWTYPE IS
        BEGIN
            SELECT * INTO emp FROM hr.employees WHERE employee_id = emp_num;
            RETURN emp;
        END get_emp;
        FUNCTION get_emp (emp_email hr.employees.email%TYPE)
        RETURN hr.employees%ROWTYPE IS
        BEGIN
            SELECT * INTO emp FROM hr.employees WHERE email = emp_email;
            RETURN emp;
        END get_emp;
        FUNCTION get_emp (f_name hr.employees.first_name%TYPE, l_name VARCHAR2)
        RETURN hr.employees%ROWTYPE IS
        BEGIN
            SELECT * INTO emp FROM hr.employees 
            WHERE first_name = f_name AND l_name = last_name;
            RETURN emp;
        END get_emp;
    BEGIN
        emp := get_emp(p_emp.employee_id);
        INSERT INTO emps_high_paid VALUES emp;

        emp := get_emp(p_emp.email);
        INSERT INTO emps_high_paid VALUES emp;

        emp := get_emp(p_emp.first_name, p_emp.last_name);
        INSERT INTO emps_high_paid VALUES emp;
    END insert_high_paid_emp;
BEGIN
    FOR r_emp IN (SELECT * FROM hr.employees) LOOP
        IF r_emp.salary > 15000 THEN
            insert_high_paid_emp(r_emp);
        END IF;
    END LOOP;
END;

DELETE emps_high_paid;
SELECT * FROM emps_high_paid;

-- Handling the Exceptions in Subprograms
CREATE OR REPLACE FUNCTION get_emp (
    emp_num hr.employees.employee_id%TYPE
) RETURN hr.employees%ROWTYPE IS 
    emp hr.employees%ROWTYPE;
BEGIN
    SELECT * INTO emp FROM hr.employees 
    WHERE employee_id = emp_num;
    RETURN emp;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('There is no employee with the id of: ' || emp_num); 
END;

DECLARE 
    v_emp hr.employees%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Fetching the employee data!..');
    v_emp := get_emp(10);
    DBMS_OUTPUT.PUT_LINE('Some of the information of the employee are: ');
    DBMS_OUTPUT.PUT_LINE('The name of the employee is: ' || v_emp.first_name);
    DBMS_OUTPUT.PUT_LINE('The email of the employee is: ' || v_emp.email);
    DBMS_OUTPUT.PUT_LINE('The salary of the employee is: ' || v_emp.salary);
END;

EXECUTE create_copy_tables;
EXECUTE drop_copy_tables;


-- Regular & Pipelined Table Functions 
CREATE TYPE t_days AS OBJECT (
    v_date DATE,
    v_day_number INT
);
/
CREATE TYPE t_days_tab IS TABLE OF t_days;
/
CREATE OR REPLACE FUNCTION f_get_days (
    p_start_date DATE,
    p_day_number INT
) RETURN t_days_tab 
IS
    v_days t_days_tab := t_days_tab();
BEGIN
    FOR i IN 1..p_day_number LOOP
        v_days.EXTEND;
        v_days(i) := t_days(p_start_date + i, 
                            TO_NUMBER(TO_CHAR(p_start_date + i, 'DDD')));
    END LOOP;
    RETURN v_days;
END f_get_days;
/
SELECT * FROM TABLE(f_get_days(SYSDATE, 50)); -- 12.1 or earlier
/
SELECT * FROM f_get_days(SYSDATE, 1000000);
/
CREATE OR REPLACE FUNCTION f_get_days_piped (
    p_start_date DATE,
    p_day_number INT
) RETURN t_days_tab PIPELINED
IS
--  v_days t_days_tab := t_days_tab();
BEGIN
    FOR i IN 1..p_day_number LOOP
--      v_days.EXTEND;
        PIPE ROW (t_days(p_start_date + i,
                         TO_NUMBER(TO_CHAR(p_start_date + i, 'DDD'))));
    END LOOP;
    RETURN;
END f_get_days_piped;
/
SELECT * FROM f_get_days(SYSDATE, 1000000)
ORDER BY 1 DESC;
/
SELECT * FROM f_get_days_piped(SYSDATE, 1000000)
ORDER BY 1 DESC;
/
