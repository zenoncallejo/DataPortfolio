Select *
from PortfolioProjects..covidDeaths
where continent <>''
order by 3,4


ALTER TABLE PortfolioProjects..covidDeaths
ALTER COLUMN total_cases float;
ALTER TABLE PortfolioProjects..covidDeaths
ALTER COLUMN total_deaths float;
ALTER TABLE PortfolioProjects..covidDeaths
ALTER COLUMN population float;
ALTER TABLE PortfolioProjects..covidVaccinations
ALTER COLUMN new_vaccinations float;


-- Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjects..covidDeaths
--where location like 'Argentina'
order by 1, 2


-- Total Cases vs Population

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopInfected
from PortfolioProjects..covidDeaths
--where location = 'Argentina'
order by 1, 2


-- Percentage of Population Infected

Select Location, population, MAX(total_cases) as InfectionCount, MAX((total_cases/population))*100 as PercentPopInfected
from PortfolioProjects..covidDeaths
--where location = 'Argentina'
Group by Location, population
order by PercentPopInfected desc


--Total Deaths by Continent

Select continent, MAX(total_deaths) as TotalDeathContinents
from PortfolioProjects..covidDeaths
where continent <>''
Group by continent
order by TotalDeathContinents desc


--Total Deaths by Cpuntries

Select Location, MAX(total_deaths) as TotalDeathCountries
from PortfolioProjects..covidDeaths
where continent <>''
Group by Location
order by TotalDeathCountries desc


-- Global Death Percentage

Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from PortfolioProjects..covidDeaths
where continent <>''
and date > '2020-01-19 00:00:00.000'
and date < '2023-08-02 00:00:00.000'
Group by date
order by 1,2



-- Total Population vs Vaccinations
-- CTE

With PopvsVacc (continent, location, date, population, new_vaccinations, TotalVaccinatedByDay)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION by dea.location Order by dea.location, dea.date) as TotalVaccinatedByDay
from PortfolioProjects..covidDeaths dea
Join PortfolioProjects..covidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent <>''

Select * , (TotalVaccinatedByDay/population)*100 as VaccinatedPercent
from PopvsVacc

-- Temp Table

--Create table #VaccinatedPercent
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--TotalVaccinatedByDay numeric
--)

--Insert into #VaccinatedPercent
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(vac.new_vaccinations) OVER (PARTITION by dea.location Order by dea.location, dea.date) as TotalVaccinatedByDay
--from PortfolioProjects..covidDeaths dea
--Join PortfolioProjects..covidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent <>''

--Select * , (TotalVaccinatedByDay/population)*100 as VaccinatedPercent
--from #VaccinatedPercent

