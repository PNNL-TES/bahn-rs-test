# 2-bahn_processing.R
# JJ updated April 2019

# Take Rs database and compute RS@MAT: soil respiration at mean annual air temperature
# -----------------------------------------------------------------------------
# Bahn et al.'s insight was that soil respiration at mean annual temperature
# (RS@MAT) was linearly related to annual soil respiration.
# Here we compute this value (µmol/m2/s) based on author equations and ancillary climate data 
# Update compute_rs_mat function allow temperature as input
# "Study_TS_Annual" means mean annual soil temperature
# "TAnnual_Del" is annual air temperature from Delaware climate data
# "MAP_Del" is mean annual air temperature between 1964 and 2014

compute_rs_mat <- function( s, Temp ) {
	# Compute model responses at MAT, taking into account different output units

	# conversions <- read.csv( CONVERSIONS, stringsAsFactors=F )
	
	s$mtr_out <- F
	um <- 0
	uu <- 0
	sv <- 0
	for( i in 1:nrow( s ) ) {
	
		
		a <- s[ i, "Model_paramA" ]
		b <- s[ i, "Model_paramB" ]
		c <- s[ i, "Model_paramC" ]
		d <- s[ i, "Model_paramD" ]
		
		T <- s[ i, Temp ]
		
		u <- s[ i, "Model_output_units" ]
		mtr = c( s[ i, "Model_temp_min" ], s[ i, "Model_temp_max" ] )
	
		stopifnot( is.numeric( a ) )
		stopifnot( is.numeric( b ) )
		stopifnot( is.numeric( T ) )
		
		conv <- conversions[ conversions$Unit==u, "Conversion" ]
		mt <- s[ i, "Model_type" ]
		rn <- s[ i, "Record_number" ]
		sn <- s[ i, "Study_number" ]
		
		
		if( sum( conversions$Unit==u ) == 0 ) {
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
		# Added model type 2: "Arrhenius, R=a*exp(b/c (1/d-1/T)), T in K" 
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
		# Added model 3
		  else if( mt == "Exponential (other), ln(R)=a+b(T+d)+c(T+d)^2" ) {
		  rs <- exp(a + b * (T + d) + c * (T + d)^2)
		  }
		# Added model 4
		  else if( mt == "Exponential (other), R=a*b^(ct)" ) {
		  rs <- a * b ^ ( c*T )
		  }
		# Added model 5, "Exponential (other), R=a*exp(ln(b (T-c)/c))"
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
		# Added model 6 - "Exponential, R=exp(a+bT)"
		  else if( mt == "Exponential, R=exp(a+bT)" ) {
		  rs <- exp( a + b * T )
		}
		# Added model 7 - "Exponential, R=a+b exp(T/c)"
		  else if( mt == "Exponential, R=a+b exp(T/c)" ) {
		  rs <- a + b * exp( T/c )
		}
		  else if( mt == "Exponential, R=a exp(b(T-c)/10)" ) {
			rs <- a * exp( b * ( T - c ) / 10 )
		} else if( mt == "Linear, R=a+b(T-c)" ) {
			rs <- a + b * ( T - c ) 
		} 
		
		# Added model 8 - Linear, R=a+b(T^2)
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
		
		# Added model 9 'Power, R=a T^2'
		  else if( mt == "Power, R=c T^2" ) {
		  rs <- c * T^2
		  } 
		# # Added model type 10, study nnumber 7238
		  else if( mt == "Q10, R=a exp((bT-c)/10)" ) {
			rs <- a * exp( ( b * T - c ) / 10.0 )
		} else if( mt == "Q10, R=a b^((T-c)/10)" ) {
			rs <- a * b ^ ( ( T - c ) / 10.0 )
		} else if( mt == "R10 (L&T), R=a exp(b((1/c)-(1/(T-d)))" ) {
			rs <- a * exp( b * ( ( 1 / c ) - ( 1 / ( T-d ) ) ) )
		} 
		  # Added model type 11, study number 5371
		  else if( mt == "R10 (L&T), R=a exp(b((1/(c-d))-(1/(T-d)))" ) {
		  rs <- a * exp( b * ( ( 1 / (c-d) ) - ( 1 / ( T-d ) ) ) )
		}
		  # Added model type 12
		  else if( mt == "R10 (L&T), R=a exp(b((1/c)-(1/(T-d))), T in K" ) {
			rs <- a * exp( b * ( ( 1 / c ) - ( 1 / ( ( T+273.15 ) - d ) ) ) )
		} else if( mt == "R10 (L&T), R=a exp(b/((273.15+c)*8.314)*(1-(273.15+c)/T)), T in K" ) {
			rs <- a * exp( b / ((273.15 + c) * 8.314) * (1-(273.15+c)/ (T+273.15) ) )
		} else if( mt == "Other" || mt == "" ) {
			rs <- NA
			next
		} else {
			rs <- NA
			um <- um + 1
			next
		}
		
		if( is.na( rs ) ) {
			next
		} else if( rs < 0 ) {
			next
		} else {
			rs_umol <- rs * conv
			
			s[ i, "Rs_TAIR_units" ] <- rs	
			s[ i, "Rs_TAIR" ] <- rs_umol	

			# Are we outside of temperature range of the model?
			
			if( all( !is.na( mtr ) ) )
				if( T < mtr[ 1 ] | T > mtr[ 2 ] ) {
					s[ i, "mtr_out" ] <- TRUE
				}

			if( !is.na( rs_umol ) && ( rs_umol < 0.01 || rs_umol > 20 ) ) {
					sv <- sv + 1
			} 			
		}
		# 455.8 * (subtest$rs * conv) ^ 1.0054
		s[ i, "Rs_annual_bahn" ] <- 455.8 * ( rs_umol ^ 1.0054 )	# Bahn et al. function
	} # for
	return( s )
} # compute_rs_mat








