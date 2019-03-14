USE [SRDBStagging]
GO

/**********************************************************************************************
1. Check extreme values
# due to Equation issue
***********************************************************************************************/

-- 1518 2251 3600 4013 8602 Rs_Bahn > 10000
SELECT DISTINCT (SRDBV4.Model_type) FROM SRDBV4 ORDER BY Model_type -- 32 model type

-- 1518 Do not have R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K this in SRDBV4
SELECT SRDBV4.Model_type From SRDBV4 WHERE Study_number = 1518
UPDATE [SRDBV4] SET Model_type = 'R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K' WHERE [study_number] = 1518

-- 2251 Do not have R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K this in SRDBV4
SELECT SRDBV4.Model_type From SRDBV4 WHERE Study_number = 2251
UPDATE [SRDBV4] SET Model_type = 'R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K' WHERE [study_number] = 2251

-- 3600, Model_Type should be: Linear, R=a+b(T-c)
-- ParameterA and ParameterB should be
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual From SRDBV4 WHERE Study_number = 3600
SELECT * From SRDBV4 WHERE Study_number = 3600
UPDATE [SRDBV4] SET Model_type = 'Linear, R=a+b(T-c)' WHERE [study_number] = 3600
UPDATE [SRDBV4] SET Model_paramA =-0.0909, Model_paramB =0.0366, Site_name = 'Mt_Kumdan_RF' WHERE [study_number] = 3600 AND Record_number = 3253
UPDATE [SRDBV4] SET Model_paramA =-0.0765, Model_paramB =0.0328 , Site_name = 'Mt_Kumdan_IF' WHERE [study_number] = 3600 AND Record_number = 3254
UPDATE [SRDBV4] SET Model_paramA =-0.1303, Model_paramB =0.0386 , Site_name = 'Mt_Kumdan_CS' WHERE [study_number] = 3600 AND Record_number = 3255

-- 4013 Exponential, R=a exp(b(T-c)), change to "Linear, R=a+b(T-c)" 
-- # units change to mol C/m2/yr
SELECT SRDBV4.Model_type, Model_output_units, Model_paramA, Model_paramB, Model_paramC, Model_paramD From SRDBV4 WHERE Study_number = 4013
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a exp(b(T-c))' WHERE [study_number] = 4013
UPDATE [SRDBV4] SET Model_output_units = 'mol C/m2/yr' WHERE [study_number] = 4013

-- 8602 Exponential, R=a exp(b(T-c)), change to Linear, R=a+b(T-c)
SELECT SRDBV4.Model_type, Model_paramC, Study_temp, TAnnual_Del, MAT From SRDBV4 WHERE Study_number = 8602
UPDATE [SRDBV4] SET Model_type = 'Q10, R=a b^((T-c)/10)' WHERE [study_number] = 8602
UPDATE [SRDBV4] SET Model_paramC = 10 WHERE [study_number] = 8602



/************************************************************************************************/
-- Rs_Annual_Bahn NA Issue
/************************************************************************************************/
-- Study number 6462
SELECT * FROM [SRDBV4] Where Study_Number = 6462
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual From SRDBV4 WHERE Study_number = 6462
-- c shoube be 10, d should be -46.02
-- but also have a WTL conponent, and is just for Rh, need make a flag
UPDATE [SRDBV4] SET Model_type = 'R10 (L&T), R=a exp(b((1/c)-(1/T+d))(WTL), Rh', Model_paramC = 10, Model_paramD = -46.02
	WHERE [study_number] = 6462


-- Study number 7290
SELECT * FROM [SRDBV4] Where Study_Number = 7290
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual From SRDBV4 WHERE Study_number = 7290
-- 7290: "Exponential, ln(R)=a+exp(b(T-c))" should change to "Exponential, R=a exp(b(T-c))" 
-- Model_paramB should change to log(Model_paramB)/10
-- Model_paramC should change to 10
SELECT log(Model_paramB)/10 FROM SRDBV4 WHERE [study_number] = 7290
-- UPDATE [SRDBV4] SET Model_paramB = log(Model_paramB)/10	WHERE [study_number] = 7290
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a exp(b(T-c))', Model_paramC = 10	WHERE [study_number] = 7290

