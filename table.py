import mysql.connector
mydb= mysql.connector.connect(
    host= "Localhost",
    username= "root",
    password= "Reymysterio$800",
    database= "reymysterio"
)

mycursor= mydb.cursor()
sql= "CREATE TABLE student_data( \
      id INT PRIMARY KEY, \
      name VARCHAR(288), \
      contact_information VARCHAR(11), \
      address VARCHAR(288), \
      admission_year YEAR, \
      department VARCHAR(288))"
mycursor.execute(sql)

mycursor= mydb.cursor()
code= "INSERT INTO student_data VALUES (%s, %s, %s, %s, %s, %s)"
val= [
    ("1", "Oduah Ikechukwu", "08139555234", "10, Opaleye str, Lagos", "2016", "Computer Science"),
    ("2", "Ifeanyi Ugorji", "08162943208", "27, Irone Avenue, Lagos", "2015", "Electrical Engineering"),
    ("3", "Michael Nwangwu", "09156058232", "31, Cole str, Lagos", "2016", "Physics"),
    ("4", "Oduah Chukwudindu", "08024944915", "12, Tayo Oyefeko str, Lagos", "2019", "Mass Communication"),
    ("5", "Eloke Ikelagwu", "09038496996", "22, Bariga road, Lagos", "2016", "Physics"),
    ("6", "Henry Chidubem", "08132404232", "197, Omogba estate, Anambra", "2019", "Mass Communication"),
    ("7", "Chigozie Nsofor", "08113179931", "7, Imode str, Lagos", "2017", "Computer Science"),
    ("8", "Christopher Ikem", "08143320934", "19, Mercy Eneli str, Anambra", "2016", "Mathematics"),
    ("9", "Ayo Bami", "08065627769", "56, Adelabu road, Lagos", "2020", "English Language"),
    ("10", "Chinedu Daniels", "08169942923", "1, Abraham Adesanya str, Lagos", "2018", "Petroeum Engineering")
    ]
mycursor.executemany(code, val)
mydb.commit()
print (mycursor.rowcount, "inserted rows")

mycursor= mydb.cursor()
sel= "SELECT name, contact_information, department FROM student_data WHERE address LIKE '%Anambra%'"
mycursor.execute(sel)
myresult= mycursor.fetchall()
for x in myresult:
    print (x)