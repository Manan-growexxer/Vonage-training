use role accountadmin;

-- Create a database to store our schemas.
create database if not exists raw;

-- Create the schema. The schema stores all our objectss.
create schema if not exists raw.science;

/*
    Warehouses are synonymous with the idea of compute
    resources in other systems. We will use this
    warehouse to call our user defined function.
*/
create warehouse if not exists development 
    warehouse_size = xsmall
    auto_suspend = 30
    initially_suspended = true;

use database raw;
use schema science;
use warehouse development;


-- ------------------------sample data--------------------------------

use role accountadmin;

-- Sample Data
create or replace table raw.science.student_test_scores as
    select
        $1 as hours_studied,
        $2 as test_score
    from values
        (1.0, 3.5),
        (2.0, 9.2),
        (3.0, 13.1),
        (4.0, 24.7),
        (5.0, 28.5),
        (6.0, 41.0),
        (7.0, 50.3),
        (8.0, 63.5),
        (9.0, 82.1),
        (10.0, 95.0);



--  -------------------------Use the model --------------------------------


-- Using the default version.
select
    10 as hours_studied,

    predict_test_score!predict(hours_studied) as result,

    result:output_feature_0::float as prediction;

    

-- Selecting a specific model version.
with
    predict_test_score as model predict_test_score version last

select
    3.5 as hours_studied,
    predict_test_score!predict(hours_studied) as result,
    result:output_feature_0::float as prediction;