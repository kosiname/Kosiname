-- SELECT * FROM PortfolioProject.dbo.CovidDeath;
-- SELECT * FROM PortfolioProject.dbo.CovidVaccination;

--Necessary Data.
SELECT location, date, total_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeath;

-- Likelihood of Nigerians dying from Covid if infected.
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases AS float))*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE location= 'Nigeria';

--Total cases vs Population in the United states. Shows what percentage of the population got Covid.
SELECT location, date, population, total_cases, (CAST(total_cases AS float) / CAST(population AS float))*100 AS CasesPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE location= 'United States';

-- Looking at Top 10 countries with the Highest infection rate compared to the population
SELECT location, population, 
MAX(total_cases) AS HighestInfectionCount, 
MAX((CAST(total_cases AS float) / CAST(population AS float)))*100 AS "Percent of Infected population"
FROM PortfolioProject.dbo.CovidDeath
GROUP BY location, population
ORDER BY "Percent of Infected population" DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

-- Top 10 Countries with Highest death count per percentage
SELECT location, population,
MAX(total_deaths) AS HighestDeathCount
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY HighestDeathCount DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

-- Top 10 Continents with Highest death count per percentage
SELECT location,
MAX(total_deaths) AS HighestDeathCount
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestDeathCount DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

--Showing continents with the highest death count per population
SELECT continent,
MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers by Date
SELECT date, 
SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
(NULLIF(SUM(CAST(new_deaths AS float)), 0) / NULLIF(SUM(CAST(new_cases AS float)), 0)) * 100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- Global Numbers 
SELECT
SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
(NULLIF(SUM(CAST(new_deaths AS float)), 0) / NULLIF(SUM(CAST(new_cases AS float)), 0)) * 100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NOT NULL
ORDER BY DeathPercentage; 

--  Total population vs vaccinations 
WITH popvsvac(continent, location, date, population, new_vaccinations, Continuous_count_of_vaccinations) AS(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Continuous_count_of_vacciantions
FROM PortfolioProject.dbo.CovidDeath AS dea
INNER JOIN PortfolioProject.dbo.CovidVaccination AS vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (CAST(Continuous_count_of_vaccinations AS float)/CAST(population AS float))*100 AS PecentageVaccinated FROM popvsvac;

-- Creating a temporary table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated(
    continent VARCHAR(288),
    location VARCHAR(288),
    date DATE,
    population BIGINT,
    new_vaccinations INT,
    Continuous_count_of_vaccinations INT
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Continuous_count_of_vacciantions
FROM PortfolioProject.dbo.CovidDeath AS dea
INNER JOIN PortfolioProject.dbo.CovidVaccination AS vac
ON dea.location = vac.location AND dea.date = vac.date

SELECT *, (CAST(Continuous_count_of_vaccinations AS float)/CAST(population AS float))*100 AS PecentageVaccinated FROM #PercentPopulationVaccinated;

-- Creating views for later visualizations
DROP VIEW PercentPopulationVaccinated
GO
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Continuous_count_of_vacciantions
FROM PortfolioProject.dbo.CovidDeath AS dea
INNER JOIN PortfolioProject.dbo.CovidVaccination AS vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GO

DROP VIEW NeccesaryData
GO 
CREATE VIEW NeccesaryData AS
SELECT location, date, total_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeath;
GO

DROP VIEW InfectedNigeriansDying
GO
CREATE VIEW InfectedNigeriansDying AS
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS float) / CAST(total_cases AS float))*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE location= 'Nigeria';
GO

DROP VIEW PercentOfUSpopulationInfected
GO
CREATE VIEW PercentOfUSpopulationInfected AS
SELECT location, date, population, total_cases, (CAST(total_cases AS float) / CAST(population AS float))*100 AS CasesPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE location= 'United States';
GO

DROP VIEW Top10CountriesByInfectionRate
GO
CREATE VIEW Top10CountriesByInfectionRate AS
SELECT location, population, 
MAX(total_cases) AS HighestInfectionCount, 
MAX((CAST(total_cases AS float) / CAST(population AS float)))*100 AS "Percent of Infected population"
FROM PortfolioProject.dbo.CovidDeath
GROUP BY location, population
ORDER BY "Percent of Infected population" DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;
GO

DROP VIEW Top10CountriesByDeathCount
GO
CREATE VIEW Top10CountriesByDeathCount AS
SELECT location, population,
MAX(total_deaths) AS HighestDeathCount
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY HighestDeathCount DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;
GO

DROP VIEW Top10ContinentsByDeathCount
GO
CREATE VIEW Top10ContinentsByDeathCount AS
SELECT location,
MAX(total_deaths) AS HighestDeathCount
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestDeathCount DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;
GO

DROP VIEW HighestDeathCountByContinent
GO
CREATE VIEW HighestDeathCountByContinent AS
SELECT continent,
MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NOT NULL
GROUP BY continent;
GO

DROP VIEW GlobalNumbersByDate
GO
CREATE VIEW GlobalNumbersByDate AS
SELECT date, 
SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
(NULLIF(SUM(CAST(new_deaths AS float)), 0) / NULLIF(SUM(CAST(new_cases AS float)), 0)) * 100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NOT NULL
GROUP BY date;
GO

DROP VIEW GlobalNumbers
GO
CREATE VIEW GlobalNumbers AS
SELECT
SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
(NULLIF(SUM(CAST(new_deaths AS float)), 0) / NULLIF(SUM(CAST(new_cases AS float)), 0)) * 100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE continent IS NOT NULL; 
GO