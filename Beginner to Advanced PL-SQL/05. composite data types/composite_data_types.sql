-- COMPOSITE DATA TYPES
-- PL/SQL Records
DECLARE 
	TYPE t_edu IS RECORD ( 
    	primary_school VARCHAR2(100), 
    	high_school VARCHAR2(100), 
    	university VARCHAR2(100), 
    	uni_graduate_date VARCHAR2(100) 
    ); 
	TYPE t_emp IS RECORD ( 
        first_name VARCHAR2(100), 
        last_name hr.employees.last_name%TYPE, 
        salary hr.employees.salary%TYPE NOT NULL DEFAULT 1000, 
        hire_date DATE, 
        dept_id hr.employees.department_id%TYPE, 
        department hr.departments%ROWTYPE, 
        education t_edu 
    ); 
	r_emp t_emp; 
BEGIN 
    SELECT first_name, last_name, salary, hire_date, department_id  
    INTO r_emp.first_name, r_emp.last_name, r_emp.salary,  
    	 r_emp.hire_date, r_emp.dept_id 
    FROM hr.employees WHERE employee_id = '146'; 
	 
	SELECT * INTO r_emp.department FROM hr.departments 
    WHERE department_id = r_emp.dept_id;  
 
    r_emp.education.high_school := 'Beverly Hills'; 
    r_emp.education.university := 'Oxford'; 
    r_emp.education.uni_graduate_date := '01-JAN-13'; 
 
	DBMS_OUTPUT.PUT_LINE( 
        r_emp.first_name || ' ' || r_emp.last_name ||  
        ' earns ' || r_emp.salary || ' and hired at: ' || 
        r_emp.hire_date 
    ); 
	DBMS_OUTPUT.PUT_LINE( 
        'She graduated from ' || r_emp.education.university ||  
        ' at ' || r_emp.education.uni_graduate_date 
    ); 
	DBMS_OUTPUT.PUT_LINE( 
        'Her department name is: ' || r_emp.department.department_name 
    ); 
END; 


-- Easy DML with Records
CREATE TABLE retired_employees
    AS SELECT * FROM hr.employees WHERE 1 = 2;
DROP TABLE retired_employees;

DECLARE 
    r_emp hr.employees%ROWTYPE;   
BEGIN 
    SELECT * INTO r_emp FROM hr.employees WHERE employee_id = 104; 
	INSERT INTO retired_employees VALUES r_emp; 
END; 

DECLARE 
    r_emp hr.employees%ROWTYPE;   
BEGIN 
    SELECT * INTO r_emp FROM hr.employees WHERE employee_id = 104; 
	r_emp.salary := 10; 
	r_emp.commission_pct := 0; 
	-- INSERT INTO retired_employees VALUES r_emp; 
	UPDATE retired_employees SET ROW = r_emp WHERE employee_id = 104;    
END; 


-- Varrays
DECLARE 
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50); 
	employees e_list; 
BEGIN 
	employees := e_list('Alex', 'Bruce', 'John', 'Bob', 'Richard'); 
	FOR i IN 1..5 LOOP 
    	DBMS_OUTPUT.PUT_LINE(employees(i)); 
	END LOOP; 
END;

DECLARE 
--  ORA-06532: Subscript outside of limit. 
--  TYPE e_list IS VARRAY(4) OF VARCHAR2(50); 
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50); 
	employees e_list;  
BEGIN 
	employees := e_list('Alex', 'Bruce', 'John', 'Bob'); 
	FOR i IN 1..employees.COUNT() LOOP 
    	DBMS_OUTPUT.PUT_LINE(employees(i)); 
	END LOOP; 
END; 

DECLARE 
--  ORA-06532: Subscript outside of limit. 
--  TYPE e_list IS VARRAY(4) OF VARCHAR2(50); 
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50); 
	employees e_list;  
BEGIN 
	employees := e_list('Alex', 'Bruce', 'John', 'Bob'); 
--	FOR i IN employees.FIRST()..employees.LAST() LOOP 
	FOR i IN 1..5 LOOP 
    	IF employees.EXISTS(i) THEN 
        	DBMS_OUTPUT.PUT_LINE(employees(i)); 
        END IF; 
	END LOOP; 
	DBMS_OUTPUT.PUT_LINE(employees.LIMIT()); 
END;

CREATE OR REPLACE TYPE e_list IS VARRAY(20) OF VARCHAR2(100);
DECLARE 
    TYPE e_list IS VARRAY(15) OF VARCHAR2(50); 
	employees e_list := e_list(); 
	idx NUMBER := 1; 
