
USE [SRDBStagging]
GO

SELECT DISTINCT TS_Source FROM SRDBV4 WHERE Study_TS_Annual IS NOT NULL Order By TS_Source
UPDATE SRDBV4 SET TS_Source = 'Figure 1 and TAIR_Del' WHERE TS_Source = 'Figure 1 and Modeling'  
UPDATE SRDBV4 SET TS_Source = 'Figure 2 and TAIR_Del' WHERE TS_Source = 'Figure 2 and TATS'

SELECT DISTINCT TS_Flag FROM SRDBV4 WHERE Study_TS_Annual IS NOT NULL

SELECT * FROM SRDBV4 
WHERE Study_TS_Annual IS NOT NULL AND TS_Source IS NULL AND TS_Flag IS NULL

UPDATE SRDBV4 SET TS_Source = 'MGRsD' WHERE Study_TS_Annual IS NOT NULL AND TS_Source IS NULL AND TS_Flag IS NULL

SELECT DISTINCT * FROM SRDBV4 WHERE Study_TS_Annual IS NOT NULL AND TS_Source IS NULL

UPDATE SRDBV4 SET TS_Source = 'MGRsD' WHERE Study_TS_Annual IS NOT NULL AND TS_Source IS NULL AND TS_Flag = 'TAIR_0'

UPDATE SRDBV4 SET TS_Source = 'MGRsD and TAIR_Del' WHERE Study_TS_Annual IS NOT NULL AND TS_Source IS NULL

--SELECT DISTINCT * FROM SRDBV4 WHERE TS_Source IS NULL

/**********************************************************************************************
To do 1. -- 115 studies out of 269
-- Potential problem: 1500
***********************************************************************************************/
-- ,,,,,, , TS details not available

-- 390
UPDATE SRDBV4 SET Model_Type = 'Model has SWC component'  WHERE Study_number = 390
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 390

-- 408
UPDATE SRDBV4 SET Study_TS_Annual = 14.28, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 408
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 408

-- 680
UPDATE SRDBV4 SET Study_TS_Annual = 19, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 680 AND Record_number = 1660
UPDATE SRDBV4 SET Study_TS_Annual = 18, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 680 AND Record_number = 1661
UPDATE SRDBV4 SET Study_TS_Annual = 18.5, TS_Source = 'Rs_Ts_Relationship', Model_type = 'Model has SWC component', Annual_TS_Coverage = 1 WHERE Study_number = 680 AND Record_number = 1662
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 680

-- 1384
-- Model_paramB = Model_paramB*10?
UPDATE SRDBV4 SET Study_TS_Annual = 5, Model_paramB = Model_paramB*10, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 1384
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 1384

-- 2182
-- Parameter issue, calculated Ts is 11, too much higher than T_nnual
--UPDATE SRDBV4 SET Study_TS_Annual = , TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2182 
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 2182

-- 2326
UPDATE SRDBV4 SET Study_TS_Annual = 14, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2326 AND Lat_Round = 37.750
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 2326

-- 4212
UPDATE SRDBV4 SET Study_TS_Annual = 10, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2107
UPDATE SRDBV4 SET Study_TS_Annual = 13, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2112
UPDATE SRDBV4 SET Study_TS_Annual = 10, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2113
UPDATE SRDBV4 SET Study_TS_Annual = 9.2, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2115
UPDATE SRDBV4 SET Study_TS_Annual = 9.2, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2116
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2117
UPDATE SRDBV4 SET Study_TS_Annual = 9.2, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2118
UPDATE SRDBV4 SET Study_TS_Annual = 7, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2124
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2125
UPDATE SRDBV4 SET Study_TS_Annual = 4, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4212 AND Record_number = 2126
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 4212 AND Model_paramA IS NOT NULL AND Model_type != 'Other'

SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 4212

-- 4756 
-- Potential issue
--UPDATE SRDBV4 SET Study_TS_Annual = , TS_Source = 'Description in Page 9 and Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 4756
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 4756

/*

*/

SELECT DISTINCT Study_number FROM [dbo].[SRDBV4]

WHERE Latitude IS NOT NULL 
	AND Longitude IS NOT NULL 
	AND Study_midyear IS NOT NULL
	AND YearsOfData IS NOT NULL
	AND Rs_annual IS NOT NULL AND Rs_annual > 0
	AND Model_output_units IS NOT NULL
	AND Model_paramA IS NOT NULL
	AND Model_paramB IS NOT NULL
	AND Manipulation = 'None'
	--AND Study_TS_Annual IS NOT NULL
	AND Study_TS_Annual IS NULL
ORDER BY Study_number

--ALTER Table SRDBV4 ADD TS_Flag NVARCHAR(20)
--ALTER Table SRDBV4 ADD Annual_TS_Coverage NUMERIC(18,3) -- SOIL Temperature Coverage (0-1)
--SELECT Annual_coverage FROM SRDBV4 WHERE Study_TS_Annual IS NOT NULL
--UPDATE SRDBV4 SET Annual_TS_Coverage = Annual_coverage WHERE Study_TS_Annual IS NOT NULL

-- 143
UPDATE SRDBV4 SET Study_TS_Annual = 10.12, Annual_TS_Coverage = 1 WHERE Study_number = 143
UPDATE SRDBV4 SET TS_Source = 'Figure 2' WHERE Study_number = 143
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 143

-- 205
UPDATE SRDBV4 SET Study_TS_Annual = 9.79, Annual_TS_Coverage = 1 WHERE Study_number = 205
UPDATE SRDBV4 SET TS_Source = 'Figure 4.2' WHERE Study_number = 205
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 205

-- 211
UPDATE SRDBV4 SET Study_TS_Annual = 10.25, Annual_TS_Coverage = 1 WHERE Study_number = 211
UPDATE SRDBV4 SET TS_Source = 'Figure 2' WHERE Study_number = 211
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 211

-- 352
UPDATE SRDBV4 SET Study_TS_Annual = 14.3, Annual_TS_Coverage = 1 WHERE Study_number = 352 AND Record_number = 2472
UPDATE SRDBV4 SET Study_TS_Annual = 13.64, Annual_TS_Coverage = 1 WHERE Study_number = 352 AND Record_number = 2473
UPDATE SRDBV4 SET TS_Source = 'Table 4' WHERE Study_number = 352
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 352

-- 951
UPDATE SRDBV4 SET Study_TS_Annual = 3.97, Annual_TS_Coverage = 1, TS_Source = 'Rs_Ts_Relationship' WHERE Study_number = 951
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual,TS_Source
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 951

-- 986
UPDATE SRDBV4 SET Study_TS_Annual = 10.9, Annual_TS_Coverage = 1 WHERE Study_number = 986 AND Record_number = 699
UPDATE SRDBV4 SET Study_TS_Annual = 11.6, Annual_TS_Coverage = 1 WHERE Study_number = 986 AND Record_number = 700
UPDATE SRDBV4 SET Study_TS_Annual = 11.1, Annual_TS_Coverage = 1 WHERE Study_number = 986 AND Record_number = 701
UPDATE SRDBV4 SET TS_Source = 'Page 9' WHERE Study_number = 986
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 986

-- 1093
UPDATE SRDBV4 SET Study_TS_Annual = 12.37, Annual_TS_Coverage = 1 WHERE Study_number = 1093
UPDATE SRDBV4 SET TS_Source = 'Figure 2' WHERE Study_number = 1093
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 1093

-- 1120
UPDATE SRDBV4 SET Study_TS_Annual = 11.64, TS_Flag = 'TAIR_5', Annual_TS_Coverage = 0.58 WHERE Study_number = 1120
UPDATE SRDBV4 SET TS_Source = 'Figure 1' WHERE Study_number = 1120
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 1120
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =37.75  AND  Longitude = 126.75 AND [year] = 1995

-- 1500
UPDATE SRDBV4 SET Annual_TS_Coverage = 1, TS_Source = 'Figure 1' WHERE Study_number = 1500
UPDATE SRDBV4 SET Study_TS_Annual = (16.71+TAnnual_Del)/2, Annual_TS_Coverage = 1 WHERE Study_number = 1500
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 1500

-- 1954
UPDATE SRDBV4 SET Study_TS_Annual = 8.44, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 74.6 And [Year] = 1998
UPDATE SRDBV4 SET Study_TS_Annual = 8.02, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 74.6 And [Year] = 1999
UPDATE SRDBV4 SET Study_TS_Annual = 8.84, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 74.5 And [Year] = 1998
UPDATE SRDBV4 SET Study_TS_Annual = 7.95, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 74.5 And [Year] = 1999
UPDATE SRDBV4 SET Study_TS_Annual = 9.26, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 89.6 And [Year] = 1998
UPDATE SRDBV4 SET Study_TS_Annual = 8.96, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 89.6 And [Year] = 1999
UPDATE SRDBV4 SET Study_TS_Annual = 6.39, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 84.8 And [Year] = 1998
UPDATE SRDBV4 SET Study_TS_Annual = 6.99, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 84.8 And [Year] = 1999
UPDATE SRDBV4 SET Study_TS_Annual = 6.57, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 79.9
UPDATE SRDBV4 SET Study_TS_Annual = 7.26, Annual_TS_Coverage = 1 WHERE Study_number = 1954 AND Model_paramB = 85.8
UPDATE SRDBV4 SET TS_Source = 'Figure 1' WHERE Study_number =1954
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 1954

-- 2197
UPDATE SRDBV4 SET Study_TS_Annual = 13.18, Annual_TS_Coverage = 1 WHERE Study_number = 2197 AND Record_number = 629
UPDATE SRDBV4 SET Study_TS_Annual = 13.75, Annual_TS_Coverage = 1 WHERE Study_number = 2197 AND Record_number = 630
UPDATE SRDBV4 SET Study_TS_Annual = 13.73, Annual_TS_Coverage = 1 WHERE Study_number = 2197 AND Record_number = 631
UPDATE SRDBV4 SET TS_Source = 'Rs_Ts_Relationship' WHERE Study_number = 2197
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2197

-- 2241
UPDATE SRDBV4 SET Study_TS_Annual = 33, Annual_TS_Coverage = 1 WHERE Study_number = 2241
UPDATE SRDBV4 SET TS_Source = 'Rs_Ts_Relationship' WHERE Study_number = 2241
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2241

