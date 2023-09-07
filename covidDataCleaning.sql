USE PortfolioProjects

Select * 
From PortfolioProjects.dbo.covidDeaths


-- Cleaning date col

Select date
from PortfolioProjects.dbo.covidDeaths

ALTER TABLE PortfolioProjects.dbo.covidDeaths
Add date_converted Date;

Update PortfolioProjects.dbo.covidDeaths
SET date_converted = CONVERT(Date, date)

ALTER TABLE PortfolioProjects.dbo.covidDeaths
DROP COLUMN date;

Select * 
From PortfolioProjects.dbo.covidDeaths

-- Filling null values

Select total_cases, new_cases_smoothed, total_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_smoothed_per_million
From PortfolioProjects.dbo.covidDeaths

UPDATE PortfolioProjects.dbo.covidDeaths
SET total_cases = ISNULL(total_cases, 0),
    new_cases_smoothed = ISNULL(new_cases_smoothed, 0),
    total_deaths = ISNULL(total_deaths, 0),
	new_deaths_smoothed = ISNULL(new_deaths_smoothed, 0),
	total_cases_per_million = ISNULL(total_cases_per_million, 0),
	new_cases_smoothed_per_million = ISNULL(new_cases_smoothed_per_million, 0),
	total_deaths_per_million = ISNULL(total_deaths_per_million, 0),
	new_deaths_smoothed_per_million = ISNULL(new_deaths_smoothed_per_million, 0),
	reproduction_rate = ISNULL(reproduction_rate, 0)
WHERE total_cases IS NULL OR new_cases_smoothed IS NULL OR total_deaths IS NULL OR new_deaths_smoothed IS NULL OR total_cases_per_million IS NULL OR new_cases_smoothed_per_million IS NULL OR total_deaths_per_million IS NULL OR new_deaths_smoothed_per_million IS NULL OR reproduction_rate IS NULL;

Select * 
From PortfolioProjects.dbo.covidDeaths




