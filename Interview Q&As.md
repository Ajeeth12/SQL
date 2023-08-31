## Most Asked Interview Q&As

## Second Highest Salary

```sql
    SELECT MAX(SALARY) 
    FROM employees 
    WHERE SALARY < (SELECT MAX(SALARY) 
                    FROM employees);

        OR

    SELECT DISTINCT
        (SELECT DISTINCT Salary
         FROM Employee
         ORDER BY Salary DESC
         LIMIT 1 OFFSET 1) AS SecondHighestSalary;
```
