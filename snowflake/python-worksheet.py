# The Snowpark package is required for Python Worksheets. 
# You can add more packages by selecting them using the Packages control and then importing them.

import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session): 
    # Your code goes here, inside the "main" handler.
    
    df = session.table("ORDERS")

    # result=group_by_func(df)
    result=filter_func(df)
    
    return result

# ---------------------------------------------------------------------------

def group_by_func(df):
    
    grouped = df.group_by("REGION").agg({"ORDER_VALUE": "avg"})
    
    return grouped

def filter_func(df):
    
    result = df.filter(col("REGION") == "East")
    
    return result