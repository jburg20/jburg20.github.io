
-- Which Location has genertaed the most revenue

SELECT CityName, SUM(Revenue) AS 'Sum of Revenue'
FROM [ZL Telecom]..SalesInfo
Inner join [ZL Telecom]..Dateinfo
	ON DateStamp = Date
Inner join [ZL Telecom]..LocationInfo
	ON SalesInfo.LocationID = LocationInfo.LocationID
GROUP BY CityName
ORDER BY 2 DESC



-- Which Location generated the most revenue in the last quarter

SELECT CityName, [FY-Qtr] , SUM(Revenue) AS 'Sum of Revenue'
FROM [ZL Telecom]..SalesInfo
Inner join [ZL Telecom]..Dateinfo
	ON DateStamp = Date
Inner join [ZL Telecom]..LocationInfo
	ON SalesInfo.LocationID = LocationInfo.LocationID
WHERE [FY-Qtr] = '2020 Q4'
GROUP BY CityName, [FY-Qtr]
ORDER BY 3 DESC



-- I' now going to categorise the Sales people to show if they have made enough sales in the last quarter. 
--Let's say there target sales revenue is £5000, and if they surpass this they are doing well.

SELECT SalespersonID, [FY-Qtr] , SUM(Revenue) AS 'Sum of Revenue',
CASE
	WHEN SUM(Revenue) > 5000 THEN 'Doing well'
	ELSE 'Not doing well'
END AS 'Performance'
FROM [ZL Telecom]..SalesInfo
Inner join [ZL Telecom]..Dateinfo
	ON DateStamp = Date
Inner join [ZL Telecom]..LocationInfo
	ON SalesInfo.LocationID = LocationInfo.LocationID
WHERE [FY-Qtr] = '2020 Q4'
GROUP BY SalespersonID, [FY-Qtr]
ORDER BY 3 DESC



-- I'm now going to show which customers' job title make the most revenue for ZL Telecom

SELECT Job, Count(Job) AS 'Count of Job', AVG(Revenue) AS 'AVG Revenue'
FROM [ZL Telecom]..SalesInfo
GROUP BY Job
Order BY 3 DESC



-- Let's see how many of ZL Telecom's customers are male and female

SELECT CustomerID, Revenue, Sex
, Count(Sex) OVER (PARTITION BY Sex) as TotalGender
FROM [ZL Telecom]..SalesInfo
ORDER BY 2 DESC



-- Let's see the average revenue per customer 

SELECT CustomerID, Revenue, (SELECT AVG(Revenue) From [ZL Telecom]..SalesInfo) as AvgRevenue
From [ZL Telecom]..SalesInfo
ORDER BY 2



--Let's create a view from one of the queries above about customers' job titles

CREATE VIEW RevenueByJob AS
SELECT Job, SUM(Revenue) AS 'SumRevenue', AVG(Revenue) AS 'AvgRevenue'
FROM [ZL Telecom]..SalesInfo
GROUP BY Job

SELECT * 
FROM RevenueByJob
