
SELECT * FROM projects.hr;

ALTER TABLE hr
CHANGE COLUMN id emp_id VARCHAR(20)NULL;

DESCRIBE hr;

SELECT birthdate FROM hr;

SET sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
 WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'),'%Y-%m-%d')
 WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'),'%Y-%m-%d')
 ELSE NULL
END; 

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

SELECT birthdate FROM hr;

UPDATE hr
SET hire_date = CASE
 WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_hdate, '%m/%d/%Y'),'%Y-%m-%d')
 WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'),'%Y-%m-%d')
 ELSE NULL
END; 

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SELECT hire_hdate FROM hr;

UPDATE hr
SET termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate!= '';

SELECT termdate FROM hr;

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR,birthdate,curdate());

SELECT birthdate,age FROM hr;

SELECT 
  min(age) AS youngest,
  max(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age< 18;

-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?

SELECT gender, count(*)AS count 
FROM hr
WHERE age>= 18 AND termdate = ''
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?

SELECT race, count(*) AS count
FROM hr
WHERE age>= 18 AND termdate = ''
GROUP BY race
ORDER BY count(*)DESC;

-- 3. What is the age distribution of employees in the company?
SELECT 
 min(age) AS youngest,
 max(age) AS oldest
FROM hr 
WHERE age>= 18 AND termdate = '';

SELECT 
 CASE
   WHEN age>=18 AND age<= 24 THEN '18-24'
   WHEN age>=25 AND age<= 34 THEN '25-34'
   WHEN age>=35 AND age<= 44 THEN '35-44'
   WHEN age>=45 AND age<= 54 THEN '45-54'
   WHEN age>=55 AND age<= 64 THEN '55-64'
   ELSE '65+'
  END as age_group,
  count(*) AS count
FROM hr
WHERE age>= 18 AND termdate = ''
GROUP BY age_group
ORDER BY age_group;

SELECT 
 CASE
   WHEN age>=18 AND age<= 24 THEN '18-24'
   WHEN age>=25 AND age<= 34 THEN '25-34'
   WHEN age>=35 AND age<= 44 THEN '35-44'
   WHEN age>=45 AND age<= 54 THEN '45-54'
   WHEN age>=55 AND age<= 64 THEN '55-64'
   ELSE '65+'
  END as age_group, gender,
  count(*) AS count
FROM hr
WHERE age>= 18 AND termdate = ''
GROUP BY age_group,gender
ORDER BY age_group, gender;

-- 4. How many employees work at the headquarters versus remote?

 SELECT location,count(*) AS count
 FROM hr
 WHERE age>= 18 AND termdate = ''
 GROUP BY location;
 
 -- 5. What is the average length of employment for employees who have been terminated?
 
 SELECT 
   round(avg(datediff(termdate, hire_date))/365,0) AS avg_length_employment
   FROM hr
   WHERE termdate<= curdate() AND termdate<> '' AND age>=18;
   
   -- 6. How does the gender distribution vary across departments and job titles 
   
   SELECT department, gender, count(*) AS count
   FROM hr
   WHERE age>= 18 AND termdate = ''
   GROUP BY department,gender
   ORDER BY department;
   
   -- 7. What is the distribution of job titles across the company?
   
   SELECT jobtitle, count(*) AS count
   FROM hr
   WHERE age>= 18 AND termdate = ''
   GROUP BY jobtitle
   ORDER BY jobtitle DESC;
   
    -- 8. What is the distribution of employees across location by state?
    
    SELECT location_state, count(*) AS count
    FROM hr
	WHERE age>= 18 AND termdate = ''
    GROUP BY location_state
    ORDER BY count DESC;
    
    -- 9. How has the employee count changed over time based on hire date and term date?
    
    SELECT 
      year,
      hires,
      terminations,
      hires - terminations AS net_change,
      round((hires - terminations)/hires * 100,2) AS net_change_percent
    FROM (
        SELECT
         YEAR(hire_date) AS year,
         count(*) AS hires,
         SUM(CASE WHEN termdate <> '' AND termdate<= curdate() THEN 1 ELSE 0 END) AS terminations
         FROM hr
         WHERE age >=18
         GROUP BY YEAR (hire_date)
         ) AS subquery
   ORDER BY year ASC;
   
   -- 10. What is the tenure distribution for each department?
    
    SELECT department,datediff , round(avg((termdate,hire_date)/365),0) AS avg_tenure
    FROM hr
    WHERE termdate <= curdate() AND termdate <> '' AND age>= 18
    GROUP BY department;
    
    
    
    
     
    
    
    
   
   
 
 


  
  









