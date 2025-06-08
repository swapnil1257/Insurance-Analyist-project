use Insurance_Analytics;

/* Total Policies */
select count(ï»¿Policy_ID) as Total_Policies from policy_details;  

/* Total Fees */
select sum(Amount) as Total_Fees from fees;

/* Total claim Amt */
select sum(Claim_Amount) as Total_Claim_AMT from claims; 

/* Policy type wise Premium Amount */
select policy_Type, round(sum(Premium_Amount),2) as TotalPremiumAmount
from Policy_Details
group by policy_Type
order by TotalPremiumAmount desc;

/* product group wise total revenue */
select product_group,sum(revenue_amount) as total_revenue
from opportunity
group by product_group;

/* policy type wise policy count*/
select Policy_Type,count(ï»¿Policy_ID) as No_of_Policies
from policy_details
group by Policy_Type
order by No_of_Policies desc;

/* claim Status by Policy Count */
select Claim_Status,count(Policy_ID) as Policy_Count from claims 
group by Claim_Status
order by Policy_Count desc;

/* Age BUCKET Wise POLICY count */
SELECT
  CASE
    WHEN c.Age < 18 THEN 'Under 18'
    WHEN c.Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN c.Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN c.Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN c.Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS age_bucket,
  CONCAT(ROUND(SUM(Premium_Amount) / 1000, 2), 'K') AS Total_Premium_K
FROM policy_details p
JOIN customer_information c ON p.Customer_ID = c.`ï»¿Customer_ID`
GROUP BY age_bucket
ORDER BY age_bucket;


/*Gender Wise Premium amount */
SELECT 
  c.Gender,
  CONCAT(ROUND(SUM(Premium_Amount) / 1000, 2), 'K') AS Total_Premium
FROM policy_details p
JOIN customer_information c ON p.customer_id = c.ï»¿Customer_ID
GROUP BY c.gender
ORDER BY Total_Premium DESC;


/*Policy Expire this year */
SELECT COUNT(*) AS policies_expiring_this_year
FROM policy_details
WHERE YEAR(STR_TO_DATE(Policy_End_Date, '%d-%m-%Y')) = YEAR(CURDATE());

/* claim Status by Policy Count*/
select Claim_Status,count(Policy_ID) as Policy_Count from claims 
group by Claim_Status
order by Policy_Count desc;

/*Payment Status wise Poliy count*/
select Payment_Status,count(Policy_ID) as Policy_count from payment_history
group by Payment_Status
order by Policy_count desc;  

/* Premium Growth rate */
SELECT 
  year_data.policy_year,
  year_data.total_premium,
  ROUND(
    100 * (year_data.total_premium - prev_year_data.total_premium) / prev_year_data.total_premium,
    2
  ) AS premium_growth_rate_percent
FROM (
  SELECT 
    YEAR(STR_TO_DATE(Policy_Start_Date, '%d-%m-%Y')) AS policy_year,
    SUM(Premium_Amount) AS total_premium
  FROM policy_details
  GROUP BY policy_year
) AS year_data
LEFT JOIN (
  SELECT 
    YEAR(STR_TO_DATE(Policy_Start_Date, '%d-%m-%Y')) AS policy_year,
    SUM(Premium_Amount) AS total_premium
  FROM policy_details
  GROUP BY policy_year
) AS prev_year_data
ON year_data.policy_year = prev_year_data.policy_year + 1
 ORDER BY year_data.policy_year;