-- 2251
UPDATE SRDBV4 SET Study_TS_Annual = 10.9, Annual_TS_Coverage = 1 WHERE Study_number = 2251
UPDATE SRDBV4 SET TS_Source = 'Description above Figure 7' WHERE Study_number = 2251
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2251

-- 2325
UPDATE SRDBV4 SET Study_TS_Annual = 6.6, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number = 1819
UPDATE SRDBV4 SET Study_TS_Annual = 7.4, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1820
UPDATE SRDBV4 SET Study_TS_Annual = 7, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1821
UPDATE SRDBV4 SET Study_TS_Annual = 5.4, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1822
UPDATE SRDBV4 SET Study_TS_Annual = 4.6, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1823
UPDATE SRDBV4 SET Study_TS_Annual = 3.1, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1824
UPDATE SRDBV4 SET Study_TS_Annual = 6.6, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1825
UPDATE SRDBV4 SET Study_TS_Annual = 4.9, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1826
UPDATE SRDBV4 SET Study_TS_Annual = 4, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1827
UPDATE SRDBV4 SET Study_TS_Annual = 7.3, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1828
UPDATE SRDBV4 SET Study_TS_Annual = 7.5, Annual_TS_Coverage = 1 WHERE Study_number = 2325 AND Record_number =1829
UPDATE SRDBV4 SET TS_Source = 'Table 2' WHERE Study_number = 2325
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2325

--ALTER TABLE SRDBV4 ADD TS_Source NVARCHAR (50)
-- 2354
UPDATE SRDBV4 SET Study_TS_Annual = 17.85, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 2354
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2354

-- 2373
UPDATE SRDBV4 SET Study_TS_Annual = 17.76, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 2373
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2373

-- 2437
UPDATE SRDBV4 SET Study_TS_Annual = -7.8, TS_Source = 'Figure 1 and Modeling', Annual_TS_Coverage = 0.25 WHERE Study_number = 2437
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2437
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 66.25 AND Longitude = 129.25 AND [year] = 1999

-- 2501
UPDATE SRDBV4 SET Study_TS_Annual = 11.52, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 2501
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2501

-- 2560
UPDATE SRDBV4 SET Study_TS_Annual = 25, TS_Source = 'Table 1', Annual_TS_Coverage = 1, Study_temp = 26, TAnnual_Del =26  WHERE Study_number = 2560 AND Record_number = 1134
UPDATE SRDBV4 SET Study_TS_Annual = 25.6, TS_Source = 'Table 1', Annual_TS_Coverage = 1 , Study_temp = 26.2, TAnnual_Del =26.2 WHERE Study_number = 2560 AND Record_number = 1135
UPDATE SRDBV4 SET Study_TS_Annual = 25.9, TS_Source = 'Table 1', Annual_TS_Coverage = 1, Study_temp = 26.6, TAnnual_Del =26.6  WHERE Study_number = 2560 AND Record_number = 1136
UPDATE SRDBV4 SET Study_TS_Annual = 28.2, TS_Source = 'Table 1', Annual_TS_Coverage = 1, Study_temp = 30, TAnnual_Del =30  WHERE Study_number = 2560 AND Record_number = 1137
UPDATE SRDBV4 SET Study_TS_Annual = 17.9, TS_Source = 'Table 1', Annual_TS_Coverage = 1, Study_temp = 18.4, TAnnual_Del =18.4  WHERE Study_number = 2560 AND Record_number = 1138
UPDATE SRDBV4 SET Study_TS_Annual = 11.4, TS_Source = 'Table 1', Annual_TS_Coverage = 1, Study_temp = 20, TAnnual_Del =20  WHERE Study_number = 2560 AND Record_number = 1139
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, MAT, Study_temp
	From SRDBV4 WHERE Study_number = 2560
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 5.250 AND Longitude = 162.750 AND [year] = 2002

-- 2563
UPDATE SRDBV4 SET Study_TS_Annual = (19.25+(2.918+0.829*TAnnual_Del))/2, TS_Source = 'Figure 5', Annual_TS_Coverage = 1 WHERE Study_number = 2563
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2563

-- 2630
UPDATE SRDBV4 SET Study_TS_Annual = 8.24, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1151
UPDATE SRDBV4 SET Study_TS_Annual = 9, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1152
UPDATE SRDBV4 SET Study_TS_Annual = 7.9, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1153
UPDATE SRDBV4 SET Study_TS_Annual = 8.41, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1154
UPDATE SRDBV4 SET Study_TS_Annual = 7.63, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1155
UPDATE SRDBV4 SET Study_TS_Annual = 8.09, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1156
UPDATE SRDBV4 SET Study_TS_Annual = 8.68, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1157
UPDATE SRDBV4 SET Study_TS_Annual = 7.74, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1158
UPDATE SRDBV4 SET Study_TS_Annual = 8.22, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1159
UPDATE SRDBV4 SET Study_TS_Annual = 7.63, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2630 And Record_number = 1160
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2630

-- 2656
UPDATE SRDBV4 SET Study_TS_Annual = 5.56, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1175
UPDATE SRDBV4 SET Study_TS_Annual = 7.17, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1176
UPDATE SRDBV4 SET Study_TS_Annual = 8.88, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1177
UPDATE SRDBV4 SET Study_TS_Annual = 9.56, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1178
UPDATE SRDBV4 SET Study_TS_Annual = 5.24, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1179
UPDATE SRDBV4 SET Study_TS_Annual = 7.07, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1180
UPDATE SRDBV4 SET Study_TS_Annual = 6.59, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1181
UPDATE SRDBV4 SET Study_TS_Annual = 9.26, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1182

UPDATE SRDBV4 SET Study_TS_Annual = 9.04, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1200
UPDATE SRDBV4 SET Study_TS_Annual = 9.04, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1201
UPDATE SRDBV4 SET Study_TS_Annual = 9.81, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1202
UPDATE SRDBV4 SET Study_TS_Annual = 9.43, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1203
UPDATE SRDBV4 SET Study_TS_Annual = 9.04, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1204
UPDATE SRDBV4 SET Study_TS_Annual = 9.04, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1205
UPDATE SRDBV4 SET Study_TS_Annual = 9.44, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1206
UPDATE SRDBV4 SET Study_TS_Annual = 7.51, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 2656 And Record_number = 1207

SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 2656

-- 2747
UPDATE SRDBV4 SET Study_TS_Annual = 6.16, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4650
UPDATE SRDBV4 SET Study_TS_Annual = 6.62, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4651
UPDATE SRDBV4 SET Study_TS_Annual = 6.28, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4652
UPDATE SRDBV4 SET Study_TS_Annual = 7.62, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4653
UPDATE SRDBV4 SET Study_TS_Annual = 7.25, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4654
UPDATE SRDBV4 SET Study_TS_Annual = 7.69, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4655
UPDATE SRDBV4 SET Study_TS_Annual = 7.34, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4656
UPDATE SRDBV4 SET Study_TS_Annual = 8.13, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4657
UPDATE SRDBV4 SET Study_TS_Annual = 8.40, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4658
UPDATE SRDBV4 SET Study_TS_Annual = 8.51, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 2747 AND Record_number = 4659
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2747

-- 2926
UPDATE SRDBV4 SET Study_TS_Annual = 8.51, TS_Source = 'Figure 2 and TATS', Annual_TS_Coverage = 0.5 WHERE Study_number = 2926
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 2926

-- 3115
UPDATE SRDBV4 SET Study_TS_Annual = 12.76, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2313
UPDATE SRDBV4 SET Study_TS_Annual = 10.92, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2314
UPDATE SRDBV4 SET Study_TS_Annual = 12.32, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2315
UPDATE SRDBV4 SET Study_TS_Annual = 10.31, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2316
UPDATE SRDBV4 SET Study_TS_Annual = 8.74, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2317
UPDATE SRDBV4 SET Study_TS_Annual = 8.01, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2318
UPDATE SRDBV4 SET Study_TS_Annual = 8.61, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2319
UPDATE SRDBV4 SET Study_TS_Annual = 8.61, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2320
UPDATE SRDBV4 SET Study_TS_Annual = 7.78, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2321
UPDATE SRDBV4 SET Study_TS_Annual = 9.71, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2322
UPDATE SRDBV4 SET Study_TS_Annual = 5.64, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3115 AND Record_number = 2323
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 3115

-- 3131
UPDATE SRDBV4 SET Study_TS_Annual = 9.17, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3131
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 3131

-- 3211
UPDATE SRDBV4 SET Study_TS_Annual = 4.29, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3211
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 3211

-- 3399
UPDATE SRDBV4 SET Study_TS_Annual = 6.09, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3399 AND [Year] = 2002
UPDATE SRDBV4 SET Study_TS_Annual = 8.54, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3399 AND [Year] = 2003
UPDATE SRDBV4 SET Study_TS_Annual = 4.17, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1 WHERE Study_number = 3399 AND [Year] = 2004
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 3399

-- 3600
UPDATE SRDBV4 SET Study_TS_Annual = 10, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 3600 AND Record_number = 3253
UPDATE SRDBV4 SET Study_TS_Annual = 12, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 3600 AND Record_number = 3254
UPDATE SRDBV4 SET Study_TS_Annual = 10.7, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 3600 AND Record_number = 3255
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 3600

-- 3647
UPDATE SRDBV4 SET Study_TS_Annual = 10.2, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 3647 AND Record_number = 2438
UPDATE SRDBV4 SET Study_TS_Annual = 11.7, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 3647 AND Record_number = 2439
UPDATE SRDBV4 SET Study_TS_Annual = 8.6, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 3647 AND Record_number = 2440
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 3647

-- 3649
UPDATE SRDBV4 SET Study_TS_Annual = 6.81, TS_Source = 'Figure 1 and 2', Study_temp = 6.2, Annual_TS_Coverage = 1 WHERE Study_number = 3649
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source, Study_temp
	From SRDBV4 WHERE Study_number = 3649

-- 3683
UPDATE SRDBV4 SET Study_TS_Annual = 25, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 3683 AND Record_number = 2738
UPDATE SRDBV4 SET Study_TS_Annual = 23, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 3683 AND Record_number = 2739
UPDATE SRDBV4 SET Study_TS_Annual = 22.5, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 3683 AND Record_number = 2740
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 3683

