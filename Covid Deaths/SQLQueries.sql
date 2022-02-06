SELECT *
	FROM dbo.CovidDeaths;

--SELECT *
	--FROM dbo.CovidVaccinations
	--ORDER BY 3, 4;

SELECT location, date,total_cases, new_cases, total_deaths, population
	FROM CovidDeaths
	ORDER BY 1,2;

-- Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
	FROM CovidDeaths
	WHERE continent IS NOT NULL
	-- WHERE location = 'India' 
	ORDER BY 1,2;

-- Total Cases vs Population
-- Intresting Fact: In india only 3% people got covid-19. 
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectionPercentage
	FROM CovidDeaths
	WHERE continent IS NOT NULL
	-- WHERE location = 'India'
	ORDER BY 1,2;

-- Countries with Highest Infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS InfectionPercentage
	FROM CovidDeaths
	WHERE continent IS NOT NULL
	GROUP BY location, population
	ORDER BY 4 DESC;

-- Countries with Highest Death rate per population
SELECT location, MAX(CAST(total_deaths as INT)) AS TotalDeathCount
	FROM CovidDeaths
	WHERE continent IS NOT NULL
	GROUP BY location
	ORDER BY TotalDeathCount DESC;


-- Wrong Numbers
-- Continent Numbers
SELECT continent, MAX(CAST(total_deaths as INT)) AS TotalDeathCount
	FROM CovidDeaths
	WHERE continent IS NOT NULL
	GROUP BY continent
	ORDER BY TotalDeathCount DESC;

-- Right Numbers
--SELECT location, MAX(CAST(total_deaths as INT)) AS TotalDeathCount
--	FROM CovidDeaths
--	WHERE continent IS NULL
--	GROUP BY location
--	ORDER BY TotalDeathCount DESC;

-- Global Numbers
SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS DeathPercentage
	FROM CovidDeaths
	WHERE continent IS NOT NULL
	-- GROUP BY date
	ORDER BY 1,2;


-- JOIN Two Tables
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/dea.population)*100
	FROM CovidDeaths dea
	JOIN CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL AND dea.location = 'India'
	GROUP BY dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations
	ORDER BY 2, 3;


-- USE CTE

WITH PopvsVAC (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/dea.population)*100
	FROM CovidDeaths dea
	JOIN CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL AND dea.location = 'India'
	GROUP BY dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations
	-- ORDER BY 2, 3
)
SELECT *, (RollingPeopleVaccinated/population)*100 as VaccinationRate
FROM PopvsVAC;


-- TEMP Table
DROP TABLE IF EXISTS #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric
)
INSERT INTO #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/dea.population)*100
	FROM CovidDeaths dea
	JOIN CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL AND dea.location = 'India'
	GROUP BY dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations
	-- ORDER BY 2, 3

SELECT *, (RollingPeopleVaccinated/population)*100 as VaccinationRate
FROM #PercentagePopulationVaccinated;


-- VIEW
CREATE VIEW PercentagePopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/dea.population)*100
	FROM CovidDeaths dea
	JOIN CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	GROUP BY dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations
	-- ORDER BY 2, 3