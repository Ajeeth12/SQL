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
-------

## Employees earning more than their Managers

```sql
    -- The given SQL query retrieves the names of employees who have a higher salary than their respective managers
    SELECT e1.name AS Employee
    FROM Employee e1
    JOIN Employee e2 ON e1.managerId = e2.id
    WHERE e1.salary > e2.salary;
```
-------

## Highest Salary in the Department

```sql
    --The given SQL query retrieves the department name, employee name, and salary of the highest-paid employee in each department.
    --It uses a subquery to find the maximum salary per department and then joins this information with the Department and Employee tables.
    SELECT
        D.name AS Department,
        E.name AS Employee,
        E.salary
    FROM
        Department D
    INNER JOIN
        Employee E ON E.departmentId = D.id
    WHERE
        (E.departmentId, E.salary) IN (
            SELECT departmentId, MAX(salary)
            FROM Employee
            GROUP BY departmentId
        );
```
-------

## Top 3 Salaries in the Department

```sql

    --The provided SQL query retrieves the top 3 highest-paid employees in each department
    SELECT Department, employee, salary
    FROM (
        SELECT
            d.name AS Department,
            e.name AS employee,
            e.salary,
            DENSE_RANK() OVER (PARTITION BY d.name ORDER BY e.salary DESC) AS drk
        FROM Employee e
        JOIN Department d ON e.DepartmentId = d.Id
    ) t
    WHERE t.drk <= 3;
```
-------
