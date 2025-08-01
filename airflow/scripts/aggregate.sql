SELECT 
    DEPARTMENT,
    COUNT(*) AS TOTAL_EMPLOYEES,
    ROUND(AVG(SALARY), 2) AS AVG_SALARY,
    ROUND(MAX(SALARY), 2) AS MAX_SALARY,
    ROUND(MIN(SALARY), 2) AS MIN_SALARY
FROM {{ database }}.{{ schema }}.{{ employee_table }}
GROUP BY DEPARTMENT
ORDER BY TOTAL_EMPLOYEES DESC;
