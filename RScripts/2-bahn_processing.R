# 2-bahn_processing.R
# BBL December 2013

# Take Rs database and compute RS@MAT: soil respiration at mean annual air temperature


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


# ==============================================================================
# create select subtest function
# ==============================================================================


n = 1518
srdb$Study_temp

subtest_1 <- function (n) {
  subtest <- srdb[ which (srdb$Study_number == n), 
                   c( if( !is.na( srdb[which(srdb$Study_number == n),]$Study_temp ) ) {
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
                   ) ]
  
  colnames (subtest) <- c("T", "a", "b", "c", "d", "Model_output_units", "Model_type", "Record_number"
                          , "Study_number", "Rs_annual", "Rs_annual_bahn", "Rs_TAIR_units")
  
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
                  ) ]
  colnames (subtest) <- c("T", "a", "b", "c", "d", "Model_output_units", "Model_type", "Record_number"
                          , "Study_number", "Rs_annual", "Rs_annual_bahn", "Rs_TAIR_units")
  
  return (subtest)
}

subtest_1 (1518)
subtest_2 ("Q10, R=a exp((bT-c)/10)")


# -----------------------------------------------------------------------------
# Bahn et al.'s insight was that soil respiration at mean annual temperature
# (RS@MAT) was linearly related to annual soil respiration.
# Here we compute this value (µmol/m2/s) based on author equations and ancillary climate data 

# test function
# i = 1
# srdb[ i, "Model_paramA" ]

# i = which(srdb$Study_number == 1518)
# s <- srdb

