/************* The Complete Oracle SQL Bootcamp *************
 * Author  : Oracle Master Training                         *
 * Course  : The Complete Oracle SQL Bootcamp               *
 * Lecture : Using Subqueries                               *
 ***********************************************************/
 
SELECT salary FROM employees
WHERE employee_id = 145;

SELECT * FROM employees
WHERE salary > 14000;

SELECT * FROM employees
WHERE salary > 18000;

SELECT * FROM employees
WHERE salary > (SELECT salary FROM employees
 WHERE employee_id = 145);