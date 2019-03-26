
USE [SRDBStagging]
GO


/**********************************************************************************************
STEP 1. Get study number, and find data from MGRsD
***********************************************************************************************/
SELECT Distinct Study_number FROM [SRDBStagging].[dbo].[SRDBV4]
WHERE Latitude IS NOT NULL 
	AND Longitude IS NOT NULL 
	AND Study_midyear IS NOT NULL
	AND YearsOfData IS NOT NULL
	AND Rs_annual IS NOT NULL AND Rs_annual > 0
	AND Model_output_units IS NOT NULL
	AND Model_paramA IS NOT NULL
	AND Model_paramB IS NOT NULL
	AND Manipulation = 'None'
ORDER BY Study_number

-- 168 studies have both MGRsD and SRDB data
WITH cte AS (
    SELECT Distinct Study_number FROM [SRDBStagging].[dbo].[SRDBV4]
	WHERE Latitude IS NOT NULL 
	AND Longitude IS NOT NULL 
	AND Study_midyear IS NOT NULL
	AND YearsOfData IS NOT NULL
	AND Rs_annual IS NOT NULL AND Rs_annual > 0
	AND Model_output_units IS NOT NULL
	AND Model_paramA IS NOT NULL
	AND Model_paramB IS NOT NULL
	AND Manipulation = 'None'
)
SELECT DISTINCT [dbo].[SRDBMonthly] .StudyNumber FROM [dbo].[SRDBMonthly] 
INNER JOIN cte ON cte.Study_number = [dbo].[SRDBMonthly] .StudyNumber
ORDER BY [dbo].[SRDBMonthly] .StudyNumber


-- 101 studies have SRDB data but not in MGRsD data
WITH cte AS (
    SELECT Distinct Study_number FROM [SRDBStagging].[dbo].[SRDBV4]
	WHERE Latitude IS NOT NULL 
	AND Longitude IS NOT NULL 
	AND Study_midyear IS NOT NULL
	AND YearsOfData IS NOT NULL
	AND Rs_annual IS NOT NULL AND Rs_annual > 0
	AND Model_output_units IS NOT NULL
	AND Model_paramA IS NOT NULL
	AND Model_paramB IS NOT NULL
	AND Manipulation = 'None'
)
SELECT DISTINCT cte.Study_number FROM [dbo].[SRDBMonthly] 
Right JOIN cte ON cte.Study_number = [dbo].[SRDBMonthly].StudyNumber
WHERE [dbo].[SRDBMonthly].StudyNumber IS NULL
ORDER BY cte.Study_number


-- Output data for all 168 studies have both MGRsD and SRDB data
WITH cte AS (
    SELECT Distinct Study_number FROM [SRDBStagging].[dbo].[SRDBV4]
	WHERE Latitude IS NOT NULL 
	AND Longitude IS NOT NULL 
	AND Study_midyear IS NOT NULL
	AND YearsOfData IS NOT NULL
	AND Rs_annual IS NOT NULL AND Rs_annual > 0
	AND Model_output_units IS NOT NULL
	AND Model_paramA IS NOT NULL
	AND Model_paramB IS NOT NULL
	AND Manipulation = 'None'
)
SELECT * INTO SRDBMGRsD
FROM [dbo].[SRDBMonthly] 
INNER JOIN cte ON cte.Study_number = [dbo].[SRDBMonthly] .StudyNumber
ORDER BY [dbo].[SRDBMonthly] .StudyNumber


SELECT * FROM [dbo].[SRDBMGRsD]
UPDATE [dbo].[SRDBMGRsD] SET Latitude = Lat_Adj2, Longitude = Long_Adj2

SELECT * FROM [dbo].[SRDBMGRsD] WHERE [Tsoil] IS NULL

--EXEC sp_RENAME '[SRDBMGRsD].[Tsoil]' , 'TSoil', 'COLUMN'

SELECT Study_number, COUNT (Study_number) AS [DOY_Frequency_Notes] INTO #Day_Freq
	FROM [dbo].[SRDBMGRsD] GROUP BY Study_number ORDER BY Study_number


WITH CET AS (SELECT Study_number, [Measure_Month] 
	FROM [dbo].[SRDBMGRsD] GROUP BY Study_number, [Measure_Month] )
SELECT Study_number, COUNT([Measure_Month]) AS Month_Frequency INTO #Month_Freq FROM CET GROUP BY Study_number ORDER BY Study_number

SELECT * FROM #Day_Freq ORDER BY Study_number

SELECT * FROM #Month_Freq ORDER BY Study_number