-- 3845
UPDATE SRDBV4 SET Study_TS_Annual = 8.48, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 0.58 WHERE Study_number = 3845
UPDATE SRDBV4 SET Model_output_units = 'umol CO2/m2/s' WHERE Model_output_units IS NULL AND Study_number = 3845
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 3845

-- 3907
UPDATE SRDBV4 SET Study_TS_Annual = 11, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 3907 AND Record_number = 1008
UPDATE SRDBV4 SET Study_TS_Annual = 11, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 3907 AND Record_number = 1009
UPDATE SRDBV4 SET Study_TS_Annual = 10.7, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 3907 AND Record_number = 1010
UPDATE SRDBV4 SET Study_TS_Annual = 12.3, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 3907 AND Record_number = 1011
UPDATE SRDBV4 SET Study_TS_Annual = 10.5, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 3907 AND Record_number = 1012
UPDATE SRDBV4 SET Study_TS_Annual = 10.5, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 3907 AND Record_number = 1013
UPDATE SRDBV4 SET Study_TS_Annual = 9.65, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 3907 AND Record_number = 1014
UPDATE SRDBV4 SET Study_TS_Annual = 11.25, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 3907 AND Record_number = 1015
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 3907

-- 3976
UPDATE SRDBV4 SET Study_TS_Annual = 13.10, TS_Source = 'Figure 1 Figure 9 and Rs_Ts_Relationship', Annual_TS_Coverage = 1, Study_temp =13 WHERE Study_number = 3976
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_temp
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 3976

-- 4013
UPDATE SRDBV4 SET Study_TS_Annual = (17.3+24.2+11.8+0.6)/4, TS_Source = 'Description in section 3.1', Annual_TS_Coverage = 1 WHERE Study_number = 4013
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 4013

-- 4016
UPDATE SRDBV4 SET Study_TS_Annual = 15, TS_Source = 'Figure 5a', Annual_TS_Coverage = 1 WHERE Study_number = 4016
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 4016

-- 4392
UPDATE SRDBV4 SET Study_TS_Annual = 9.3, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 4392 AND [Year] = 2002
UPDATE SRDBV4 SET Study_TS_Annual = 8.15, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 4392 AND [Year] = 2003
UPDATE SRDBV4 SET Study_TS_Annual = 7.96, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 4392 AND [Year] = 2004
UPDATE SRDBV4 SET Study_TS_Annual = 11.73, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 4392 AND [Year] = 2005
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 4392

-- 4472
UPDATE SRDBV4 SET Study_TS_Annual = 12, TS_Source = 'Figure 3', Annual_TS_Coverage = 0.75, TS_Flag = 'TAIR_3' WHERE Study_number = 4472
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 4472
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 36.250 AND Longitude = 140.250 AND [year] = 2003

-- 5162
-- Q15	seasonal model, not annual
UPDATE SRDBV4 SET Study_TS_Annual = NULL,  Annual_TS_Coverage = 1, Study_temp = 5.6 WHERE Study_number = 5162 AND [Year] = 2002
UPDATE SRDBV4 SET Study_TS_Annual = NULL,  Annual_TS_Coverage = 1, Study_temp = 5.5 WHERE Study_number = 5162 AND [Year] = 2003
UPDATE SRDBV4 SET Study_TS_Annual = NULL,  Annual_TS_Coverage = 1, Study_temp = 6.3 WHERE Study_number = 5162 AND [Year] = 2004
UPDATE SRDBV4 SET Study_TS_Annual = NULL,  Annual_TS_Coverage = 1, Study_temp = 5.2 WHERE Study_number = 5162 AND [Year] = 2005
UPDATE SRDBV4 SET Model_type = 'Arrhenius, R=a*exp(b/c (1/d-1/T)), T in K, seasonal model' WHERE Study_number = 5162

SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 5162

-- 5247
UPDATE SRDBV4 SET Study_TS_Annual = 20.41, TS_Source = 'Figure 5', Annual_TS_Coverage = 1 WHERE Study_number = 5247
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 5247

-- 5458
UPDATE SRDBV4 SET Study_TS_Annual = 7.35, TS_Source = 'Table 2', Annual_TS_Coverage = 1 WHERE Study_number = 5458 AND Record_number = 4109
UPDATE SRDBV4 SET Study_TS_Annual = 9.12, TS_Source = 'Table 2', Annual_TS_Coverage = 1 WHERE Study_number = 5458 AND Record_number = 4110
UPDATE SRDBV4 SET Study_TS_Annual = 6.57, TS_Source = 'Table 2', Annual_TS_Coverage = 1 WHERE Study_number = 5458 AND Record_number = 4111
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 5458

-- 5470
UPDATE SRDBV4 SET Study_TS_Annual = -0.5, TS_Source = 'Rs_Ts_Relationthip', Annual_TS_Coverage = 1, Study_temp = -1.4 WHERE Study_number = 5470 AND Elevation = 1343
UPDATE SRDBV4 SET Study_TS_Annual = 1.97, TS_Source = 'Rs_Ts_Relationthip', Annual_TS_Coverage = 1, Study_temp = 0.35 WHERE Study_number = 5470 AND Elevation = 1130
UPDATE SRDBV4 SET Study_TS_Annual = 2.68, TS_Source = 'Rs_Ts_Relationthip', Annual_TS_Coverage = 1, Study_temp = 1.5 WHERE Study_number = 5470 AND Elevation = 970
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Elevation,Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 5470

-- 5587
UPDATE SRDBV4 SET Study_TS_Annual = 17, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 5587
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 5587

-- 5670
UPDATE SRDBV4 SET Study_TS_Annual = 21.5, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 5670
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 5670

-- 6082
UPDATE SRDBV4 SET Study_TS_Annual = 16.0, TS_Source = 'Description in Page 5', Annual_TS_Coverage =1 WHERE Study_number = 6082
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6082

-- 6462
UPDATE SRDBV4 SET Study_TS_Annual = 11.9/2+0.4/2, TS_Source = 'Table 2', Annual_TS_Coverage = 1 WHERE Study_number = 6462
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6462

-- 6479
UPDATE SRDBV4 SET Study_TS_Annual = 30.8, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 6479 AND Record_number = 5014
UPDATE SRDBV4 SET Study_TS_Annual = 29.25, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 6479 AND Record_number = 5015
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6479

-- 6497
-- Model parameter is not correct, according to Figure 4, re-simulated the model
UPDATE SRDBV4 SET Model_paramA = 3.5534, Model_paramB = 0.0575 WHERE Study_number = 6497
UPDATE SRDBV4 SET Study_TS_Annual = 17.99, TS_Source = 'Figure 4', Annual_TS_Coverage = 1 WHERE Study_number = 6497
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6497

-- 6561
UPDATE SRDBV4 SET Study_TS_Annual = 18.98, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 6561
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6561

-- 6755
UPDATE SRDBV4 SET Study_TS_Annual = 18.7, TS_Source = 'Figure 2', Annual_TS_Coverage =1 WHERE Study_number = 6755
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6755

-- 6762
UPDATE SRDBV4 SET Study_TS_Annual = 13.82, TS_Source = 'Figure 1 and TAIR_Del', Annual_TS_Coverage = 0.92, TS_Flag = 'TAIR_1' WHERE Study_number = 6762
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6762

-- 6768
UPDATE SRDBV4 SET Study_TS_Annual = 12, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 6768 AND Record_number = 5237
UPDATE SRDBV4 SET Study_TS_Annual = 15, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 6768 AND Record_number = 5238
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6768

-- 6769
UPDATE SRDBV4 SET Study_TS_Annual = 16.10, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 6769
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6769

-- 6984
UPDATE SRDBV4 SET Study_TS_Annual = 4.77, TS_Source = 'Figure 1 ab and TAIR_Del',TS_Flag = 'TAIR_4', Annual_TS_Coverage = 0.75, Study_temp = 1.5 WHERE Study_number = 6984
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual,MAP,Study_precip
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 6984
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 47.250 AND Longitude = 128.750 AND [year] = 2010

-- 7044
UPDATE SRDBV4 SET Study_TS_Annual = 14.14, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 7044
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7044

-- 7053
UPDATE SRDBV4 SET Study_TS_Annual = 20.21, TS_Source = 'Figure 6', Annual_TS_Coverage = 1 WHERE Study_number = 7053
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_temp
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7053

-- 7238
UPDATE SRDBV4 SET Study_TS_Annual = 17, TS_Source = 'Figure 1', Annual_TS_Coverage = 1,Study_temp = 16.8 WHERE Study_number = 7238
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_temp
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7238

--7289
UPDATE SRDBV4 SET Study_TS_Annual = 9.5, TS_Source = 'Figure 4', Annual_TS_Coverage = 1 WHERE Study_number = 7289
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7289

-- 7290
UPDATE SRDBV4 SET Study_TS_Annual = 15.19, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5461
UPDATE SRDBV4 SET Study_TS_Annual = 14.53, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5462
UPDATE SRDBV4 SET Study_TS_Annual = 14.97, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5463
UPDATE SRDBV4 SET Study_TS_Annual = 14.86, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5464
UPDATE SRDBV4 SET Study_TS_Annual = 15.2, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5465
UPDATE SRDBV4 SET Study_TS_Annual = 16.12, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5466
UPDATE SRDBV4 SET Study_TS_Annual = 14.91, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5467
UPDATE SRDBV4 SET Study_TS_Annual = 14.95, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5468
UPDATE SRDBV4 SET Study_TS_Annual = 14.87, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5469
UPDATE SRDBV4 SET Study_TS_Annual = 14, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5470

UPDATE SRDBV4 SET Study_TS_Annual = 15.58, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5471
UPDATE SRDBV4 SET Study_TS_Annual = 15.17, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5472
UPDATE SRDBV4 SET Study_TS_Annual = 15.4, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5473
UPDATE SRDBV4 SET Study_TS_Annual = 15.22, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5474
UPDATE SRDBV4 SET Study_TS_Annual = 15, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5475
UPDATE SRDBV4 SET Study_TS_Annual = 17, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5476
UPDATE SRDBV4 SET Study_TS_Annual = 16, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5477
UPDATE SRDBV4 SET Study_TS_Annual = 14, TS_Source = 'Table 3', Annual_TS_Coverage = 1 WHERE Study_number = 7290 AND Record_number = 5478

SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7290

-- 7300
UPDATE SRDBV4 SET Study_TS_Annual = 8.92, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 7300
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7300

-- 7527
UPDATE SRDBV4 SET Study_TS_Annual = 15.38, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 7527 
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7527

-- 7530
-- Model_paramC = 10
UPDATE SRDBV4 SET Study_TS_Annual = 16, TS_Source = 'Figure 1 and 2 and 3', Annual_TS_Coverage = 1, Study_temp =14, Model_paramC = 10 WHERE Study_number = 7530 AND Record_number = 5479
UPDATE SRDBV4 SET Study_TS_Annual = 16, TS_Source = 'Figure 1 and 2 and 3', Annual_TS_Coverage = 1, Study_temp =14, Model_paramC = 10 WHERE Study_number = 7530 AND Record_number = 5480
UPDATE SRDBV4 SET Study_TS_Annual = 15, TS_Source = 'Figure 1 and 2 and 3', Annual_TS_Coverage = 1, Study_temp =13, Model_paramC = 10 WHERE Study_number = 7530 AND Record_number = 5481
UPDATE SRDBV4 SET Study_TS_Annual = 15, TS_Source = 'Figure 1 and 2 and 3', Annual_TS_Coverage = 1, Study_temp =13, Model_paramC = 10 WHERE Study_number = 7530 AND Record_number = 5482
UPDATE SRDBV4 SET Study_TS_Annual = 13, TS_Source = 'Figure 1 and 2 and 3', Annual_TS_Coverage = 1, Study_temp =8, Model_paramC = 10 WHERE Study_number = 7530 AND Record_number = 5483
UPDATE SRDBV4 SET Study_TS_Annual = 13, TS_Source = 'Figure 1 and 2 and 3', Annual_TS_Coverage = 1, Study_temp =8, Model_paramC = 10 WHERE Study_number = 7530 AND Record_number = 5484
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_temp
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7530

-- 7573
UPDATE SRDBV4 SET Study_TS_Annual = 23, TS_Source = 'Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 7573
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7573

-- 7574
UPDATE SRDBV4 SET Study_TS_Annual = 14, TS_Source = 'Figure 2', Annual_TS_Coverage = 0.58 WHERE Study_number = 7574 AND Record_number = 5800
UPDATE SRDBV4 SET Study_TS_Annual = 14, TS_Source = 'Figure 2', Annual_TS_Coverage = 0.58 WHERE Study_number = 7574 AND Record_number = 5801
UPDATE SRDBV4 SET Study_TS_Annual = 10, TS_Source = 'Figure 2', Annual_TS_Coverage = 0.58 WHERE Study_number = 7574 AND Record_number = 5802
UPDATE SRDBV4 SET Study_TS_Annual = 9, TS_Source = 'Figure 2', Annual_TS_Coverage = 0.58 WHERE Study_number = 7574 AND Record_number = 5803
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Figure 2', Annual_TS_Coverage = 0.58 WHERE Study_number = 7574 AND Record_number = 5804
UPDATE SRDBV4 SET Study_TS_Annual = 9, TS_Source = 'Figure 2', Annual_TS_Coverage = 0.58 WHERE Study_number = 7574 AND Record_number = 5805
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7574

-- 7582
UPDATE SRDBV4 SET Study_TS_Annual = 15.36, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 7582
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, MAT, MAP
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7582

-- 7588
-- Potential issue of ST data
UPDATE SRDBV4 SET Study_TS_Annual = 9, TS_Source = 'Fig 6', Annual_TS_Coverage = 1 WHERE Study_number = 7588 AND Record_number = 5817
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Fig 6', Annual_TS_Coverage = 1 WHERE Study_number = 7588 AND Record_number = 5818
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Fig 6', Annual_TS_Coverage = 1 WHERE Study_number = 7588 AND Record_number = 5819
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Fig 6', Annual_TS_Coverage = 1 WHERE Study_number = 7588 AND Record_number = 5820
UPDATE SRDBV4 SET Study_TS_Annual = 6, TS_Source = 'Fig 6', Annual_TS_Coverage = 1 WHERE Study_number = 7588 AND Record_number = 5821
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7588

-- 7596
-- This is a hourly model (Figure 3)
-- Should change to figure 5&6, remodeling
-- Model type: "Polynomial, R=exp(a+b(T-d)+c(T-d)^2)"
UPDATE SRDBV4 SET Study_TS_Annual = 25.31, TS_Source = 'Figure 4', Annual_TS_Coverage = 1, Model_type = 'Polynomial, R=a+b(T-d)+c(T-d)^2', Model_paramA = -798.76, Model_paramB = 71.714, Model_paramC = -1.36
	 WHERE Study_number = 7596 AND Record_number = 5822
UPDATE SRDBV4 SET Study_TS_Annual = 24.65, TS_Source = 'Figure 4', Annual_TS_Coverage = 1, Model_type = 'Polynomial, R=a+b(T-d)+c(T-d)^2', Model_paramA = -773.22, Model_paramB = 69.774, Model_paramC = -1.3233
	 WHERE Study_number = 7596 AND Record_number = 5823
UPDATE SRDBV4 SET Model_paramD = 0 WHERE Study_number = 7596
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7596

-- 7630
UPDATE SRDBV4 SET Study_TS_Annual = 10.5, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 7630 and Year = 2009
UPDATE SRDBV4 SET Study_TS_Annual = 10.7, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 7630 and Year = 2010
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7630

-- 7631
UPDATE SRDBV4 SET Study_TS_Annual = 15.8, TS_Source = 'Table 4', Annual_TS_Coverage = 1 WHERE Study_number = 7631 AND Record_number = 6485
UPDATE SRDBV4 SET Study_TS_Annual = 15.2, TS_Source = 'Table 4', Annual_TS_Coverage = 1 WHERE Study_number = 7631 AND Record_number = 6486
UPDATE SRDBV4 SET Study_TS_Annual = 16.5, TS_Source = 'Table 4', Annual_TS_Coverage = 1 WHERE Study_number = 7631 AND Record_number = 6487
UPDATE SRDBV4 SET Study_TS_Annual = 15.8, TS_Source = 'Table 4', Annual_TS_Coverage = 1 WHERE Study_number = 7631 AND Record_number = 6488
UPDATE SRDBV4 SET Study_TS_Annual = 15.5, TS_Source = 'Table 4', Annual_TS_Coverage = 1 WHERE Study_number = 7631 AND Record_number = 6489
UPDATE SRDBV4 SET Study_TS_Annual = 16.4, TS_Source = 'Table 4', Annual_TS_Coverage = 1 WHERE Study_number = 7631 AND Record_number = 6490
UPDATE SRDBV4 SET Study_TS_Annual = 15.7, TS_Source = 'Table 4', Annual_TS_Coverage = 1 WHERE Study_number = 7631 AND Record_number = 6491
UPDATE SRDBV4 SET Study_TS_Annual = 15.3, TS_Source = 'Table 4', Annual_TS_Coverage = 1 WHERE Study_number = 7631 AND Record_number = 6492
UPDATE SRDBV4 SET Study_TS_Annual = 16.6, TS_Source = 'Table 4', Annual_TS_Coverage = 1 WHERE Study_number = 7631 AND Record_number = 6493
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7631

-- 7632
UPDATE SRDBV4 SET Study_TS_Annual = 10.69, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7632 AND Record_number = 6507
UPDATE SRDBV4 SET Study_TS_Annual = 11.84, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7632 AND Record_number = 6508
UPDATE SRDBV4 SET Study_TS_Annual = 11.85, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7632 AND Record_number = 6509
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7632

-- 7636
UPDATE SRDBV4 SET Study_TS_Annual = 11.43, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5486
UPDATE SRDBV4 SET Study_TS_Annual = 11.00, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5487
UPDATE SRDBV4 SET Study_TS_Annual = 10.32, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5488
UPDATE SRDBV4 SET Study_TS_Annual = 10.17, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5489
UPDATE SRDBV4 SET Study_TS_Annual = 14.97, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5490
UPDATE SRDBV4 SET Study_TS_Annual = 12.52, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5491
UPDATE SRDBV4 SET Study_TS_Annual = 12.67, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5492
UPDATE SRDBV4 SET Study_TS_Annual = 12.16, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5493
UPDATE SRDBV4 SET Study_TS_Annual = 12.04, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5494
UPDATE SRDBV4 SET Study_TS_Annual = 17.95, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7636 AND Record_number = 5495
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7636

-- 7659
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Figure 1', Annual_TS_Coverage = 1, [Year] = 2008 WHERE Study_number = 7659 AND Year = 2009
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Figure 1', Annual_TS_Coverage = 1, [Year] = 2009 WHERE Study_number = 7659 AND Year = 2010
UPDATE SRDBV4 SET Study_TS_Annual = 10, TS_Source = 'Figure 1', Annual_TS_Coverage = 1, [Year] = 2010 WHERE Study_number = 7659 AND Year = 2011
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Figure 1', Annual_TS_Coverage = 1, [Year] = 2011 WHERE Study_number = 7659 AND Year = 2012
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7659

-- 7675
UPDATE SRDBV4 SET Study_TS_Annual = 17.62, TS_Source = 'Figure 4', Annual_TS_Coverage = 1 WHERE Study_number = 7675
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7675

-- 7695
UPDATE SRDBV4 SET Study_TS_Annual = 17.82, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7695 AND Record_number = 6543
UPDATE SRDBV4 SET Study_TS_Annual = 18.04, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7695 AND Record_number = 6544
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7695

-- 7698
UPDATE SRDBV4 SET Study_TS_Annual = 14.9, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 7698 AND Record_number = 6501
UPDATE SRDBV4 SET Study_TS_Annual = 12.4, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 7698 AND Record_number = 6502
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7698

-- 7702
UPDATE SRDBV4 SET Study_TS_Annual = 19.94, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7702 AND Record_number = 5496
UPDATE SRDBV4 SET Study_TS_Annual = 20.44, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 7702 AND Record_number = 5497
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7702

