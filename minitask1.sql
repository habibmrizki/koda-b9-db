CREATE TABLE events (
    event_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL
);

INSERT INTO
    events (event_name, start_date)
VALUES
    ('Event A', '2024-01-01'),
    ('Event B', '2024-01-05'),
    ('Event C', '2024-01-10');
    

SELECT e.event_name , string_agg(ne.event_name, ', ') AS next_event 
FROM events e
LEFT JOIN events ne ON e.start_date < ne.start_date
GROUP BY e.event_name;

select e.event_name, ne.event_name as next_event
FROM events e
left join events ne on e.start_date < ne.start_date;