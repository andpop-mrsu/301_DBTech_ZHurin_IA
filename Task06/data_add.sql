INSERT INTO users (name, email, gender, register_date, occupation_id)
VALUES 
('Журин Илья', 'ilya.zhurin@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'administrator')),
('Еремин Вадим', 'vadim.eremin@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'developer')),
('Кармышев Ильдар', 'ildar.karmyshev@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'programmer')),
('Гончаров Константин', 'konstantin.goncharov@example.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'writer')),
('Кучина Альвина', 'alvina.kuchina@example.com', 'female', date('now'), 
    (SELECT id FROM occupations WHERE name = 'engineer'));


INSERT INTO movies (title, year)
VALUES 
('Начало', 2010),
('Побег из Шоушенка', 1994),
('Темный рыцарь', 2008);

INSERT INTO movies_genres (movie_id, genre_id)
VALUES 
-- Начало: Sci-Fi, Action, Thriller
((SELECT id FROM movies WHERE title = 'Начало'), 
 (SELECT id FROM genres WHERE name = 'Sci-Fi')),
((SELECT id FROM movies WHERE title = 'Начало'), 
 (SELECT id FROM genres WHERE name = 'Action')),
((SELECT id FROM movies WHERE title = 'Начало'), 
 (SELECT id FROM genres WHERE name = 'Thriller')),

-- Побег из Шоушенка: Drama
((SELECT id FROM movies WHERE title = 'Побег из Шоушенка'), 
 (SELECT id FROM genres WHERE name = 'Drama')),

-- Темный рыцарь: Action, Crime, Drama
((SELECT id FROM movies WHERE title = 'Темный рыцарь'), 
 (SELECT id FROM genres WHERE name = 'Action')),
((SELECT id FROM movies WHERE title = 'Темный рыцарь'), 
 (SELECT id FROM genres WHERE name = 'Crime')),
((SELECT id FROM movies WHERE title = 'Темный рыцарь'), 
 (SELECT id FROM genres WHERE name = 'Drama'));

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES 
((SELECT id FROM users WHERE email = 'ilya.zhurin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Начало'), 5.0, strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'ilya.zhurin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Побег из Шоушенка'), 4.9, strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'ilya.zhurin@example.com'), 
 (SELECT id FROM movies WHERE title = 'Темный рыцарь'), 4.8, strftime('%s', 'now'));
