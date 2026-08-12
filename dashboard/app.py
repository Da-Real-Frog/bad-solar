import streamlit as st
import pandas as pd
import psycopg2
import os

st.set_page_config(page_title="Tesla Solar Monitor", layout="wide")
st.title("Historical Solar Production")

# 1. Establish Database Connection
@st.cache_resource
def get_db_connection():
    return psycopg2.connect(
        dbname=os.environ.get("DB_NAME"),
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASSWORD"),
        host="timescaledb", # Connects securely via the internal Docker network
        port="5432"
    )

conn = get_db_connection()

# 2. Timeframe Controls
col1, col2 = st.columns(2)
with col1:
    view_option = st.selectbox("Select Granularity", ["Day", "Week", "Month"])
with col2:
    metric_option = st.selectbox("Select Metric", ["Solar Generation", "Home Consumption", "Grid Export"])

st.divider()

# 3. Visualization Placeholder
st.info("Data visualizations mapping current metrics against T-12 and T-24 baselines will be rendered here.")