
-- Move all the below procedures/functions which you have written in the Exercise #4  
-- to a package (create package specification and then create package body).

-- 1) Write a procedure to fetch data from table SALES  
--    for a given parameter order_id and display the data.
CREATE OR REPLACE PROCEDURE display_sales_by_order_id (
    order_id_param IN NUMBER
) AS
    sales_date     sales.sales_date%type;
    order_id       sales.order_id%type;
    product_id	   sales.product_id%type;
    customer_id	   sales.customer_id%type;
    salesperson_id sales.salesperson_id%type;
    quantity	   sales.quantity%type;
    unit_price	   sales.unit_price%type;
    sales_amount   sales.sales_amount%type;
    tax_amount	   sales.tax_amount%type;
    total_amount   sales.total_amount%type;
	negative_order_id_ex EXCEPTION;
BEGIN
	IF order_id_param < 0 THEN
    	RAISE negative_order_id_ex;
    END IF;
    
    SELECT sales_date, order_id, product_id, customer_id,
    	   salesperson_id, quantity, unit_price, sales_amount,
    	   tax_amount, total_amount
    INTO sales_date, order_id, product_id, customer_id,
    	 salesperson_id, quantity, unit_price, sales_amount,
    	 tax_amount, total_amount
    FROM sales
    WHERE order_id = order_id_param;

    DBMS_OUTPUT.PUT_LINE('Sales Date: ' || sales_date);
	DBMS_OUTPUT.PUT_LINE('Order ID: ' || order_id);
    DBMS_OUTPUT.PUT_LINE('Product ID: ' || product_id);
    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_id);
    DBMS_OUTPUT.PUT_LINE('Salesperson ID: ' || salesperson_id);
    DBMS_OUTPUT.PUT_LINE('Quantity: ' || quantity);
    DBMS_OUTPUT.PUT_LINE('Unit Price: ' || unit_price);
    DBMS_OUTPUT.PUT_LINE('Sales Amount: ' || sales_amount);
    DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || tax_amount);
	DBMS_OUTPUT.PUT_LINE('Total Amount: ' || total_amount);
EXCEPTION
    WHEN negative_order_id_ex THEN
		DBMS_OUTPUT.PUT_LINE('The order_id can''t be a negative number!');
    WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('order_id not found!');
	WHEN TOO_MANY_ROWS THEN
    	DBMS_OUTPUT.PUT_LINE('You got more than 1 row!');
    WHEN OTHERS THEN
    	DBMS_OUTPUT.PUT_LINE('Error!');
END display_sales_by_order_id;
/


-- 2) Write a procedure which does the following operations
--  * Fetch data from table SALES for a given parameter order_id and display the data. 
--  * Return the number of rows (using OUT parameter) in the SALES table for that 
--    sales date (get sales date from the above operation).
CREATE OR REPLACE PROCEDURE display_and_count_rows (
    order_id_param IN NUMBER,
    number_of_rows OUT NUMBER
) AS
    sales_date_var sales.sales_date%type;
	order_id       sales.order_id%type;
    product_id	   sales.product_id%type;
    customer_id	   sales.customer_id%type;
    salesperson_id sales.salesperson_id%type;
    quantity	   sales.quantity%type;
    unit_price	   sales.unit_price%type;
    sales_amount   sales.sales_amount%type;
    tax_amount	   sales.tax_amount%type;
    total_amount   sales.total_amount%type;
BEGIN
    SELECT sales_date, order_id, product_id, customer_id,
    	   salesperson_id, quantity, unit_price, sales_amount,
    	   tax_amount, total_amount
    INTO sales_date_var, order_id, product_id, customer_id,
    	 salesperson_id, quantity, unit_price, sales_amount,
    	 tax_amount, total_amount
    FROM sales WHERE order_id = order_id_param;

	SELECT COUNT(order_id) 
        INTO number_of_rows
    FROM sales WHERE sales_date = sales_date_var;

    DBMS_OUTPUT.PUT_LINE('Sales Date: ' || sales_date_var);
	DBMS_OUTPUT.PUT_LINE('Order ID: ' || order_id);
    DBMS_OUTPUT.PUT_LINE('Product ID: ' || product_id);
    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_id);
    DBMS_OUTPUT.PUT_LINE('Salesperson ID: ' || salesperson_id);
    DBMS_OUTPUT.PUT_LINE('Quantity: ' || quantity);
    DBMS_OUTPUT.PUT_LINE('Unit Price: ' || unit_price);
    DBMS_OUTPUT.PUT_LINE('Sales Amount: ' || sales_amount);
    DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || tax_amount);
	DBMS_OUTPUT.PUT_LINE('Total Amount: ' || total_amount);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('order_id not found!');
	WHEN TOO_MANY_ROWS THEN
    	DBMS_OUTPUT.PUT_LINE('You got more than 1 row!');
    WHEN OTHERS THEN
    	DBMS_OUTPUT.PUT_LINE('Error!');
