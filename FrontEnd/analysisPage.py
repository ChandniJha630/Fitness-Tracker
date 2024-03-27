import streamlit as st
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import plotly.graph_objects as go
import datetime
import pandas as pd
from PIL import Image

def user_info(user_id, cur):
    cur.execute(
        'SELECT * FROM "user" WHERE id = :user_id',
        {"user_id": user_id},
    )
    row = cur.fetchone()
    if row is not None:
        sex = row[3]
        age = row[2]
        wt = row[4]
        ht = row[5]
        bmi=row[6]
    
    return sex, age, wt, ht,bmi

def query_and_process(cur, query, granularity):

    cur.execute(query)
    rows = cur.fetchall()

    if granularity == "Daily":
        df = pd.DataFrame(rows, columns=['date_column', 'total_data'])
    elif granularity == "Weekly":
        df = pd.DataFrame(rows, columns=['week_number', 'total_data'])
    elif granularity == "Monthly":
        df = pd.DataFrame(rows, columns=['month', 'total_data'])

    return df


# Define function to plot data based on granularity
def plot_data(df, title, x_axis_title, y_axis_title,w,thresold, granularity):
    fig = go.Figure()

    # Check if the DataFrame is empty
    if not df.empty:
        if granularity == 'Daily':
            # Plot line chart for daily data
            fig.add_trace(go.Scatter(x=df['date_column'], y=df['total_data'], mode='lines+markers'))
        elif granularity == 'Weekly':
            # Plot bar chart for weekly data
            text_inside_bars = df['week_number'] + '<br>' + df['total_data'].astype(str)
            fig.add_trace(go.Bar(x=df['week_number'], y=df['total_data'], text=text_inside_bars,
                            textposition='inside', 
                            hoverinfo='x+text'))
            thresold*=7
        elif granularity == 'Monthly':
            # Plot bar chart for monthly data
            month_names = []
            thresold*=30
            for month_year in df['month']:
                # Split the string to extract month and year
                year, month = month_year.split('-')
                
                # Get the month name from the month number
                month_name = datetime.date(int(year), int(month), 1).strftime("%B")
                month_names.append(month_name)

            # Concatenate month name and total data values for displaying inside the bars
            text_inside_bars = [f"{month}<br>{total}" for month, total in zip(month_names, df['total_data'])]

            fig.add_trace(go.Bar(
                x=month_names,
                y=df['total_data'],
                text=text_inside_bars,  # Display month name and total data inside the bars
                textposition='inside',  # Position the text inside the bars
                hoverinfo='text',  # Display only text on hover
               
            ))
            
    # Update layout properties
    fig.update_layout(
        title=title,
        # xaxis_title=x_axis_title,
        yaxis_title=y_axis_title,
        # xaxis_tickformat='%d-%b',  # Customize x-axis tick labels to show only date and month
        xaxis_tickangle=-45,  # Rotate x-axis tick labels
        xaxis_showgrid=True,  # Add gridlines
        yaxis_showgrid=True,
         width=w
    )
    if thresold !=0:
        fig.add_hline(y=thresold, line_dash="dash", line_color="green", annotation_text="Target", annotation_position="bottom right")
    # Display the Plotly figure using Streamlit
    st.plotly_chart(fig)

def fetch_calories(user_id, cur,granularity):
   
    if granularity == "Daily":
        exercise_query = f"""
        SELECT TRUNC(timedate) AS date_column, sum(CaloriesBurnt) AS total_data
        FROM ExerciseData
        WHERE UserID = {user_id}
        GROUP BY TRUNC(timedate)
        """

    elif granularity == "Weekly":
        exercise_query = f"""
        SELECT TO_CHAR(timedate, 'IYYY-IW') AS week_number,SUM(CaloriesBurnt) AS total_data
        FROM ExerciseData
        WHERE UserID = {user_id}
        GROUP BY TO_CHAR(timedate, 'IYYY-IW')
        ORDER BY week_number
        """

    else :
        exercise_query = f"""
        SELECT TO_CHAR(timedate, 'YYYY-MM') AS month ,SUM(CaloriesBurnt) AS total_data
        FROM ExerciseData
        WHERE UserID = {user_id}
        GROUP BY TO_CHAR(timedate, 'YYYY-MM')
        ORDER BY month
        """

    df = query_and_process(cur, exercise_query, granularity)
 
    return df
   


