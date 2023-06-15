# Solution to the Pivot tables challenge on HackerRank Advanced select.
# Question: Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. 
# The output column headers should be Doctor, Professor, Singer, and Actor, respectively. 
import mysql.connector
mydb= mysql.connector.connect(
    host= "Localhost",
    username= "root",
    password= "",
    database= "hacker_rank"
)
mycursor= mydb.cursor()
sql= "CREATE VIEW pq AS( \
      SELECT \
      CASE WHEN occupation= 'Doctor' THEN name END AS 'Doctor', \
      CASE WHEN occupation= 'Professor' THEN name END AS 'Professor', \
      CASE WHEN occupation= 'Singer' THEN name END AS 'Singer', \
      CASE WHEN occupation= 'Actor' THNE name END AS 'Actor', \
      ROW_NUMBER() OVER(PARTITION BY occupation ORDER BY name) AS cr \
      FROM occupations); \
      SELECT MAX(Doctor), MAX(Professor), MAX(Singer), MAX(Actor) FROM pq \
      GROUP cr"
mycursor.execute(sql)
myresult= mycursor.fetchall()
for x in myresult:
    print (x)
