CREATE OR REPLACE STAGE learning_db.public.image_stage 
  DIRECTORY = (ENABLE = TRUE);



CREATE OR REPLACE TABLE learning_db.public.unstructured_files (
  file_name STRING,
  file_url STRING,
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);


INSERT into learning_db.public.unstructured_files (file_name, file_url)
SELECT 
  RELATIVE_PATH AS file_name,
  GET_PRESIGNED_URL(@image_stage, RELATIVE_PATH) AS file_url
FROM DIRECTORY(@image_stage);


select * from learning_db.public.unstructured_files;
