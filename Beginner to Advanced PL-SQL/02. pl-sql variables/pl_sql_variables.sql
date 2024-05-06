-- PL/SQL VARIABLES
-- Declaring & Initializing & Using Variables
DECLARE
    v_number NUMBER(4, 2) NOT NULL DEFAULT 50.42;
    v_integer PLS_INTEGER NOT NULL := 50;
    v_binary BINARY_INTEGER NOT NULL := 50;
    v_binary_float BINARY_FLOAT NOT NULL := 50.42f;

	v_date DATE NOT NULL := SYSDATE;
	v_date2 DATE NOT NULL := '01-JAN-2024';

	v_timestamp TIMESTAMP NOT NULL := SYSTIMESTAMP;
	v_timestamp2 TIMESTAMP WITH TIME ZONE NOT NULL := SYSTIMESTAMP;
	v_timestamp3 TIMESTAMP(3) NOT NULL := SYSTIMESTAMP;

	v_date_interval INTERVAL DAY(4) TO SECOND(2) NOT NULL := '24 02:05:21.012';
	v_date_interval2 INTERVAL YEAR(3) TO MONTH := '12-3';

	v_bool BOOLEAN := TRUE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_number || ' BEGINNER TO ADVANCED');	
    DBMS_OUTPUT.PUT_LINE(v_integer || ' BEGINNER TO ADVANCED');	
	DBMS_OUTPUT.PUT_LINE(v_binary || ' BEGINNER TO ADVANCED');
	DBMS_OUTPUT.PUT_LINE(v_binary_float || ' BEGINNER TO ADVANCED');

	DBMS_OUTPUT.PUT_LINE(v_date); -- 04-JAN-24
	DBMS_OUTPUT.PUT_LINE(v_date2); -- 01-JAN-24
	
	DBMS_OUTPUT.PUT_LINE(v_timestamp); -- 04-JAN-24 10.16.35.098640 PM
	DBMS_OUTPUT.PUT_LINE(v_timestamp2); -- 04-JAN-24 10.18.23.563433 PM +00:00
	DBMS_OUTPUT.PUT_LINE(v_timestamp3); -- 04-JAN-24 10.19.08.273 PM

	-- 05-JAN-24 04.46.08.852 PM+0024 02:05:21.01
	DBMS_OUTPUT.PUT_LINE(v_date_interval);
	DBMS_OUTPUT.PUT_LINE(v_date_interval2); -- +12-03

	-- DBMS_OUTPUT.PUT_LINE(v_bool); -- We can't print boolean variables
END;


-- Using %TYPE Attribute
DESC hr.employees;

DECLARE
	v_type hr.employees.job_id%TYPE;
	v_type2 v_type%TYPE;
	v_type3 hr.employees.job_id%TYPE;
BEGIN
    v_type := 'IT_PROG';
	v_type2 := 'SA_MAN';
	v_type3 := NULL;

	DBMS_OUTPUT.PUT_LINE(v_type);
	DBMS_OUTPUT.PUT_LINE(v_type2);
	DBMS_OUTPUT.PUT_LINE(v_type3 || ' HELLO');
END;


-- PL/SQL Delimiters and Commenting Your Code
DECLARE
	v_text VARCHAR2(10) := 'PL/SQL'; 
BEGIN
    -- This is a single line comment
    /*
     This is a
     multi-line comment
    */
	DBMS_OUTPUT.PUT_LINE(v_text || ' is a good language');    
END;


-- Variable Scope
begin <<OUTER>>
    DECLARE
        v_outer VARCHAR2(50) := 'Outer!'; 
    	v_text VARCHAR2(50) := 'Out-text';
    BEGIN
        DECLARE
        	v_inner VARCHAR2(30) := 'Inner Variable';
    		v_text VARCHAR2(30) := 'In-text';
    	BEGIN
        	DBMS_OUTPUT.PUT_LINE('Inside -> ' || v_outer);
    		DBMS_OUTPUT.PUT_LINE('Inside_inner -> ' || v_inner);
    
    		DBMS_OUTPUT.PUT_LINE('Inside_inner -> ' || v_text);
    		DBMS_OUTPUT.PUT_LINE('Inside_outer -> ' || outer.v_text);
        END;
        -- DBMS_OUTPUT.PUT_LINE('outside_inner -> ' || v_inner);
    	DBMS_OUTPUT.PUT_LINE(v_outer);
    	DBMS_OUTPUT.PUT_LINE('Outside -> ' || v_text);
    END;
END;


-- Using Bind Variables
SET serveroutput ON;
SET autoprint ON;

DECLARE
    v_text VARCHAR2(30);
BEGIN
    :var_text := 'Hello PL/SQL';
	v_text := :var_text;
	:var_number := 20;
	DBMS_OUTPUT.PUT_LINE(v_text);
	DBMS_OUTPUT.PUT_LINE(:var_text);
END;
/
print var_text;

VARIABLE var_text VARCHAR2(30);
VARIABLE var_number NUMBER;
-- VARIABLE var_number NUMBER(30);
-- VARIABLE var_date DATE;
VARIABLE var_sql NUMBER;
BEGIN
	:var_sql := '100'; 
END;
SELECT * FROM hr.employees WHERE hr.employees_id = :var_sql;