-- 7704
-- Model_type = 'Exponential, R=a exp(b(T-c))' according to Figure 5
-- The unit for the Rs_annual should be reported wrong in the mamuscript, if change to umol CO2/m2/s - (780=2.06, 840=2.22, 1175=3.11,647=1.72,1448=3.83)
-- But from FIgure 5, we can see that the Rs_Annual is much smaller than that.
-- If unit of Rs_annual change from g c/m2/yr to g co2/m2/yr, they values perfectly mach
-- Rs_annual = Rs_annual(current values)*44/12
--UPDATE SRDBV4 SET Study_TS_Annual = 11, TS_Source = 'Figure 5', Annual_TS_Coverage = 1, Model_type = 'Exponential, R=a exp(b(T-c))', Rs_annual = Rs_annual/44*12
--	 WHERE Study_number = 7704
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7704

-- 7721
UPDATE SRDBV4 SET Study_TS_Annual = 4, TS_Source = 'Figure 3 and TAIR_Del', Annual_TS_Coverage = 0.42, TS_Flag = 'TAIR_7' WHERE Study_number = 7721
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, MAT, MAP
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7721
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 42.250 AND Longitude = 128.250 AND [year] = 2005

-- 7727
-- Data are from warm period
UPDATE SRDBV4 SET Study_TS_Annual = 21, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 7727
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual,MAT, MAP
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7727

-- 7981
UPDATE SRDBV4 SET Study_TS_Annual = 10.49, TS_Source = 'Figure 6', Annual_TS_Coverage = 1 WHERE Study_number = 7981
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 7981

-- 8007
UPDATE SRDBV4 SET Study_TS_Annual = 15.85, TS_Source = 'Figure 3', Annual_TS_Coverage = 1, Model_type = 'Exponential, R=a exp(b(T-c))' WHERE Study_number = 8007
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8007

-- 8079
-- Record number 6621, model only for summer and spring
-- Re-simulated the model: Model_paramA = -0.0075, Model_paramB = 0.141, Model_paramC = -0.0031
-- Model_paramD = 0 WHERE Study_number = 8079 AND Record_number = 6622
UPDATE SRDBV4 SET Study_TS_Annual = 14, TS_Source = 'Figure 8', Annual_TS_Coverage = 1, Model_paramA = -0.0075, Model_paramB = 0.141, Model_paramC = -0.0031
	 WHERE Study_number = 8079 AND Record_number = 6621
UPDATE SRDBV4 SET Study_TS_Annual = 12, TS_Source = 'Figure 8', Annual_TS_Coverage = 1, Model_paramD = 0 WHERE Study_number = 8079 AND Record_number = 6622
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8079

-- 8117
UPDATE SRDBV4 SET Study_TS_Annual = 12.64, TS_Source = 'Description in Page 5', Annual_TS_Coverage = 1 WHERE Study_number = 8117 AND Record_number = 5511
UPDATE SRDBV4 SET Study_TS_Annual = 15.08, TS_Source = 'Description in Page 5', Annual_TS_Coverage = 1 WHERE Study_number = 8117 AND Record_number = 5512
UPDATE SRDBV4 SET Study_TS_Annual = 12.83, TS_Source = 'Description in Page 5', Annual_TS_Coverage = 1 WHERE Study_number = 8117 AND Record_number = 5513
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8117

-- 8186
UPDATE SRDBV4 SET Study_TS_Annual = 17.02, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 8186
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8186

-- 8289
UPDATE SRDBV4 SET Study_TS_Annual = 14.21, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 8289
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8289

-- 8307
UPDATE SRDBV4 SET Study_TS_Annual = 5.5, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8307 AND Record_number = 5521
UPDATE SRDBV4 SET Study_TS_Annual = 6.4, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8307 AND Record_number = 5522
UPDATE SRDBV4 SET Study_TS_Annual = 8.9, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8307 AND Record_number = 5523
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8307

-- 8334
-- Model parameter reported in the manuscript are wrong
-- Model_paramA = Model_paramA(original)*10
--UPDATE SRDBV4 SET Study_TS_Annual = 17.3, TS_Source = 'Table II', Annual_TS_Coverage = 1, Model_paramA = 0.9282,  Model_paramB = 0.0701
--	WHERE Study_number = 8334 AND Record_number = 5877
--UPDATE SRDBV4 SET Study_TS_Annual = 17.4, TS_Source = 'Table II', Annual_TS_Coverage = 1, Model_paramA = Model_paramA*10 WHERE Study_number = 8334 AND Record_number = 5878
--UPDATE SRDBV4 SET Study_TS_Annual = 17.9, TS_Source = 'Table II', Annual_TS_Coverage = 1, Model_paramA = Model_paramA*10 WHERE Study_number = 8334 AND Record_number = 5879
--UPDATE SRDBV4 SET Study_TS_Annual = 16.8, TS_Source = 'Table II', Annual_TS_Coverage = 1, Model_paramA = Model_paramA*10 WHERE Study_number = 8334 AND Record_number = 5880
--UPDATE SRDBV4 SET Study_TS_Annual = 21.0, TS_Source = 'Table II', Annual_TS_Coverage = 1, Model_paramA = Model_paramA/10 WHERE Study_number = 8334 AND Record_number = 5881
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8334

-- 8382
-- Re-simulated the model without SWC conponent
-- for control (Recordnumber = 5882) Model_paramA = 0.995, Model_paramB = 250.96, Model_type = 'R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K'
UPDATE SRDBV4 SET Study_TS_Annual = 9.25, TS_Source = 'Figure 1', Annual_TS_Coverage = 1, Model_type = 'R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K'
	, Model_paramA = 0.995, Model_paramB = 250.96, Model_paramC = 56.2, Model_paramD = 227.13
	WHERE Study_number = 8382 AND Record_number = 5882
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8382

-- 8383
UPDATE SRDBV4 SET Study_TS_Annual = 16.4, TS_Source = 'Table 1 and Figure 3', Annual_TS_Coverage = 1 WHERE Study_number = 8383
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8383

-- 8464
UPDATE SRDBV4 SET Study_TS_Annual = 11.2, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 8464 AND Record_number = 5539
UPDATE SRDBV4 SET Study_TS_Annual = 8.8, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 8464 AND Record_number = 5540
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8464

-- 8602
UPDATE SRDBV4 SET Study_TS_Annual = 7.1, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 8602 AND Record_number = 5561
UPDATE SRDBV4 SET Study_TS_Annual = 7.9, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 8602 AND Record_number = 5562
UPDATE SRDBV4 SET Study_TS_Annual = 7, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 8602 AND Record_number = 5563
UPDATE SRDBV4 SET Study_TS_Annual = 7, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 8602 AND Record_number = 5564
UPDATE SRDBV4 SET Study_TS_Annual = 7.2, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 8602 AND Record_number = 5565
UPDATE SRDBV4 SET Study_TS_Annual = 7.6, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 8602 AND Record_number = 5566
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8602

-- 8866
-- if the model_output_units is g co2/m2/hr, the annual TS mean should be -0.6 C, which is far wary from the T_Annual (12 C)
-- IF the model_output_units is g c/m2/d, the annual TS mean is 15 C, close to the T_Annual
-- Update the unit?
UPDATE SRDBV4 SET Study_TS_Annual = 15, TS_Source = 'Rs_Ts_Relationship', Annual_TS_Coverage = 1, Model_output_units = 'g C/m2/day' WHERE Study_number = 8866
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8866
--SELECT DISTINCT Model_output_units FROM SRDBV4 ORDER BY Model_output_units

-- 8887
UPDATE SRDBV4 SET Study_TS_Annual = 6.87, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 8887
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8887

-- 8917
-- Model_paramB = 0.0331 WHERE Study_number = 8917 AND Record_number = 5973 (Table 2)
-- Model_paramB = 0.0541 WHERE Study_number = 8917 AND Record_number = 5979 (Table 2)
UPDATE SRDBV4 SET Study_TS_Annual = 18.7/2+25/2, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8917 AND Record_number = 5971
UPDATE SRDBV4 SET Study_TS_Annual = 18.2/2+24.8/2, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8917 AND Record_number = 5972
UPDATE SRDBV4 SET Study_TS_Annual = 18.6/2+24.7/2, TS_Source = 'Table 1', Annual_TS_Coverage = 1, Model_paramB = 0.0331 WHERE Study_number = 8917 AND Record_number = 5973
UPDATE SRDBV4 SET Study_TS_Annual = 17.3/2+24.2/2, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8917 AND Record_number = 5974
UPDATE SRDBV4 SET Study_TS_Annual = 17.5/2+24/2, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8917 AND Record_number = 5975
UPDATE SRDBV4 SET Study_TS_Annual = 17.1/2+24/2, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8917 AND Record_number = 5976
UPDATE SRDBV4 SET Study_TS_Annual = 16.4/2+23.1/2, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8917 AND Record_number = 5977
UPDATE SRDBV4 SET Study_TS_Annual = 16.2/2+23.1/2, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 8917 AND Record_number = 5978
UPDATE SRDBV4 SET Study_TS_Annual = 16.3/2+22.8/2, TS_Source = 'Table 1', Annual_TS_Coverage = 1, Model_paramB = 0.0541 WHERE Study_number = 8917 AND Record_number = 5979
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 8917

-- 9081
UPDATE SRDBV4 SET Study_TS_Annual = -0.12, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 9081
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 9081

-- 9177
UPDATE SRDBV4 SET Study_TS_Annual = 19.72, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 9177
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 9177

-- 9501
UPDATE SRDBV4 SET Study_TS_Annual = 20, TS_Source = 'Figure 1 and TAIR_Del', TS_Flag = 'TAIR_4', Annual_TS_Coverage = 0.75 WHERE Study_number = 9501
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 9501
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 30.750 AND Longitude = 103.250 AND [year] = 2010

-- 9563
-- Cannot find the model parameters
UPDATE SRDBV4 SET Study_TS_Annual = 20.2, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9563 AND Record_number = 5959
UPDATE SRDBV4 SET Study_TS_Annual = 20.5, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9563 AND Record_number = 5960
UPDATE SRDBV4 SET Study_TS_Annual = 21.2, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9563 AND Record_number = 5961
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 9563

