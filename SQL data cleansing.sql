SELECT *
FROM [Premier league fantasy]..[FPL_Schedule2324]

SELECT *
FROM [Premier league fantasy]..[cleaned_players]



--Standerdize Date Format

SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Merged_gw'

SELECT Kickoff_time, CONVERT(datetime, Kickoff_time)
FROM [Premier league fantasy]..[merged_gw]

UPDATE [merged_gw]
SET kickoff_time = CONVERT(Datetime, Kickoff_time)



--Seperate name into first and second name

SELECT
SUBSTRING(Name, 1, CHARINDEX(' ', Name) - 1) AS 'First Name'
, SUBSTRING(Name, CHARINDEX(' ', Name) + 1 , LEN(NAME)) AS 'Second Name'
FROM [Premier league fantasy]..[cleaned_players]

ALTER TABLE [Premier league fantasy]..cleaned_players
ADD First_Name Nvarchar(255);

UPDATE [Premier league fantasy]..cleaned_players
SET First_Name = SUBSTRING(Name, 1, CHARINDEX(' ', Name) - 1)

ALTER TABLE [Premier league fantasy]..cleaned_players
ADD Second_Name Nvarchar(255);

UPDATE [Premier league fantasy]..cleaned_players
SET Second_Name = SUBSTRING(Name, CHARINDEX(' ', Name) + 1 , LEN(NAME))



--Convert shortened positions to positions and rename column

SELECT DISTINCT(element_type)
FROM [Premier league fantasy]..[cleaned_players]

SELECT element_type
, CASE WHEN element_type = 'FWD' THEN 'Forward'
		WHEN element_type = 'DEF' THEN 'Defender'
		WHEN element_type = 'MID' THEN 'Midfielder'
		ELSE 'GoalKeeper'
		END
FROM [Premier league fantasy]..[cleaned_players]

UPDATE [cleaned_players]
SET element_type = CASE WHEN element_type = 'FWD' THEN 'Forward'
		WHEN element_type = 'DEF' THEN 'Defender'
		WHEN element_type = 'MID' THEN 'Midfielder'
		ELSE 'GoalKeeper'
		END

EXEC sp_rename 'cleaned_players.element_type' , 'Position' , 'COLUMN';

SELECT element_type
FROM [Premier league fantasy]..[cleaned_players]



--Check and remove duplicates

WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY NAME, minutes 
							ORDER BY NAME) row_num
FROM [Premier league fantasy]..[cleaned_players]
)

DELETE
FROM RowNumCTE
WHERE row_num > 1



--Delete unused columns

SELECT *
FROM [Premier league fantasy]..[cleaned_players]

ALTER TABLE [Premier league fantasy]..[cleaned_players]
DROP COLUMN first_name, second_name


