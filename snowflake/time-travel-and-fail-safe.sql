Select * from learning_db.public.weather_data;


delete from learning_db.public.weather_data where city='Mumbai';

Select * from learning_db.public.weather_data;


SELECT * FROM learning_db.public.weather_data AT (TIMESTAMP => TO_TIMESTAMP_NTZ('2025-07-14 12:34:20')); 
  

-- At a specific offset: 

SELECT * FROM learning_db.public.weather_data AT (OFFSET => -60*5); -- 5 minutes ago 
  

-- At a query ID: 

SELECT * FROM learning_db.public.weather_data AT (STATEMENT => '01bdad86-3201-caa9-000e-50720003d096'); 
  

-- Undrop (recover dropped objects): 
DROP TABLE learning_db.public.WEATHER_DATA;

UNDROP TABLE learning_db.public.WEATHER_DATA; 
  

-- Clone previous versions: 

CREATE TABLE learning_db.public.weather_data_clone CLONE weather_data BEFORE (STATEMENT => '01bdad86-3201-caa9-000e-50720003d096'); 
  
SELECT * FROM learning_db.public.WEATHER_DATA_CLONE;


