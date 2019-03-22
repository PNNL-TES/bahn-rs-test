


rm (list = ls())
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()

source( "0-header.R" )
# install.packages("stringr")
loadlibs( c( "ggplot2", "stringr" ) )

SCRIPT			<- "2-bahn_processing.R"
INFN 			  <- "srdb-data-v4-climate.csv"
OUTFN 			<- "srdb-data-processed.csv"
SRDB_DIR    <- "E:/PNNL/bahn-rs-test/srdb_v4"
fn <- paste( SRDB_DIR, INFN, sep="/" )

CONVERSIONS		<- "srdb-conversions.csv"
conversions <- read.csv( paste( SRDB_DIR, CONVERSIONS, sep="/" ), stringsAsFactors=F )

sink( paste0( LOG_DIR, SCRIPT, ".txt" ), split=T )
printlog( "Welcome to", SCRIPT )

theme_set( theme_bw() )

printlog( "Reading", OUTFN )
srdb <- read.csv( OUTFN, stringsAsFactors=F )
printdims( srdb )

# In SRDB_V4, range are seperated into Model_temp_min and Model_temp_max
# printlog( "Splitting model temperate range strings..." )
# x <- str_split_fixed( srdb$Model_temp_range, ",", 2 )
# srdb$mtr_low <- as.numeric( x[ , 1 ] )
# srdb$mtr_high <- as.numeric( x[ , 2 ] )

# ==============================================================================
# check model output units
# fixed
# ==============================================================================
unique(srdb$Model_output_units)
# gC/m2/hr need change to g C/m2/hr
# gC/m2/day need change to g C/m2/day
# mgC/m2/hr need change to mg C/m2/hr
# gCO2/m2/day need change to g CO2/m2/day
# umolCO2/m2/s need change to umol CO2/m2/s


# ==============================================================================
# check extreme calculation results
# fixed
# ==============================================================================


sort(srdb[!is.na(srdb$Rs_annual_bahn),]$Rs_annual_bahn)
srdb[srdb$Rs_annual_bahn > 10000 & !is.na(srdb$Rs_annual_bahn), ]$Study_number



# 1518 2251 3600 4013 8602 Rs_Bahn > 10000
max(srdb$Rs_annual)
min(srdb$Rs_annual)



# which (srdb$Study_number == 1518) , Model_type change to: "R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K"
subtest <- subtest_1 (1518)

subtest$rs <- subtest$a * exp( subtest$b * (( 1 / subtest$c) - ( 1 / ( subtest$T + 273.15 -subtest$d ))))
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual

# which (srdb$Study_number == 2251) , Model_type change to: "R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K" *************
subtest <- subtest_1 (2251)

subtest$rs <- subtest$a * exp( subtest$b * (( 1 / subtest$c) - ( 1 / ( subtest$T + 273.15 -subtest$d ))))
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# which (srdb$Study_number == 3600) , Cannot find out the equation in the paper" *************
subtest <- subtest_1 (3600)

