import streamlit as st
import cx_Oracle
from datetime import datetime


def connect_to_database():
    connStr = "system/12345678@localhost:1521/xepdb1"
    conn = cx_Oracle.connect(connStr)
    return conn


def authenticate_user(username, password):
    conn = connect_to_database()
    cur = conn.cursor()
    cur.execute(
        'SELECT * FROM "user" WHERE username = :username AND password = :password',
        {"username": username, "password": password},
    )
    row = cur.fetchone()
    # st.write(cur.rowcount)
    user_id = None
    if cur.rowcount > 0:
        user_id = row[0]
    # st.write(user_id if user_id else "No")
    cur.close()
    return user_id


def user_login():
    # Navigation bar
    conn = connect_to_database()
    cur = conn.cursor()
    st.title("Login")
    username = st.text_input("Username")
    password = st.text_input("Password")
    user_id = None
    if st.button("Login"):
        user_id = authenticate_user(username, password)
        if user_id:
            cur = conn.cursor()
            cur.execute(
        'SELECT name, sex, age, weight_kg, height_cm, bmi FROM "user" WHERE id = :user_id',
        {"user_id": user_id},
            )
            userData=cur.fetchone()
            st.title(f"Welcome, {userData[0]}!")
            # Display navigation bar
        else:
            st.error("Invalid username or password")

    cur.close()
    conn.close()
    return user_id