/**********************************************************************************************
Check unique(srdb$Model_output_units)
***********************************************************************************************/
-- gC/m2/hr need change to g C/m2/hr
-- gC/m2/day need change to g C/m2/day
-- mgC/m2/hr need change to mg C/m2/hr
-- gCO2/m2/day need change to g CO2/m2/day
-- umolCO2/m2/s need change to umol CO2/m2/s
SELECT DISTINCT Model_output_units FROM [dbo].[SRDBV4] ORDER BY Model_output_units

SELECT * FROM [SRDBV4] WHERE Model_output_units = 'gC/m2/hr'
UPDATE [dbo].[SRDBV4] SET Model_output_units = 'g C/m2/hr' WHERE Model_output_units = 'gC/m2/hr'
UPDATE [dbo].[SRDBV4] SET Model_output_units = 'g C/m2/day' WHERE Model_output_units = 'gC/m2/day'
UPDATE [dbo].[SRDBV4] SET Model_output_units = 'mg C/m2/hr' WHERE Model_output_units = 'mgC/m2/hr'
UPDATE [dbo].[SRDBV4] SET Model_output_units = 'g CO2/m2/day' WHERE Model_output_units = 'gCO2/m2/day'
UPDATE [dbo].[SRDBV4] SET Model_output_units = 'umol CO2/m2/s' WHERE Model_output_units = 'umolCO2/m2/s'

SELECT * FROM [SRDBV4] WHERE Model_output_units = 'gC/m2/day'


/**********************************************************************************************
Check srdb NA prediction issue
***********************************************************************************************/

-- Study number 395
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual, Record_number From SRDBV4 WHERE Study_number = 395
-- Model type should change to ""Linear, R=a+b(T^2)""
-- Model_paramA change to 11 and 31
-- Model_paramB change to 0.42 and 0.58
-- Model_paramC change to NULL
-- Table 3 in the paper

UPDATE [SRDBV4] SET Model_type = 'Linear, R=a+b(T^2)', Model_paramA = 11, Model_paramB = 0.42, Model_paramC = NULL	WHERE [study_number] = 395 AND Record_number = 1655
UPDATE [SRDBV4] SET Model_type = 'Linear, R=a+b(T^2)', Model_paramA = 31, Model_paramB = 0.58, Model_paramC = NULL	WHERE [study_number] = 395 AND Record_number = 1656


-- Study number 1384, parameter seems wrong, calculated Rs is negative, or due to the TS vs TA issue
-- Study number 5591, parameter seems wrong, calculated Rs is negative, or due to the TS vs TA issue

-- Study number 8079
--# Parameter D change to 0
-- According to Figure 8 in the paper, the model for the forest cannot be used, because it is only for summer
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD Rs_annual, Record_number From SRDBV4 WHERE Study_number = 8079
UPDATE [SRDBV4] SET Model_paramD = 0 WHERE [study_number] = 8079 AND Record_number = 6621

-- Study number 8382
-- According to table 2 and equation 1, model type should change to 'R10 (L&T), R=a exp(b((1/56.02)-1/(T-227.13)) exp(-exp(c-d SWC))'
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual From SRDBV4 WHERE Study_number = 8382
UPDATE [SRDBV4] SET Model_type = 'R10 (L&T), R=a exp(b((1/56.02)-1/(T-227.13)) exp(-exp(c-d SWC))'	WHERE [study_number] = 8382

-- Study number 109
--# a,b,c,d should be 0, 0, 0.0444, NULL
--# according to Table 1
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual From SRDBV4 WHERE Study_number = 109
UPDATE [SRDBV4] SET Model_type = 'Power, R=c T^2', Model_paramA = 0, Model_paramB = 0, Model_paramD = NULL WHERE [study_number] = 109

-- Study number 390
-- Model with SWC component, make a notes?

-- Study number 680
-- For the Gum Swamp site, model with water table depth, make a notes?

-- Study number 1116
-- Model with ground water table variable, make a notes?

-- Study number 1324
-- Model_paramA, B, C, D change to 2.414, 7.483e-12, 1.176, NUL
-- Digitized the data, and use the same equation formate simulated the model
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual, Record_number From SRDBV4 WHERE Study_number = 1324
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a+b exp(T/c)', Model_paramA = 2.414, Model_paramB = 7.483e-12, Model_paramC =1.176, Model_paramD = NULL 
	WHERE [study_number] = 1324 AND Record_number = 3247
SELECT 7.483e-12


-- Study number 2182
-- Model type change to "Exponential (other), ln(R)=a+b(T+d)+c(T+d)^2"
-- Model_paramD change to 10
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD
	, Rs_annual From SRDBV4 WHERE Study_number = 2182
