Select *
From [PORTFOLIO PROJECT].dbo.[covid deaths]
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From [PORTFOLIO PROJECT].dbo.[covid deaths]
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths in India

Select Location, date, total_cases,total_deaths, cast(total_deaths as numeric)/cast(total_cases as numeric)*100 as DeathPercentage
From [PORTFOLIO PROJECT].dbo.[covid deaths]
Where location like '%India%'
and continent is not null 
order by 1,2


-- Total Cases vs Population in India

Select Location, date, Population, total_cases,  (total_cases /population)*100 as PercentPopulationInfected
From [PORTFOLIO PROJECT].dbo.[covid deaths]
Where location like '%India%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [PORTFOLIO PROJECT].dbo.[covid deaths]
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
From [PORTFOLIO PROJECT].dbo.[covid deaths]
Where continent is not null 
Group by Location
order by TotalDeathCount desc


-- Showing contintents with the highest death count per population

Select continent, MAX(Total_deaths) as TotalDeathCount
From [PORTFOLIO PROJECT].dbo.[covid deaths]
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From [PORTFOLIO PROJECT].dbo.[covid deaths]
Where continent is not null
order by 1,2


-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as numeric))OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
From [PORTFOLIO PROJECT].dbo.[covid deaths] dea
Join [PORTFOLIO PROJECT].dbo.[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3




-- Using CTE to perform Calculation on Partition By in previous query


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as numeric)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
From [PORTFOLIO PROJECT].dbo.[covid deaths] dea
Join [PORTFOLIO PROJECT].dbo.[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (PeopleVaccinated/Population)*100 as totalvaccinationstaken
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as numeric)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [PORTFOLIO PROJECT].dbo.[covid deaths] dea
Join [PORTFOLIO PROJECT].dbo.[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *, (PeopleVaccinated/Population)*100 as totalvaccinationstaken
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

Create View Vaccinatedpeople as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as numeric)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rollingPeopleVaccinated

From [PORTFOLIO PROJECT].dbo.[covid deaths] dea
Join [PORTFOLIO PROJECT].dbo.[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null



select* from Vaccinatedpeople;





