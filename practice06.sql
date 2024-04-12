-- bai tap 1
with twt_so_luong AS
(SELECT company_id, title, description,
    COUNT(job_id) AS job_count  
  FROM job_listings
    GROUP BY company_id, title,description
    ORDER BY company_id)
 select COUNT(DISTINCT company_id) AS duplicate_companies
  FROM twt_so_luong 
  WHERE job_count >=2
  
-- bai tap 2
with twt_total_spend as 
(SELECT category,product, 
sum(spend) as total_spend 
FROM product_spend 
where extract (year from transaction_date) = '2022'
group by category,product),
twt_ranking AS 
(select*, 
rank() over(partition by category order by total_spend desc) 
as ranking
from twt_total_spend)
select category, product, total_spend
from twt_ranking
where ranking <=2

-- bai tap 3
WITH policy_callers AS (
SELECT policy_holder_id, 
COUNT(policy_holder_id) as member_count 
FROM callers
GROUP BY policy_holder_id),

SELECT callers.case_id,
FROM callers
join policy_callers
on callers.policy_holder_id=policy_callers.policy_holder_id
WHERE callers.case_id >= 3

-- bai tap 4
SELECT a.page_id 
FROM pages as a
left join page_likes as b
on a.page_id = b.page_id 
where b.liked_date is null
order by a.page_id

-- bai tap 5
with cte AS
(select event_date 
from user_actions
where event_date between '06/01/2022' and '06/30/2022'
group by event_date)
SELECT extract(month from event_date) as month, count(distinct user_id) "monthly_active_users"
FROM user_actions
where event_date between '07/01/2022' and '07/31/2022'
group by month

-- bai tap 6
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month, country,
COUNT(*) AS trans_count,
CASE 
    WHEN state = 'approved' THEN 1 ELSE 0 END AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE 
      WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country
ORDER BY month,country

-- bai tap 7
SELECT product_id, year AS first_year, quantity,price
FROM Sales
WHERE (product_id, year) IN (SELECT product_id, MIN(year) AS first_year
FROM Sales
GROUP BY product_id)

-- bai tap 8
select customer_id
from customer
group by customer_id
having count(distinct product_key ) = (select count(*) from product)

-- bai tap 9
select employee_id
from Employees
where salary < 300000
and manager_id not in ( select employee_id from Employees)
order by employee_id

-- bai tap 10

-- bai tap 11
with cte1 as 
(select b.name
from users as b
join MovieRating as c
on c.user_id = b.user_id
group by c.user_id
order by count(*) desc, name
limit 1),
cte2 as 
(select a.title
from Movies as a
join MovieRating as c
on c.movie_id = a.movie_id
where left(created_at,7) = '2020-02'
group by c.movie_id
order by avg(rating) desc, title
limit 1)

select cte1.name as results
from cte1
union all
select cte2.title as results
from cte2
    
-- bai tap 12
WITH cte1 AS (
SELECT requester_id, accepter_id FROM RequestAccepted
UNION
SELECT accepter_id, requester_id FROM RequestAccepted)
SELECT requester_id AS id, COUNT(accepter_id) AS num
FROM cte1
GROUP BY accepter_id
LIMIT 1