subtest$rs <- subtest$a + subtest$b * (( subtest$T - subtest$c) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# which (srdb$Study_number == 4013) , Model_type should be linear, change to "Linear, R=a+b(T-c)" **********
# units change to mol C/m2/yr
subtest <- subtest_1 (4013)

subtest$rs <- subtest$a + subtest$b * (subtest$T - subtest$c)
subtest$rs <- subtest$a * exp (subtest$b * (subtest$T - subtest$c)) 
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# which (srdb$Study_number == 8602) , Model_type change to: " Q10, R=a b^((T-c)/10)  "
# and c should change to 10

subtest <- subtest_1 (8602)

subtest$rs <- subtest$a * subtest$b ^((subtest$T - 10)/10)
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual


# ==============================================================================
# check NA calculation results
# check Model_type
# ==============================================================================
unique (srdb[is.na(srdb$Rs_annual_bahn), ]$Model_type)
unique (srdb[is.na(srdb$Rs_annual_bahn), ]$Study_number)

# need added Model_type
# Added 1 - "Arrhenius, R=a*exp(-b/RT), T in K"
subtest <- subtest_2 ("Arrhenius, R=a*exp(-b/RT), T in K")
subtest$rs <- subtest$a * exp(-subtest$b /(0.008314*(subtest$T+273.15)) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# Added 3 - "Exponential, R=exp(a+bT)"
# 6479 
subtest <- subtest_1 (6479)
subtest$rs <- exp(subtest$a + subtest$b * subtest$T  )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual


# Added 4  
# 7290: "Exponential, ln(R)=a+exp(b(T-c))" should change to "Exponential, R=a exp(b(T-c))" 
# Model_paramB change to log(subtest$Model_paramB)/10 
# Model_paramC change to = 10
# According to paper pg 4 description on formular (2)
# subtest$b = log(subtest$b)/10
# exp(2)
# log(7.389)
# subtest$a * exp(subtest$b)
subtest <- subtest_1 (7290)
subtest$rs <- subtest$a * exp(subtest$b * (subtest$T - 10)  ) 
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# ==============================================================================
# check NA calculation results 2
# ==============================================================================
unique (srdb[is.na(srdb$Rs_annual_bahn), ]$Study_number)
# 109  390  395  680 1116 1324 1384 2182 2325 2437 2541 2560 3619 4155 4212 4614 5162 5184 5216
# 5227 5273 5591 6219 6462 7238 7695 7727 8079 8117 8186 8382
unique (srdb[is.na(srdb$Rs_annual_bahn), ]$Model_type)
# [1] "Other"                                            
# [2] "Exponential (2nd order), R=exp(a+b(T-d)+c(T-d)^2)"
# [3] "Linear, R=a+b(T-c)"                               
# [4] "Exponential, R=a exp(b(T-c))"                     
# [5] "R10 (L&T), R=a exp(b((1/c)-(1/T+d))(WTL), Rh"     
# [6] ""                                                 
# [7] "Polynomial, R=a+b(T-d)+c(T-d)^2"                  
# [8] "R10 (L&T), R=a exp(b((1/c)-(1/T-d))"

# "Exponential (2nd order), R=exp(a+b(T-d)+c(T-d)^2)"

# Study number 395 Model_paramD should change to ""Linear, R=a+b(T^2)""
# Model_paramA change to 11 and 31
# Model_paramB change to 0.42 and 0.58
# Model_paramA change to 0
# Table 3 in the paper
# Add Model 4
subtest <- subtest_1 (395)
subtest$rs <- 31 + 0.58 * subtest$T^2 
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual



# model Exponential, R=a exp(b(T-c))
# 2560, use MAT if both study_temp and TAnnual_Del Null
subtest <- subtest_1 (2560)
subtest


#************************************************************************************
subtest <- subtest_2 ("Other")
unique(subtest$Study_number)

# 109  390  680 1116 1324 2182 

# study number 109
# a,b,c,d should be NULL, NULL, 0.0444, NULL
# according to Table 1
subtest <- subtest_1 (109)
subtest$rs <- subtest$c * subtest$T^2 
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual


Rs <- c(2.232,2.661,2.536,2.526,2.525,2.649,2.839,3.222,3.545,4.244)
ta <- c(26.476,26.510,26.777,27.329,28.014,28.698,29.201,29.585,30.370,30.805)
m <-nls(Rs~a + b*exp(ta/c), start=list(a=2.4,b=0.114, c=1.19))
plot (Rs ~ ta)
lines(ta,predict(m),col="red",lty=2,lwd=3)

subtest$rs <- 2.414 + 7.483e-12*exp(subtest$T/1.176) 
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# study number 2182
# parameter d should change to NULL
subtest <- subtest_1 (2182)
subtest
subtest$rs <- exp(subtest$a + subtest$b*(subtest$T+10) + subtest$c*(subtest$T+10)^2)
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# 2325 2437 2541 3619 4155 4212 
# study number 2325
subtest <- subtest_1 (2325)
subtest
exp(1.09)
subtest$rs <- exp(subtest$a + subtest$b*(subtest$T) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual





# study number 3619
# model type change to "Exponential (other), R=a*b^(ct)"
# parameter c change to 0.1
subtest <- subtest_1 (3619)
subtest
subtest$rs <- subtest$a * subtest$b^(subtest$T * subtest$c)
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual



# 4614 5162 5184 5216 5227 5273 7238
# study number 4614
# model type change to "Exponential, R=a exp(b(T-c))""
# table 1
subtest <- subtest_1 (4614)
subtest
subtest$rs <- subtest$a * exp( subtest$b*(subtest$T - subtest$c) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual


# study number 5162
# model type change to "Arrhenius, R=a*exp(b/c (1/d-1/T)), T in K"
# according to equation 2 and table 4
# c = R = 8.134, d = Tref = 283.16
subtest <- subtest_1 (5162)
subtest
subtest$rs <- subtest$a * exp( subtest$b / 8.134 * (1/283.16 - 1/(subtest$T + 273.15)) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual


# study number 5227
# model type change to "Exponential (other), R=a*exp(ln(b (T-c)/c))" Add model 10
# according to Figure 8
subtest <- subtest_1 (5227)
subtest
subtest$rs <- subtest$a * exp( log( subtest$b *(subtest$T - subtest$c)/subtest$c ) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual



# study number 7238
# model type change to "Q10, R=a b^((T-c)/10)"
# parameter c = Tb = 24 (section 2.5.1 in the paper)
# Equation 1 in the paper
subtest <- subtest_1 (7238)
subtest
subtest$rs <- subtest$a * subtest$b^( (subtest$T - 24)/10 )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual


# *****************************************************************************************
subtest <- subtest_2 ("")
unique(subtest$Study_number)
# 7695 7727 8117 8186

# study number 7695
# model type change to "Exponential, R=a exp(b(T-c))"
# Table 3 and equation 1

subtest <- subtest_1 (7695)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (subtest$T - subtest$c) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# study number 7727
# model type change to "Exponential, R=a exp(b(T-c))"
# Figure 2
subtest <- subtest_1 (7727)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (subtest$T - subtest$c) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# study number 8117
# model type change to "Exponential, R=a exp(b(T-c))"
# Figure 5
subtest <- subtest_1 (8117)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (subtest$T - subtest$c) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# study number 8186
# model type change to "Exponential, R=a exp(b(T-c))" 
# Table 3
subtest <- subtest_1 (8186)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (subtest$T - subtest$c) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

srdb[is.na(srdb$Rs_annual_bahn), ]$Rs_annual

srdb[is.na(srdb$Rs_annual), ]






# *****************************************************************************************
# Find out studies wiht Rs_Annual_Bahn = 0, but Rs_Annual is != 0
# *****************************************************************************************


srdb_Bahn_null <- subset( srdb, Rs_annual_bahn < 10 )
min(srdb$Rs_annual_bahn)
max(srdb$Rs_annual_bahn)
min(srdb$Rs_annual)

unique(srdb_Bahn_null$Study_number)

# 1518 3733 5317 5766 6272 6566 8866

# Study number 3733
# Model type shuld change to "Exponential, R=a exp(b(T-c))"
subtest <- subtest_1 (3733)

# subtest$rs <- subtest$a ^ subtest$b * (subtest$T - subtest$c)
# subtest$rs
# u <- subtest[ 1, "Model_output_units" ]
# conv <- conversions[ conversions$Unit==u, "Conversion" ]
# subtest$Rs_TAIR_units
# 455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
# subtest$Rs_annual_bahn # need check out why not exictly the same
# subtest$Rs_annual

AT <- seq (-5, 20, 1)
rs <- subtest$a[1] ^ ( subtest$b[1] * (AT - subtest$c[1]) )
qplot(AT, rs, ylim = c(0, 15))

rs <- subtest$a[2] ^ ( subtest$b[2] * (AT - subtest$c[2]) )
qplot(AT, rs, ylim = c(0, 15))

rs <- subtest$a[3] ^ ( subtest$b[3] * (AT - subtest$c[3]) )
qplot(AT, rs, ylim = c(0, 15))

rs <- subtest$a[4] ^ ( subtest$b[4] * (AT - subtest$c[4]) )
qplot(AT, rs, ylim = c(0, 15))

# change to exp 
rs <- subtest$a[1] * exp ( subtest$b[1] * (AT - subtest$c[1]) )
qplot(AT, rs, ylim = c(0, 15))

rs <- subtest$a[2] * exp ( subtest$b[2] * (AT - subtest$c[2]) )
qplot(AT, rs, ylim = c(0, 15))

rs <- subtest$a[3] * exp ( subtest$b[1] * (AT - subtest$c[3]) )
qplot(AT, rs, ylim = c(0, 15))

rs <- subtest$a[4] * exp ( subtest$b[4] * (AT - subtest$c[4]) )
qplot(AT, rs, ylim = c(0, 15))


subtest$rs <- subtest$a * exp( subtest$b * (subtest$T - subtest$c) ) 
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual


# Study number 5317
# Model type shuld change to "R10 (L&T), R=a exp(b((1/(c-d))-(1/(T-d)))"
subtest <- subtest_1 (5317)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (1/(subtest$c - subtest$d) - 1/(subtest$T - subtest$d) ) )  
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual


# Study number 5766
# According to Figure 4
# Soil temperature is not in K
# Model_type change to: "Arrhenius, R=a exp(-b/c(T-d))"
subtest <- subtest_2 ("Arrhenius, R=a exp(-b/c(T-d)), T in K")
subtest <- subtest_1 (5766)
subtest
subtest$rs <- subtest$a * exp( -subtest$b / (subtest$c * (subtest$T - subtest$d) )  )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual


# Study number 6272
# Table 3 and 4, the unit in Figure 4 should be wrong
# Unit change to "umol CO2/m2/s"
subtest <- subtest_1 (6272)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (subtest$T - subtest$c) )  
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual

# Study number 6566
# According to Ewuation 8 in J. Lloyd, J.A. Taylor, On the temperature dependence of soil respiration, Funct. Ecol. 8 (1994) 315 e 323.
# Equation (3) in this study should be wrong
# Model change to "R10 (L&T), R=a exp(b/((273.15+c)*8.314)*(1-(273.15+c)/T)), T in K"
subtest <- subtest_1 (6566)
subtest
attach(subtest)
subtest$rs <- a * exp( b / (283.15 * 8.314) * (1-(273.15+c)/ (T+273.15) ) )
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual

subtest_2 ('R10 (L&T), R=a exp(b/((273.15+c)*8.314)*(1-273.15-c)/T), T in K')

# study6566 <- read.csv("G:/My Drive/MyResearch/17.SRDB/AllPapers/601-709/6566/6566PaperDigitizeRSMonthly.csv")
# Rs <- study6566$RS_Norm / conv
# ta <- study6566$Tsoil.C.
# m <-nls(Rs ~ R10 * exp(Ea/(283.15 * 8.314) * (1-273.5)/(ta + 273.15) ), start=list(R10=24, Ea=0.114) )
# plot (Rs ~ ta)
# lines(ta,predict(m),col="red",lty=2,lwd=3)

# Study number 8866
# According to Table 1, unit here should be "g CO2/m2/hr" ?
# Unit change to "g CO2/m2/hr"
subtest <- subtest_1 (8866)
subtest
attach(subtest)
subtest$rs <- a * exp( b * (T-c) )
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn # need check out why not exictly the same
subtest$Rs_annual

AT <- seq (-5, 20, 1)
rs <- a * exp( b * (AT-c) )
qplot(AT, rs)




# *****************************************************************************************
# Rs_Annual_Bahn is na, and TS TA issue
# *****************************************************************************************

srdb_Bahn_null <- subset( srdb, is.na(Rs_annual_bahn))
unique(srdb_Bahn_null$Study_number)

# Study number 390
# According to Table 1 and Equation (1) and (2)
# Add Q16 to the model type, model has a soil water component or dependency
subtest <- subtest_1 (390)
subtest

# Study number 680
# According to Table 2
# Add Q16 to the model type, model has a soil water component or dependency (but only for record number = 1662)
subtest <- subtest_1 (680)
subtest

# Study number 1116
# According to Table 3
# Add Q16 to the model type, model has a soil water component or dependency
subtest <- subtest_1 (1116)
subtest


# "Linear, R=a+b(T-c)"
# 1384 & 5591 The parameter of the model seens not right, or due to the TS TA issue
subtest <- subtest_1 (1384)
subtest

# which (srdb$Study_number == 1518) , Model_type change to: "R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K"
# due to the TS TA issue
subtest <- subtest_1 (1518)
subtest$rs <- subtest$a * exp( subtest$b * (( 1 / subtest$c) - ( 1 / ( subtest$T + 273.15 -subtest$d ))))
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054	# Bahn et al. function
subtest$Rs_annual_bahn 
subtest$Rs_annual


# study number 2437
# TS TA issue, meaun annual air temperature is -10C, but data are measured from Aug to Sep, cannot represent
subtest <- subtest_1 (2437)
subtest
subtest$rs <- subtest$a * (exp( subtest$b*subtest$T )-1 )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# study number 2541
# model has SWC component, digitize the model and redo the regression?
subtest <- subtest_1 (2541)
subtest

# study number 4155
# model has SWC component
subtest <- subtest_1 (4155)
subtest

# study number 4212
# model has SWC component for some site
subtest <- subtest_1 (4212)

# study number 4609, this extreme value is caused by TS TA issue
srdb[srdb$Rs_annual_bahn > 5000,]$Study_number


# study number 5184
# model has SWC term, drop
subtest <- subtest_1 (5184)
subtest

# study number 5216
# model has SWC term, drop
subtest <- subtest_1 (5216)
subtest

# study number 5273
# model type change to 
# description on page 2 of the paper shows that this model is just for the diurnal data, may not valid for the annual data, drop
subtest <- subtest_1 (5273)
subtest
subtest$rs <- subtest$a * exp( subtest$b / (subtest$T - subtest$c) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# 5591 The parameter of the model seens not right
subtest <- subtest_1 (5591)
subtest


# 6219 
# Model_paramC change to 0
subtest <- subtest_1 (6219)
subtest
subtest$rs <- subtest$a * exp( subtest$b / (subtest$T - 0) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# Added 2 - "R10 (L&T), R=a exp(b((1/c)-(1/T+d))"
# 6462, c shoube be 10, d should be -46.02, but also have a WTL conponent, may not include this study
subtest <- subtest_1 (6462)
subtest$rs <- subtest$a * exp(  subtest$b * ((1/(10 + subtest$d)) - 1/(subtest$T + subtest$d))  )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# Study number 8079
# "Polynomial, R=a+b(T-d)+c(T-d)^2", extreme value, may due to TS TA issue
# ParamA, B, and C chenge to 0.007, 0.0959, 0.0013
# Parameter D change to 0
subtest <- subtest_1 (8079)
subtest
subtest$rs <- 6.1265 + 0.2849*subtest$T + 0.0042*subtest$T
# subtest$rs <- 0.007 + 0.0959*subtest$T + 0.0013*subtest$T
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# "R10 (L&T), R=a exp(b((1/c)-1/(T-d))"
# study 8382 cannot be used because it also include a soil water content component
subtest <- subtest_1 (8382)
subtest
subtest$rs <- subtest$a * exp(subtest$b * ((1/subtest$c) - 1/subtest$d-subtest$d))
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual
AT <- c(17.09000,16.50000,15.56,13.6,10.39,7.88,5.3,4.12,0.35,3.32,6.73,10.7)
rs <- c(1.190,1.700,1.460,1.530,1.370,.850,0.630,0.390,0.220,0.380,0.660,1.350)
m <-nls(rs ~ a * exp (b * ((1/56.02) - 1/(AT+273.15-227.13))), start=list(a=0.7,b=326) )
summary(m)
qplot (AT, rs)

# 6497
# Model_paramC change to 0
subtest <- subtest_1 (6497)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (subtest$T - 0) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual
AT <- seq(10:35)
AT <- c(11.45000,11.51000,12.28000,14.59000,18.22000,20.86,23.17,25.71,24.88,21.25,17.45,14.53)
rs <- subtest$a * exp( subtest$b * (AT - 0) )
rs <- c(7.010,6.440,7.360,8.020,9.960,11.340,13.320,15.600,14.470,12.980,10.030,8.500)

qplot(AT, rs, xlim = c(0,40), ylim = c(0,100) )

# 7596
# Model_paramC change to 0
subtest <- subtest_1 (7596)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (subtest$T - 0) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

# 77046
# Model_paramC change to 0
subtest <- subtest_1 (7704)
subtest
subtest$rs <- subtest$a * exp( subtest$b * (subtest$T - 0) )
subtest$rs
u <- subtest[ 1, "Model_output_units" ]
conv <- conversions[ conversions$Unit==u, "Conversion" ]
subtest$Rs_TAIR_units
455.8 * (subtest$rs * conv) ^ 1.0054 	# Bahn et al. function
subtest$Rs_annual_bahn
subtest$Rs_annual

AT <- seq(5:26)
rs <- subtest$a[2] * exp( subtest$b[2]*(AT - 0) )
# rs <- subtest$a[2] * subtest$b[2]^( (AT - 10)/10 )
qplot(AT, rs, xlim = c(0,30), ylim = c(-1,3) )

# 9501
subtest <- subtest_1 (9501)
subtest
AT <- seq(5:26)
rs <- subtest$a[1] * exp( subtest$b[1]*(AT - 0) )
qplot(AT, rs, xlim = c(0,30), ylim = c(0,5) )

rs <- subtest$a[2] * exp( subtest$b[2]*(AT - 0) )
qplot(AT, rs, xlim = c(0,20), ylim = c(0,5) )

# *****************************************************************************************
# Study in filtration3, may due to TS TA issue
# *****************************************************************************************
# 5278 # Zu et al., Maoershan: reported annual fluxes very high, # checked, seems like nothing wrong
# 3886,		# Jia et al., Maoershan: reported annual fluxes very high, # checked, seems like nothing wrong
# 6479,		# TEMPORARY - remove at office, model type updated
# 6292,		# TEMPORARY - remove at office
# 2349

subtest <- subtest_1 (2349)
qplot(subtest$Rs_annual, subtest$Rs_annual_bahn) + geom_abline(intercept = 0, slope = 1, color="red", 
                                                               linetype="dashed", size=1.5)

subtest <- subtest_1 (3886)
qplot(subtest$Rs_annual, subtest$Rs_annual_bahn) + geom_abline(intercept = 0, slope = 1, color="red", 
                                                               linetype="dashed", size=1.5)

subtest <- subtest_1 (5278)
qplot(subtest$Rs_annual, subtest$Rs_annual_bahn) + geom_abline(intercept = 0, slope = 1, color="red", 
                                                               linetype="dashed", size=1.5)

subtest <- subtest_1 (6479)
qplot(subtest$Rs_annual, subtest$Rs_annual_bahn) + geom_abline(intercept = 0, slope = 1, color="red", 
                                                               linetype="dashed", size=1.5)


subtest <- subtest_1 (6292)
qplot(subtest$Rs_annual, subtest$Rs_annual_bahn) + geom_abline(intercept = 0, slope = 1, color="red", 
                                                               linetype="dashed", size=1.5)



# *****************************************************************************************
# Find out studies wiht Rs_Annual_Bahn = 0, but Rs_Annual is != 0
# *****************************************************************************************

srdb_Bahn_null <- subset( srdb, Rs_annual_bahn < 50 )

unique(srdb_Bahn_null$Study_number)
