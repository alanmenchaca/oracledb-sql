/************* The Complete Oracle SQL Bootcamp *************
 * Author  : Oracle Master Training                         *
 * Course  : The Complete Oracle SQL Bootcamp               *
 * Lecture : Single Row Subqueries                          *
 ***********************************************************/
 
--Step 1:---------------------------------------------
SELECT * FROM employees;

--Step 2: Write the subquery first and enclose it with the parentheses.
(SELECT department_id FROM employees 
WHERE employee_id = 145);

--Step 3: Use subquery/(ies) with the main query.                        
SELECT * FROM employees
WHERE department_id = 
                     (SELECT department_id FROM employees 
                        WHERE employee_id = 145)
AND salary <         
                     (SELECT salary FROM EMPLOYEES
                        WHERE employee_id = 145);
--Step 4: The returning value from the subqueries must have the same data type with the column you compared it to.
SELECT * FROM employees
WHERE department_id = 
                     (SELECT first_name FROM employees 
                        WHERE employee_id = 145)
AND salary <         
                     (SELECT salary FROM EMPLOYEES
                        WHERE employee_id = 145);
-----------------------------------------------------------------
--Step 5: The returning value from the subqueries must have the same data type with the column you compared it to.
SELECT * FROM employees
WHERE employee_id = 
                     (SELECT manager_id FROM employees 
                        WHERE employee_id = 145)
AND salary <         
                     (SELECT salary FROM EMPLOYEES
                        WHERE employee_id = 145);


-----------------------------------------------------------------

SELECT * FROM employees
WHERE hire_date =
                 (SELECT min(hire_date) FROM employees);
                 
SELECT * FROM employees
WHERE hire_date =
                 (SELECT max(hire_date) FROM employees);
SELECT * FROM employees
WHERE hire_date =
                 (SELECT max(hire_date) FROM employees
                    GROUP BY department_id);