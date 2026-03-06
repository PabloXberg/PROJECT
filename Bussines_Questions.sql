-- Q1: Question: Which U.S. Region has the highest average Research Impact Score?
SELECT s.region, ROUND(AVG(u.research_impact_score), 2) as avg_research
FROM universities u
JOIN state_info s ON u.state = s.state_code
GROUP BY s.region
ORDER BY avg_research DESC;

-- Q2: The "Wealthy State" Filter (Subquery)
-- Question: List all universities located in states where the Median Household Income is higher than the overall national average of all states in our list.
SELECT university_name, state
FROM universities
WHERE state IN (
    SELECT state_code 
    FROM state_info 
    WHERE median_household_income > (SELECT AVG(median_household_income) FROM state_info)
);
-- Q3
-- Question: Find universities in the 'Northeast' that have an Employment Rate higher than 92%.
SELECT u.university_name, u.employment_rate, s.region
FROM universities u
JOIN state_info s ON u.state = s.state_code
WHERE s.region = 'Northeast' AND u.employment_rate > 92;

-- Q4: State Opportunity Score (JOIN + HAVING)
-- Question: For each state, show the number of top universities and the average state income, but only for states with more than 2 universities.
SELECT s.state_name, COUNT(u.university_name) as uni_count, s.median_household_income
FROM state_info s
JOIN universities u ON s.state_code = u.state
GROUP BY s.state_name
HAVING uni_count > 2;

-- Q5: Question: Does being an "Elite" school (Rank 1-5) correlate with being in a high-income state (>$80k)?
SELECT 
    CASE WHEN u.national_rank <= 5 THEN 'Elite (1-5)' ELSE 'Rest of Top 50' END as rank_group,
    AVG(s.median_household_income) as avg_state_wealth
FROM universities u
JOIN state_info s ON u.state = s.state_code
GROUP BY rank_group;

-- Q6: Question: Which region hosts the university with the absolute highest International Student Ratio?
SELECT u.university_name, s.region, u.intl_student_ratio
FROM universities u
JOIN state_info s ON u.state = s.state_code
ORDER BY u.intl_student_ratio DESC
LIMIT 1;

-- Q7: Education Deserts (LEFT JOIN)
-- Question: Which states in our metadata table currently have zero universities represented in the Top 50 list?
SELECT s.state_name, s.region
FROM state_info s
LEFT JOIN universities u ON s.state_code = u.state
WHERE u.university_name IS NULL;

-- Q8: Comparative Employment (Subquery)
-- Question: List Public universities that have a higher Employment Rate than the average of all Private universities.
SELECT university_name, employment_rate
FROM universities
WHERE institution_type = 'Public' 
AND employment_rate > (SELECT AVG(employment_rate) FROM universities WHERE institution_type = 'Private');

-- Q9: Regional Diversity (JOIN + Count Distinct)
-- Question: How many different states in each region have at least one university in the Top 50?
SELECT s.region, COUNT(DISTINCT u.state) as active_states_count
FROM state_info s
JOIN universities u ON s.state_code = u.state
GROUP BY s.region;

-- Q10: Master Summary (CTE + JOIN)
-- Question: Create a final report showing each state, its region, the best rank found in that state, and its average research impact.
WITH StateSummary AS (
    SELECT state, MIN(national_rank) as best_rank, AVG(research_impact_score) as avg_impact
    FROM universities
    GROUP BY state
)
SELECT info.state_name, info.region, summ.best_rank, ROUND(summ.avg_impact, 2) as avg_impact
FROM state_info info
JOIN StateSummary summ ON info.state_code = summ.state;