-- 9777
UPDATE SRDBV4 SET Study_TS_Annual = 15.28, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9777 AND Record_number = 5998
UPDATE SRDBV4 SET Study_TS_Annual = 15.63, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9777 AND Record_number = 5999
UPDATE SRDBV4 SET Study_TS_Annual = 15.45, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9777 AND Record_number = 6000
UPDATE SRDBV4 SET Study_TS_Annual = 15.09, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9777 AND Record_number = 6001
UPDATE SRDBV4 SET Study_TS_Annual = 15.76, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9777 AND Record_number = 6002
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 9777

-- 9835
UPDATE SRDBV4 SET Study_TS_Annual = 17.6, TS_Source = 'Description in page 5', Annual_TS_Coverage = 1 WHERE Study_number = 9835
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 9835

-- 9928
UPDATE SRDBV4 SET Study_TS_Annual = 7.5, TS_Source = 'Figure 2', Annual_TS_Coverage = 1 WHERE Study_number = 9928
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 9928

-- 9989
UPDATE SRDBV4 SET Study_TS_Annual = 16.3, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9989 AND Record_number = 6018
UPDATE SRDBV4 SET Study_TS_Annual = 17.3, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9989 AND Record_number = 6019
UPDATE SRDBV4 SET Study_TS_Annual = 13.9, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9989 AND Record_number = 6020
UPDATE SRDBV4 SET Study_TS_Annual = 14.3, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9989 AND Record_number = 6021
UPDATE SRDBV4 SET Study_TS_Annual = 15.5, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9989 AND Record_number = 6022
UPDATE SRDBV4 SET Study_TS_Annual = 15.7, TS_Source = 'Table 1', Annual_TS_Coverage = 1 WHERE Study_number = 9989 AND Record_number = 6023
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 9989

--SELECT DISTINCT Study_number FROM SRDBV4 WHERE Study_TS_Annual IS NOT NULL and Study_number > 10000

-- 10087
UPDATE SRDBV4 SET Study_TS_Annual = 17, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10087
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 10087

-- 10104
UPDATE SRDBV4 SET Study_TS_Annual = 11, TS_Source = 'Figure 1 and 5', Annual_TS_Coverage = 1 WHERE Study_number = 10104
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 10104

-- 10266
UPDATE SRDBV4 SET Study_TS_Annual = 9, TS_Source = 'Figure 2 and TAIR_Del',TS_Flag = 'TAIR_2', Annual_TS_Coverage = 1 WHERE Study_number = 10266 AND [Year] = 2009
UPDATE SRDBV4 SET Study_TS_Annual = 12, TS_Source = 'Figure 2 and TAIR_Del', TS_Flag = 'TAIR_2', Annual_TS_Coverage = 1 WHERE Study_number = 10266 AND [Year] = 2010
UPDATE SRDBV4 SET Study_TS_Annual = 10, TS_Source = 'Figure 2 and TAIR_Del', TS_Flag = 'TAIR_2', Annual_TS_Coverage = 1 WHERE Study_number = 10266 AND [Year] = 2011
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Figure 2 and TAIR_Del', TS_Flag = 'TAIR_2', Annual_TS_Coverage = 1 WHERE Study_number = 10266 AND [Year] = 2012
UPDATE SRDBV4 SET Study_TS_Annual = 12, TS_Source = 'Figure 2 and TAIR_Del', TS_Flag = 'TAIR_2', Annual_TS_Coverage = 1 WHERE Study_number = 10266 AND [Year] = 2013
UPDATE SRDBV4 SET Study_TS_Annual = 8, TS_Source = 'Figure 2 and TAIR_Del', TS_Flag = 'TAIR_2', Annual_TS_Coverage = 1 WHERE Study_number = 10266 AND [Year] = 2014
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_temp
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 10266

-- 10373
UPDATE SRDBV4 SET Study_TS_Annual = 12.03, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6079
UPDATE SRDBV4 SET Study_TS_Annual = 15.18, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6080
UPDATE SRDBV4 SET Study_TS_Annual = 14, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6081
UPDATE SRDBV4 SET Study_TS_Annual = 14.3, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6082
UPDATE SRDBV4 SET Study_TS_Annual = 13.03, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6083
UPDATE SRDBV4 SET Study_TS_Annual = 16.18, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6084
UPDATE SRDBV4 SET Study_TS_Annual = 15, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6085
UPDATE SRDBV4 SET Study_TS_Annual = 15.3, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6086
UPDATE SRDBV4 SET Study_TS_Annual = 14.03, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6087
UPDATE SRDBV4 SET Study_TS_Annual = 17.18, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6088
UPDATE SRDBV4 SET Study_TS_Annual = 16, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6089
UPDATE SRDBV4 SET Study_TS_Annual = 16.3, TS_Source = 'Figure 1', Annual_TS_Coverage = 1 WHERE Study_number = 10373 AND Record_number = 6090

SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 10373




/*
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =  AND Longitude =  AND [year] = 

-- 
UPDATE SRDBV4 SET Study_TS_Annual = , TS_Source = '', Annual_TS_Coverage =  WHERE Study_number = 
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 

10373
*/


-- 66
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year], Annual_TS_Coverage, TS_Source
	From SRDBV4 WHERE Study_number = 66
UPDATE SRDBV4 SET Study_TS_Annual = 13.60 WHERE Study_number = 66 AND [Year] = 1970 OR [Year] = 1964
UPDATE SRDBV4 SET Study_TS_Annual = 14.51 WHERE Study_number = 66 AND [Year] = 1967
UPDATE SRDBV4 SET TS_Source = 'Figure 1' WHERE Study_number =66

-- 90
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 90
UPDATE SRDBV4 SET Study_TS_Annual = 9.45 WHERE Study_number = 90
UPDATE SRDBV4 SET TS_Source = 'Figure 1' WHERE Study_number =90

/******************************************************************************************************************************
--2. Study has less than 12 month TS? : 70 studies
******************************************************************************************************************************/
SELECT DISTINCT Study_number FROM [dbo].[SRDBMGRsD] 
WHERE [Month_Frequency] < 12 ORDER BY Study_number
-- 142
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 142
UPDATE SRDBV4 SET Study_TS_Annual = 11.53, Annual_coverage = 0.67 WHERE Study_number = 142
UPDATE SRDBV4 SET TS_Flag = 'TAIR_4' WHERE Study_number = 142
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 48.75 AND Longitude = 16.25 AND [year] = 1971

-- 109
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 109
UPDATE SRDBV4 SET Study_TS_Annual = 13.00 WHERE Study_number = 109
UPDATE SRDBV4 SET TS_Source = 'Table 1' WHERE Study_number =109


-- 560
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Study_TS_Annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 560
UPDATE SRDBV4 SET Study_TS_Annual = 19.55, Annual_coverage = 0.91 WHERE Study_number = 560
UPDATE SRDBV4 SET TS_Flag = 'TAIR_1' WHERE Study_number = 560
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 33.75 AND Longitude =133.25 AND [year] = 1987

-- 900
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Latitude, Longitude, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 900
UPDATE SRDBV4 SET Study_TS_Annual = 7.59 WHERE Study_number = 900
UPDATE SRDBV4 SET TS_Flag = 'TAIR_4' WHERE Study_number = 900
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 44.75 AND Longitude =-85.75 AND [year] = 1992

-- 1099
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 1099
UPDATE SRDBV4 SET Study_TS_Annual = 7.16, Annual_coverage = 0.83 WHERE Study_number = 1099
UPDATE SRDBV4 SET TS_Flag = 'TAIR_2' WHERE Study_number = 1099
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =56.25 AND Longitude =9.75 AND [year] = 1994

-- 1116
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 1116 AND Lat_round = 62.75 AND Long_Round = 30.75
UPDATE SRDBV4 SET Study_TS_Annual = 5.239, Annual_coverage = 0.5 WHERE Study_number = 1116 AND Lat_round = 62.75 AND Long_Round = 30.75
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =62.75 AND Longitude =30.75 AND [year] = 1991
UPDATE SRDBV4 SET Study_TS_Annual = 7.07, Annual_coverage = 0.5 WHERE Study_number = 1116 AND Lat_round = 61.75 AND Long_Round = 24.25
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =61.75 AND Longitude =24.25 AND [year] = 1992
UPDATE SRDBV4 SET Study_TS_Annual = 6.50, Annual_coverage = 0.5 WHERE Study_number = 1116 AND Lat_round = 62.25 AND Long_Round = 29.75
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =62.25 AND Longitude =29.75 AND [year] = 1992
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number = 1116

-- 1118
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 1118
UPDATE SRDBV4 SET Study_TS_Annual = 6.21 WHERE Study_number = 1118 AND Lat_Round = 45.25 AND Long_Round = -68.75
UPDATE SRDBV4 SET Study_TS_Annual = 6.21 WHERE Study_number = 1118 AND Lat_Round = 45.75 AND Long_Round = -68.25
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number = 1118
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =45.25 AND Longitude =-68.75 AND [year] = 1994

-- 1207
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 1207
UPDATE SRDBV4 SET Study_TS_Annual = 1.656 WHERE Study_number = 1207
UPDATE SRDBV4 SET TS_Flag = 'TAIR_7' WHERE Study_number = 1207
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =49.25 AND Longitude =-88.75 AND [year] = 1994

-- 1216
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 1216
UPDATE SRDBV4 SET Study_TS_Annual = 1.24 WHERE Study_number = 1216
UPDATE SRDBV4 SET TS_Flag = 'TAIR_7' WHERE Study_number = 1216
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =53.75 AND Longitude =-105.25 AND [year] = 1995

-- 1286
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 1286
UPDATE SRDBV4 SET Study_TS_Annual = 9.12, Annual_coverage = 0.75 WHERE Study_number = 1286
UPDATE SRDBV4 SET TS_Flag = 'TAIR_3' WHERE Study_number = 1286
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =35.25 AND Longitude =-111.750 AND [year] = 1994

-- 1324
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 1324
UPDATE SRDBV4 SET Study_TS_Annual = 25.315 WHERE Study_number = 1324
UPDATE SRDBV4 SET TS_Flag = 'TAIR_9' WHERE Study_number = 1324
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =5.25 AND Longitude =-52.750 AND [year] = 1994