ALTER TABLE [SRDBMGRsD] ADD Month_Frequency NUMERIC(18,3)

UPDATE [SRDBMGRsD] SET [SRDBMGRsD].DOY_Frequency = D.[DOY_Frequency_Notes], [SRDBMGRsD].Month_Frequency = M.Month_Frequency
FROM [SRDBMGRsD] AS RS
INNER JOIN #Day_Freq AS D
ON RS.Study_number = D.Study_number
INNER JOIN #Month_Freq AS M
ON RS.Study_number = M.Study_number


SELECT * FROM [dbo].[SRDBMGRsD] ORDER BY Month_Frequency

-- Check out studies cover less than 6 month
SELECT DISTINCT Study_number FROM [dbo].[SRDBMGRsD] WHERE Month_Frequency < 12 ORDER BY Study_number

SELECT DISTINCT Study_number FROM [dbo].[SRDBMGRsD] WHERE Month_Frequency > 10 AND TSOIL >-999 ORDER BY Study_number

/**********************************************************************************************
STEP 2. Get studies have TSoil measurements for at least 12 month, and get TSoil_Annual value
***********************************************************************************************/

WITH CET AS (SELECT * FROM [dbo].[SRDBMGRsD] WHERE Month_Frequency = 12 AND TSOIL >-999)
SELECT Study_number, [Measure_Month], AVG ([TSoil]) AS TSoil INTO #MGRsDTSoil_12Month
FROM CET GROUP BY Study_number, [Measure_Month]
ORDER BY Study_number, [Measure_Month]

SELECT Study_number, AVG(TSoil) AS Study_TS_Annual INTO MGRsD_TSoil_12Month FROM #MGRsDTSoil_12Month GROUP BY Study_number ORDER BY Study_number

SELECT * FROM MGRsD_TSoil_12Month ORDER BY Study_number


/**********************************************************************************************
STEP 3. Update Study_TSoil_Annual information for SRDB_V4
***********************************************************************************************/
-- ADD column Study_TS_Annual FOR [dbo].[SRDBV4]
SELECT * FROM [dbo].[SRDBV4]

ALTER TABLE [dbo].[SRDBV4] ADD Study_TS_Annual NUMERIC (18,3)

UPDATE [dbo].[SRDBV4] SET [dbo].[SRDBV4].Study_TS_Annual = TS.Study_TS_Annual
FROM [dbo].[SRDBV4] AS SRDB
INNER JOIN MGRsD_TSoil_12Month AS TS
ON SRDB.Study_number = TS.Study_number



/**********************************************************************************************
Step 4. Check extreme values
# due to multiple sites issue
***********************************************************************************************/

-- 5766
-- Elevation affects TSoil
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual
	From SRDBV4 WHERE Study_number = 5766

UPDATE [SRDBV4] SET Study_TS_Annual = 10.50 WHERE [study_number] = 5766 AND Record_Number = 4318
UPDATE [SRDBV4] SET Study_TS_Annual = 17.52 WHERE [study_number] = 5766 AND Record_Number = 4319
UPDATE [SRDBV4] SET Study_TS_Annual = 20.03 WHERE [study_number] = 5766 AND Record_Number = 4320
UPDATE [SRDBV4] SET Study_TS_Annual = 23.46 WHERE [study_number] = 5766 AND Record_Number = 4321


-- 3429
-- Looks fine
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual
	From SRDBV4 WHERE Study_number = 3429

-- 3801
-- According to Table 3, Rs_Annual unit in paper is g co2/m2/yr
-- Rs_Annual unit in SRDB is g c/m2/yr
-- Rs_Annual change to Rs_Annual(original)*12/44
-- Model_paramA, B change to 39.449, 0.0414 (record number = 3080)
-- Model_paramA, B change to 4.3737, 0.1018 (record number = 3081)
-- Model_paramA, B change to 11.301, 0.073 (record number = 3082)
-- Model_paramA, B change to 16.734, 0.0632 (record number = 3083)
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual
	From SRDBV4 WHERE Study_number = 3801

UPDATE [SRDBV4] SET Model_paramA = 39.449 , Model_paramB = 0.0414 WHERE [study_number] = 3801 AND Record_Number = 3080
UPDATE [SRDBV4] SET Model_paramA = 4.3737 , Model_paramB = 0.1018 WHERE [study_number] = 3801 AND Record_Number = 3081
UPDATE [SRDBV4] SET Model_paramA = 11.301 , Model_paramB = 0.073 WHERE [study_number] = 3801 AND Record_Number = 3082
UPDATE [SRDBV4] SET Model_paramA = 16.734 , Model_paramB = 0.0632 WHERE [study_number] = 3801 AND Record_Number = 3083

