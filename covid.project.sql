Select * 
from covidproject..CovidDeaths$
order by 3,4

Select * 
from covidproject..CovidVaccinations$
order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 1,2

--looking at total cases vs tootal deaths
--shows the likelihood of dying if you contract covid in Jordan
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from CovidDeaths$
where location like 'Jordan'
order by 1,2


--looking at total cases vs population
--shows the persentage of population that got covid
select location, date, total_cases, population, (total_cases/population)*100 as casespercentage
from CovidDeaths$
where location like 'Jordan'
order by 1,2


--looking at countries with highest infiction rate compared to population

select location, population, max(total_cases) as infictioncount, max((total_cases/population))*100 as infectionpercet
from CovidDeaths$
group by location, population
order by infectionpercet desc


--countries with highest death count per population
select location, MAX(CAST(total_deaths AS int)) as totaldeathcount
from CovidDeaths$
where continent is not null
group by location
order by totaldeathcount desc

--filtiring by continent 
select location, MAX(CAST(total_deaths AS int)) as totaldeathcount
from covidproject..CovidDeaths$
where continent is null
group by location
order by totaldeathcount desc

select continent, MAX(CAST(total_deaths AS int)) as totaldeathcount
from covidproject..CovidDeaths$
where continent is not null
group by continent
order by totaldeathcount desc


--Global Numbers
select date, sum(new_cases) as cases, sum(cast(new_deaths as int)) as deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from CovidDeaths$
where continent is not null
group by date
order by 1,2


select sum(new_cases) as cases, sum(cast(new_deaths as int)) as deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from CovidDeaths$
where continent is not null
order by 1,2


-- looking at population vs total vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingproplevacc
from CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
order by 2, 3


--Use A CTE
with popvsvac (continent, location, date, population, new_vaccinations, rollingproplevacc)
as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingproplevacc
from CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
)
select *, (rollingproplevacc/population)*100 as popvacpercentage
from popvsvac


--creating view to store data for visualization
create view popvsvac as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingproplevacc
from CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date =vac.date
where dea.continent is not null
)





