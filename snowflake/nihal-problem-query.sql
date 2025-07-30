
 
CREATE or replace TABLE learning_db.public.MEMBERS(
CUSTOMER_ID VARCHAR(1) PRIMARY KEY,
JOIN_DATE TIMESTAMP
);
 
CREATE or replace TABLE learning_db.public.MENU(
PRODUCT_ID INT PRIMARY KEY,
PRODUCT_NAME VARCHAR(5),
PRICE INT
);
 
CREATE or replace TABLE SALES(
CUSTOMER_ID VARCHAR(1) FOREIGN KEY REFERENCES learning_db.public.MEMBERS(CUSTOMER_ID),
ORDER_DATE DATE,
PRODUCT_ID INT FOREIGN KEY REFERENCES learning_db.public.MENU(PRODUCT_ID)
);
 
INSERT INTO learning_db.public.SALES VALUES ('A','2021-01-01',1),('A','2021-01-01',2),('A','2021-01-07',2),('A','2021-01-10',3),('A','2021-01-11',3),('A','2021-01-11',3),('B','2021-01-01',2),('B','2021-01-02',2),('B','2021-01-04',1),
('B','2021-01-11',1),('B','2021-01-16',3),('B','2021-02-01',3),
('C','2021-01-01',3),('C','2021-01-01',3),('C','2021-01-07',3);
 
INSERT INTO MENU VALUES(1,'SUSHI',10),(2,'CURRY',15),(3,'RAMEN',12);
 
INSERT INTO MEMBERS VALUES ('A','2021-01-07'),('B','2021-01-09');


select * from learning_db.public.members;

select * from learning_db.public.menu;

select * from learning_db.public.sales;


-- Which item was the most popular for each customer?

with tc as (select s.customer_id, s.product_id,m.product_name,count(s.product_id) as cnt,dense_rank() over(partition by s.customer_id order by COUNT(s.product_id) DESC) as dr
from learning_db.public.sales as s join learning_db.public.menu as m 
on s.product_id=m.product_id 
group by s.customer_id,s.product_id,m.product_name
order by s.customer_id 
)
select tc.customer_id,tc.product_name
from tc
where dr=1
;


-- What is the total items and amount spent for each member before they became a member?

select s.customer_id, sum(m.price) as amount,count(m.product_name) as item
from learning_db.public.sales as s join learning_db.public.members as mb
on s.customer_id=mb.customer_id  join learning_db.public.menu as m on s.product_id=m.product_id
where s.order_date < mb.join_date
group by s.customer_id
order by s.customer_id
;







CREATE OR REPLACE VIEW TOATL_ITEM_PURCHASE_BEFORE_BECOMING_MEMBER AS

SELECT CUSTOMER_ID,COUNT(CUSTOMER_ID) AS TOTAL_PURCHASE_PRODUCT FROM (SELECT SALES.CUSTOMER_ID,SALES.ORDER_DATE,SALES.PRODUCT_ID FROM SALES INNER JOIN MEMBERS ON SALES.ORDER_DATE<MEMBERS.JOIN_DATE AND SALES.CUSTOMER_ID=MEMBERS.CUSTOMER_ID) GROUP BY CUSTOMER_ID;
 
CREATE OR REPLACE VIEW ITEM_PURCHASE_BEFORE_BECOMING_MEMBER AS

SELECT MEMBERS.CUSTOMER_ID,SALES.PRODUCT_ID,COUNT(MEMBERS.CUSTOMER_ID) AS ITEM_COUNT FROM SALES INNER JOIN MEMBERS ON SALES.ORDER_DATE<MEMBERS.JOIN_DATE AND SALES.CUSTOMER_ID=MEMBERS.CUSTOMER_ID GROUP BY MEMBERS.CUSTOMER_ID,SALES.PRODUCT_ID;
 
-- 895ms 01bde011-0001-5ab9-000a-c852000ae566