UPDATE [SRDBV4] SET Rs_annual = Rs_annual * 12/44 WHERE [study_number] = 3801

-- 5178
-- According to Figure 3 caption, model is based on data two years after haverst
-- Model_paramA, B change to NULL for Record_Number = 3437, 3439, 3440, and 3441
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual
	From SRDBV4 WHERE Study_number = 5178
UPDATE [SRDBV4] SET Study_TS_Annual = 22.2, Model_paramA = NULL, Model_paramB = NULL WHERE [study_number] = 5178 AND Record_Number = 3437
UPDATE [SRDBV4] SET Study_TS_Annual = 21.5 WHERE [study_number] = 5178 AND Record_Number = 3438
UPDATE [SRDBV4] SET Study_TS_Annual = 20.5, Model_paramA = NULL, Model_paramB = NULL WHERE [study_number] = 5178 AND Record_Number = 3439
UPDATE [SRDBV4] SET Study_TS_Annual = 20.2, Model_paramA = NULL, Model_paramB = NULL WHERE [study_number] = 5178 AND Record_Number = 3440
UPDATE [SRDBV4] SET Study_TS_Annual = 20.7, Model_paramA = NULL, Model_paramB = NULL WHERE [study_number] = 5178 AND Record_Number = 3441

--# Study 6372
--# According to Table 4, Model_paramB = 0.07231 for record_number = 4901
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual
	From SRDBV4 WHERE Study_number = 6372
UPDATE [SRDBV4] SET Model_paramB = 0.07231 WHERE [study_number] = 6372 AND Record_Number = 4901


--# Study 2534
--# 
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Model_temp_min, Model_temp_max
	From SRDBV4 WHERE Study_number = 2534
UPDATE [SRDBV4] SET Model_temp_min = 2 WHERE [study_number] = 2534

--# Study 4934
--# 
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Model_temp_min, Model_temp_max
	From SRDBV4 WHERE Study_number = 4934
UPDATE [SRDBV4] SET Study_TS_Annual = 25.45 WHERE [study_number] = 4934 AND Model_temp_max = 27
UPDATE [SRDBV4] SET Study_TS_Annual = 18.09 WHERE [study_number] = 4934 AND Model_temp_max = 21


--# Study 5326
--# Different site should have different TS
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Model_temp_min, Model_temp_max
	From SRDBV4 WHERE Study_number = 5326
UPDATE [SRDBV4] SET Study_TS_Annual = 1.08 WHERE [study_number] = 5326 AND Record_Number = 3864
UPDATE [SRDBV4] SET Study_TS_Annual = 5.52 WHERE [study_number] = 5326 AND Record_Number = 3865
UPDATE [SRDBV4] SET Study_TS_Annual = 21.03 WHERE [study_number] = 5326 AND Record_Number = 3866
UPDATE [SRDBV4] SET Study_TS_Annual = 19.37 WHERE [study_number] = 5326 AND Record_Number = 3867

--# Study 1292
--# According to Fig 4, Model_output_units = 'mg C/m2/hr'
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Model_temp_min, Model_temp_max, Model_output_units
	From SRDBV4 WHERE Study_number = 1292
UPDATE [SRDBV4] SET Model_output_units = 'mg C/m2/hr' WHERE [study_number] = 1292

--# Study 1891
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Model_temp_min, TAnnual_Del, Model_output_units
	From SRDBV4 WHERE Study_number = 1891
UPDATE [SRDBV4] SET Study_TS_Annual =  (Study_TS_Annual + TAnnual_Del)/2 WHERE Study_number = 1891


--# Study 2349
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Model_temp_min, TAnnual_Del, Study_temp
	From SRDBV4 WHERE Study_number = 2349
UPDATE [SRDBV4] SET Study_TS_Annual =  3.81 WHERE Study_number = 2349 AND Site_name = 'Lavigne-cool'
UPDATE [SRDBV4] SET Study_TS_Annual =  4.38 WHERE Study_number = 2349 AND Site_name = 'Lavigne-midtransect'
UPDATE [SRDBV4] SET Study_TS_Annual =  5.19 WHERE Study_number = 2349 AND Site_name = 'Lavigne-warm'
UPDATE [SRDBV4] SET Study_TS_Annual =  (Study_TS_Annual + TAnnual_Del)/2 WHERE Study_number = 2349

--# Study 2534
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Study_temp, TAnnual_Del, Model_output_units
	From SRDBV4 WHERE Study_number = 2534
