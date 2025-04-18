--USING goal::real tells PostgreSQL to convert the existing values in goal to type real using a cast (::real).

ALTER TABLE ksproject
ALTER COLUMN goal TYPE real
USING goal::real;

-- This query is used to retrieve detailed metadata about the columns of a table

SELECT *
  FROM information_schema.columns
  WHERE table_name = 'ksproject'

  
-- relevant columns from the ksprojects table that will shows us to assess a project's result 
-- based on its main category, amount of money set as a goal, number of backers, 
-- and amount of money pledged.

SELECT main_category,goal,backers,pledged FROM ksproject LIMIT 10;


--Shows the records where the project state is either 'failed', 'canceled', or 'suspended'.

SELECT main_category, goal, backers, pledged
  FROM ksproject WHERE state IN('failed','canceled','suspended')
 LIMIT 10;

--Find which of these projects had at least 100 backers and at least $20,000 pledged.
--project state is either 'failed', 'canceled', or 'suspended'.

SELECT main_category, backers, pledged, goal
 FROM ksproject
WHERE state IN ('failed', 'canceled', 'suspended') AND backers >= 100 AND pledged >= 20000 
LIMIT 10;

--Main category sorted in ascending order. A calculated field called pct_pledged, which divides pledged by goal. Sort this field in descending order.
--(Add pct_pledged to the SELECT clause, too.) and where project state is failed

SELECT main_category, backers, pledged, goal, pledged/goal AS pct_pledged
  FROM ksproject
 WHERE state IN ('failed')
   AND backers >= 100 AND pledged >= 20000
 ORDER BY main_category , pct_pledged DESC
 LIMIT 10;


-- Create a field funding_status that applies the following logic based on the percentage of amount pledged to campaign goal:

-- If the percentage pledged is greater than or equal to 1, then the project is "Fully funded".
-- If the percentage pledged is between 75% and 100%, then the project is "Nearly funded".
-- If the percentage pledged is less than 75%, then the project is "Not nearly funded".

 SELECT main_category, backers, pledged, goal,
         pledged / goal AS pct_pledged,
    CASE 
     WHEN (pledged / goal)*100 = 1 THEN 'Fully funded'
     WHEN (pledged / goal)*100 BETWEEN 75 AND 100 THEN 'Nearly funded'
     WHEN (pledged / goal)*100 < 75 THEN 'Not nearly funded'
     END AS funding_status
    FROM ksproject
   WHERE state IN ('failed')
     AND backers >= 100 AND pledged >= 20000     
ORDER BY main_category, pct_pledged DESC
   LIMIT 10;



