select id, title
from movies
WHERE extract(YEAR from release_date) = 2020;


select id, first_name
from actors
where lower(first_name) like lower('%s');


SELECT id, title, rating 
FROM movies 
WHERE rating >= 4 AND rating <= 8
  AND extract(YEAR from release_date) BETWEEN '2004' AND '2010';




