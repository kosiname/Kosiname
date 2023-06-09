import mysql.connector
mydb= mysql.connector.connect(
    host= "Localhost",
    username= "root",
    password= "Reymysterio$800",
    database= "reymysterio"
)
mycursor= mydb.cursor()
sql= "SELECT * FROM friends"
mycursor.execute(sql)
myresult= mycursor.fetchall()
for x in myresult:
    print(x)
    