-- 1382
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 1382
UPDATE SRDBV4 SET Study_TS_Annual = 1.36 WHERE Study_number = 1382
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number = 1382
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =53.750 AND Longitude =-106.250 AND [year] = 1994

-- 1405
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, [Year]
	From SRDBV4 WHERE Study_number = 1405
UPDATE SRDBV4 SET Study_TS_Annual = 9.512 WHERE Study_number = 1405
UPDATE SRDBV4 SET TS_Flag = 'TAIR_3' WHERE Study_number = 1405
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =43.250 AND Longitude =-89.250 AND [year] = 1995

-- 1479
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type,TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 1479
UPDATE SRDBV4 SET Study_TS_Annual =20.49, Annual_coverage = 0.83 WHERE Study_number = 1479
UPDATE SRDBV4 SET TS_Flag = 'TAIR_2' WHERE Study_number = 1479
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = 30.750 AND Longitude =-94.250 AND [year] = 1994

-- 1518
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 1518
UPDATE SRDBV4 SET Study_TS_Annual = -7.87, Annual_coverage = 0.5 WHERE Study_number = 1518
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number =1518
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =74.250 AND Longitude =-20.750 AND [year] = 1996

-- 1539
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 1539
UPDATE SRDBV4 SET Study_TS_Annual = 18.60, Annual_coverage = 0.75 WHERE Study_number = 1539
UPDATE SRDBV4 SET TS_Flag = 'TAIR_3' WHERE Study_number =1539
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =36.750 AND Longitude =-119.250 AND [year] = 1995

-- 1850
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 1850
UPDATE SRDBV4 SET Study_TS_Annual = 3.76, Annual_coverage = 0.75 WHERE Study_number = 1850
UPDATE SRDBV4 SET TS_Flag = 'TAIR_3' WHERE Study_number = 1850
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =49.250 AND Longitude =-119.250 AND [year] = 1997

-- 1971
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 1971
UPDATE SRDBV4 SET Study_TS_Annual = 27.85, Annual_coverage = 0.67 WHERE Study_number = 1971
UPDATE SRDBV4 SET TS_Flag = 'TAIR_4' WHERE Study_number =1971
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =-12.750 AND Longitude =130.750 AND [year] = 2000

-- 2037
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Record_number
	From SRDBV4 WHERE Study_number = 2037
UPDATE SRDBV4 SET Study_TS_Annual = 7.17, Annual_coverage = 0.92 WHERE Study_number = 2037 AND Record_number = 93
UPDATE SRDBV4 SET Study_TS_Annual = 7.7, Annual_coverage = 0.92 WHERE Study_number = 2037 AND Record_number = 95
UPDATE SRDBV4 SET Study_TS_Annual = 7.7, Annual_coverage = 0.92 WHERE Study_number = 2037 AND Record_number = 97
UPDATE SRDBV4 SET Annual_coverage = 0.92 WHERE Study_number = 2037 
UPDATE SRDBV4 SET TS_Flag = 'TAIR_1' WHERE Study_number = 2037
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =44.750 AND Longitude =-121.750 AND [year] = 1999

-- 2065
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 2065
UPDATE SRDBV4 SET Study_TS_Annual = 9.96, Annual_coverage = 0.42 WHERE Study_number = 2065
UPDATE SRDBV4 SET TS_Flag = 'TAIR_7' WHERE Study_number =2065
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =36.250 AND Longitude =137.250 AND [year] = 1999

-- 2326
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 2326
UPDATE SRDBV4 SET Study_TS_Annual = 7.29 WHERE Study_number = 2326 AND Lat_Round =38.250 AND Long_Round =128.250
UPDATE SRDBV4 SET TS_Flag = 'TAIR_4' WHERE Study_number =2326
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =38.250 AND Longitude =128.250 AND [year] = 2000

-- 2451
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 2451
UPDATE SRDBV4 SET Study_TS_Annual = 10.97, Annual_coverage = 0.83 WHERE Study_number = 2451
UPDATE SRDBV4 SET TS_Flag = 'TAIR_2' WHERE Study_number =2451
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =37.250 AND Longitude =127.250 AND [year] = 2001

-- 2503
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 2503
UPDATE SRDBV4 SET Study_TS_Annual = 9.79 WHERE Study_number = 2503
UPDATE SRDBV4 SET TS_Source = 'Figure 2' WHERE Study_number =2503

-- 2537
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 2537
UPDATE SRDBV4 SET Study_TS_Annual = 7.71, Annual_coverage = 0.75 WHERE Study_number = 2537 AND [Year] = 1989
UPDATE SRDBV4 SET TS_Flag = 'TAIR_3' WHERE Study_number =2537
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =42.750 AND Longitude =-72.250 AND [year] = 1989

-- 2541
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 2541
UPDATE SRDBV4 SET Study_TS_Annual = (7.03 + TAnnual_Del)/2  WHERE Study_number = 2541
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number =2541
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =46.750 AND Longitude =-88.750 AND [year] = 1999

-- 2680
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 2680
UPDATE SRDBV4 SET Study_TS_Annual = 7.19, Annual_coverage = 0.42 WHERE Study_number = 2680
UPDATE SRDBV4 SET TS_Flag = 'TAIR_7' WHERE Study_number =2680
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =42.750 AND Longitude =141.750 AND [year] = 2001

-- 2842
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 2842
UPDATE SRDBV4 SET Study_TS_Annual = 11.04, Annual_coverage = 0.58 WHERE Study_number = 2842
UPDATE SRDBV4 SET TS_Flag = 'TAIR_5' WHERE Study_number =2842
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =36.750 AND Longitude =138.250 AND [year] = 2000

-- 2844
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 2844
UPDATE SRDBV4 SET Study_TS_Annual = 8.7 WHERE Study_number = 2844 AND Record_number = 2018
UPDATE SRDBV4 SET Study_TS_Annual = 8.12 WHERE Study_number = 2844 AND Record_number = 2019
UPDATE SRDBV4 SET Study_TS_Annual = 8.07 WHERE Study_number = 2844 AND Record_number = 2020
UPDATE SRDBV4 SET Study_TS_Annual = 7.87 WHERE Study_number = 2844 AND Record_number = 2021
UPDATE SRDBV4 SET Study_TS_Annual = 9.68 WHERE Study_number = 2844 AND Record_number = 2022
UPDATE SRDBV4 SET Study_TS_Annual = 9.22 WHERE Study_number = 2844 AND Record_number = 2023
UPDATE SRDBV4 SET TS_Source = 'Figure 4' WHERE Study_number =2844

-- 3415
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 3415
UPDATE SRDBV4 SET Study_TS_Annual = 9.77, Annual_coverage = 0.92 WHERE Study_number = 3415
UPDATE SRDBV4 SET TS_Flag = 'TAIR_1' WHERE Study_number =3415
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =51.250 AND Longitude =4.750 AND [year] = 2001

-- 3619
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 3619
UPDATE SRDBV4 SET Study_TS_Annual = 13.45, Annual_coverage = 0.83 WHERE Study_number = 3619
UPDATE SRDBV4 SET TS_Flag = 'TAIR_2' WHERE Study_number =3619
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =42.250 AND Longitude =11.750 AND [year] = 2001

-- 3653
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 3653
UPDATE SRDBV4 SET Study_TS_Annual = 4.615, Annual_coverage = 0.75 WHERE Study_number = 3653
UPDATE SRDBV4 SET TS_Flag = 'TAIR_3' WHERE Study_number =3653
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =45.250 AND Longitude =127.750 AND [year] = 2005

-- 3676
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 3676
UPDATE SRDBV4 SET Study_TS_Annual = 8.95 WHERE Study_number = 3676
UPDATE SRDBV4 SET TS_Flag = 'TAIR_7' WHERE Study_number =3676
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =31.750 AND Longitude =103.750 AND [year] = 2005

-- 3733
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 3733
UPDATE SRDBV4 SET Study_TS_Annual = 7.669 WHERE Study_number = 3733 AND [Year] = 2001
UPDATE SRDBV4 SET Study_TS_Annual = 8.19 WHERE Study_number = 3733 AND [Year] = 2002
UPDATE SRDBV4 SET TS_Source = 'Figure 1' WHERE Study_number =3733

-- 3886
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 3886
UPDATE SRDBV4 SET Study_TS_Annual = 2.58, Annual_coverage = 0.5 WHERE Study_number = 3886 AND Record_number = 3043 OR Record_number = 3044
UPDATE SRDBV4 SET Study_TS_Annual = 3.14, Annual_coverage = 0.5 WHERE Study_number = 3886 AND Record_number = 3045 OR Record_number = 3046
UPDATE SRDBV4 SET TS_Flag = 'TAIR_5' WHERE Study_number =3886
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =45.250 AND Longitude =127.750 AND [year] = 2005

-- 3927
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year]
	From SRDBV4 WHERE Study_number = 3927
UPDATE SRDBV4 SET Study_TS_Annual = 9.25, Annual_coverage = 0.67 WHERE Study_number = 3927
UPDATE SRDBV4 SET TS_Flag = 'TAIR_4' WHERE Study_number =3927
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =49.750 AND Longitude =-125.250 AND [year] = 2005

-- 4062
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 4062
UPDATE SRDBV4 SET Study_TS_Annual = 11.91, Annual_TS_coverage = 0.58 WHERE Study_number = 4062
UPDATE SRDBV4 SET TS_Flag = 'TAIR_5' WHERE Study_number =4062
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =36.250 AND Longitude =140.250 AND [year] = 2002

-- 4136
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 4136
UPDATE SRDBV4 SET Study_TS_Annual = 10.25, Annual_TS_Coverage = 0.5 WHERE Study_number = 4136
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number =4136
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =44.750 AND Longitude =123.750 AND [year] = 2002

-- 4375
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 4375
UPDATE SRDBV4 SET Study_TS_Annual = 10.05, Annual_TS_Coverage = 1 WHERE Study_number = 4375
UPDATE SRDBV4 SET TS_Flag = 'TAIR_0' WHERE Study_number =4375

