-- PL/SQL Exceptions
-- What are the Exceptions?
DECLARE
    v_name VARCHAR2(50);
BEGIN
    SELECT first_name INTO v_name FROM hr.employees WHERE employee_id = 50;
    DBMS_OUTPUT.PUT_LINE('Hello');
END;


-- Handling Predefined Exceptions
DECLARE
    v_name VARCHAR2(6);
    v_department_name VARCHAR2(100);
BEGIN
    -- SELECT first_name INTO v_name FROM hr.employees WHERE employee_id = 50;
    SELECT first_name INTO v_name FROM hr.employees WHERE employee_id = 100;

    BEGIN
        SELECT department_id INTO v_department_name 
        FROM hr.employees WHERE first_name = v_name;
    EXCEPTION
        WHEN too_many_rows THEN
            v_department_name := 'Error in department name';        
    END;

    DBMS_OUTPUT.PUT_LINE('Hello ' || v_name || 
        '. Your department is: ' || v_department_name);
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('There is no employee with the selected id.');
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('There are more than one employee with the name ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Try with a different employee.');
    WHEN others THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error happened. Connect with the programmer.');
        DBMS_OUTPUT.PUT_LINE(sqlcode || ' --> ' || sqlerrm);
END;


-- Handling Nonpredefined Exceptions
DECLARE
    cannot_update_to_null EXCEPTION;
    PRAGMA EXCEPTION_INIT(cannot_update_to_null, -01407);
BEGIN
    UPDATE hr.employees SET email = null WHERE employee_id = 100;
EXCEPTION
    WHEN cannot_update_to_null THEN
        DBMS_OUTPUT.PUT_LINE('You cannot update with a null value!');
END;


-- Handling & Raising User-Defined Exceptions
DECLARE
    too_high_salary EXCEPTION;
    v_salary_check PLS_INTEGER;
BEGIN
    SELECT salary INTO v_salary_check 
    FROM hr.employees WHERE employee_id = 100;

    IF v_salary_check > 20000 THEN
        -- RAISE invalid number;
        RAISE too_high_salary;
    END IF;
    -- we do our business if the salary is under 20,000.
    DBMS_OUTPUT.PUT_LINE('The salary is in an acceptable range.');
EXCEPTION
    WHEN too_high_salary THEN
    DBMS_OUTPUT.PUT_LINE('This salary is too high. We need to decrease it.');
    RAISE;
END;


-- Using RAISE_APPLICATION_ERROR() Procedure
DECLARE
    too_high_salary EXCEPTION;
    v_salary_check PLS_INTEGER;
BEGIN
    SELECT salary INTO v_salary_check FROM hr.employees
    WHERE employee_id = 100;
    IF v_salary_check > 20000 THEN
        -- RAISE too_high_salary;
        RAISE_APPLICATION_ERROR(-20243, 'The salary of the selected employee is too high!');
    END IF;
    -- we do our business if the salary is under 20000
    DBMS_OUTPUT.PUT_LINE('The salary is in an acceptable range.');
EXCEPTION
    WHEN too_high_salary THEN
        DBMS_OUTPUT.PUT_LINE('This salary is too high. You need to decrease it');
        RAISE_APPLICATION_ERROR(-20243, 'The salary of the selected employee is too high!', TRUE);
END;
