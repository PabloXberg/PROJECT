/* Q1: The Elite Five (Top Ranks) */ 
SELECT university_name, national_rank 
FROM universities 
ORDER BY national_rank ASC 
LIMIT 5;

/* Q2: Public vs. Private Research Impact */ 
SELECT institution_type, ROUND(AVG(research_impact_score), 2) as avg_impact
FROM universities
GROUP BY institution_type;

/* Q3: The State Leaderboard (Education Hubs) */ 
SELECT state, COUNT(*) as school_count
FROM universities
GROUP BY state
ORDER BY school_count DESC;

/* Q4: Employment Excellence */ 
SELECT university_name, employment_rate, state
FROM universities
ORDER BY employment_rate DESC
LIMIT 5;

/* Q5: The "Old Guard" (Founded before 1800) */ 
SELECT university_name, founded_year, institution_type
FROM universities
WHERE founded_year < 1800
ORDER BY founded_year ASC;

/* Q6: Top Employment in CA and NY */ 
SELECT university_name, state, employment_rate
FROM universities
WHERE state IN ('CA', 'NY')
ORDER BY employment_rate DESC
LIMIT 5;

/* Q7: Research Impact by Century (Historical Performance) */ 
SELECT 
    CASE 
        WHEN founded_year < 1800 THEN 'Pre-1800s'
        WHEN founded_year BETWEEN 1800 AND 1899 THEN '19th Century'
        ELSE '20th Century+' 
    END AS era,
    ROUND(AVG(research_impact_score), 2) as avg_impact
FROM universities
GROUP BY era;

/* Q8: Public vs Private Split (%)*/ 
SELECT institution_type, 
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM universities) as percentage
FROM universities
GROUP BY institution_type;

/* Q9: Highest Ranked Public School */ 
SELECT university_name, national_rank, state
FROM universities
WHERE institution_type = 'Public'
ORDER BY national_rank ASC
LIMIT 1;

/* Q10: Performance-to-International Ratio */ 
/* Checking schools that get high research impact relative to their international student ratio */
SELECT university_name, 
       ROUND(research_impact_score / intl_student_ratio, 2) as efficiency_score
FROM universities
ORDER BY efficiency_score DESC
LIMIT 5;