BEGIN 
    FOR i in 100..110 LOOP 
    	employees.EXTEND; 
		SELECT first_name INTO employees(idx)  
        FROM hr.employees WHERE employee_id = i; 
		idx := idx + 1; 
    END LOOP; 
 
	FOR i in 1..employees.COUNT() LOOP 
    	DBMS_OUTPUT.PUT_LINE(employees(i)); 
    END LOOP; 
END; 

 
-- Nested Tables 
DECLARE 
    TYPE e_list IS TABLE OF VARCHAR2(50); 
	emps e_list := e_list('Alex', 'Bruce', 'John'); 
BEGIN 
    emps.EXTEND; 
    emps(4) := 'Bob';  
    FOR i IN 1..emps.COUNT() LOOP 
    	DBMS_OUTPUT.PUT_LINE(emps(i)); 
    END LOOP; 
END;

DECLARE 
    TYPE e_list IS TABLE OF hr.employees.first_name%TYPE; 
	emps e_list := e_list(); 
	idx PLS_INTEGER := 1; 
BEGIN 
    FOR i IN 100..110 LOOP 
    	emps.EXTEND; 
    	SELECT first_name INTO emps(idx)  
    	FROM hr.employees WHERE employee_id = i; 
    	idx := idx + 1; 
    END LOOP; 
 
	FOR i IN 1..emps.COUNT() LOOP 
    	DBMS_OUTPUT.PUT_LINE(emps(i)); 
	END LOOP; 
END;

DECLARE 
    TYPE e_list IS TABLE OF hr.employees.first_name%TYPE; 
	emps e_list := e_list(); 
	idx PLS_INTEGER := 1; 
BEGIN 
    FOR i IN 100..110 LOOP 
    	emps.EXTEND; 
    	SELECT first_name INTO emps(idx)  
    	FROM hr.employees WHERE employee_id = i; 
    	idx := idx + 1; 
    END LOOP; 
 
	emps.DELETE(3); 
 
	FOR i IN 1..emps.COUNT() LOOP 
		IF emps.EXISTS(i) THEN 
        	DBMS_OUTPUT.PUT_LINE(emps(i)); 
        END IF; 
	END LOOP; 
END;

 
-- PL&SQL Associative Arrays 
DECLARE 
    TYPE e_list IS TABLE OF hr.employees.first_name%TYPE 
    	INDEX BY PLS_INTEGER; 
	emps e_list; 
BEGIN 
    FOR i IN 100..110 LOOP 
    	SELECT first_name INTO emps(i) FROM hr.employees  
    	WHERE employee_id = i; 
    END LOOP; 
 
	FOR i IN emps.FIRST..emps.LAST LOOP 
        DBMS_OUTPUT.PUT_LINE(emps(i)); 
    END LOOP; 
END;

DECLARE
    TYPE e_list IS TABLE OF hr.employees.first_name%TYPE 
    	INDEX BY PLS_INTEGER; 
	emps e_list; 
	idx PLS_INTEGER; 
BEGIN 
    emps(100) := 'Bob';
	emps(120) := 'Sue'; 
	idx := emps.FIRST; 
 
    WHILE idx IS NOT NULL LOOP 
		DBMS_OUTPUT.PUT_LINE(emps(idx)); 
		idx := emps.NEXT(idx); 
    END LOOP; 
END;

DECLARE 
    TYPE e_list IS TABLE OF hr.employees.first_name%TYPE 
    	INDEX BY hr.employees.email%TYPE; 
	emps e_list; 
	idx hr.employees.email%TYPE; 
	v_email hr.employees.email%TYPE; 
	v_first_name hr.employees.email%TYPE; 
BEGIN
	FOR i IN 100..110 LOOP
    	SELECT first_name, email INTO v_first_name, v_email  
    	FROM hr.employees WHERE employee_id = i;
		emps(v_email) := v_first_name;
    END LOOP;

	idx := emps.FIRST;
    WHILE idx IS NOT NULL LOOP
		DBMS_OUTPUT.PUT_LINE(
        	'The email of ' || emps(idx) || 
        	' is: ' || idx
        );
		idx := emps.NEXT(idx);
    END LOOP;
END;

DECLARE
    TYPE e_type IS RECORD (
    	first_name hr.employees.first_name%TYPE,
    	last_name hr.employees.last_name%TYPE,
    	email hr.employees.email%TYPE
    );
    TYPE e_list IS TABLE OF e_type 
    	INDEX BY hr.employees.email%TYPE;
	emps e_list;
	idx hr.employees.email%TYPE;
	-- v_email hr.employees.email%TYPE;
	-- v_first_name hr.employees.first_name%TYPE;
