select *
from PortfolioProject..CovidDeaths1
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations1
--order by 3,4

-- Select Data that we are going to be using
select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths1
order by 1,2

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths1
where location like '%states%'
order by 1,2


-- Looking at total cases vs population

select Location, date, population, total_cases, (total_cases/population)*100 as PercentOfPopulationInfected
from PortfolioProject..CovidDeaths1
where location like '%states%'
order by 1,2

-- Looking at countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases * 100.0/population)) as PercentOfPopulationInfected
from PortfolioProject..CovidDeaths1
--where location like '%states%'
group by location, population
order by PercentOfPopulationInfected desc


-- Showing Countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths1
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc


Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths1
--where location like '%states%'
where continent is null
group by location
order by TotalDeathCount desc

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths1
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global numbers

select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, Sum(new_deaths)/SUM(new_cases)*100
from PortfolioProject..CovidDeaths1
--where location like '%states%'
where continent is not null
group by date
order by 1,2


select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, Sum(new_deaths)/SUM(new_cases)*100
from PortfolioProject..CovidDeaths1
--where location like '%states%'
where continent is not null
order by 1,2

-- Total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
,-- (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths1 dea
join PortfolioProject..CovidVaccinations1 vac
  on dea.location = vac.location
  and dea.date = vac.date 
where dea.continent is not null
order by 2, 3

-- Use a CTE

With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

from PortfolioProject..CovidDeaths1 dea
join PortfolioProject..CovidVaccinations1 vac
  on dea.location = vac.location
  and dea.date = vac.date 
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/population) * 100
from PopvsVac

-- Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric 
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

from PortfolioProject..CovidDeaths1 dea
join PortfolioProject..CovidVaccinations1 vac
  on dea.location = vac.location
  and dea.date = vac.date 
where dea.continent is not null

Select *, (RollingPeopleVaccinated/population) * 100
from #PercentPopulationVaccinated


-- Creating view

Create View PercentPopulationVaccinated as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

from PortfolioProject..CovidDeaths1 dea
join PortfolioProject..CovidVaccinations1 vac
  on dea.location = vac.location
  and dea.date = vac.date 
where dea.continent is not null

Select *
from PercentPopulationVaccinated