
# ==============================================================================
# This code is for result check and quality check
# ==============================================================================

srdb <- read.csv( "MGRsD-data-v4-TSoil.csv", stringsAsFactors=F )

# In SRDB_V4, range are seperated into Model_temp_min and Model_temp_max
# printlog( "Splitting model temperate range strings..." )
# x <- str_split_fixed( srdb$Model_temp_range, ",", 2 )
# srdb$mtr_low <- as.numeric( x[ , 1 ] )
# srdb$mtr_high <- as.numeric( x[ , 2 ] )


# ==============================================================================
# create select subtest function
# ==============================================================================

colnames (srdb)

# n = 1518
# srdb$Study_temp

subtest_1 <- function (n) {
  subtest <- srdb[ which (srdb$Study_number == n), 
                   c( if( !is.na( srdb[which(srdb$Study_number == n),]$Study_TS_Annual ) ) {
                     which (colnames(srdb) == "Study_TS_Annual")
                   } 
                   else if ( !is.na( srdb[which(srdb$Study_number == n),]$Study_temp )) {
                     which (colnames(srdb) == "Study_temp")
                   }
                   else if ( !is.na( srdb[which(srdb$Study_number == n),]$TAnnual_Del )) {
                     which (colnames(srdb) == "TAnnual_Del")
                   }
                   else {
                     which (colnames(srdb) == "MAT")
                   } 
                   
                   
                   , which (colnames(srdb) == "Model_paramA")
                   , which (colnames(srdb) == "Model_paramB")
                   , which (colnames(srdb) == "Model_paramC")
                   , which (colnames(srdb) == "Model_paramD")
                   , which (colnames(srdb) == "Model_output_units")
                   , which (colnames(srdb) == "Model_type")
                   , which (colnames(srdb) == "Record_number")
                   , which (colnames(srdb) == "Study_number")
                   , which (colnames(srdb) == "Rs_annual")
                   , which (colnames(srdb) == "Rs_annual_bahn")
                   , which (colnames(srdb) == "Rs_TAIR_units")
                   , which (colnames(srdb) == "Study_TS_Annual")
                   , which (colnames(srdb) == "Study_temp")
                   , which (colnames(srdb) == "TAnnual_Del")
                   , which (colnames(srdb) == "Lat_Round")
                   , which (colnames(srdb) == "Long_Round")
                   ) ]
  
  colnames (subtest) <- c("T", "a", "b", "c", "d", "Model_output_units", "Model_type", "Record_number"
                          , "Study_number", "Rs_annual", "Rs_annual_bahn", "Rs_TAIR_units"
                          , "Study_TS_Annual", "Study_temp", "TAnnual_Del", "Lat_Round", "Long_Round" )
  
  return (subtest)
}




subtest_2 <- function (mot) {
  subtest <- srdb[which (srdb$Model_type == mot)
                  , c(which (colnames(srdb) == "TAnnual_Del") 
                      , which (colnames(srdb) == "Model_paramA")
                      , which (colnames(srdb) == "Model_paramB")
                      , which (colnames(srdb) == "Model_paramC")
                      , which (colnames(srdb) == "Model_paramD")
                      , which (colnames(srdb) == "Model_output_units")
                      , which (colnames(srdb) == "Model_type")
                      , which (colnames(srdb) == "Record_number")
                      , which (colnames(srdb) == "Study_number")
                      , which (colnames(srdb) == "Rs_annual")
                      , which (colnames(srdb) == "Rs_annual_bahn")
                      , which (colnames(srdb) == "Rs_TAIR_units")
                      , which (colnames(srdb) == "Study_TS_Annual")
                      , which (colnames(srdb) == "Study_temp")
                      , which (colnames(srdb) == "TAnnual_Del")
                  ) ]
  colnames (subtest) <- c("T", "a", "b", "c", "d", "Model_output_units", "Model_type", "Record_number"
                          , "Study_number", "Rs_annual", "Rs_annual_bahn", "Rs_TAIR_units"
                          , "Study_TS_Annual", "Study_temp", "TAnnual_Del" )
  
  return (subtest)
}

# subtest_1 (1518)
# subtest_2 ("Q10, R=a exp((bT-c)/10)")


# ==============================================================================
# check extreme calculation results
# fixed
# ==============================================================================
# 1518 2251 3600 4013 8602 Rs_Bahn > 10000
max(srdb$Rs_annual)
min(srdb$Rs_annual)

sort(srdb[!is.na(srdb$Rs_annual_bahn),]$Rs_annual_bahn)
srdb[srdb$Rs_annual_bahn > 4200 & !is.na(srdb$Rs_annual_bahn), ]$Study_number

# Study_number == 5766
# Elevation effects TS
subtest <- subtest_1 (5766)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (( 1 / subtest$c) - ( 1 / ( subtest$T + 273.15 -subtest$d ))))
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual

# Study_number == 4614
# Elevation effects TS
subtest <- subtest_1 (4614)
34.88*exp(-0.05*24.91) /0.9645 * 365
subtest$rs <- subtest$a * exp( subtest$b * subtest$T)
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same