compute_rs_mat <- function( s ) {
	# Compute model responses at MAT, taking into account different output units
	printlog( "Reading unit conversions..." )
	# conversions <- read.csv( CONVERSIONS, stringsAsFactors=F )
  conversions <- read.csv( paste( SRDB_DIR, CONVERSIONS, sep="/" ), stringsAsFactors=F )
	
	printlog( "Computing Rs @ mean annual temperature..." )
	s$mtr_out <- F
	um <- 0
	uu <- 0
	sv <- 0
	for( i in 1:nrow( s ) ) {
	
		printlog( SEPARATOR )
		a <- s[ i, "Model_paramA" ]
		b <- s[ i, "Model_paramB" ]
		c <- s[ i, "Model_paramC" ]
		d <- s[ i, "Model_paramD" ]
		
		if( !is.na( s[ i, "Study_temp" ] ) ) {
		  printlog( "Study_temp is available" )
			T <- s[ i, "Study_temp" ]
		} 
		else if ( !is.na( s[ i, "TAnnual_Del" ] ) ) {
		  T <- s[ i, "TAnnual_Del" ]
		}
		# updated for study number 2560, use MAT if both study_temp and TAnnual_Del Null
		else {
		  printlog( "Both Study_temp and TAnnual_Del are not available, MAT is used" )
			T <- s[ i, "MAT" ]
		}
		u <- s[ i, "Model_output_units" ]
		mtr = c( s[ i, "Model_temp_min" ], s[ i, "Model_temp_max" ] )
	
		stopifnot( is.numeric( a ) )
		stopifnot( is.numeric( b ) )
		stopifnot( is.numeric( T ) )
		
		conv <- conversions[ conversions$Unit==u, "Conversion" ]
		mt <- s[ i, "Model_type" ]
		rn <- s[ i, "Record_number" ]
		sn <- s[ i, "Study_number" ]
		printlog( "Processing:", i, s[ i, "Author" ], "Record_number =", rn, "Study_number =", sn  )
		printlog( "Model:", mt, a, b, c, d, "(", mtr, ")" )
		printlog( "Output:", u, conv )
		
		if( sum( conversions$Unit==u ) == 0 ) {
			printlog( "***** ERROR Unknown unit", u, "record_number =", rn )
			uu <- uu + 1
			next
		}
		
		if( mt == "Arrhenius, R=a exp(-b/c(T-d)), T in K" ) {
			rs <- a * exp( -b / ( c * ( T+273.1 - d ) ) )
		} else if( mt == "Arrhenius, R=a exp(-b/c(T-d))" ) {
			rs <- a * exp( -b / ( c * ( T - d ) ) )
		} 
		# Added model type 1: "Arrhenius, R=a*exp(-b/RT), T in K" 
		  else if( mt == "Arrhenius, R=a*exp(-b/RT), T in K" ) {
		  rs <- a * exp(-b /(0.008314*(T+273.15)) )
		}
		# Added model type 9: "Arrhenius, R=a*exp(b/c (1/d-1/T)), T in K" 
		# c = R = 8.134, d = Tref = 283.16
		  else if( mt == "Arrhenius, R=a*exp(b/c (1/d-1/T)), T in K" ) {
		  rs <- a * exp( b / c * (1/d - 1/(T+273.15) ) )
		}
		  else if( mt == "Exponential (2nd order), R=exp(a+b(T-d)+c(T-d)^2)" ) {
			rs <- exp( a + b * ( T - d ) + c * ( T - d ) ^ 2 )
		} else if( mt == "Exponential (ln1), ln(R)=a+b(T-c)" ) {
			rs <- exp( a + b * ( T - c ) )
		} else if( mt == "Exponential (ln2), ln(R)=a+b ln(T-c)" ) {
			rs <- exp( a + b * log( T - c ) )
		} else if( mt == "Exponential (log1), log(R)=a+b(T-c)" ) {
			rs <- 10 ^ ( a + b * ( T - c ) )
		} else if( mt == "Exponential (log2), log(R)=a+b log(T-c)" ) {
			rs <- 10 ^ ( a + b * log10( T - c ) )
		} else if( mt == "Exponential (other), ln(R)=a+exp(b(T-c))" ) {
			rs <- exp( a + exp( b * ( T - c ) ) )
		} 
		  # added model 7
		  else if( mt == "Exponential (other), ln(R)=a+b(T+d)+c(T+d)^2" ) {
		  rs <- exp(a + b * (T + d) + c * (T + d)^2)
		  }
		# added model 8
		  else if( mt == "Exponential (other), R=a*b^(ct)" ) {
		  rs <- a * b ^ ( c*T )
		  }
		# add model 10, "Exponential (other), R=a*exp(ln(b (T-c)/c))"
		  else if( mt == "Exponential (other), R=a*exp(ln(b (T-c)/c))" ) {
		  rs <- a * exp( log( b *(T - c)/c ) )
		}
		  else if( mt == "Exponential (other), R=a 10^(b(T-c))" ) {
			rs <- a * 10 ^ ( b * ( T - c ) )
		} else if( mt == "Exponential (other), R=a+b ln(T-c)" ) {
			rs <- a + b * ln( T - c )
		} else if( mt == "Exponential (other), R=a+b^(cT)" ) {
			rs <- a + b ^ ( c * T )
		} else if( mt == "Exponential, R=exp(a+b(T-c))" ) {
			rs <- exp( a + b * ( T - c ) )
		} else if( mt == "Exponential, log(R)=a+b(T-c)" ) {
			rs <- 10 ^ ( a + b * ( T - c ) )
		} 
		# subtest$a * exp( subtest$b * subtest$T ) study number 7695
		  else if( mt == "Exponential, R=a exp(b(T-c))" ) {
			rs <- a * exp( b * ( T - c ) )
		} 
		# Added model 3 - "Exponential, R=exp(a+bT)"
		  else if( mt == "Exponential, R=exp(a+bT)" ) {
		  rs <- exp( a + b * T )
		}
		# Added model 6 - "Exponential, R=a+b exp(T/c)"
		else if( mt == "Exponential, R=a+b exp(T/c)" ) {
		  rs <- a + b * exp( T/c )
		}
		  else if( mt == "Exponential, R=a exp(b(T-c)/10)" ) {
			rs <- a * exp( b * ( T - c ) / 10 )
		} else if( mt == "Linear, R=a+b(T-c)" ) {
			rs <- a + b * ( T - c ) 
		} 
		
		# Added model 4 - Linear, R=a+b(T^2)
		  else if( mt == "Linear, R=a+b(T^2)" ) {
		  rs <- a + b * ( T^2 ) 
		}	else if( mt == "Logistic, R=a/(1+b exp(-cT))" ) {
			rs <- a / ( 1 + b * exp( -c * T ) )
		} else if( mt == "Polynomial, R=a+b(T-d)+c(T-d)^2" ) {
			rs <- a + b * ( T - d ) + c * ( T - d ) ^ 2	
		} else if( mt == "Polynomial, R=exp(a+b(T-d)+c(T-d)^2)" ) {
			rs <- exp( a + b * ( T - d ) + c * ( T - d ) ^ 2 )	
		} else if( mt == "Power, R=a (T-b)^c" ) {
			rs <- a * ( T - b ) ^ c
		} else if( mt == "Power, R=a^(b(T-c))" ) {
			rs <- a ^ ( b * ( T - c ) )
		} 
		
		# Add model 5 'Power, R=a T^2'
		  else if( mt == "Power, R=c T^2" ) {
		  rs <- c * T^2
		  } 
		# # subtest$a * subtest$b^( (subtest$T - 24)/10 ) # study nnumber 7238
		  else if( mt == "Q10, R=a exp((bT-c)/10)" ) {
			rs <- a * exp( ( b * T - c ) / 10.0 )
		} else if( mt == "Q10, R=a b^((T-c)/10)" ) {
			rs <- a * b ^ ( ( T - c ) / 10.0 )
		} else if( mt == "R10 (L&T), R=a exp(b((1/c)-(1/(T-d)))" ) {
			rs <- a * exp( b * ( ( 1 / c ) - ( 1 / ( T-d ) ) ) )
		} else if( mt == "R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K" ) {
			rs <- a * exp( b * ( ( 1 / c ) - ( 1 / ( ( T+273.15 ) - d ) ) ) )
		} else if( mt == "R10 (L&T), R=a exp(b/((273.15+c)*8.314)*(1-273.15-c)/T), T in K" ) {
			rs <- a * exp( b / ( ( 273.15 + c ) * 8.314 ) * ( 1 - 273.15 - c ) / T )
		} else if( mt == "Other" || mt == "" ) {
			rs <- NA
			printlog( "Skipping" )
			next
		} else {
			rs <- NA
			printlog( "***** ERROR Unknown model:", mt )
			printlog( "record_number =", rn )
			um <- um + 1
			next
		}
		
		if( is.na( rs ) ) {
			printlog( "***** WARNING Computed rs is NA! record_number =", rn )
			next
		} else if( rs < 0 ) {
			printlog( "***** WARNING Computed rs is <0! record_number =", rn )
			next
		} else {
			rs_umol <- rs * conv
			
			printlog( "#", i, rn, ": Rs @", T, "C =", rs, u, "=", rs_umol, "umol/m2/s" )
			s[ i, "Rs_TAIR_units" ] <- rs	
			s[ i, "Rs_TAIR" ] <- rs_umol	

			# Are we outside of temperature range of the model?
			
			if( all( !is.na( mtr ) ) )
				if( T < mtr[ 1 ] | T > mtr[ 2 ] ) {
					printlog( "***** WARNING T =", T, "but model T range is (", mtr, ")" )
					s[ i, "mtr_out" ] <- TRUE
				}

			if( !is.na( rs_umol ) && ( rs_umol < 0.01 || rs_umol > 20 ) ) {
					printlog( "***** WARNING Screwy value", rs_umol )
#					print( s[ i, ] )
					sv <- sv + 1
			} 			
		}
		# 455.8 * (subtest$rs * conv) ^ 1.0054
		s[ i, "Rs_annual_bahn" ] <- 455.8 * ( rs_umol ^ 1.0054 )	# Bahn et al. function
	} # for
	
	printlog( SEPARATOR )
	printlog( "----- Summary -----" )
	printlog( "Unknown units =", uu )
	printlog( "Unknown model =", um )
	printlog( "Screwy value  =", sv )
	printlog( SEPARATOR )
	
	return( s )
} # compute_rs_mat


                              
# [3] "Linear, R=a+b(T-c)"                               
# [4] "Exponential, R=a exp(b(T-c))"                     
# [5] "R10 (L&T), R=a exp(b((1/c)-(1/T+d))(WTL), Rh"     
# [7] "Polynomial, R=a+b(T-d)+c(T-d)^2"                  
# [8] "R10 (L&T), R=a exp(b((1/c)-(1/T-d))"