UPDATE [SRDBV4] SET Model_type = 'Exponential (other), ln(R)=a+b(T+d)+c(T+d)^2', Model_paramD = 10 WHERE [study_number] = 2182

-- Study number 2325
-- Model type change to "Exponential (ln1), ln(R)=a+b(T-c)" 
-- Model type change to "Exponential (ln1), ln(R)=a+b(T-c)SWC" 
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual, Record_number From SRDBV4 WHERE Study_number = 2325
UPDATE [SRDBV4] SET Model_type = 'Exponential (ln1), ln(R)=a+b(T-c)' WHERE [study_number] = 2325 AND Model_paramC IS NOT NULL
UPDATE [SRDBV4] SET Model_type = 'Exponential (ln1), ln(R)=a+b(T-c)SWC' WHERE [study_number] = 2325 AND Model_paramC IS NULL

--# study number 2541
--# model has SWC component, digitize the model and redo the regression?

--# study number 3619
--# model type change to "Exponential (other), R=a*b^(ct)"
-- Model_paramC change to 0.1
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual From SRDBV4 WHERE Study_number = 3619
UPDATE [SRDBV4] SET Model_type = 'Exponential (other), R=a*b^(ct)', Model_paramC = 0.1 WHERE [study_number] = 3619

--# study number 4614
--# model type change to "Exponential, R=a exp(b(T-c))"
--# From table 1
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Rs_annual From SRDBV4 WHERE Study_number = 4614
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a exp(b(T-c))' WHERE [study_number] = 4614

--# study number 5162
--# model type change to "Arrhenius, R=a*exp(b/c (1/d-1/T)), T in K"
--# according to equation 2 and table 4
--# c = R = 8.134, d = Tref = 283.16
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual From SRDBV4 WHERE Study_number = 5162
UPDATE [SRDBV4] SET Model_type = 'Arrhenius, R=a*exp(b/c (1/d-1/T)), T in K', Model_paramC = 8.134, Model_paramD = 283.16 WHERE [study_number] = 5162


--# study number 5227
--# model type change to "Exponential (other), R=a*exp(ln(b (T-c)/c))" Add model 10
--# according to Figure 8
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual From SRDBV4 WHERE Study_number = 5227
UPDATE [SRDBV4] SET Model_type = 'Exponential (other), R=a*exp(ln(b (T-c)/c))' WHERE [study_number] = 5227

--# study number 7238 ? TAnnual got a problem???
--# model type change to 'Q10, R=a b^((T-c)/10)'
--# parameter c = Tb = 24 (section 2.5.1 in the paper)
--# Equation 1 in the paper
-- Longitude should change from 75.75 to -75.75
SELECT MAP, MAT, PAnnual, TAnnual FROM [DelClimateDB].[dbo].[Global_P] WHERE [Latitude] = 35.75 
	AND [Longitude] = -75.75 AND [Year] = 2011

SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, TAnnual_Del, MAP_Del,Longitude From SRDBV4 WHERE Study_number = 7238
SELECT * From SRDBV4 WHERE Study_number = 7238
UPDATE [SRDBV4] SET Model_type = 'Q10, R=a b^((T-c)/10)', MAT = 16.8, Longitude = -75.9
	, TAnnual_Del = 17.14, PAnnual_Del = 1081.7, MAT_Del= 17, MAP_Del = 1201.94
WHERE [study_number] = 7238

UPDATE [SRDBV4] SET Model_paramC = 24 WHERE [study_number] = 7238

--# study number 7695
--# model type change to "Exponential, R=a exp(b(T-c))"
--# Table 3 and equation 1
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual From SRDBV4 WHERE Study_number = 7695
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a exp(b(T-c))' WHERE [study_number] = 7695


--# study number 7727
--# model type change to "Exponential, R=a exp(b(T-c))"
--# Figure 2
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual From SRDBV4 WHERE Study_number = 7727
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a exp(b(T-c))' WHERE [study_number] = 7727

--# study number 8117
--# model type change to "Exponential, R=a exp(b(T-c))"
--# Figure 5
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual From SRDBV4 WHERE Study_number = 8117
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a exp(b(T-c))' WHERE [study_number] = 8117

--# study number 8186
--# model type change to "Exponential, R=a exp(b(T-c))"
--# Table 3
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual From SRDBV4 WHERE Study_number = 8186
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a exp(b(T-c))' WHERE [study_number] = 8186




