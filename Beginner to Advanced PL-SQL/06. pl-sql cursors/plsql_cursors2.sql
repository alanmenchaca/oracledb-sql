-- PL/SQL Cursors
-- For Update Clause
-- system schema
CREATE USER my_user IDENTIFIED BY 123;
GRANT CREATE SESSION TO my_user;
GRANT SELECT ANY TABLE TO my_user;
GRANT UPDATE ON hr.employees_copy TO my_user;
GRANT UPDATE ON hr.departments TO my_user;

-- hr schema
DECLARE
    CURSOR c_emps IS
    	SELECT employee_id, first_name, last_name, department_id
    	FROM hr.employees JOIN hr.departments USING (department_id)
    	WHERE employee_id IN (100, 101, 102) 
    -- we can specify WAIT 5, or NOWAIT
	FOR UPDATE OF hr.employees.phone_number, departments.location_id;
BEGIN
    FOR r_emps IN c_emps LOOP
    	UPDATE hr.employees SET phone_number = 3
    		WHERE employee_id = r_emps.employee_id;
    END LOOP;
END;

-- my_user schema
UPDATE hr.employees_copy SET pone_number = '1'
	WHERE employee_id = 100;
/
UPDATE hr.departments SET department_name = 'x'
	WHERE department_id = 90;


-- Where Current Of Clause
SELECT rowid, employees.* FROM hr.employees WHERE department_id = 30;
/
DECLARE
    CURSOR c_emps IS 
    	SELECT * FROM hr.employees 
    	WHERE department_id = 30 
    FOR UPDATE;
BEGIN
    FOR r_emps IN c_emps LOOP
    	-- We can't use WHERE CURRENT OF sentence when using 
    	-- INNER JOINS in the COURSOR SELECT statement.
    	UPDATE hr.employees SET salary = salary + 60
    		WHERE CURRENT OF c_emps;
    		-- WHERE employee_id = r_emps.employee_id;
    END LOOP;
END;


-- Reference Cursors (Ref Cursors)
DECLARE
    TYPE t_emps IS REF CURSOR RETURN hr.employees%ROWTYPE;
	rc_emps t_emps;
--	r_emps hr.employees%ROWTYPE;
	TYPE t_emps2 IS REF CURSOR RETURN rc_emps%ROWTYPE;
	r_emps rc_emps%ROWTYPE;
BEGIN
    OPEN rc_emps FOR SELECT * FROM hr.employees;
	LOOP
	    FETCH rc_emps INTO r_emps;
		EXIT WHEN rc_emps%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(r_emps.first_name || ' ' || r_emps.last_name);
    END LOOP;
	CLOSE rc_emps;

	DBMS_OUTPUT.PUT_LINE('----------------');
	
	OPEN rc_emps FOR SELECT * FROM hr.employees
        			 WHERE job_id = 'IT_PROG';
	LOOP
    	FETCH rc_emps INTO r_emps;
		EXIT WHEN rc_emps%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(r_emps.first_name 
        	|| ' ' || r_emps.last_name);
	END LOOP;
	CLOSE rc_emps;
END;

-- Strong Cursor
DECLARE
    TYPE ty_emps IS RECORD (	
    	e_id NUMBER,
    	first_name hr.employees.first_name%TYPE,
    	last_name hr.employees.last_name%TYPE,
    	department_name hr.departments.department_name%TYPE
    );
	TYPE sc_emps IS REF CURSOR RETURN ty_emps;
	r_emps ty_emps;
	rc_emps sc_emps;
BEGIN
	OPEN rc_emps FOR SELECT e.employee_id, e.first_name, e.last_name, d.department_name
        	  		 FROM hr.employees e INNER JOIN hr.departments d USING (department_id);
	LOOP
    	FETCH rc_emps INTO r_emps;
		EXIT WHEN rc_emps%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(r_emps.first_name || ' ' || r_emps.last_name
            	|| ' is at the department of: ' || r_emps.department_name);
	END LOOP;
	CLOSE rc_emps;
END;

-- Weak Cursor
DECLARE
    TYPE t_emp IS RECORD (
    	employee_id NUMBER,
    	first_name hr.employees.first_name%TYPE,
    	last_name hr.employees.last_name%TYPE,
    	department_name hr.departments.department_name%TYPE
    );
	--TYPE ct_emps IS REF CURSOR;
	r_emps t_emp;
	c_emps SYS_REFCURSOR;
	r_depts hr.departments%ROWTYPE;
	query VARCHAR2(200);
BEGIN
    query := 'SELECT e.employee_id, e.first_name, e.last_name, d.department_name
    		  FROM hr.employees e INNER JOIN hr.departments d USING(department_id)
    		  WHERE department_id = :b';
	OPEN c_emps FOR query USING '50';
	LOOP
        FETCH c_emps INTO r_emps;
		EXIT WHEN c_emps%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(r_emps.first_name || ' ' || r_emps.last_name
            	|| ' is at the department of: ' || r_emps.department_name);
    END LOOP;
	CLOSE c_emps;

	OPEN c_emps FOR SELECT * FROM hr.departments;
	LOOP
        FETCH c_emps INTO r_depts;
		EXIT WHEN c_emps%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(r_depts.department_id || ' ' ||
        	r_depts.department_name);
    END LOOP;
	CLOSE c_emps;
END;
