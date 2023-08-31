## Most Asked Interview Q&As

## Second Highest Salary

```sql
    SELECT MAX(SALARY) 
    FROM employees 
    WHERE SALARY < (SELECT MAX(SALARY) 
                    FROM employees);

        OR

    SELECT DISTINCT Salary
    FROM Employee
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 1;
```
-------

## Find Consecutive Numbers

```sql
    -- Create a Common Table Expression (CTE) named 'temp' to calculate next and previous numbers
    WITH temp AS (
        SELECT 
            num,
            LEAD(num) OVER (ORDER BY id) AS next_num,
            LAG(num) OVER (ORDER BY id) AS prev_num
        FROM LOGS
    )
    
    -- Select distinct 'num' values from the 'temp' CTE
    SELECT DISTINCT num AS ConsecutiveNums
    FROM temp
    WHERE num = next_num AND num = prev_num;
```
