
--Q1
create table products
(
product_id varchar(20) ,
cost int
);
insert into products values ('P1',200),('P2',300),('P3',500),('P4',800);

create table customer_budget
(
customer_id int,
budget int
);

insert into customer_budget values (100,400),(200,800),(300,1500);

--find how many products falls into customer budget along with list of products
--incase of clash choose the less costly products
with running_cost as 
(
select *,
sum(cost) over(order by cost asc) as r_cost
from products
)
select customer_id, budget, count(1) as no_of_products, STRING_AGG(product_id,',') as list_of_products
from customer_budget cb
left join running_cost rc on rc.r_cost < cb.budget
group by customer_id, budget
;


--Q2
--find total no. of messages exchanged between each per day



CREATE TABLE subscriber (
 sms_date date ,
 sender varchar(20) ,
 receiver varchar(20) ,
 sms_no int
);
-- insert some values
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);

select * 
from subscriber;
select sms_date, p1, p2, sum(sms_no) as total_sms
from
(
select sms_date,
	case when sender < receiver then sender else receiver end as p1,
	case when sender > receiver then sender else receiver end as p2,
	sms_no
	from subscriber)A
group by sms_date, p1, P2
;



CREATE TABLE [students](
 [studentid] [int] NULL,
 [studentname] [nvarchar](255) NULL,
 [subject] [nvarchar](255) NULL,
 [marks] [int] NULL,
 [testid] [int] NULL,
 [testdate] [date] NULL
)
data:
insert into students values (2,'Max Ruin','Subject1',63,1,'2022-01-02');
insert into students values (3,'Arnold','Subject1',95,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject1',61,1,'2022-01-02');
insert into students values (5,'John Mike','Subject1',91,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject2',71,1,'2022-01-02');
insert into students values (3,'Arnold','Subject2',32,1,'2022-01-02');
insert into students values (5,'John Mike','Subject2',61,2,'2022-11-02');
insert into students values (1,'John Deo','Subject2',60,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject2',84,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject3',29,3,'2022-01-03');
insert into students values (5,'John Mike','Subject3',98,2,'2022-11-02');


--write a sql query to get the list of students who scored above average marks in each subject

with avg_cte as
(
select subject, avg(marks) as avg_marks
from students
group by subject
)
select s.*, ac.*
from students s
inner join avg_cte ac on s.subject = ac.subject
where s.marks > ac.avg_marks
;

--percentage of students who scored more than 90 in any subjects amongst the total students

SELECT
    (COUNT(DISTINCT studentid) / (SELECT COUNT(DISTINCT studentid) FROM students)) * 100 AS percentage
FROM students
WHERE marks > 90
;

-- write a sql query to get the second highest and second lowest marks for each subject
select subject,
	sum(case when rnk_desc = 2 then marks else null end) as second_highest_marks,
	sum(case when rnk_asc = 2 then marks else null end) as second_lowest_marks
from
(
select subject, marks,
rank() over(partition by subject order by marks asc) as rnk_asc,
rank() over(partition by subject order by marks desc) as rnk_desc
from students
)A
group by subject


CREATE TABLE int_orders (
  order_number INT NOT NULL,
  order_date DATE NOT NULL,
  cust_id INT NOT NULL,
  salesperson_id INT NOT NULL,
  amount FLOAT NOT NULL,
  PRIMARY KEY (order_number)
);

INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (30, '1995-07-14', 9, 1, 460);
INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (10, '1996-08-02', 4, 2, 540);
INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (40, '1998-01-29', 7, 2, 2400);
INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (50, '1998-02-03', 6, 7, 600);
INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (60, '1998-03-02', 6, 7, 720);
INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (70, '1998-05-06', 9, 7, 150);
INSERT INTO int_orders (order_number, order_date, cust_id, salesperson_id, amount) VALUES (20, '1999-01-30', 4, 8, 1800);


-- Find the largest order by value for each salesperson and display order details
--get the result without using sub query, cte, window functions, temp tables

select a.order_number, a.order_date, a.cust_id, a.salesperson_id, a.amount from int_orders a
left join int_orders b on a.salesperson_id = b.salesperson_id
group by a.order_number, a.order_date, a.cust_id, a.salesperson_id, a.amount
having a.amount >= max(b.amount)