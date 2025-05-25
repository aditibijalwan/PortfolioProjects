--Select Location, date , total_cases 
--from COVID..Deaths
--order by 1, 2


--DEATH PERCENTAGE INDIA
--Select Location, date,  total_cases , total_deaths ,
--     (total_deaths * 100.0 / total_cases) AS percentage_deaths
--From COVID..Deaths
--Where Location like '%India%'
--order by 1, 2



--DEATH PERCENTAGE
--Select Location, date, population , total_cases , total_deaths ,
--     (total_cases * 100.0 / population) AS percentage_deaths
--From COVID..Deaths

--order by 1, 2


--SELECT Location ,
--Population, MAX(total_cases) as highest_infection_count --This returns the maximum number of total cases recorded in each group (i.e., the peak total cases reported for that location).
--,max(total_deaths)*100.0/ population as Deathpercentage --If total_deaths is always increasing (which it usually is), the max value will always be the last value anyway.
--from COVID..Deaths 
--GROUP BY    Location , Population
--order by 1 , 2 

--County with the hightest infection count

--Select Location , population , max(total_cases) , max (total_cases)*100.0/population as population_affected
--from COVID..Deaths 
--GROUP BY location , population 
--order by population_affected desc



--highest death count

--Select Location , population , max(total_deaths) as total_deceased
--from COVID..Deaths 
--Group by location ,population
--order by total_deceased desc


--Death count by continent 

--Select continent , max(total_cases) as death_count
--from COVID..Deaths
--group by continent
--order by death_count desc


--Global numbers

--Select date , SUM(new_cases) 
--from COVID..Deaths
--group by date
--order by date

--Joining the tables 

--Select *
--from COVID..Deaths  as d
--Join COVID..Vaccinations  as v
--On d.location= v.location
--and d.date = v.date

--Total population VS Vaccinations

--Select d.population  ,
--SUM(CAST(v.new_vaccinations AS bigint)) AS total_vaccination,
--d.Location
--from COVID.dbo.Deaths as d
--join COVID.dbo.Vaccinations as v 
--ON d.Location = v.location
--group by d.Location , d.population
--order by d.population desc


--Select
--d.location ,
--d.population ,
--MAX(CAST(v.people_fully_vaccinated as BIGINT)) as FULL_Vaccination,
--SUM(CAST(v.new_deaths as BIGINT)) as Total_death
--from COVID..Deaths AS d 
--JOIN COVID.dbo.Vaccinations as v 
--On d.location = v.location 
--group by d.location , d.population
--Order by d.population desc


--Total population VS vaccination

--Select d.continent, d.Location , d.population , d.date , v.new_vaccinations ,
--Sum(CAST(v.new_vaccinations as BIGINT)) Over (Partition by d.location order by d.date ) as rolling_vaccination
--From COVID..Deaths as d 
--JOIN COVID..Vaccinations as v 
--ON d.location = v.location
--and d.date = v.date

--order by d.location , d.date 


----Using CTE
--WITH pop_VS_Vac as

--(
--Select d.continent, d.Location , d.population , d.date , v.new_vaccinations ,
--Sum(CONVERT(bigint , v.new_vaccinations))
--OVER (Partition by d.location
--      Order by d.date )  as Rolling

--From COVID..Deaths as d 
--JOIN COVID..Vaccinations as v 
--ON d.location = v.location
--and d.date = v.date

----order by 
--)
--Select *
--from pop_VS_Vac


--CREATE TEMP TABLE
drop table if exists percentagePopulationVaccinated
Create Table percentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime ,
Population numeric ,
New_Vaccinations numeric ,
RollingPeopleVaccinated numeric )
                      
 Insert INTO percentagePopulationVaccinated

Select d.continent, d.Location    , d.date , d.population , v.new_vaccinations ,
Sum(CONVERT(int , v.new_vaccinations))
OVER (Partition by d.location 
      Order by d.date )  as RollingPeopleVaccinated

From COVID..Deaths as d 
JOIN COVID..Vaccinations as v 
ON d.location = v.location
and d.date = v.date

select * , (RollingPeopleVaccinated * 100.0 / Population) as percentage
from percentagePopulationVaccinated 

--CREATING VIEW to store for later data visualization

CREATE VIEW 
PercentagePopulationVaccinatedView as 

Select d.continent, d.Location , d.population , d.date , v.new_vaccinations ,
Sum(CONVERT(bigint , v.new_vaccinations))
OVER (Partition by d.location
      Order by d.date )  as Rolling

From COVID..Deaths as d 
JOIN COVID..Vaccinations as v 
ON d.location = v.location
and d.date = v.date



SELECT name 
FROM sys.views;