# ==============================================================================
# Main

sink( paste0( LOG_DIR, SCRIPT, ".txt" ), split=T )
printlog( "Welcome to", SCRIPT )

theme_set( theme_bw() )

printlog( "Reading", INFN )
srdb <- read.csv( fn, stringsAsFactors=F )
printdims( srdb )

# In SRDB_V4, range are seperated into Model_temp_min and Model_temp_max
# printlog( "Splitting model temperate range strings..." )
# x <- str_split_fixed( srdb$Model_temp_range, ",", 2 )
# srdb$mtr_low <- as.numeric( x[ , 1 ] )
# srdb$mtr_high <- as.numeric( x[ , 2 ] )

srdb <- compute_rs_mat( srdb )

printlog( "Diagnostic plot..." )
srdb$Rs_annual_bahn_err <- with( srdb, round( abs( ( Rs_annual_bahn-Rs_annual ) / Rs_annual ), 2 ) )
srdb$higherr <- srdb$Rs_annual_bahn_err > .9 & !is.na( srdb$Rs_annual_bahn_err )
srdb[ srdb$higherr, "labl" ] <- srdb[ srdb$higherr, "Record_number" ]
# unique(srdb$labl)
#srdb[ srdb$higherr, "labl" ] <- srdb[ srdb$higherr, "err" ]
srdb$TAIR_LTM_dev <- with( srdb, abs( MAT_Del - MAT ) )
srdb$TAIR_dev <- with( srdb, abs( TAnnual_Del - Study_temp ) )

