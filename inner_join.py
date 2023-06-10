import mysql.connector
mydb= mysql.connector.connect(
    host= "Localhost",
    username= "root",
    password= "Reymysterio$800",
    database= "reymysterio"
)
mycursor= mydb.cursor()
sql= "SELECT users.id AS id, friends.friend_name AS name, friends.email AS email \
      FROM users \
      INNER JOIN friends ON users.id= friends.id \
      WHERE friends.email LIKE '%gmail%' \
      ORDER BY id"
mycursor.execute(sql)
myresult= mycursor.fetchall()
for x in myresult:
    print(x)
