import streamlit as st
import datetime
import pandas as pd
from PIL import Image

exercise_list = [
    "Yoga",
    "Walking",
    "Running",
    "Cricket",
    "Badminton",
    "Swimming",
    "Cycling",
    "Aerobics/Zumba",
    "Traditional Dance",
    "Skipping",
    "Martial Arts",
    "Misc"
]

def calories_burnt(conn, user_id, exercise, duration):
    cur = conn.cursor()
    cur.execute(
        'SELECT weight_kg FROM "user" WHERE id = :user_id',
        {"user_id": user_id},
    )
    usr_row = cur.fetchone()
  
    if cur.rowcount > 0:
        wt = usr_row[0]
    cur.execute(
        'SELECT met_value,description FROM Exercise_MET_Values WHERE exercise = :exercise',
        {"exercise": exercise},
    )

    exer_row = cur.fetchone()
    if cur.rowcount > 0:
        MET = exer_row[0]
        desc = exer_row[1]
    cur.close()
    return round((wt*MET*duration)/60,2),MET

def add_exercise(conn, user_id, time_stamp,exercise,duration,cals):
    cur = conn.cursor()
    cur.execute(
       """ INSERT INTO ExerciseData (timedate, UserID, TypeOfExercise, Duration, CaloriesBurnt)
            VALUES (:timedate, :UserID, :TypeOfExercise, :Duration, :CaloriesBurnt) """,
       
       {"timedate": time_stamp, "UserID": user_id, "TypeOfExercise": exercise, 
        "Duration": duration, "CaloriesBurnt": cals},
    )
    conn.commit()
    cur.close()

def exercise_tracker(user_id, conn):
# Streamlit app layout

    im=Image.open('Asset/Exercise.png') 
    col1, col2 = st.columns([1, 9])
    with col1:
        st.image(im, width=200)
    with col2:
        st.title("Exercise Tracker")
   
    # Date input
    date = st.date_input("Select Date")

    # Time slot selection
    time = st.time_input('Select Time Slot', datetime.time(8, 45))

    # Combine date and time into a datetime object
    timestamp = datetime.datetime.combine(date, time)

    # Exercise selection
    exercise = st.selectbox("Select Exercise", exercise_list)

    # Duration input
    duration = st.number_input("Enter Duration (in minutes)", min_value=5)


    # Submit button
    if st.button("Submit"):
        # Calculate calories
        calories,MET = calories_burnt(conn,user_id,exercise, duration)
        
        # Display result

        data = {
            "Attribute": ["Exercise",  "MET Value", "Calories Burnt"],
            "Value": [exercise,  MET, calories]
        }
        df = pd.DataFrame(data)

        styled_df = df.style.hide(axis='index').format(precision=2)
        styled_df.hide(axis='columns')
        
        st.write(styled_df.to_html(), unsafe_allow_html=True)
        st.markdown("") 
        add_exercise(conn, user_id, timestamp, exercise, duration, calories)
        st.success("Exercise Logged!")