END display_and_count_rows;
/


-- 3) Write a function which accepts 2 numbers n1 and n2 and 
--    returns the power of n1 to n2.
--    (Example: If I pass values 10 and 3, the output should be 1000)
CREATE OR REPLACE FUNCTION defined_pow (
    base NUMBER,
    exp NUMBER
) RETURN NUMBER AS
    null_or_zero_ex EXCEPTION;
    greater_than_100_ex EXCEPTION;
BEGIN
    IF (base IS NULL OR exp IS NULL) OR
       (base = 0 OR exp = 0) THEN
        RAISE null_or_zero_ex;
    END IF;

    IF (base > 100 OR exp > 100) THEN
        DBMS_OUTPUT.PUT_LINE('inside if');
        RAISE greater_than_100_ex;
    END IF;

    RETURN POWER(base, exp);
EXCEPTION
    WHEN null_or_zero_ex THEN
        DBMS_OUTPUT.PUT_LINE('Null or zero values are not allowed.');
        RETURN NULL;
    WHEN greater_than_100_ex THEN
        DBMS_OUTPUT.PUT_LINE('Base or exponent cannot be greater than 100.');
        RETURN NULL;
END defined_pow;
/


-- 4) Write a function to display the number of rows 
--    in the SALES table for a given sales date.
CREATE OR REPLACE FUNCTION count_rows_by_sales_date (
    sales_date_param VARCHAR
) RETURN NUMBER AS
	count_rows NUMBER := 0;
BEGIN
	SELECT COUNT(order_id) INTO count_rows
    FROM sales WHERE sales_date = sales_date_param;
	RETURN count_rows;
EXCEPTION
	WHEN OTHERS THEN            
    	DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END count_rows_by_sales_date;
/


CREATE OR REPLACE PACKAGE sales_package AS
	PROCEDURE display_sales_by_order_id (
    	order_id_param IN NUMBER
	);

	PROCEDURE display_and_count_rows (
    	order_id_param IN NUMBER,
    	number_of_rows OUT NUMBER
	);

	FUNCTION defined_pow (
        base NUMBER,
        exp NUMBER
    ) RETURN NUMBER;

    FUNCTION count_rows_by_sales_date (
        sales_date_param VARCHAR
    ) RETURN NUMBER;
