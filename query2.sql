-- Active: 1777419634954@@127.0.0.1@5432@minitask_query

-- 1. Menampilkan data gabungan antara tabel directors dan genres ke dalam tabel movies, batasi output sebanyak 50 baris
SELECT 
    m.id AS movie_id,
    m.title,
    m.release_date,
    m.rating,
    d.first_name AS director_first_name,
    d.last_name AS director_last_name,
    g.name AS genre_name
FROM movies m
JOIN directors d ON m.director_id = d.id
JOIN genres g ON m.genre_id = g.id
LIMIT 50;


-- 2. Menampilkan data gabungan antara tabel movies dan actors berdasarkan tabel asosiasi movies_actors
SELECT 
    m.id AS movie_id,
    m.title,
    m.release_date,
    m.rating,
    a.first_name AS actor_first_name,
    a.last_name AS actor_last_name,
    ma.role
FROM movies m
JOIN movies_actors ma ON m.id = ma.movie_id
JOIN actors a ON ma.actor_id = a.id;
