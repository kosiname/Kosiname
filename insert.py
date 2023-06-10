import mysql.connector
mydb= mysql.connector.connect(
    host= "Localhost",
    username= "root",
    password= "Reymysterio$800",
    database= "reymysterio"
)
mycursor= mydb.cursor()
sql= "INSERT INTO users(id, name) VALUES (%s, %s)"
val= [
    ("4", "Muyiwa"),
    ("5", "Jude"),
    ("6", "Chukwudi")
]
mycursor.executemany(sql, val)
mydb.commit()
print(mycursor.rowcount, "inserted rows")