END sales_package;
/

    
CREATE OR REPLACE PACKAGE BODY sales_package AS
    PROCEDURE display_sales_by_order_id (
        order_id_param IN NUMBER
    ) AS
        sales_date     sales.sales_date%type;
    	order_id       sales.order_id%type;
        product_id	   sales.product_id%type;
        customer_id	   sales.customer_id%type;
        salesperson_id sales.salesperson_id%type;
        quantity	   sales.quantity%type;
        unit_price	   sales.unit_price%type;
        sales_amount   sales.sales_amount%type;
        tax_amount	   sales.tax_amount%type;
        total_amount   sales.total_amount%type;
    	negative_order_id_ex EXCEPTION;
    BEGIN
    	IF order_id_param < 0 THEN
        	RAISE negative_order_id_ex;
        END IF;
        
        SELECT sales_date, order_id, product_id, customer_id,
        	   salesperson_id, quantity, unit_price, sales_amount,
        	   tax_amount, total_amount
        INTO sales_date, order_id, product_id, customer_id,
        	 salesperson_id, quantity, unit_price, sales_amount,
        	 tax_amount, total_amount
        FROM sales
        WHERE order_id = order_id_param;
    
        DBMS_OUTPUT.PUT_LINE('Sales Date: ' || sales_date);
    	DBMS_OUTPUT.PUT_LINE('Order ID: ' || order_id);
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product_id);
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_id);
        DBMS_OUTPUT.PUT_LINE('Salesperson ID: ' || salesperson_id);
        DBMS_OUTPUT.PUT_LINE('Quantity: ' || quantity);
        DBMS_OUTPUT.PUT_LINE('Unit Price: ' || unit_price);
        DBMS_OUTPUT.PUT_LINE('Sales Amount: ' || sales_amount);
        DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || tax_amount);
    	DBMS_OUTPUT.PUT_LINE('Total Amount: ' || total_amount);
    EXCEPTION
        WHEN negative_order_id_ex THEN
    		DBMS_OUTPUT.PUT_LINE('The order_id can''t be a negative number!');
        WHEN NO_DATA_FOUND THEN
    		DBMS_OUTPUT.PUT_LINE('order_id not found!');
    	WHEN TOO_MANY_ROWS THEN
        	DBMS_OUTPUT.PUT_LINE('You got more than 1 row!');
        WHEN OTHERS THEN
        	DBMS_OUTPUT.PUT_LINE('Error!');
    END display_sales_by_order_id;

    PROCEDURE display_and_count_rows (
        order_id_param IN NUMBER,
        number_of_rows OUT NUMBER
    ) AS
        sales_date_var sales.sales_date%type;
    	order_id       sales.order_id%type;
        product_id	   sales.product_id%type;
        customer_id	   sales.customer_id%type;
        salesperson_id sales.salesperson_id%type;
        quantity	   sales.quantity%type;
        unit_price	   sales.unit_price%type;
        sales_amount   sales.sales_amount%type;
        tax_amount	   sales.tax_amount%type;
        total_amount   sales.total_amount%type;
    BEGIN
        SELECT sales_date, order_id, product_id, customer_id,
        	   salesperson_id, quantity, unit_price, sales_amount,
        	   tax_amount, total_amount
        INTO sales_date_var, order_id, product_id, customer_id,
        	 salesperson_id, quantity, unit_price, sales_amount,
        	 tax_amount, total_amount
        FROM sales WHERE order_id = order_id_param;
    
    	SELECT COUNT(order_id) 
            INTO number_of_rows
        FROM sales WHERE sales_date = sales_date_var;
    
        DBMS_OUTPUT.PUT_LINE('Sales Date: ' || sales_date_var);
    	DBMS_OUTPUT.PUT_LINE('Order ID: ' || order_id);
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product_id);
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_id);
        DBMS_OUTPUT.PUT_LINE('Salesperson ID: ' || salesperson_id);
        DBMS_OUTPUT.PUT_LINE('Quantity: ' || quantity);
        DBMS_OUTPUT.PUT_LINE('Unit Price: ' || unit_price);
        DBMS_OUTPUT.PUT_LINE('Sales Amount: ' || sales_amount);
        DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || tax_amount);
    	DBMS_OUTPUT.PUT_LINE('Total Amount: ' || total_amount);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
    		DBMS_OUTPUT.PUT_LINE('order_id not found!');
    	WHEN TOO_MANY_ROWS THEN
        	DBMS_OUTPUT.PUT_LINE('You got more than 1 row!');
        WHEN OTHERS THEN
        	DBMS_OUTPUT.PUT_LINE('Error!');
    END display_and_count_rows;

    FUNCTION defined_pow (
        base NUMBER,
        exp NUMBER
    ) RETURN NUMBER AS
        null_or_zero_ex EXCEPTION;
        greater_than_100_ex EXCEPTION;
    BEGIN
        IF (base IS NULL OR exp IS NULL) OR
           (base = 0 OR exp = 0) THEN
            RAISE null_or_zero_ex;
        END IF;
    
        IF (base > 100 OR exp > 100) THEN
            DBMS_OUTPUT.PUT_LINE('inside if');
            RAISE greater_than_100_ex;
        END IF;
    
        RETURN POWER(base, exp);
    EXCEPTION
        WHEN null_or_zero_ex THEN
            DBMS_OUTPUT.PUT_LINE('Null or zero values are not allowed.');
            RETURN NULL;
        WHEN greater_than_100_ex THEN
            DBMS_OUTPUT.PUT_LINE('Base or exponent cannot be greater than 100.');
            RETURN NULL;
    END defined_pow;

    FUNCTION count_rows_by_sales_date (
        sales_date_param VARCHAR
    ) RETURN NUMBER AS
    	count_rows NUMBER := 0;
    BEGIN
    	SELECT COUNT(order_id) INTO count_rows
        FROM sales WHERE sales_date = sales_date_param;
    	RETURN count_rows;
    EXCEPTION
    	WHEN OTHERS THEN            
        	DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END count_rows_by_sales_date;
END sales_package;
/

EXECUTE sales_package.display_sales_by_order_id(1269);
