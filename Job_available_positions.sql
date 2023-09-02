

drop table if exists job_positions;
create table job_positions
(
	id			int,
	title 		varchar(100),
	groups 		varchar(10),
	levels		varchar(10),
	payscale	int,
	totalpost	int
);
insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1);
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5);
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);

drop table if exists job_employees;
create table job_employees
(
	id				int,
	name 			varchar(100),
	position_id 	int
);
insert into job_employees values (1, 'John Smith', 1);
insert into job_employees values (2, 'Jane Doe', 2);
insert into job_employees values (3, 'Michael Brown', 2);
insert into job_employees values (4, 'Emily Johnson', 2);
insert into job_employees values (5, 'William Lee', 3);
insert into job_employees values (6, 'Jessica Clark', 3);
insert into job_employees values (7, 'Christopher Harris', 3);
insert into job_employees values (8, 'Olivia Wilson', 3);
insert into job_employees values (9, 'Daniel Martinez', 3);
insert into job_employees values (10, 'Sophia Miller', 3);

select * from job_positions;
select * from job_employees;




--- SOLUTION 1 using Generate_Series function ---
	select p.title, p.groups, p.levels, p.payscale, coalesce(e.name,'Vacant') as employee_name
	from job_positions p
	cross join generate_series(1,totalpost)
	left join (select *, row_number() over(partition by position_id order by id) as rn 
			   from job_employees) e on e.rn=generate_series and e.position_id = p.id;



--- SOLUTION 2 using Recursion--- 
	with recursive cte as
		(select p.id, p.title, p.groups, p.levels, p.payscale, '' as employee_name, p.totalpost 
		from job_positions p 
		union all
		select id, title, groups, levels, payscale, '' as employee_name, (totalpost - 1) as totalpost
		from cte 
		where totalpost > 1)
	select title, groups, levels, payscale, coalesce(e.name,'Vacant') as employee_name
	from cte
	left join (select *, row_number() over(partition by position_id order by id) as rn 
			   from job_employees) e on e.rn=cte.totalpost and e.position_id = cte.id
	order by groups,totalpost;



