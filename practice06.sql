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
