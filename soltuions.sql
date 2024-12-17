SELECT * FROM new_schema.netflix_titles;

-- 10 Business Problems

1. Count total number of Movies and Tv shows in netflix

SELECT 
type,
COUNT(*) as title
FROM new_schema.netflix_titles
GROUP BY type

2.Find the most common ratings for tv and movie shows 


SELECT 
 type,
 rating
FROM
(SELECT
  type,
  rating,
  COUNT(*),
  RANK() OVER(PARTITION by type ORDER BY COUNT(*) DESC) as ranking
FROM new_schema.netflix_titles  
  GROUP BY 
   type,rating)
   as t1 
WHERE 
    ranking =1 
   
   
3.List all movies released in any specific year (eg:2020)

SELECT * FROM new_schema.netflix_titles
WHERE 
type="Movie"
AND
release_year=2020

4. Find the top 5 countries with the most content on netflix


SELECT 
    TRIM(LOWER(jt.new_country)) AS new_country, 
    COUNT(nt.show_id) AS total_content
FROM 
    new_schema.netflix_titles nt,
    JSON_TABLE(
        CONCAT('["', REPLACE(nt.country, ',', '","'), '"]'),
        '$[*]' COLUMNS (new_country VARCHAR(255) PATH '$')
    ) AS jt
GROUP BY 
    TRIM(LOWER(jt.new_country))
ORDER BY 
    total_content DESC
LIMIT 5;

5.Idnetify the longest movie?


SELECT MAX(duration) 
FROM new_schema.netflix_titles 
WHERE type = 'Movie'


6. Find content added inlast five years ?


SELECT 
   *,
   STR_TO_DATE(date_added, '%M %d,%Y') AS formatted_date
FROM 
   new_schema.netflix_titles
WHERE
  STR_TO_DATE(date_added, '%M %d,%Y') >= CURRENT_DATE() - INTERVAL 5 YEAR;
  
  
  7.find all movies/tv shows directed by "Scott stewart"?
  
  SELECT *FROM new_schema.netflix_titles
  WHERE director LIKE "%Scott Stewart%" ;
  
  
  8. list all the number of seasons which are greater than 5?
  
  
 SELECT 
    *, 
    SUBSTRING_INDEX(duration, ' ', 1) AS seasons 
FROM 
    new_schema.netflix_titles
WHERE 
    LOWER(type) = 'Tv Show' 
    AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) >5;
    
    
   9. count the number of content items in each genre
   
  SELECT 
    listed_in,
    show_id,
    SUBSTRING_INDEX(listed_in, ',', 1) AS first_category,
    COUNT(show_id) AS total_content
FROM new_schema.netflix_titles
GROUP BY
    listed_in,show_id;
    
    
 10. list all the movies that are documentaries  ?
 
SELECT * 
FROM new_schema.netflix_titles
WHERE 
    LOWER(listed_in) LIKE '%documentaries%';