p <- ggplot( srdb[srdb$Rs_annual_bahn < 40000, ], aes( Rs_annual, Rs_annual_bahn ) ) 
p <- p + geom_abline( slope=1, linetype=2 ) + geom_smooth( method='lm' )
p <- p + geom_text( aes( label=labl ), size=2.5, vjust=-1, position="jitter" )
p1 <- p + geom_point( aes( color=mtr_out ) ) 
print( p1 )
saveplot( "2-Diagnostic1" )
saveplot( "2-Diagnostic2", p + geom_point( aes( color=( TAIR_LTM_dev ) ) ) )
saveplot( "2-Diagnostic3", p + geom_point( aes( color=( TAIR_dev ) ) ) )
saveplot( "2-Diagnostic4", p + geom_point( aes( color=( Ecosystem_type ) ) ) )

printlog( "Writing", OUTFN )

srdb <- srdb[!is.na(srdb$Rs_annual_bahn),]
write.csv( srdb, OUTFN, row.names=F )

printlog( "All done with", SCRIPT )
sink()


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

# study number 4609, this extreme value is caused by TS TA issue
srdb[srdb$Rs_annual_bahn > 5000,]$Study_number

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

# "Linear, R=a+b(T-c)"
# 1384 & 5591 The parameter of the model seens not right, or due to the TS TA issue
subtest <- subtest_1 (1384)
subtest

# 5591 The parameter of the model seens not right
subtest <- subtest_1 (5591)
subtest


# model Exponential, R=a exp(b(T-c))
# 2560, use MAT if both study_temp and TAnnual_Del Null
subtest <- subtest_1 (2560)
subtest


# [7] "Polynomial, R=a+b(T-d)+c(T-d)^2", extreme value, may due to TS TA issue
# Study number 8079
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

# [8] "R10 (L&T), R=a exp(b((1/c)-1/(T-d))"
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

subtest <- subtest_1 (390)
subtest

subtest <- subtest_1 (680)
subtest

subtest <- subtest_1 (1116)
subtest

# study number 1324
subtest <- subtest_1 (1324)
subtest
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

# study number 4155
# model has SWC component
subtest <- subtest_1 (4155)
subtest

# study number 4212
# model has SWC component for some site
subtest <- subtest_1 (4212)

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


# study number 5184
# model has SWC term, drop
subtest <- subtest_1 (5184)
subtest

# study number 5216
# model has SWC term, drop
subtest <- subtest_1 (5216)
subtest

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

