
USE [SRDBStagging]
GO


SELECT * FROM [dbo].[SRDBMonthly] WHERE [DOY_Frequency] > 8 
ORDER BY [StudyNumber], [Measure_Year], [Measure_Month], [Measure_DOY]


/**********************************************************************************************
Output data WITH TS information  -- 869 records
Assume the Bahn approach works in monthly time scale
Step 1: get TAIR_1 - TAIR 12 AND Rs1 - Rs12 for all those 869 rows (1-12 means Jan to Dec)
***********************************************************************************************/

/*
SELECT * INTO MGRsDBahn
FROM [dbo].[SRDBV4]
WHERE Latitude IS NOT NULL 
	AND Longitude IS NOT NULL 
	AND Study_midyear IS NOT NULL
	AND YearsOfData IS NOT NULL
	AND Rs_annual IS NOT NULL AND Rs_annual > 0
	AND Model_output_units IS NOT NULL
	AND Model_paramA IS NOT NULL
	AND Model_paramB IS NOT NULL
	AND Manipulation = 'None'
	AND Study_TS_Annual IS NOT NULL
ORDER BY Study_number



ALTER TABLE MGRsDBahn ADD TAIR1 NUMERIC(18,3), TAIR2 NUMERIC(18,3), TAIR3 NUMERIC(18,3),TAIR4 NUMERIC(18,3),TAIR5 NUMERIC(18,3),TAIR6 NUMERIC(18,3),
	TAIR7 NUMERIC(18,3),TAIR8 NUMERIC(18,3),TAIR9 NUMERIC(18,3),TAIR10 NUMERIC(18,3),TAIR11 NUMERIC(18,3),TAIR12 NUMERIC(18,3)

	,Rs1 NUMERIC (18,3),Rs2 NUMERIC (18,3),Rs3 NUMERIC (18,3),Rs4 NUMERIC (18,3),Rs5 NUMERIC (18,3),Rs6 NUMERIC (18,3)
	,Rs7 NUMERIC (18,3),Rs8 NUMERIC (18,3),Rs9 NUMERIC (18,3),Rs10 NUMERIC (18,3),Rs11 NUMERIC (18,3),Rs12 NUMERIC (18,3)

*/

SELECT * FROM MGRsDBahn 
WHERE TAnnual_Del IS NULL
-- WHERE TAIR1 IS NULL

/**********************************************************************************************
Step 2: update Rs1-12 and TAIR1-12
***********************************************************************************************/

/*
UPDATE MGRsDBahn SET MGRsDBahn.TAIR1 = T.Jan, MGRsDBahn.TAIR2 = T.Feb, MGRsDBahn.TAIR3 = T.Mar, MGRsDBahn.TAIR4 = T.Apr, MGRsDBahn.TAIR5 = T.May, MGRsDBahn.TAIR6 = T.Jun	
	, MGRsDBahn.TAIR7 = T.Jul, MGRsDBahn.TAIR8 = T.Aug, MGRsDBahn.TAIR9 = T.Sep, MGRsDBahn.TAIR10 = T.Oct, MGRsDBahn.TAIR11 = T.Nov, MGRsDBahn.TAIR12 = T.[Dec]	 
FROM MGRsDBahn AS M
INNER JOIN [DelClimateDB].[dbo].[Global_T] AS T
ON T.[Year] = M.[Year] AND T.Latitude = M.Lat_Round AND T.Longitude = M.Long_Round



--SELECT * FROM [SRDBDW].[dbo].[MSRDBALL]


UPDATE MGRsDBahn SET MGRsDBahn.Rs1 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 1

UPDATE MGRsDBahn SET MGRsDBahn.Rs2 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 2

UPDATE MGRsDBahn SET MGRsDBahn.Rs3 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 3

UPDATE MGRsDBahn SET MGRsDBahn.Rs4 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 4

UPDATE MGRsDBahn SET MGRsDBahn.Rs5 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 5

UPDATE MGRsDBahn SET MGRsDBahn.Rs6 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 6

UPDATE MGRsDBahn SET MGRsDBahn.Rs7 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 7

UPDATE MGRsDBahn SET MGRsDBahn.Rs8 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 8

UPDATE MGRsDBahn SET MGRsDBahn.Rs9 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 9

UPDATE MGRsDBahn SET MGRsDBahn.Rs10 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 10

UPDATE MGRsDBahn SET MGRsDBahn.Rs11 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 11

UPDATE MGRsDBahn SET MGRsDBahn.Rs12 = MG.Rs_Norm	 
FROM MGRsDBahn AS M
INNER JOIN [SRDBDW].[dbo].[MSRDBALL] AS MG
ON MG.[Measure_Year] = M.[Year] AND MG.Latitude = M.Lat_Round AND MG.Longitude = M.Long_Round AND MG.studynumber = M.Study_number AND MG.Measure_Month = 12
*/

/**********************************************************************************************
Step 3: update data for Bahn monthly analysis
***********************************************************************************************/

SELECT [Record_number]
      ,[Study_number]
      ,[Author]
      ,[Site_name]      
      ,[YearsOfData]
      ,[Latitude]
      ,[Longitude]
      ,[Elevation]
      ,[Manipulation]
      ,[Manipulation_level]
      ,[Age_ecosystem]
      ,[Age_disturbance]
      ,[Species]
      ,[Biome]
      ,[Ecosystem_type]
      ,[Ecosystem_state]      
      ,[MAT]
      ,[MAP]
      ,[PET]
      ,[Study_temp]
      ,[Study_precip]
      ,[Meas_method]
      ,[Meas_interval]
      ,[Annual_coverage]
      ,[Partition_method]
      ,[Rs_annual]
      ,[Rs_annual_err]      
      ,[Rs_wet]
      ,[Rs_dry]
      ,[RC_seasonal]
      ,[RC_season]
      ,[Model_type]
      ,[Temp_effect]
      ,[Model_output_units]
      ,[Model_temp_min]
      ,[Model_temp_max]
      ,[Model_N]
      ,[Model_R2]
      ,[T_depth]
      ,[Model_paramA]
      ,[Model_paramB]
      ,[Model_paramC]
      ,[Model_paramD]
      ,[Model_paramE]
      ,[WC_effect]
      ,[R10]      
      ,[Lat_Round]
      ,[Long_Round]
      ,[MAP_Del]
      ,[MAT_Del]
      ,[PAnnual_Del]
      ,[TAnnual_Del]
      ,[Year]
      ,[PRECIP_SD]
      ,[TAIR_SD]
      ,[SPI]
      ,[Study_TS_Annual]
      ,[TS_Flag]
      ,[Annual_TS_Coverage]
      ,[TS_Source]
      ,[TAIR1]
      ,[TAIR2]
      ,[TAIR3]
      ,[TAIR4]
      ,[TAIR5]
      ,[TAIR6]
      ,[TAIR7]
      ,[TAIR8]
      ,[TAIR9]
      ,[TAIR10]
      ,[TAIR11]
      ,[TAIR12]
      ,[Rs1]
      ,[Rs2]
      ,[Rs3]
      ,[Rs4]
      ,[Rs5]
      ,[Rs6]
      ,[Rs7]
      ,[Rs8]
      ,[Rs9]
      ,[Rs10]
      ,[Rs11]
      ,[Rs12]
  FROM [SRDBStagging].[dbo].[MGRsDBahn]