-- 4587
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 4587
UPDATE SRDBV4 SET Study_TS_Annual = 9.10, Annual_TS_Coverage = 0.5 WHERE Study_number = 4587
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number =4587
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =35.250 AND Longitude =127.750 AND [year] = 2003

-- 4609
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 4609
UPDATE SRDBV4 SET Study_TS_Annual = 24.17, Annual_TS_Coverage = 0.92 WHERE Study_number = 4609
UPDATE SRDBV4 SET TS_Flag = 'TAIR_1' WHERE Study_number =4609

-- 4768
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 4768
UPDATE SRDBV4 SET Study_TS_Annual = 0.68, Annual_TS_Coverage = 0.42 WHERE Study_number = 4768
UPDATE SRDBV4 SET TS_Flag = 'TAIR_7' WHERE Study_number =4768
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =38.250 AND Longitude =99.250 AND [year] =2005 

-- 4825
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 4825
UPDATE SRDBV4 SET Study_TS_Annual = 21.935, Annual_TS_Coverage = 1 WHERE Study_number = 4825
UPDATE SRDBV4 SET TS_Flag = 'TAIR_0' WHERE Study_number =4825

-- 4915
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 4915
UPDATE SRDBV4 SET Study_TS_Annual = 11.48, Annual_TS_Coverage = 1 WHERE Study_number = 4915 AND Record_number = 3581
UPDATE SRDBV4 SET Study_TS_Annual = 9.07, Annual_TS_Coverage = 1 WHERE Study_number = 4915 AND Record_number = 3582
UPDATE SRDBV4 SET TS_Flag = 'TAIR_0' WHERE Study_number =4915

-- 4927
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 4927
UPDATE SRDBV4 SET Study_TS_Annual = 9.79, Annual_TS_Coverage = 0.58 WHERE Study_number = 4927 AND [Year] = 2003
UPDATE SRDBV4 SET Study_TS_Annual = 10.67, Annual_TS_Coverage = 0.58 WHERE Study_number = 4927 AND [Year] = 2004
UPDATE SRDBV4 SET TS_Flag = 'TAIR_5' WHERE Study_number =4927
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =37.750 AND Longitude =127.750 AND [year] = 2003

-- 5184
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5184
UPDATE SRDBV4 SET Study_TS_Annual = 12.44, Annual_TS_Coverage = 0.77 WHERE Study_number = 5184 AND Record_number = 3434
UPDATE SRDBV4 SET Study_TS_Annual = 14.31, Annual_TS_Coverage = 0.77 WHERE Study_number = 5184 AND Record_number = 3435
UPDATE SRDBV4 SET Study_TS_Annual = 14.95, Annual_TS_Coverage = 0.77 WHERE Study_number = 5184 AND Record_number = 3436
UPDATE SRDBV4 SET TS_Flag = 'TAIR_3' WHERE Study_number =5184

-- 5273
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5273
UPDATE SRDBV4 SET Study_TS_Annual = 10.82, Annual_TS_Coverage = 0.83 WHERE Study_number = 5273
UPDATE SRDBV4 SET TS_Flag = 'TAIR_0' WHERE Study_number =5273

-- 5385
UPDATE SRDBV4 SET Study_TS_Annual = 9.8, Annual_TS_Coverage = 1 WHERE Study_number = 5385
UPDATE SRDBV4 SET TS_Flag = 'TAIR_0' WHERE Study_number =5385
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5385

-- 5520
UPDATE SRDBV4 SET Study_TS_Annual = 9.73, Annual_TS_Coverage = 0.83 WHERE Study_number = 5520
UPDATE SRDBV4 SET TS_Flag = 'TAIR_2' WHERE Study_number =5520
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5520
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =36.250 AND Longitude =137.250 AND [year] = 2005

-- 5526
UPDATE SRDBV4 SET Study_TS_Annual = 12.4, Annual_TS_Coverage = 0.5 WHERE Study_number = 5526 AND [Year] = 2007
UPDATE SRDBV4 SET Study_TS_Annual = 11.58, Annual_TS_Coverage = 0.5 WHERE Study_number = 5526 AND [Year] = 2008
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number =5526
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5526
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =36.250 AND Longitude =137.250 AND [year] = 2007

-- 5538
UPDATE SRDBV4 SET Study_TS_Annual = 12.47, Annual_TS_Coverage = 0.25 WHERE Study_number = 5538
UPDATE SRDBV4 SET TS_Flag = 'TAIR_8' WHERE Study_number =5538
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5538
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =36.250 AND Longitude =137.250 AND [year] = 2007

-- 5591
-- Seasonal model?
UPDATE SRDBV4 SET Study_TS_Annual = 4.5, Annual_TS_Coverage = 0.25 WHERE Study_number = 5591
UPDATE SRDBV4 SET TS_Flag = 'TAIR_8' WHERE Study_number =5591
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5591
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =42.250 AND Longitude =128.250 AND [year] = 2008

-- 5594
UPDATE SRDBV4 SET Study_TS_Annual = -0.97, Annual_TS_Coverage = 0.5 WHERE Study_number = 5594 AND Record_number = 4026
UPDATE SRDBV4 SET Study_TS_Annual = -0.97, Annual_TS_Coverage = 0.5 WHERE Study_number = 5594 AND Record_number = 4027
UPDATE SRDBV4 SET Study_TS_Annual = -0.87, Annual_TS_Coverage = 0.5 WHERE Study_number = 5594 AND Record_number = 4028
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number =5594
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5594
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =64.750 AND Longitude =-148.250 AND [year] = 2003

-- 5640
UPDATE SRDBV4 SET Study_TS_Annual = -0.5, Annual_TS_Coverage = 0.5 WHERE Study_number = 5640
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number =5640
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5640
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =55.750 AND Longitude =-98.250 AND [year] = 2008

-- 5732
UPDATE SRDBV4 SET Study_TS_Annual = 15.81, Annual_TS_Coverage = 1 WHERE Study_number = 5732
UPDATE SRDBV4 SET TS_Flag = 'TAIR_0' WHERE Study_number =5732
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5732

-- 5927
UPDATE SRDBV4 SET Study_TS_Annual = 18.87, Annual_TS_Coverage = 1 WHERE Study_number = 5927
UPDATE SRDBV4 SET TS_Flag = 'TAIR_0' WHERE Study_number =5927
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 5927

-- 6064
UPDATE SRDBV4 SET Study_TS_Annual = 10.472, Annual_TS_Coverage = 1 WHERE Study_number = 6064 And Year = 2002
UPDATE SRDBV4 SET Study_TS_Annual = 10.802, Annual_TS_Coverage = 1 WHERE Study_number = 6064 And Year = 2003
UPDATE SRDBV4 SET Study_TS_Annual = 10.472, Annual_TS_Coverage = 1 WHERE Study_number = 6064 And Year = 2004
UPDATE SRDBV4 SET TS_Flag = 'TAIR_0' WHERE Study_number =6064
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 6064

-- 6090
UPDATE SRDBV4 SET Study_TS_Annual = 8.09, Annual_TS_Coverage = 0.75 WHERE Study_number = 6090
UPDATE SRDBV4 SET TS_Flag = 'TAIR_4' WHERE Study_number =6090
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 6090
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =33.750 AND Longitude =112.250 AND [year] = 2009

-- 6219
UPDATE SRDBV4 SET Study_TS_Annual = 8.4, Annual_TS_Coverage = 0.5 WHERE Study_number = 6219
UPDATE SRDBV4 SET TS_Flag = 'TAIR_6' WHERE Study_number =6219
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 6219
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =40.250 AND Longitude = 140.750 AND [year] = 2008

-- 6292
UPDATE SRDBV4 SET Study_TS_Annual = 11.84, Annual_TS_Coverage = 0.42 WHERE Study_number = 6292
UPDATE SRDBV4 SET TS_Flag = 'TAIR_7' WHERE Study_number =6292
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 6292
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =43.250 AND Longitude =-7.750 AND [year] = 2007

-- 6355
UPDATE SRDBV4 SET Study_TS_Annual =10.145 , Annual_TS_Coverage = 0.82 WHERE Study_number = 6355
UPDATE SRDBV4 SET TS_Flag = 'TAIR_2' WHERE Study_number =6355
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 6355
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =37.750 AND Longitude =126.750 AND [year] = 2011

-- 6391
UPDATE SRDBV4 SET Study_TS_Annual = 8.07, Annual_TS_Coverage = 0.75 WHERE Study_number = 6391
UPDATE SRDBV4 SET TS_Flag = 'TAIR_3' WHERE Study_number =6391
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 6391
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =33.750 AND Longitude =112.250 AND [year] = 2008

-- 6446
UPDATE SRDBV4 SET Study_TS_Annual = 8.31, Annual_TS_Coverage = 0.83 WHERE Study_number = 6446
UPDATE SRDBV4 SET TS_Flag = 'TAIR_2' WHERE Study_number =6446
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 6446
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =52.750 AND Longitude =-7.250 AND [year] = 2009

-- 6458
UPDATE SRDBV4 SET Study_TS_Annual = 2.8, Annual_TS_Coverage = 0.58 WHERE Study_number = 6458
UPDATE SRDBV4 SET TS_Flag = 'TAIR_5' WHERE Study_number =6458
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 6458
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =49.750 AND Longitude =-74.250 AND [year] = 2008

-- 6493
UPDATE SRDBV4 SET Study_TS_Annual = 18.57, Annual_TS_Coverage = 0.83 WHERE Study_number = 6493
UPDATE SRDBV4 SET TS_Flag = 'TAIR_2' WHERE Study_number =6493
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 6493
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude =31.250 AND Longitude =-87.250 AND [year] = 2008


/* TS = 2.918 + 0.829*TAIR
-- 
UPDATE SRDBV4 SET Study_TS_Annual = , Annual_TS_Coverage =  WHERE Study_number = 
UPDATE SRDBV4 SET TS_Flag = 'TAIR_' WHERE Study_number =
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units, Record_number, Lat_Round, Long_Round, Study_TS_Annual, TAnnual_Del, Annual_coverage, Model_type, TS_Flag, [Year], Annual_TS_Coverage
	From SRDBV4 WHERE Study_number = 
SELECT * FROM [DelClimateDB].[dbo].[Global_T] WHERE Latitude = AND Longitude = AND [year] = 

*/

