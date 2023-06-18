## Connect to database
import mysql.connector
mydb= mysql.connector.connect(
    host= "Localhost",
    username= "root",
    password= "Reymysterio$800",
    database= "covid_project"
)
## Global number of cases and deaths. Calculate the death percentage worldwide.
mycursor= mydb.cursor()
sql= "SELECT \
      SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, \
      (NULLIF(SUM(new_deaths), 0) / NULLIF(SUM(new_cases), 0)) * 100 AS DeathPercentage \
      FROM CovidDeath \
      WHERE continent IS NOT NULL \
      ORDER BY DeathPercentage; "
mycursor.execute(sql)
myresult= mycursor.fetchall()
for x in myresult:
    print(x)

## Death count per continent.
mycursor= mydb.cursor()
sqm= "SELECT location, SUM(new_deaths) AS TotalDeathCount \
      FROM CovidDeath \
      WHERE continent IS NULL AND location NOT IN ('World', 'European Union', 'International') \
      GROUP BY location \
      ORDER BY TotalDeathCount DESC;"
mycursor.execute(sqm)
myresult= mycursor.fetchall()
for x in myresult:
    print(x)

## Number of Infected per country and percentage of population infected.
mycursor= mydb.cursor()
sqn= "SELECT location, population, \
      MAX(total_cases) AS HighestInfectionCount, \
      MAX((total_cases / population)) * 100 AS Percent_of_Infected_population \
      FROM CovidDeath \
      GROUP BY location, population \
      ORDER BY Percent_of_Infected_population DESC" 
mycursor.execute(sqn)
myresult= mycursor.fetchall()
for x in myresult:
    print(x)

## Daily infection country per country and percentage of population infected.
mycursor= mydb.cursor()
sqo= "SELECT location, population, date, \
MAX(total_cases) AS HighestInfectionCount, \
(total_cases / population) * 100 AS PercentPopulationInfected \
FROM CovidDeath \
GROUP BY location, population, date \
ORDER BY PercentPopulationInfected DESC;"
mycursor.execute(sqo)
myresult= mycursor.fetchall()
for x in myresult:
    print(x)

   