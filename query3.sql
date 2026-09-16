
-- 1. Menampilkan list director beserta banyaknya genre yang sudah di-direct
SELECT 
    d.id AS director_id,
    d.first_name,
    d.last_name,
    COUNT(DISTINCT m.genre_id) AS total_genres
FROM directors d
JOIN movies m ON d.id = m.director_id
GROUP BY d.id, d.first_name, d.last_name;


-- 2. Menampilkan list aktor dengan peran lebih dari 5
SELECT 
    a.id AS actor_id,
    a.first_name,
    a.last_name,
    COUNT(ma.role) AS total_roles
FROM actors a
JOIN movies_actors ma ON a.id = ma.actor_id
GROUP BY a.id, a.first_name, a.last_name
HAVING COUNT(ma.role) > 5;


-- 3. Menampilkan director yang paling produktif sepanjang masa
SELECT 
    d.id AS director_id,
    d.first_name,
    d.last_name,
    COUNT(m.id) AS total_movies
FROM directors d
JOIN movies m ON d.id = m.director_id
GROUP BY d.id, d.first_name, d.last_name
ORDER BY total_movies DESC
LIMIT 1;


-- 4. Menampilkan tahun tersibuk sepanjang masa (tahun dengan rilis film terbanyak)
SELECT 
    EXTRACT(YEAR FROM release_date) AS release_year,
    COUNT(*) AS total_movies
FROM movies
GROUP BY EXTRACT(YEAR FROM release_date)
ORDER BY total_movies DESC
LIMIT 1;


-- 5. Mendapatkan data movies dengan list actors yang disatukan menjadi 1 kolom (dipisahkan dengan koma) dengan menggunakan string_agg
SELECT 
    m.id AS movie_id,
    m.title,
    STRING_AGG(CONCAT(a.first_name, ' ', a.last_name), ', ') AS list_actors
FROM movies m
JOIN movies_actors ma ON m.id = ma.movie_id
JOIN actors a ON ma.actor_id = a.id
GROUP BY m.id, m.title;