def fetch_water_intake(user_id, cur,weight,granularity):

    if granularity == "Daily":
            water_query = f"""
            SELECT TRUNC(time_stamp) AS date_column, sum(quantity_ml) AS total_data
            FROM water_intake
            WHERE user_id = {user_id}
            GROUP BY TRUNC(time_stamp)
            """
    elif granularity == "Weekly":
            water_query = f"""
            SELECT TO_CHAR(time_stamp, 'IYYY-IW') AS week_number, SUM(quantity_ml) AS total_data
            FROM water_intake
            WHERE user_id = {user_id}
            GROUP BY TO_CHAR(time_stamp, 'IYYY-IW')
            ORDER BY week_number
            """
    elif granularity == "Monthly":
            water_query = f"""
            SELECT TO_CHAR(time_stamp, 'YYYY-MM') AS month, SUM(quantity_ml) AS total_data
            FROM water_intake
            WHERE user_id = {user_id}
            GROUP BY TO_CHAR(time_stamp, 'YYYY-MM')
            ORDER BY month
            """

    df = query_and_process(cur, water_query, granularity)
   
    if granularity=="Daily":
        df['consume'] = df.apply(lambda row: weight * 40 - row['total_data'], axis=1)
    elif granularity=="Monthly":
        df['consume'] = df.apply(lambda row: weight * 40 - row['total_data']/30, axis=1)
    else:
        df['consume'] = df.apply(lambda row: weight * 40 - row['total_data']/7, axis=1)
    # Create a suggestion column row-wise
    df['Suggestion'] = df.apply(lambda row: f"Consume {row['consume']} ml of extra water" if row['consume'] > 0 else "Great job! You are perfectly hydrated", axis=1)

    return df

def fetch_sleep_time(user_id, cur,granularity):

    if granularity == "Daily":
        sleep_query = f"""
        SELECT TRUNC(time_stamp) AS date_column, sum(totalduration) AS total_data,sum(light) AS light_sleep,sum(deep) AS deep_sleep, sum(rem) AS rem_sleep,
        AVG(SleepQualityIndex) AS avg_sleep_index
        FROM sleep
        WHERE userid = {user_id}
        GROUP BY TRUNC(time_stamp)
        """
    elif granularity == "Weekly":
        sleep_query = f"""
        SELECT TO_CHAR(time_stamp, 'IYYY-IW') AS week_number, sum(totalduration) AS total_data,sum(light) AS light_sleep,sum(deep) AS deep_sleep, sum(rem) AS rem_sleep,
        AVG(SleepQualityIndex) AS avg_sleep_index
        FROM sleep
        WHERE userid = {user_id}
        GROUP BY TO_CHAR(time_stamp, 'IYYY-IW')
        ORDER BY week_number
        """
    else :
        sleep_query = f"""
        SELECT TO_CHAR(time_stamp, 'YYYY-MM') AS month, sum(totalduration) AS total_data,sum(light) AS light_sleep,sum(deep) AS deep_sleep, sum(rem) AS rem_sleep,
        AVG(SleepQualityIndex) AS avg_sleep_index
        FROM sleep
        WHERE userid = {user_id}
        GROUP BY TO_CHAR(time_stamp, 'YYYY-MM')
        ORDER BY month
        """

    cur.execute(sleep_query)
    rows = cur.fetchall()   # list of tuples

    # Convert to DataFrame
    if granularity == "Daily":
        df = pd.DataFrame(rows, columns=['date_column', 'total_data', 'light_sleep', 'deep_sleep', 'rem_sleep','index'])
    elif granularity == "Weekly":
        df = pd.DataFrame(rows, columns=['week_number', 'total_data', 'light_sleep', 'deep_sleep', 'rem_sleep','index'])
    elif granularity == "Monthly":
        df = pd.DataFrame(rows, columns=['month', 'total_data', 'light_sleep', 'deep_sleep', 'rem_sleep','index'])
    
    return df


def fetch_food_intake(user_id, cur,granularity):
   
    if granularity == "Daily":
        food_query = f"""
        SELECT TRUNC(time_stamp) AS date_column, sum(Calories) AS total_calories
        FROM foodlog
        WHERE UserID = {user_id}
        GROUP BY TRUNC(time_stamp)
        """

    elif granularity == "Weekly":
        food_query = f"""
        SELECT TO_CHAR(time_stamp, 'IYYY-IW') AS week_number, sum(Calories) AS total_calories
        FROM foodlog
        WHERE UserID = {user_id}
        GROUP BY TO_CHAR(time_stamp, 'IYYY-IW')
        ORDER BY week_number
        """
    elif granularity == "Monthly":
        food_query = f"""
        SELECT TO_CHAR(time_stamp, 'YYYY-MM') AS month, sum(Calories) AS total_calories
        FROM foodlog
        WHERE UserID = {user_id}
        GROUP BY TO_CHAR(time_stamp, 'YYYY-MM')
        ORDER BY month
        """
        
    df = query_and_process(cur, food_query, granularity)
    return df
    