BEGIN
    FOR i IN 100..110 LOOP
    	SELECT first_name, last_name, email INTO emps(i)
    	FROM hr.employees WHERE employee_id = i;
    END LOOP;

	-- emps.DELETE(100, 104);
	idx := emps.LAST;
	
	WHILE idx IS NOT NULL LOOP
    	DBMS_OUTPUT.PUT_LINE(
        	'The email of ' || emps(idx).first_name ||
        	' ' || emps(idx).last_name ||
        	' is ' || emps(idx).email
        );
    	idx := emps.PRIOR(idx);
    END LOOP;
END;

CREATE TABLE employees_salary_history 
    AS SELECT * FROM hr.employees WHERE 1 = 2;
ALTER TABLE employees_salary_history ADD insert_date DATE;
DROP TABLE employees_salary_history;
    
DECLARE
	TYPE e_list IS TABLE OF employees_salary_history%ROWTYPE
    	INDEX BY PLS_INTEGER;
	emps e_list;
	idx PLS_INTEGER;
BEGIN
    FOR i IN 100..110 LOOP
    	SELECT e.*, '01-JAN-2024' INTO emps(i) 
    	FROM hr.employees e WHERE employee_id = i; 
	END LOOP;

	idx := emps.FIRST;
	WHILE idx IS NOT NULL LOOP
    	emps(idx).salary := emps(idx).salary + emps(idx).salary * 0.2;
    	INSERT INTO employees_salary_history VALUES emps(idx);
		DBMS_OUTPUT.PUT_LINE(
            'The employee ' || emps(idx).first_name ||
            ' is inserted into the history table.'
        );
		idx := emps.NEXT(idx);
	END LOOP;
END;
SELECT * FROM employees_salary_history;


-- Storing Collections in Tables
CREATE OR REPLACE TYPE t_phone_number AS OBJECT (
	p_type VARCHAR2(10),
    p_number VARCHAR2(50)
);
/ 
CREATE OR REPLACE TYPE n_phone_numbers AS TABLE OF t_phone_number;
/
CREATE TABLE emps_with_phones2 (
    employee_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    phone_number n_phone_numbers) 
    NESTED TABLE phone_number STORE AS phone_numbers_table;
/
SELECT * FROM emps_with_phones;
INSERT INTO emps_with_phones2
    VALUES (10, 'Alex', 'Brown', n_phone_numbers(  
    	t_phone_number('HOME', '111.111.1111'),
    	t_phone_number('WORK', '222.222.2222'),
    	t_phone_number('MOBILE', '333.333.3333')
    ));

INSERT INTO emps_with_phones2 
    VALUES (10, 'Alex', 'Brown', n_phone_numbers(  
    	t_phone_number('HOME', '000.000.0000'),
    	t_phone_number('WORK', '444.444.4444')
    ));

INSERT INTO emps_with_phones2 
    VALUES (10, 'Bruce', 'Green', n_phone_numbers(  
    	t_phone_number('HOME', '000.000.0000'),
    	t_phone_number('WORK', '444.444.4444'),
    	t_phone_number('WORK2', '444.444.4444'),
    	t_phone_number('WORK3', '444.444.4444'),
    	t_phone_number('WORK4', '444.444.4444')
    ));

UPDATE emps_with_phones2 SET phone_number = n_phone_numbers(  
    	t_phone_number('HOME', '000.000.0000'),
    	t_phone_number('WORK', '444.444.4444'),
    	t_phone_number('WORK6', '444.444.4444'),
    	t_phone_number('WORK7', '444.444.4444'),
    	t_phone_number('WORK8', '444.444.4444')
    )
WHERE employee_id = 10; 

SELECT e.employee_id, e.first_name, e.last_name,
       p.p_type, p.p_number
FROM emps_with_phones2 e, TABLE(e.phone_number) p;

------------------------------------------------------

DELETE FROM emps_with_phones2;
INSERT INTO emps_with_phones2
    VALUES (10, 'Alex', 'Brown', n_phone_numbers(  
    	t_phone_number('HOME', '111.111.1111'),
    	t_phone_number('WORK', '222.222.2222'),
    	t_phone_number('MOBILE', '333.333.3333')
    ));

DECLARE
	p_num n_phone_numbers;
BEGIN
	SELECT phone_number INTO p_num 
    FROM emps_with_phones2 WHERE employee_id = 10;
	
	p_num.EXTEND;
	p_num(4) := t_phone_number('FAX', '999.99.9999');
	UPDATE emps_with_phones2 SET phone_number = p_num
    WHERE employee_id = 10;
END;
