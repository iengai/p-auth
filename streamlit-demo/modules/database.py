from sqlalchemy import create_engine
from sqlalchemy.sql import text
from sqlalchemy.exc import SQLAlchemyError
from dotenv import load_dotenv
import os
import streamlit as st

load_dotenv()
SNOWFLAKE_USER = os.getenv("SNOWFLAKE_USER")
SNOWFLAKE_PASSWORD = os.getenv("SNOWFLAKE_PASSWORD")
SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT")
SNOWFLAKE_DATABASE = os.getenv("SNOWFLAKE_DATABASE")
SNOWFLAKE_SCHEMA = os.getenv("SNOWFLAKE_SCHEMA")
SNOWFLAKE_WAREHOUSE = os.getenv("SNOWFLAKE_WAREHOUSE")


@st.cache_resource
def get_engine():
    """create and cache pool"""
    engine = create_engine(
        "snowflake://{user}:{password}@{account_identifier}/{database}/{schema}?warehouse={warehouse}" . format(
            user=SNOWFLAKE_USER,
            password=SNOWFLAKE_PASSWORD,
            account_identifier=SNOWFLAKE_ACCOUNT,
            database=SNOWFLAKE_DATABASE,
            schema=SNOWFLAKE_SCHEMA,
            warehouse=SNOWFLAKE_WAREHOUSE,
        ),
        pool_size=5,
        max_overflow=10,
        pool_recycle=1800,
        echo=False
    )
    return engine

def execute_query(query):
    """use pool to query"""
    try:
        engine = get_engine()
        with engine.connect() as connection:
            result = connection.execute(text(query))
            return result
    except SQLAlchemyError as err:
        st.error(f"execute failed: {err}")
        return None