def show_charts(user_id, conn):

    cur = conn.cursor()

#--------------------------------------------------------------------------------------------------- 
    # Fetch data from Oracle database
    age ,sex, weight_kg, height_cm,bmi = user_info(user_id, cur)

    data = {
        "Attribute": ["Age",  "Sex", "Calories Weight(kg)", "Height(cm)","BMI"],
        "Value": [age, sex, weight_kg, height_cm,bmi],
    }
    df = pd.DataFrame(data)

    user_df = df.style.hide(axis='index')
    user_df.hide(axis='columns')
    
    st.title("Overview")
    
    col1, col2 = st.columns([1, 1])
    with col1:
        if sex=='Male':
                st.image('Asset/male.png', width=350)
               
        else:
                st.image('Asset/female.png', width=350)
            

    with col2:
        st.write(user_df.to_html(), unsafe_allow_html=True)  
        st.divider()
        info_style = "font-size: 14px; padding: 20px; background-color: black; border-radius: 5px;"
        message=''
        if bmi < 18.5:
            message = ("Underweight: You may need to gain some weight to reach a healthy BMI. "
                   "Consider incorporating more calorie-dense foods into your diet, such as nuts, avocados, "
                   "cheese, and healthy fats like olive oil and coconut oil. Also, focus on consuming protein-rich "
                   "foods like chicken, fish, beans, and lentils to help build muscle mass.")
        elif 18.5 <= bmi < 25:
            message = ("Normal weight: Your BMI is within the healthy range. "
                   "Maintain a balanced diet rich in fruits, vegetables, whole grains, lean proteins, "
                   "and healthy fats. Remember to stay hydrated by drinking plenty of water and limit "
                   "consumption of processed foods and sugary beverages.")
        elif 25 <= bmi < 30:
            message = ("Overweight: You may need to lose some weight to reach a healthy BMI. "
                   "Focus on incorporating more fruits, vegetables, and whole grains into your diet while "
                   "limiting high-calorie and high-fat foods. Additionally, engage in regular physical "
                   "activity such as brisk walking, jogging, or cycling to aid in weight loss.")
        else:
            message = ("Obese: You may be at risk for various health issues. Consider consulting a healthcare professional "
                   "for personalized advice. In the meantime, aim to make healthier food choices by reducing "
                   "consumption of processed foods, sugary snacks, and high-fat foods. Increase intake of "
                   "nutrient-dense foods like fruits, vegetables, lean proteins, and whole grains. It's also "
                   "important to prioritize regular exercise and physical activity to improve overall health.")
    
        st.write(f"<p style='{info_style}'>{message}</p>", unsafe_allow_html=True)
#------------------------------------------------------------------------------------------------------
    st.divider()
# Add a slider to select the granularity (weekly or daily)
    granularity = st.select_slider('Select Granularity', options =['Daily','Weekly','Monthly'],value='Daily')
#--------------------------------------------------------------------------------------------------------
    st.divider()
    st.title("Water Intake Tracker")
    # Based on the selected granularity, display the appropriate chart
    if granularity == 'Weekly':
        st.write("Weekly Chart")
        # Plot the weekly chart here using the Plotly or Matplotlib code for weekly data
    elif granularity == 'Monthly':
        st.write("Monthly Chart")
    else:
        st.write("Daily Chart")
        
    if granularity=="Daily":
        val='date_column'
    elif granularity=="Monthly":
        val='month'
    else:
        val='week_number'
    water_df = fetch_water_intake(user_id, cur,weight_kg,granularity)
    st.write(water_df)
    plot_data(water_df, "Water Intake", "Date", "Water Intake (ml)", 600,weight_kg*30, granularity)

    posW=0
    negW=0
    for each in water_df['Suggestion']:
        if each == "Great job! You are perfectly hydrated":
            posW+=1
        else:
            negW+=1
      # Create labels and corresponding values for the pie chart
    labels = ['Hydrated','Dehydrated']
    values = [posW,negW]

    # Define colors for each sleep stage
    colors = ['lightblue', 'lightgreen', 'lightcoral']
    from plotly.colors import sequential

    colorscale = sequential.Viridis
    # Create the pie chart
    fig = go.Figure(data=[go.Pie(labels=labels, values=values, hole=0.3 ,marker_colors=colorscale,
                    textinfo='value+percent', textposition='inside',
                    textfont=dict(size=20,color='white'))])


    # Update layout properties
    fig.update_layout(
        title="Hydration Level",
    )

    # Display the plot
    st.plotly_chart(fig)
    msgW=''
    if posW<negW:
        msgW='''Grow an habbit of drinking more water. You are mostly dehydrated !!. Staying hydrated is good for your
                 health, it gives you glowing skin and does purification and detoxification of blood'''
    else:
        msgW='''Great Job Dude !! A healthy person is basic building block of a healthy society'''
    st.write(f"<p style='{info_style}'>{msgW}</p>", unsafe_allow_html=True)
    
