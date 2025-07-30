-- Step 1: Create Required Table

CREATE OR REPLACE TABLE DEV_DB.DEV_SCHEMA.TITANIC_DATA (
  age FLOAT ,
  sex STRING,
  survived INT
);


INSERT INTO DEV_SCHEMA.TITANIC_DATA (age, sex, survived) VALUES 
(22, 'male', 0),
(38, 'female', 1),
(26, 'female', 1),
(35, 'male', 0),
(28, 'male', 1);


-- Step 2: Create Stage for Model Storage


CREATE OR REPLACE STAGE DEV_SCHEMA.ml_stage;

list @ml_stage;


--  ---------------------------------UDF

CREATE OR REPLACE FUNCTION predict_survival(age FLOAT, sex INT)
RETURNS INT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
HANDLER = 'predict_survival'
IMPORTS = ('@ml_stage/rf_model.pkl.gz')
PACKAGES = ('cloudpickle', 'scikit-learn')
AS
$$
import cloudpickle
import gzip
import os
import sys

def predict_survival(age: float, sex: int) -> int:
    # Get the path to the imported files directory
    import_dir = sys._xoptions.get("snowflake_import_directory")
    file_path = os.path.join(import_dir, "rf_model.pkl.gz")

    # Only load the model once
    if not hasattr(predict_survival, "model"):
        with gzip.open(file_path, "rb") as f:
            predict_survival.model = cloudpickle.load(f)

    input_data = [[age, sex]]
    prediction = predict_survival.model.predict(input_data)[0]
    return int(prediction)
$$;



-- -----------------------------Query

SELECT
  AGE,
  SEX,
  predict_survival(
    AGE,
    CASE
      WHEN LOWER(SEX) = 'female' THEN 1
      ELSE 0
    END
  ) AS predicted_survived
FROM DEV_SCHEMA.TITANIC_DATA
LIMIT 10;