/* *****************************************************************************************
# Find out studies wiht Rs_Annual_Bahn = 0, but Rs_Annual is != 0
 ******************************************************************************************/

--# study number 3733
--# The author reported the model wrong in Fig 3, these models should be exponential model rather than power function
--# In the fig caption, the author said is exponential model, and if use exponential model, I got the same figure
--# If use the power function, it is way off from the figure
--# Model type shuld change to "Exponential, R=a exp(b(T-c))"

SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual From SRDBV4 WHERE Study_number = 3733
UPDATE [SRDBV4] SET Model_type = 'Exponential, R=a exp(b(T-c))' WHERE [study_number] = 3733


--# study number 5317
--# According to Table 3 and description of Equation (1) 
-- Model_paramC = 10 (unit should be in C)
--# Model type shuld change to "R10 (L&T), R=a exp(b((1/(c-d))-(1/(T-d)))"
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual 
	From SRDBV4 WHERE Study_number = 5317
UPDATE [SRDBV4] SET Model_type = 'R10 (L&T), R=a exp(b((1/(c-d))-(1/(T-d)))', Model_paramC = 10 WHERE [study_number] = 5317


--# Study number 5766
--# According to Figure 4
--# Soil temperature is not in K
--# Model_type change to: "R10 (L&T), R=a exp(b((1/c)-(1/(T-d)))"
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual 
	From SRDBV4 WHERE Study_number = 5766
UPDATE [SRDBV4] SET Model_type = 'Arrhenius, R=a exp(-b/c(T-d))' WHERE [study_number] = 5766


--# Study number 6219
--# Table 2 and equation 7
--# Model_paramC change to 0
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units From SRDBV4 WHERE Study_number = 6219
UPDATE [SRDBV4] SET Model_paramC = 0 WHERE [study_number] = 6219

--# Study number 6272
--# Table 3 and 4, the unit in Figure 4 should be wrong
--# Unit change to "umol CO2/m2/s"
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units From SRDBV4 WHERE Study_number = 6272
UPDATE [SRDBV4] SET Model_output_units = 'umol CO2/m2/s' WHERE [study_number] = 6272

--# Study number 6566
--# According to Ewuation 8 in J. Lloyd, J.A. Taylor, On the temperature dependence of soil respiration, Funct. Ecol. 8 (1994) 315 e 323.
--# Equation (3) in this study should be wrong
--# Model change to "R10 (L&T), R=a exp(b/((273.15+c)*8.314)*(1-(273.15+c)/T)), T in K"
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units From SRDBV4 WHERE Study_number = 6566
UPDATE [SRDBV4] SET Model_type = 'R10 (L&T), R=a exp(b/((273.15+c)*8.314)*(1-(273.15+c)/T)), T in K' WHERE [study_number] = 6566


--# Study number 8866
--# According to Table 1, unit here should be "g CO2/m2/hr" ?
--# Unit change to "g CO2/m2/hr"
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units From SRDBV4 WHERE Study_number = 8866
UPDATE [SRDBV4] SET Model_output_units = 'g CO2/m2/hr' WHERE [study_number] = 8866

--# Study number 2182
-- # checked, TS TA issue
SELECT SRDBV4.Model_type, SRDBV4.Site_name, Model_paramA, Model_paramB, Model_paramC, Model_paramD, Rs_annual
	, Model_output_units From SRDBV4 WHERE Study_number = 2182


/**********************************************************************************************
Output data
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
ORDER BY Study_number

SELECT Lat_Round, Long_Round, [Year], MAP,MAT,Study_Precip, Study_temp
	, MAP_Del, MAT_Del, PAnnual_Del, TAnnual_Del FROM [SRDBV4] WHERE [study_number] = 864


/**********************************************************************************************
Calculate SPI
Need discuss
***********************************************************************************************/

SELECT SRDBV4.Model_type, Model_paramC, Study_temp, TAnnual_Del, MAT From SRDBV4 WHERE Study_number = 6479

/**********************************************************************************************
Output data: SRDB
***********************************************************************************************/

--ALTER TABLE [SRDBV4] ADD PRECIP_SD Numeric (18,3), TAIR_SD Numeric (18,3), SPI Numeric (18,3)

