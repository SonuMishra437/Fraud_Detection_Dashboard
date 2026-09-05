select * from transactions;


-- unique_raws;
select * , row_number() over(order by step asc) as rn from transactions;

-- How many transactions happened per hour (step)? (you already wrote this one)
select step as transactions_per_hr,count(*) as total_transactions from transactions
group by step
order by  count(*) desc;	


-- How many transactions happened per type (PAYMENT, TRANSFER, CASH_OUT, etc.)?
select count(*) as total_transactions,`type` as transactions_method from
transactions group by `type`;

-- What's the total and average amount moved per type
select count(*) as total_transactions,`type` as transactions_method,sum(amount) as total_amount,avg(amount) as avg_amount from
transactions group by `type`;

-- 4. How many transactions are fraud (isFraud = 1) vs not, and what percentage is that?
select count(*) as total_transactions,`type` as transactions_method,sum(if(isfraud = 1,1,0)) fraud_count from 
transactions group by `type`;
----------------------------------------------------------------------------------------------------
select `type` as transactions_method,(sum(if(isfraud = 1,1,0))/count(*))*100 'fraud_%' from 
transactions group by `type`;
---------------------------------------------------------------------------------------------------
-- 5. Which type values actually contain fraud, and how many fraud cases per type
select `type` as transactions_method,count(isfraud) as actual_fraud from transactions
where isfraud = 1
group by `type`;


-- 6. What's the average amount for fraud transactions vs non-fraud transactions?
select `type` as transactions_method,
sum(if(isfraud = 1,1,0)) as fraud_category,
avg(amount) as avg_amount from 
transactions group by `type`;

-- 7. How many transactions were flagged (isFlaggedFraud = 1), and of those, how many were actually fraud?
select `type` as transactions_method , count(*) as total_transactions,
sum(if(isflaggedfraud = 1,1,0)) as isflaggedfraud,
sum(if(isfraud = 1,1,0)) as isfraud from transactions
group by `type`;

-- What this means in plain words: out of every real fraud that happened, the system's own flagging rule (isFlaggedFraud)
--  only caught about 0.2% of them (16 out of 8,213) — it missed 99.8% of actual fraud cases 
--  (8,197 out of 8,213). 
----------------------------------------------------------------------------------
-- real fraud = 8213
select sum(if(isfraud=1,1,0)) as real_fraud from transactions;

-- 9. Which hour-steps have the highest count of fraud transactions?
select step ,count(*) as fraud_count from transactions
where isfraud = 1
group by step
order by fraud_count desc;


-- 10. Does fraud cluster at certain hours of the day (using step % 24)?
select (step%24) as 'days' ,count(*) as fraud_count from transactions
where isfraud = 1
group by step
order by fraud_count desc;

-- 11. Which receiving accounts (nameDest) appear most often in fraud transactions?
 select namedest as 'receiving accounts',count(*) as fraud_count,
 dense_rank() over(order by count(*) desc) as d_rank,
rank() over(order by count(*) desc) as rn
 from transactions
where isfraud  =1
group by namedest
order by fraud_count desc;

-- How many DISTINCT receiving accounts were involved in fraud at all?
SELECT COUNT(DISTINCT nameDest) AS distinct_fraud_recipients
FROM transactions
WHERE isFraud = 1;
---------------------------------------------------------------------
-- Do any accounts appear more than once? in fraud cases
SELECT nameDest, COUNT(*) AS times_seen
FROM transactions
WHERE isFraud = 1
GROUP BY nameDest
HAVING COUNT(*) > 1
ORDER BY count(*) DESC;


select isfraud,
sum(if(newbalanceorig=0,1,0)) AS sender_emptied_count ,count(*) as total_transactions,
(sum(if(newbalanceorig=0,1,0))/count(*))*100 as sender_emptied_pct from transactions
group by isfraud;

-- Receiver side (nameDest / newbalanceDest) — has a catch
SELECT isFraud,
       SUM(CASE WHEN newbalanceDest = 0 THEN 1 ELSE 0 END) AS receiver_zero_balance_count,
       COUNT(*) AS total_transactions,
       ROUND(SUM(CASE WHEN newbalanceDest = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) 
       AS receiver_zero_pct
FROM transactions
where namedest not  like 'M%'
GROUP BY isFraud;

-- % of merchants acc
select sum(if(namedest like 'M%',1,0)) as Merchant_acc,count(*) as total_transactions ,
(sum(if(namedest like 'M%',1,0))*100/count(*)) as 'merchant_%'
from transactions;


	