UPDATE [SRDBV4] SET Study_TS_Annual =  (Study_TS_Annual + TAnnual_Del + 2.54 + 3.3)/2 WHERE Study_number = 2534
SELECT AVG(TAnnual_Del) FROM SRDBV4 WHERE Study_number = 2534 GROUP BY Study_number -- -3.3

--# Study 2656
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Study_temp, TAnnual_Del, Model_output_units, Latitude, Longitude
	From SRDBV4 WHERE Study_number = 2656
UPDATE [SRDBV4] SET Study_TS_Annual =  16.14 WHERE Study_number = 2656 AND Site_name = 'POPFACE'
UPDATE [SRDBV4] SET Study_TS_Annual =  20.6 WHERE Study_number = 2656 AND Site_name = 'Oak Ridge'
UPDATE [SRDBV4] SET Study_TS_Annual =  NULL WHERE Study_number = 2656 AND Site_name = 'FACTS-II'
UPDATE [SRDBV4] SET Study_TS_Annual =  (Study_TS_Annual + TAnnual_Del)/2 WHERE Study_number = 2656 AND Site_name != 'FACTS-II'


--# Study 3302
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Study_temp, TAnnual_Del, Model_output_units, Latitude, Longitude
	From SRDBV4 WHERE Study_number = 3302
SELECT AVG(TAnnual_Del) FROM SRDBV4 WHERE Study_number = 3302 GROUP BY Study_number -- 7.22
UPDATE [SRDBV4] SET Study_TS_Annual =  (Study_TS_Annual + TAnnual_Del+1)/2 WHERE Study_number = 3302

--# Study 3429
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Study_temp, TAnnual_Del, Model_output_units, Latitude, Longitude
	From SRDBV4 WHERE Study_number = 3429
SELECT AVG(TAnnual_Del) FROM SRDBV4 WHERE Study_number = 3429 GROUP BY Study_number -- 8.26
UPDATE [SRDBV4] SET Study_TS_Annual =  (Study_TS_Annual + TAnnual_Del+1.4)/2 WHERE Study_number = 3429


--# Study 3700
-- According to Fig 2 and FIg 3
-- Rs_annual = 590 when Record_number = 2444
-- Rs_annual = 1075 when Record_number = 2446
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Study_temp, TAnnual_Del, Model_output_units, Latitude, Longitude
	From SRDBV4 WHERE Study_number = 3700
UPDATE [SRDBV4] SET Rs_annual = 590 WHERE Study_number = 3700 AND Record_number = 2444
UPDATE [SRDBV4] SET Rs_annual = 1075 WHERE Study_number = 3700 AND Record_number = 2446


--# Study 5227
-- The model reported in the paper is not correct, but I cannot figure it out what is the problem
-- The model is: 2.49*exp(log(3.89 * (T-10)/10)), then when T < 10 there are no rs can be calculated
-- Use the digitized data, I re-simulated the exponential model
-- Model_type = 'Exponential, R=a exp(b(T-c))', Model_paramA = 0.573, Model_paramB = 0.0924, Model_paramC = 0
-- Longitude Wrong? I search 'Tenerife canary islands' in google, the location is 28.2916° , and -16.6291° 
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual
	, Record_Number, Study_TS_Annual, Study_temp, TAnnual_Del, Model_output_units, Latitude, Longitude
	From SRDBV4 WHERE Study_number = 5227
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a exp(b(T-c))', Model_paramA = 0.573, Model_paramB = 0.0924, Model_paramC = 0 WHERE [study_number] = 5227


--# Study number 6272
--# Table 3 and 4, the unit in Figure 4 should be wrong
--# Unit change to "umol CO2/m2/s" (Already reported)
--# Rs_annual
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number From SRDBV4 WHERE Study_number = 6272
UPDATE [SRDBV4] SET Model_output_units = 'umol CO2/m2/s' WHERE [study_number] = 6272

UPDATE [SRDBV4] SET Rs_annual = 961 WHERE [study_number] = 6272 AND Record_number = 4794
UPDATE [SRDBV4] SET Rs_annual = 833 WHERE [study_number] = 6272 AND Record_number = 4797

UPDATE [SRDBV4] SET Rs_annual = 1166 WHERE [study_number] = 6272 AND Record_number = 4796
UPDATE [SRDBV4] SET Rs_annual = 1158 WHERE [study_number] = 6272 AND Record_number = 4799