srdb[srdb$Rs_annual_bahn < 500 & srdb$Rs_annual > 1000, ]$Study_number

# Study_number == 3801
# Rs_annual = Rs_annual * 12 / 44
subtest <- subtest_1 (3801)
subtest
subtest$rs <- subtest$a * exp( subtest$b * subtest$T)
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual*12/44

AT <- seq (0,40,0.5)
rs <- 39.449*exp(0.0414*AT)

qplot(AT, rs, ylim = c(0,600))

rs_annual_forest <- 11.301*exp(0.073*18) * 0.0001 * 365*24
rs_annual_dryland <- 4.3737*exp(0.1018*18) * 0.0001 * 365*24
rs_annual_orchard <- 16.734*exp(0.0632*18) * 0.0001 * 365*24
rs_annual_paddy <- 39.449*exp(0.0414*18) * 0.0001 * 365*24

# Study 5178
subtest <- subtest_1 (5178)
subtest

2.75/0.9645 * 365
0.1521*exp(0.1021*22.2) /0.9645 * 365

# Study 6372
# According to Table 4, Model_paramB = 0.07231
subtest <- subtest_1 (6372)
subtest

# Study 2534
# According to Table 4, Model_paramB = 0.07231
subtest <- subtest_1 (2534)
subtest

# Study number 5227
unique (srdb$Study_number)
subtest <- subtest_1 (5227)
subtest
subtest_2 ('Exponential (other), R=a*exp(ln(b (T-c)/c))')

subtest$rs <- 0.573*exp(0.0924*10.592)
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual

AT <- c (7.954,6.277,6.169,5.787,8.065,9.976,12.07,18.201,16.167,14.501,11.549,9.974,9.751,5.541)
rs <- c(0.833,1.167,1.215,1.287,1.746,2.12,2.867,4.389,1.876,1.387,0.935,1.907,1.355,0.462)
m <-nls(rs ~ a*exp(log(b * (AT - c)/10)), start=list(a=2.4,b=0.114, c=1.19))
qplot(AT, rs)

# 6451
unique (srdb$Study_number)
subtest <- subtest_1 (6451)

# *****************************************************************************************
# Find out studies wiht Rs_Annual_Bahn = 0, but Rs_Annual is != 0
# *****************************************************************************************

srdb_Bahn_null <- subset( srdb, Rs_annual_bahn < 50 )

unique(srdb_Bahn_null$Study_number)


# *****************************************************************************************
# Check Site, lat, long, model type, model parameter one by one: 87
# *****************************************************************************************
# [1]   68   77  267  316  395  447 1078 1292 1647 1665 1700 1871 1891 1987 2349 2372 2412 2534 2656 2771 3052
# [22] 3130 3273 3302 3326 3333 3343 3344 3429 3561 3618 3675 3700 3710 3801 3873 3885 3893 4045 4122 4166 4182
# [43] 4303 4383 4459 4614 4616 4630 4853 4934 4938 5125 5178 5227 5278 5303 5317 5325 5326 5327 5436 5441 5467
# [64] 5521 5522 5524 5701 5702 5766 5824 5929 5935 6070 6088 6152 6272 6334 6372 6381 6396 6451 6492 6548 6566
unique (srdb$Study_number)
subtest <- subtest_1 (6566)
subtest
subtest_2 ('Exponential (other), R=a*exp(ln(b (T-c)/c))')

mean(subtest$Rs_annual)
mean(subtest$Rs_annual_bahn)


# Study_number == 8542
subtest <- subtest_1 (8542)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (( 1 / subtest$c) - ( 1 / ( subtest$T + 273.15 -subtest$d ))))
subtest$rs <- 2
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual

# Study_number == 5725
subtest <- subtest_1 (5725)
subtest
attach(subtest)
subtest$rs <- a + b * ( T - d ) + c * ( T - d ) ^ 2
-0.2189 + 0.0964 * ( 16.576 ) + -0.0025 * ( 16.576 ) ^ 2
455.8 * (0.59 * conv) ^ 1.0054	# Bahn et al. function

ST <- seq(5, 30, 1)
rs1 <- 0.416 + 0.0024 * ( ST ) + -0.0018 * ( ST ) ^ 2
rs1 <- -0.1226 + 0.054 * ( ST ) + -0.0014 * ( ST ) ^ 2
qplot(ST, rs1, xlim = c(0,35), ylim = c(0,1))

# *****************************************************************************************
# check results
# 8382, 8334
# *****************************************************************************************
srdb[srdb$Rs_annual_bahn > 9000,]$Study_number
subtest <- subtest_1 (8382)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (( 1 / subtest$c) - ( 1 / ( subtest$T + 273.15 -subtest$d ))))
subtest$rs <- 2
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual

# 8384
subtest <- subtest_1 (8334)
subtest

# Model Type not including in the calculating function
unique(srdb[is.na(srdb$Rs_annual_bahn),]$Model_type)
unique(srdb$Model_type)

# caused by estimates < 0
subset <- subtest_2("Polynomial, R=a+b(T-d)+c(T-d)^2")
subset[is.na(subset$Rs_annual_bahn),]

subset <- subtest_1(5591)

