-- CONTROL STRUCTURES
-- IF Statements
DECLARE
	v_number NUMBER := 5;
	v_name VARCHAR2(30) := 'John';
BEGIN
    IF v_number < 10 OR v_name = 'Carol' THEN 
    	DBMS_OUTPUT.PUT_LINE('I''m smaller than 10');
    ELSIF v_number < 20 THEN
    	DBMS_OUTPUT.PUT_LINE('I''m smaller than 20');
    ELSIF v_number < 30 THEN
        DBMS_OUTPUT.PUT_LINE('I''m smaller than 30');
    ELSE
        IF v_number IS NULL THEN
        	DBMS_OUTPUT.PUT_LINE('The number is null...');	
		ELSE
            DBMS_OUTPUT.PUT_LINE('I''m equal or greater than 30');
		END IF;
	END IF;
END;


-- CASE Expressions
DECLARE
    v_job_code VARCHAR2(10) := 'IT_PROG';
	v_salary_increase NUMBER;
	v_department VARCHAR2(10) := 'IT';
BEGIN
	v_salary_increase := CASE v_job_code 
                    	 	WHEN 'SA_MAN' THEN 0.2
                    	 	WHEN 'SA_REP' THEN 0.3
                    	 ELSE 0 END;

	v_salary_increase := CASE 
                    	 	WHEN v_job_code = 'SA_MAN' THEN 0.2
        					WHEN v_department = 'IT' AND v_job_code = 'IT_PROG' THEN 0.3
        					-- WHEN v_job_code IN ('SA_REP', 'IT_PROG') THEN 0.3
        					-- WHEN v_job_code = 'SA_REP' OR v_job_code = 'IT_PROG' THEN 0.3
                    	 ELSE 0 END;
	DBMS_OUTPUT.PUT_LINE('Your salary increase is: ' || v_salary_increase);

	CASE
        WHEN v_job_code = 'SA_MAN' THEN
        	v_salary_increase := 0.2;
			DBMS_OUTPUT.PUT_LINE('The salary increase for a Sales Manager is: ' || v_salary_increase);
		WHEN v_department = 'IT' AND v_job_code = 'IT_PROG' THEN 
            v_salary_increase := 0.3;
			DBMS_OUTPUT.PUT_LINE('The salary increase for an IT Programmer is: ' || v_salary_increase);
		ELSE
            v_salary_increase := 0;
			DBMS_OUTPUT.PUT_LINE('The salary increase for this job_id is: ' || v_salary_increase);
	END CASE;
END;


-- Basic Loops
DECLARE
	v_counter NUMBER(2) := 1;
BEGIN
	LOOP 
    	DBMS_OUTPUT.PUT_LINE('My counter is: ' || v_counter);
    	v_counter := v_counter + 1;

		-- IF v_counter = 10 THEN
        --     DBMS_OUTPUT.PUT_LINE('Now I reached the maximum value: ' || v_counter);
		-- EXIT;
        -- END IF;
		EXIT WHEN v_counter > 10;
	END LOOP;
END;


-- WHILE Loops
DECLARE
	v_counter NUMBER(2) := 1;
BEGIN
    WHILE v_counter <= 10 LOOP
    	DBMS_OUTPUT.PUT_LINE('My counter is: ' || v_counter);
		v_counter := v_counter + 1;
		-- EXIT WHEN v_counter > 3;
    END LOOP;
END;


-- FOR Loops
BEGIN
	FOR idx IN REVERSE 1..3 LOOP
    	DBMS_OUTPUT.PUT_LINE('My counter is: ' || idx);
    END LOOP;
END;


-- Nested Loops & Looping Labeling
DECLARE
	v_inner NUMBER := 1;
BEGIN
    <<outer_loop>>
    FOR v_outer IN 1..5 LOOP
    	DBMS_OUTPUT.PUT_LINE('My outer value is: ' || v_outer);
    	v_inner := 1;

		<<inner_loop>>
		LOOP 
            v_inner := v_inner + 1;
			DBMS_OUTPUT.PUT_LINE('	My inner value is: ' || v_inner);	
			EXIT outer_loop WHEN v_inner * v_outer >= 16; 
			EXIT WHEN v_inner * v_outer >= 15;
		END LOOP inner_loop;
	END LOOP outer_loop;
END;


-- Continue Statement
DECLARE
    v_inner NUMBER := 1;
BEGIN
    <<outer_loop>>
    FOR v_outer IN 1..10 LOOP
    	DBMS_OUTPUT.PUT_LINE('My outer value is: ' || v_outer);
		v_inner := 1;

		<<inner_loop>>
		WHILE v_inner * v_outer < 15 LOOP
			v_inner := v_inner + 1;
			CONTINUE outer_loop WHEN v_inner = 10;
			DBMS_OUTPUT.PUT_LINE('	My inner value is: ' || v_inner);	
        END LOOP inner_loop;
    END LOOP outer_loop;
END;


-- GOTO Statement
DECLARE
    v_searched_number NUMBER := 32453;
	v_is_prime BOOLEAN := TRUE;
	x NUMBER := 2;
BEGIN
	<<start_point>>
    	IF v_searched_number MOD X = 0 THEN
    		DBMS_OUTPUT.PUT_LINE(v_searched_number || ' is not a prime number..');
    		v_is_prime := FALSE;
			GOTO end_point;
		END IF;
		x := x + 1;
		IF x = v_searched_number THEN
            GOTO prime_point;
        ELSE IF;

		GOTO start_point;

	<<prime_point>>
    	IF v_is_prime THEN
    		DBMS_OUTPUT.PUT_LINE(v_searched_number || ' is a prime number..');
    	END IF;

	<<end_point>>
		DBMS_OUTPUT.PUT_LINE('Check complete..');
END;