UPDATE [SRDBV4] SET [SRDBV4].PRECIP_SD = P.PRECIP_SD, [SRDBV4].TAIR_SD = P.TAIR_SD
FROM [SRDBV4] AS S
INNER JOIN [DelClimateDB].[dbo].[Global_P] AS P
ON P.Latitude = S.Lat_Round AND P.Longitude = S.Long_Round

UPDATE [SRDBV4] SET [SRDBV4].SPI = P.SPI
FROM [SRDBV4] AS S
INNER JOIN [DelClimateDB].[dbo].[Global_P] AS P
ON P.Latitude = S.Lat_Round AND P.Longitude = S.Long_Round AND P.[Year] = S.[Year]


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

/**********************************************************************************************
SPI IS NULL Issue
***********************************************************************************************/

SELECT Lat_Round, Long_Round, PRECIP_SD, TAIR_SD, SPI FROM [dbo].[SRDBV4]
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
	AND [dbo].[SRDBV4].SPI IS NULL
ORDER BY Lat_Round, Long_Round

-- 1
SELECT [Latitude], Longitude, PRECIP_SD, TAIR_SD, SPI FROM [DelClimateDB].[dbo].[Global_P]
	WHERE [Latitude] = 6.75 AND Longitude = 2.25
SELECT Lat_Round, Long_Round, PRECIP_SD, TAIR_SD, SPI FROM [dbo].[SRDBV4] WHERE Lat_Round = 6.25 AND Long_Round = 2.25
UPDATE [dbo].[SRDBV4] SET PRECIP_SD = 225.756, TAIR_SD = 0.391, SPI = -0.02 WHERE Lat_Round = 6.25 AND Long_Round = 2.25

--2
SELECT [Latitude], Longitude, PRECIP_SD, TAIR_SD, SPI FROM [DelClimateDB].[dbo].[Global_P]
	WHERE [Latitude] = 28.25 AND Longitude = -16.75
SELECT Study_number, Lat_Round, Long_Round, PRECIP_SD, TAIR_SD, SPI FROM [dbo].[SRDBV4] WHERE Lat_Round = 28.75 AND Long_Round = -27.25
UPDATE [dbo].[SRDBV4] SET PRECIP_SD = 126.968, TAIR_SD = 0.594, SPI = -0.07 WHERE Lat_Round = 28.75 AND Long_Round = -27.25

--3
SELECT [Latitude], Longitude, PRECIP_SD, TAIR_SD, SPI FROM [DelClimateDB].[dbo].[Global_P]
	WHERE [Latitude] = 34.25 AND Longitude = 132.75
SELECT Study_number, Lat_Round, Long_Round, PRECIP_SD, TAIR_SD, SPI FROM [dbo].[SRDBV4] WHERE Lat_Round = 34.25 AND Long_Round = 132.25
UPDATE [dbo].[SRDBV4] SET PRECIP_SD = 259.858, TAIR_SD = 0.471, SPI = 0.05 WHERE Lat_Round = 34.25 AND Long_Round = 132.25

--4
SELECT [Latitude], Longitude, PRECIP_SD, TAIR_SD, SPI FROM [DelClimateDB].[dbo].[Global_P]
	WHERE [Latitude] = 42.25 AND Longitude = 142.75
SELECT Study_number, Lat_Round, Long_Round, PRECIP_SD, TAIR_SD, SPI FROM [dbo].[SRDBV4] WHERE Lat_Round = 42.25 AND Long_Round = 142.25
UPDATE [dbo].[SRDBV4] SET PRECIP_SD = 177.275, TAIR_SD = 0.515, SPI = 0.016 WHERE Lat_Round = 42.25 AND Long_Round = 142.25

--5
SELECT [Latitude], Longitude, PRECIP_SD, TAIR_SD, SPI FROM [DelClimateDB].[dbo].[Global_P]
	WHERE [Latitude] = 45.25 AND Longitude = 11.75
SELECT Study_number, Lat_Round, Long_Round, PRECIP_SD, TAIR_SD, SPI FROM [dbo].[SRDBV4] WHERE Lat_Round = 45.25 AND Long_Round = 12.25
UPDATE [dbo].[SRDBV4] SET PRECIP_SD = 142.805, TAIR_SD = 0.853, SPI = 0.075 WHERE Lat_Round = 45.25 AND Long_Round = 12.25
/**********************************************************************************************
Summarized climate data
***********************************************************************************************/

SELECT [Latitude] ,[Longitude], [MAT], [MAP]
FROM [DelClimateDB].[dbo].[Global2010PT]