SELECT TEMP_1.CUSTOMER_ID,TEMP_1.TOTAL_PURCHASE_PRODUCT, TEMP_2.TOTAL_AMOUNT_SPENT FROM (SELECT CUSTOMER_ID,SUM(AMOUNT_SPENT) AS TOTAL_AMOUNT_SPENT  FROM (SELECT CUSTOMER_ID,TEMP.PRODUCT_ID,ITEM_COUNT,PRICE,ITEM_COUNT*PRICE AS AMOUNT_SPENT,TOTAL_PURCHASE_PRODUCT FROM (SELECT ITEM_PURCHASE_BEFORE_BECOMING_MEMBER.CUSTOMER_ID,PRODUCT_ID,ITEM_COUNT,TOTAL_PURCHASE_PRODUCT FROM ITEM_PURCHASE_BEFORE_BECOMING_MEMBER INNER JOIN (TOATL_ITEM_PURCHASE_BEFORE_BECOMING_MEMBER) AS TEMP ON ITEM_PURCHASE_BEFORE_BECOMING_MEMBER.CUSTOMER_ID=TEMP.CUSTOMER_ID) AS TEMP INNER JOIN MENU ON TEMP.PRODUCT_ID=MENU.PRODUCT_ID) AS TEMP GROUP BY CUSTOMER_ID) AS TEMP_2 INNER JOIN (TOATL_ITEM_PURCHASE_BEFORE_BECOMING_MEMBER) AS TEMP_1 ON TEMP_1.CUSTOMER_ID=TEMP_2.CUSTOMER_ID ORDER BY TEMP_1.CUSTOMER_ID;
 




-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

with ta as (select s.customer_id,m.product_name, m.price, 
case 
when m.product_name='SUSHI' then price*20 else price*10 end as points
from learning_db.public.sales as s join learning_db.public.menu as m
on s.product_id=m.product_id)
select ta.customer_id,sum(ta.points) as points
from ta
group by ta.customer_id
;



SELECT CUSTOMER_ID,SUM(POINTS) AS POINTS FROM (SELECT CUSTOMER_ID,CASE WHEN PRODUCT_NAME='SUSHI' THEN (PRICE*20) ELSE PRICE*10 END AS POINTS FROM SALES INNER JOIN MENU ON SALES.PRODUCT_ID=MENU.PRODUCT_ID) GROUP BY CUSTOMER_ID;



-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?



with nh as 
(select s.customer_id,s.order_date,m.product_name, m.price,
case when (s.order_date between '2021-01-06' and '2021-01-14'and s.customer_id='A') or (m.product_name='SUSHI'and s.customer_id='A') then m.price*20 
when s.order_date<'2021-01-16' or m.product_name='SUSHI' and s.customer_id='B' then m.price*20 

else m.price*10 
end as points


from learning_db.public.sales as s join learning_db.public.menu as m
on s.product_id=m.product_id join learning_db.public.members as mb
on s.customer_id=mb.customer_id
where s.order_date<'2021-02-01'
)

select 
nh.customer_id,sum(nh.points) as points
from nh
group by nh.customer_id
;



WITH nh AS (
  SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    mb.join_date,
    
    CASE 
      -- First week after joining: all items get 2x
      WHEN s.order_date BETWEEN mb.join_date AND mb.join_date + INTERVAL '7 days'
           THEN m.price * 20
           
      -- After first week: only sushi gets 2x
      WHEN m.product_name = 'SUSHI'
           THEN m.price * 20
           
      -- All others get normal points
      ELSE m.price * 10
    END AS points

  FROM learning_db.public.sales AS s 
  JOIN learning_db.public.menu AS m ON s.product_id = m.product_id
  JOIN learning_db.public.members AS mb ON s.customer_id = mb.customer_id
  WHERE s.order_date < '2021-02-01'
)

SELECT 
  customer_id, 
  SUM(points) AS total_points
FROM nh
GROUP BY customer_id;
