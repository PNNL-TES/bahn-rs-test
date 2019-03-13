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


# n = 1518
# srdb$Study_temp

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

# subtest_1 (1518)
# subtest_2 ("Q10, R=a exp((bT-c)/10)")


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
		} 
		  # Added model type 11 , study number 5371
		else if( mt == "R10 (L&T), R=a exp(b((1/(c-d))-(1/(T-d)))" ) {
		  rs <- a * exp( b * ( ( 1 / (c-d) ) - ( 1 / ( T-d ) ) ) )
		}
		
		  else if( mt == "R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K" ) {
			rs <- a * exp( b * ( ( 1 / c ) - ( 1 / ( ( T+273.15 ) - d ) ) ) )
		} else if( mt == "R10 (L&T), R=a exp(b/((273.15+c)*8.314)*(1-(273.15+c)/T)), T in K" ) {
			rs <- a * exp( b / ((273.15 + c) * 8.314) * (1-(273.15+c)/ (T+273.15) ) )
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






