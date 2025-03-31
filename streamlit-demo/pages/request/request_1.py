import streamlit as st
from modules import database
import pandas as pd


st.header("Requester 1")
st.write(f"You are logged in as {st.session_state.role}.")

query = st.text_area("Query", "select * from users")
result = database.execute_query(query)
df = pd.DataFrame(list(result.fetchall()), columns=result.keys())
st.dataframe(df)