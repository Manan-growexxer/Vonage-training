select * from learning_db.public.weather_data_clone;


-- 10% Random Sample
SELECT * FROM learning_db.public.weather_data_clone SAMPLE (10);


-- 10% Sample Using SYSTEM Method (Faster)

SELECT * FROM learning_db.public.weather_data_clone SAMPLE SYSTEM (10);


-- 3 Random Rows Using BERNOULLI

SELECT * FROM learning_db.public.weather_data_clone SAMPLE BERNOULLI (3 ROWS);




-- Using the LIMIT Clause

select * from learning_db.public.weather_data_clone limit 5;