--# Study number 6451
--# Different site different ST
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude From SRDBV4 WHERE Study_number = 6451
UPDATE [SRDBV4] SET Study_TS_Annual = 8.6461 WHERE Study_number = 6451 AND Latitude = 47.26666667
UPDATE [SRDBV4] SET Study_TS_Annual = 5.388 WHERE Study_number = 6451 AND Latitude = 46.71666667
UPDATE [SRDBV4] SET Study_TS_Annual = 7.861 WHERE Study_number = 6451 AND Latitude = 47.16666667


/**********************************************************************************************
Step 5: Annual coverage check
1078, 1292,1647,1871,1987,2372,2534,5278,5522,5701,6372,6381,6451 Annual_coverage should be 1
***********************************************************************************************/
SELECT DISTINCT Study_number, Annual_coverage FROM [dbo].[SRDBV4]
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
	AND Annual_coverage != 1
ORDER BY Study_number

SELECT Study_number, Annual_coverage FROM [dbo].[SRDBV4] WHERE Study_number = 1078 OR Study_number = 1292 OR Study_number = 1647
	OR Study_number = 1871 OR Study_number = 1987 OR Study_number = 2372 OR Study_number = 2534 OR Study_number = 5278
	OR Study_number = 5522 OR Study_number = 5701 OR Study_number = 6372 OR Study_number = 6381 OR Study_number = 6451


--3 Add studies for Rs_annual > 3000 (6140, 8542, 8569)
SELECT DISTINCT Study_number FROM [SRDBStagging].[dbo].[SRDBV4]
WHERE Latitude IS NOT NULL 
	AND Longitude IS NOT NULL 
	AND Study_midyear IS NOT NULL
	AND YearsOfData IS NOT NULL
	AND Rs_annual IS NOT NULL AND Rs_annual > 0
	AND Model_output_units IS NOT NULL
	AND Model_paramA IS NOT NULL
	AND Model_paramB IS NOT NULL
	AND Manipulation = 'None'
	AND Rs_annual > 3000
ORDER BY Study_number


SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Model_type
	From SRDBV4 WHERE Study_number = 6140
--UPDATE [SRDBV4] SET Study_TS_Annual =  (14.8) WHERE Study_number = 6140
UPDATE [SRDBV4] SET Study_TS_Annual =  (6.27+8.19+10.77+13.69+16.43+19.76+23.1+26+29+32+35+37)/12 WHERE Study_number = 6140


SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Model_type
	From SRDBV4 WHERE Study_number = 8542
--UPDATE [SRDBV4] SET Study_TS_Annual =  (7.42+9.32+10.906+13.878+17.886+20.944+22.449+23.737+19.455+13.662+12.273+8.509)/12 WHERE Study_number = 8542
UPDATE [SRDBV4] SET Study_TS_Annual =  (12.696+13.805+15.07+16.28+17.448+18.77+19.93+20.77+21.94+22.78+23.63+24.37)/12 WHERE Study_number = 8542 

-- Study 8569
-- Rs_Annual reported in unit of g CO2/m2/yr, should *12/44
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Model_type
	From SRDBV4 WHERE Study_number = 8569
UPDATE [SRDBV4] SET Study_TS_Annual =  11.45 WHERE Study_number = 8569
UPDATE [SRDBV4] SET Rs_Annual =  Rs_Annual*12/44 WHERE Study_number = 8569


-- Study 5725
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Model_type
	From SRDBV4 WHERE Study_number = 5725 AND Record_number = 4294 OR Record_number = 4295 OR Record_number = 4298

UPDATE [SRDBV4] SET Model_paramA = -0.1226, Model_paramB = 0.054, Model_paramC = -0.0014  WHERE Study_number = 5725


/**********************************************************************************************
Output data WITH TS information  -- 869 records
***********************************************************************************************/
SELECT * FROM [dbo].[SRDBV4]
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

--SELECT Model_type FROM SRDBV4

-- MGRsD, MGRsD + TAIR, Rs_Ts_Relationship
SELECT * FROM [dbo].[SRDBV4]
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
	AND TS_Source like 'MGRsD'


/*
SELECT * FROM [SRDBStagging].[dbo].[SRDBV4]
WHERE Latitude IS NOT NULL 
	AND Longitude IS NOT NULL 
	AND Study_midyear IS NOT NULL
	AND YearsOfData IS NOT NULL
	AND Rs_annual IS NOT NULL AND Rs_annual > 0
	AND Model_output_units IS NOT NULL
	AND Model_paramA IS NOT NULL
	AND Model_paramB IS NOT NULL
	AND Manipulation = 'None'
ORDER BY Study_number
*/

SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Model_type
	From SRDBV4 WHERE Study_number = 5458