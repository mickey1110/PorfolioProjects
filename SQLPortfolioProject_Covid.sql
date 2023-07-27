
--------------- Print no. of total deaths and total Cases of Continents -----------

select continent, Max(cast(total_cases as int)) As Highest_Cases, Max(cast(total_deaths as int)) as Total_Deaths from CovidDeaths
where continent is not null
--where location like '%income%'
group by continent
order by total_deaths DESC

-------SHOWING TOTAL CASES VS TOTAL DEATHS and DEATH % ----------
----------------- pRINT Likelihood of Dying if contract the COVID in your country.-----------

select location, date, total_cases, total_deaths,
(CAST(total_deaths as float) /  CAST(total_cases as float) *100) as Death_Percentage,population
from CovidDeaths
Where location like '%india%'
order by 1,2

-----------------------NOW Print # total cases VS Population---------------
select location, date, population, total_cases, 
(CAST(total_cases as float) /  CAST(population as int))*100 as Population_Per_Totalcases
from CovidDeaths
Where location like '%india%'
order by 1,2

---------------------- Countries with Highest Infection rate compared to Population--------

select location, population, Max(cast(total_cases as int)) as HighestInfectionRate, 
--Max(CAST(total_cases as float) /  CAST(population as int)) *100 as Population_Per_Totalcases
Max((total_cases / population)) *100 as Population_Per_Totalcases
from CovidDeaths
--Where location like 'india'
group by location, population
order by Population_Per_Totalcases DESC

---------------------- Countries with Highest Death Counts compared to Population--------

select location, population, Max(cast(total_deaths as int)) as HighestDeathCounts, 
--Max(CAST(total_cases as float) /  CAST(population as int)) *100 as Population_Per_Totalcases
Max((total_deaths/ population)) *100 as PopPerDC
from CovidDeaths
--Where location like 'india'
Where continent is not null
group by location, population
order by HighestDeathCounts DESC


select location, Max(cast(total_deaths as int)) as HighestDeathCounts
from CovidDeaths 
Where continent is not null
group by location
order by HighestDeathCounts DESC


--------------------Total Cases vs Total Deaths VS DC%
---                      // GLOBAL NUMBERS  //      -------

select date, SUM(new_cases) as ToTalCases, SUM(new_deaths) as TotalDeaths 
--, SUM(cast(new_deaths as int)) / SUM(new_cases) * 100 as TotalDeathPer
from CovidDeaths
where continent is not null
group by date
order by 1,2
	

select SUM(new_cases) as ToTalCases, SUM(new_deaths) as TotalDeaths 
, SUM(new_deaths) /SUM(NULLIF(new_cases,0)) * 100 as TotalDeathPer
from CovidDeaths
where continent is not null
--group by date
order by 1,2


-------------- // look for Total vaccinations and Populatiions

select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(bigint, cv.new_vaccinations)) over (Partition By cd.location ORDER BY cd.location, cd.Date) as RollingOverVaccinated
from CovidDeaths cd
JOIN CovidVaccinations cv
on cd.location=cv.location
and cd.date = cv.date
where cd.continent is not null
order by 2,3


------- // With CTE //-----------

WITH Pop_VS_Vacc --(Continent, Location, Date, Population, New_Vaccinations, RollingOverVaccinated)
AS
(select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(int, cv.new_vaccinations)) over (Partition By cd.location ORDER BY cd.location, cd.Date) as RollingOverVaccinated
from CovidDeaths cd
JOIN CovidVaccinations cv
on cd.location=cv.location
and cd.date = cv.date
where cd.continent is not null and cd.location like '%india%'
--order by 2,3
)
select Continent, Location, Date, Population, New_Vaccinations, RollingOverVaccinated, (RollingOverVaccinated/population)*100 As Total_VaccPopp
from Pop_VS_Vacc


------------- //  CREATE VIEW  // ------------
CREATE VIEW PercentPopVacc1
AS 
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(int, cv.new_vaccinations)) over (Partition By cd.location ORDER BY cd.location, cd.Date) as RollingOverVaccinated
from CovidDeaths cd
JOIN CovidVaccinations cv
on cd.location=cv.location
and cd.date = cv.date
where cd.continent is not null 
--and cd.location like '%india%'


select * from PercentPopVacc













































