-- PL/SQL Cursors
-- Using Explicit Cursors
DECLARE
    CURSOR c_emps IS SELECT first_name, last_name, department_name
                     FROM hr.employees INNER JOIN hr.departments USING (department_id)
                     WHERE department_id BETWEEN 30 AND 60;
    v_first_name hr.employees.first_name%TYPE;
    v_last_name hr.employees.last_name%TYPE;
    v_department_name hr.departments.department_name%TYPE;
BEGIN
    OPEN c_emps;
    FETCH c_emps INTO v_first_name, v_last_name, v_department_name;
    DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name ||
                         ' in the department of ' || v_department_name);
    CLOSE c_emps;
END;


-- Using Cursors with Records
DECLARE 
    TYPE r_emp IS RECORD (
        v_first_name hr.employees.first_name%TYPE,
        v_last_name hr.employees.last_name%TYPE
    );
    v_emp r_emp;
    CURSOR c_emps IS SELECT first_name, last_name FROM hr.employees;
BEGIN
    OPEN c_emps;
    FETCH c_emps INTO v_emp;
    DBMS_OUTPUT.PUT_LINE(v_emp.v_first_name || ' ' || v_emp.v_last_name);
    CLOSE c_emps;
END;

DECLARE
    CURSOR c_emps IS SELECT first_name, last_name FROM hr.employees;
    v_emp c_emps%ROWTYPE;
BEGIN
    OPEN c_emps;
    FETCH c_emps INTO v_emp.first_name, v_emp.last_name;
    DBMS_OUTPUT.PUT_LINE(v_emp.first_name || ' '
        || v_emp.last_name);
    CLOSE c_emps;
END;


-- Looping with Cursors
DECLARE
    CURSOR c_emps IS SELECT * FROM hr.employees 
                     WHERE department_id = 30;
    v_emps c_emps%ROWTYPE;
BEGIN
    OPEN c_emps;
    LOOP
        FETCH c_emps INTO v_emps;
        EXIT WHEN c_emps%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_emps.employee_id || ' ' || 
                             v_emps.first_name || ' ' || v_emps.last_name);
    END LOOP;
    CLOSE c_emps;
END;

DECLARE
    CURSOR c_emps IS SELECT * FROM hr.employees 
                     WHERE department_id = 30;
    v_emps c_emps%ROWTYPE;
BEGIN
    OPEN c_emps;
    WHILE c_emps%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(v_emps.employee_id || ' ' || 
                             v_emps.first_name || ' ' || v_emps.last_name);
        FETCH c_emps INTO v_emps;
    END LOOP;
    CLOSE c_emps;
END;

-- best way to loop a cursor using a for loop
DECLARE
    --CURSOR c_emps IS SELECT * FROM hr.employees 
    --               WHERE department_id = 30;
BEGIN
    --FOR i IN c_emps LOOP
    FOR i IN (SELECT * FROM hr.employees WHERE department_id = 30) LOOP
        DBMS_OUTPUT.PUT_LINE(i.employee_id || ' ' || 
                             i.first_name || ' ' || i.last_name);
    END LOOP;
END;


-- PL/SQL Cursors with Parameters
DECLARE
    CURSOR c_emps (p_dept_id NUMBER, p_job_id VARCHAR2) IS 
        SELECT first_name, last_name, job_id, department_name
        FROM hr.employees JOIN hr.departments USING (department_id)
        WHERE department_id = p_dept_id AND job_id = p_job_id;
    v_emps c_emps%ROWTYPE;
BEGIN
    OPEN c_emps(50, 'ST_MAN');
    FETCH c_emps INTO v_emps;
    DBMS_OUTPUT.PUT_LINE(chr(10) || 'The employees in department of ' 
        || v_emps.department_name || ' are: '); 
    CLOSE c_emps;

    FOR i IN c_emps(50, 'ST_MAN') LOOP
        DBMS_OUTPUT.PUT_LINE(i.first_name || ' ' || i.last_name);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('---------------');

    OPEN c_emps(80, 'SA_MAN');
    FETCH c_emps INTO v_emps;
    DBMS_OUTPUT.PUT_LINE('The employees in department of ' 
        || v_emps.department_name || ' are: '); 
    CLOSE c_emps;

    FOR i IN c_emps(80, 'SA_MAN') LOOP
        DBMS_OUTPUT.PUT_LINE(i.first_name || ' ' || i.last_name);
    END LOOP;
END;
