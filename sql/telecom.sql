USE telecom_churn;

-- Here's all the table
SELECT * FROM customers;

SELECT * FROM accounts;

SELECT * FROM services;

SELECT * FROM support_tickets;

SELECT * FROM monthly_usage;


-- 1. How many rows in each tables 
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL
SELECT 'services', COUNT(*) FROM services
UNION ALL
SELECT 'support_tickets', COUNT(*) FROM support_tickets
UNION ALL
SELECT 'monthly_usage', COUNT(*) FROM monthly_usage;

-- 2. Check null values
SELECT 
    SUM(CASE WHEN total_charges IS NULL THEN 1 ELSE 0 END) AS null_total_charges,
    SUM(CASE WHEN monthly_charges IS NULL THEN 1 ELSE 0 END) AS null_monthly_charges
FROM accounts;


-- 3. Distinct values in categorical columns (helps spot inconsistent labels)
SELECT DISTINCT contract_type FROM accounts;
SELECT DISTINCT payment_method FROM accounts;
SELECT DISTINCT internet_service FROM services;
SELECT DISTINCT issue_type FROM support_tickets;


-- 4. Any duplicate customer_ids? (should be 0)
SELECT customer_id, COUNT(*) 
FROM customers 
GROUP BY customer_id 
HAVING COUNT(*) > 1;
-- There is no any duplicate customer ID

-- 5.1. Average resolution time by issue_type (O/P => Between 36.93 & 35.69) It doesn't matter 
SELECT
	issue_type,
    ROUND(AVG(resolution_time_hours),2) AS avg_resolution_time
FROM support_tickets
GROUP BY issue_type
ORDER BY avg_resolution_time DESC; 

-- 5.2 Customer churn by Issue_type
SELECT 
	st.issue_type,
    COUNT(a.churn) AS churn_customers
FROM accounts a JOIN support_tickets st ON a.customer_id = st.customer_id
GROUP BY
	a.churn,
    st.issue_type
HAVING a.churn = 'Yes';

-- 6. Overall churn rate
SELECT 
    churn, 
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM accounts
GROUP BY churn;


-- 7. Churn rate by contract type (first real insight)
SELECT 
    contract_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM accounts
GROUP BY contract_type
ORDER BY churn_rate_pct DESC; 


-- 8. Average support tickets: churned vs retained
SELECT 
    a.churn,
    ROUND(AVG(t.ticket_count), 2) AS avg_tickets
FROM accounts a
LEFT JOIN (
    SELECT customer_id, COUNT(*) AS ticket_count
    FROM support_tickets
    GROUP BY customer_id
) t ON a.customer_id = t.customer_id
GROUP BY a.churn;


-- 9. Combine all data in one table, and export it.
SELECT 
    c.customer_id, 
    c.gender, 
    c.senior_citizen, 
    c.partner, 
    c.dependents, 
    c.signup_date,
    a.tenure_months, 
    a.contract_type, 
    a.paperless_billing, 
    a.payment_method, 
    a.monthly_charges, 
    a.total_charges, 
    a.churn,
    s.phone_service, 
    s.multiple_lines, 
    s.internet_service, 
    s.online_security, 
    s.online_backup, 
    s.device_protection, 
    s.tech_support, 
    s.streaming_tv, 
    s.streaming_movies,
    COALESCE(t.ticket_count, 0) AS total_tickets,
    COALESCE(t.avg_satisfaction, NULL) AS avg_satisfaction_score,
    COALESCE(u.avg_data_gb, NULL) AS avg_monthly_data_gb,
    COALESCE(u.avg_call_minutes, NULL) AS avg_monthly_call_minutes
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN services s ON c.customer_id = s.customer_id
LEFT JOIN (
    SELECT customer_id, COUNT(*) AS ticket_count, AVG(satisfaction_score) AS avg_satisfaction
    FROM support_tickets
    GROUP BY customer_id
) t ON c.customer_id = t.customer_id
LEFT JOIN (
    SELECT customer_id, AVG(data_gb) AS avg_data_gb, AVG(call_minutes) AS avg_call_minutes
    FROM monthly_usage
    GROUP BY customer_id
) u ON c.customer_id = u.customer_id;