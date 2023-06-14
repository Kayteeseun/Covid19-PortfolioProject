Select * 
From [portfolio project]..CovidDeaths
Where continent is not null
order by 3,4


--Select * 
--From [portfolio project]..CovidVacination
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from [portfolio project]..CovidDeaths
where continent is not null
order by 1,2

--Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathPercentage
from [portfolio project]..CovidDeaths
where location like '%africa%'
order by 1,2




--Total Cases by Population
--percentage of people that  got covid

Select Location, date, total_cases, population,(total_cases/population)*100 as deathPercentage
from [portfolio project]..CovidDeaths
where location like '%africa%'
order by 1,2

--Countries with highest Infection Rate Compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectioncount, MAX((total_cases/population)) *100 as
Percentpopulationinfected
from [portfolio project]..CovidDeaths
--where location like '%africa%'
Group by location, Population
order by Percentpopulationinfected desc


--Countries with Hishest Death Count per Population


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project]..CovidDeaths
--where location like '%africa%'
Where continent is not null
Group by continent
order by TotalDeathCount desc 



--Continent with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project]..CovidDeaths
--where location like '%africa%'
Where continent is not null
Group by continent
order by TotalDeathCount desc 



--Global Numbers


Select SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/
SUM(new_cases)*100 as DeathPercentage
from [portfolio project]..CovidDeath
--where location like '%africa%'
where continent is not null
Group by date
order by 1,2

--Total population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccin
, SUM(CONVERT(int,vac.new_vaccinations))   OVER (Partition by dea.Location order by dea.location,dea.date) as
RollingpeopleVaccinations
from [portfolio project]..Covideaths dea
Join [portfolio project]..CovidVacination vac
     On dea.location = vac..location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

With PopvsVac (Continent,Location, Date, Population, New_Vacinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_cases
, SUM(CAST(vac.new_cases AS int)) OVER (Partition by dea.Location Order by dea.Date)
 as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/poppulation)*100
From [portfolio project]..CovidDeaths dea
Join [portfolio project]..CovidVacination vac
On dea.Location = vac.location
And dea.Date = vac.date
where dea.continent is not null
--order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