#-------------------------------------------------------------------------------------------------------
    st.divider()
    st.title("Calorie Intake") 
    food_df = fetch_food_intake(user_id, cur,granularity)
    col1,col2=st.columns([1,1])
    with col2:
        st.write(food_df)
    with col1:
        plot_data(food_df, "Calories Intake", "Date", "Calories",300,0, granularity)

#---------------------------------------------------------------------------------------------------------
    st.title("Calorie Burnt")
    calories_df = fetch_calories(user_id, cur,granularity)
    col1,col2=st.columns([1,1])
    with col2:
        st.write(calories_df)
    with col1:
        plot_data(calories_df, "Calories Burnt", "Date", "Calories",300,0, granularity)
#-----------------------------------------------------------------------------------------------------
    st.title("Sleep Analysis")
    sleep_df = fetch_sleep_time(user_id, cur,granularity)
    st.write(sleep_df)
    if granularity=="Monthly":
        sd=240
    elif granularity=="Daily":
        sd=8
    else:
        sd=56  
    col1,col2=st.columns([1,1])
    with col1:
    # Create a Plotly figure
        fig = go.Figure()
        # Add a line trace for the daily sleep duration
        fig.add_trace(go.Scatter(x=sleep_df[f"{val}"], y=sleep_df['total_data'], mode='lines+markers', name='Sleep Duration'))
        # Update layout properties
        fig.update_layout(
            title="Sleep Duration",
            yaxis_title="Total Sleep (hours)",
            xaxis_tickformat='%d-%b',  # Customize x-axis tick labels to show only date and month
            xaxis_tickangle=-45,  # Rotate x-axis tick labels
            xaxis_showgrid=True,  # Add gridlines
            yaxis_showgrid=True,
            width=300
        )

        fig.add_hline(y=sd, line_dash="dash", line_color="green", annotation_text="Target", annotation_position="bottom right")
         # Display the plot
        st.plotly_chart(fig)
    with col2:
        fig1 = go.Figure()
        # Add a line trace for the daily sleep duration
        fig1.add_trace(go.Scatter(x=sleep_df[f"{val}"], y=sleep_df['index'], mode='lines+markers', name='Sleep Duration'))
        # Update layout properties
        fig1.update_layout(
            title="Sleep Index",
            yaxis_title="index",
            xaxis_tickformat='%d-%b',  # Customize x-axis tick labels to show only date and month
            xaxis_tickangle=-45,  # Rotate x-axis tick labelsr
            xaxis_showgrid=True,  # Add gridlines
            yaxis_showgrid=True,
            width=300
        )

        # Add a horizontal line at y=3.7
        fig1.add_hline(y=0.37, line_dash="dash", line_color="green", annotation_text="Target", annotation_position="bottom right")

        # Display the plot
        st.plotly_chart(fig1)

    # Calculate total sleep duration for each sleep stage
    light_sleep_total = sleep_df['light_sleep'].sum()
    deep_sleep_total = sleep_df['deep_sleep'].sum()
    rem_sleep_total = sleep_df['rem_sleep'].sum()

    # Create labels and corresponding values for the pie chart
    labels = ['Light Sleep', 'Deep Sleep', 'REM Sleep']
    values = [light_sleep_total, deep_sleep_total, rem_sleep_total]

    # Define colors for each sleep stage
    colors = ['lightblue', 'lightgreen', 'lightcoral']
    from plotly.colors import sequential

    colorscale = sequential.Viridis
    # Create the pie chart
    fig = go.Figure(data=[go.Pie(labels=labels, values=values, hole=0.3 ,marker_colors=colorscale,
                    textinfo='value+percent', textposition='inside',
                    textfont=dict(size=20,color='white'))])


    # Update layout properties
    fig.update_layout(
        title="Sleep Distribution",
    )

    # Display the plot
    st.plotly_chart(fig)
    posS=0
    negS=0
    for each in sleep_df['index']:
        if each>=0.37 and each<=0.38:
            posS+=1
        else:
            negS+=1
    messS=''
    if posS>negS:
        messS='It is good to see that you had perfect sleep'
    else:
        messS='You donot care about yourself, Have a good sleep. Ideally you should sleep 8 hours a days 4 hour light sleep, 2 hour deep and 2 hour rem sleep'
    st.write(f"<p style='{info_style}'>{messS}</p>", unsafe_allow_html=True)
    cur.close()
