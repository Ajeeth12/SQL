# DataLemur Medium Level Questions
## User's Third Transaction [Uber SQL Interview Question]

```sql
  --Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user
  --Output the user id, spend and transaction date

  SELECT user_id, spend, transaction_date
  FROM
  (
    SELECT *,
    row_number() over(partition by user_id order by transaction_date) as rn
    FROM transactions
  ) A
  WHERE rn = 3
  ;
```
-------

## Sending vs. Opening Snaps [Snapchat SQL Interview Question]

```sql
  --Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps
  --Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group
  --Round the percentage to 2 decimal places in the output

  WITH snaps_statistics
  AS (
  	SELECT age.age_bucket
  		,SUM(CASE 
  				WHEN activities.activity_type = 'send'
  					THEN activities.time_spent
  				ELSE 0
  				END) AS send_timespent
  		,SUM(CASE 
  				WHEN activities.activity_type = 'open'
  					THEN activities.time_spent
  				ELSE 0
  				END) AS open_timespent
  		,SUM(activities.time_spent) AS total_timespent
  	FROM activities
  	INNER JOIN age_breakdown AS age ON activities.user_id = age.user_id
  	WHERE activities.activity_type IN (
  			'send'
  			,'open'
  			)
  	GROUP BY age.age_bucket
  	)
  SELECT age_bucket
  	,ROUND(100.0 * send_timespent / total_timespent, 2) AS send_perc
  	,ROUND(100.0 * open_timespent / total_timespent, 2) AS open_perc
  FROM snaps_statistics;
```

-------

## Tweets' Rolling Averages [Twitter SQL Interview Question]

```sql
  --Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user
  --Output the user ID, tweet date, and rolling averages rounded to 2 decimal places
  SELECT user_id
  	,tweet_date
  	,ROUND(AVG(tweet_count) OVER (
  			PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING
  					AND CURRENT ROW
  			), 2) AS rolling_avg_3d
  FROM tweets;
  ```
-------

