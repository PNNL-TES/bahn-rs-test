# 3-bahn_analysis.R
# BBL December 2013

# Analyze the soil respiration database, after it's gone through 
# steps 1 (matching with climate data) and 2 (computing Rs at MAT)

rm (list = ls())
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()

source( "0-header.R" )

SCRIPT			<- "3-bahn_analysis.R"
INFN 			<- "srdb-data-processed.csv"
OUTFN 			<- "srdb-data-final.csv"

TDIFF_MAX 		<- 2	# max diff allowed btwn global dataset TAIR and observed



# -----------------------------------------------------------------------------
# Filter out data: need more work, not figure out what this try to do
# Some part have finished in 2-bahn_processing.R
# need update 1
# -----------------------------------------------------------------------------

# srdb_02 <- subset( srdb, !mtr_out )
# colnames (srdb)

filtration3 <- function( srdb, tdiff_max=TDIFF_MAX, quiet=F ) {
  fields <- c( 	"Record_number", "Study_number",
                "Author", "Site_name", "Study_midyear", "YearsOfData", 
                "Latitude", "Longitude", "Biome", "Ecosystem_type", 
                "MAT", "MAP", "Study_temp", "Study_precip",
                "Meas_interval", "Annual_coverage", "Meas_method",
                "Rs_annual", "Rs_annual_err", "Rs_wet", "Rs_dry", "RC_annual",
                "Model_type", "R10",
                "TAnnual_Del", "TAIR_SD", 
                "PAnnual_Del", "PRECIP_SD", 
                # "TAIR_LTM", "PRECIP_LTM", 
                "SPI",
                "mtr_out", "Rs_TAIR_units", "Rs_TAIR", "Rs_annual_bahn", "TAIR_dev", "TAIR_LTM_dev"
  )
  
  if( !quiet ) printlog( "Removing extraneous fields..." )
  srdb <- srdb_orig[ fields ]		
  printdims( srdb )
  
  srdb <- subset( srdb, !is.na( Rs_annual ) & !is.na( Rs_annual_bahn ) )
  if( !quiet ) printlog( "Filtered for Rs_annual:", nrow( srdb ) )
  srdb <- subset( srdb, !mtr_out ) # filt mtr_out == true (out of temperature range)
  if( !quiet ) printlog( "Filtered for mtr_out:", nrow( srdb ) )
  srdb <- subset( srdb, Meas_method %in% c( "IRGA", "Gas chromatography" ) )
  if( !quiet ) printlog( "Filtered for Meas_method:", nrow( srdb ) )
  srdb <- subset( srdb, Ecosystem_type != "Agriculture" )
  if( !quiet ) printlog( "Filtered for !Agriculture:", nrow( srdb ) )
  
  # (Temporary?) excludes; values weird but can't find anything wrong
  srdb <- subset( srdb, !( Study_number %in% c( 
    # 5278, 		# Zu et al., Maoershan: reported annual fluxes very high
    # # checked, seems like nothing wrong
    # 3886,		# Jia et al., Maoershan: reported annual fluxes very high
    # # checked, seems like nothing wrong
    # # 6479,		# TEMPORARY - remove at office, model type updated
    # 6292,		# TEMPORARY - remove at office
    # 2349		# Lavigne, Canada, looks OK not sure why so off
    2182 # checked, TS TA issue
  ) ) )
  if( !quiet ) printlog( "Filtered problem studies:", nrow( srdb ) )
  
  
  if( !quiet ) {
    printlog( "If the climate data diverges from on-the-ground climate," )
    printlog( "this is a problem obviously." )
    printlog( "Diff Temp MAT  (# records)" )
    for( i in 0:9 ) 
      printlog( i, sum( srdb$TAIR_LTM_dev > i, na.rm=T ), sum( srdb$TAIR_dev > i, na.rm=T ) )
  }
  srdb <- subset( srdb, is.na( MAT ) | TAIR_LTM_dev <= tdiff_max )
  printlog( "Filtered for MAT temp diff <=", tdiff_max,":", nrow( srdb ) )
  srdb <- subset( srdb, is.na( Study_temp ) | TAIR_dev <= tdiff_max )
  printlog( "Filtered for Study_temp temp diff <=", tdiff_max,":", nrow( srdb ) )
  srdb
} # filtration


# -----------------------------------------------------------------------------
# Re-compute the relationship between Rs_annual and RS@MAT
compute_Rs_annual_bahn <- function( sdata, name="" ) {
	printlog( SEPARATOR )
	printlog( "Bahn relationship for these data:" )
	m1 <- lm( Rs_annual ~ Rs_TAIR, data=sdata )
	print( summary( m1 ) )
}

# -----------------------------------------------------------------------------
# See how Rs_annual is related to Rs_annual_bahn
Rs_annual_bahn_test <- function( sdata, name="", quiet=F ) {
	printlog( SEPARATOR )
	if( name != "" ) {
		printlog( name )
		name <- paste0( "-", name )
	}
	printlog( "How are Rs_annual and Rs_annual_bahn related?" )
	printdims( sdata )

	cooks_count <- 0		# if 0, outlier code is disabled
	m <- lm( Rs_annual_bahn ~ Rs_annual, data=sdata )
	while( cooks_count > 0 ) {
		m <- lm( Rs_annual_bahn ~ Rs_annual, data=sdata )
		influentials <- which( cooks.distance( m ) > 0.5 )
		cooks_count <- length( influentials )
		printlog( "Influential outliers =", cooks_count )
		if( cooks_count > 0 ) {
			print( sdata[ influentials, "Record_number" ] )
			sdata <- sdata[ -influentials, ]	
		}
	}
	
	if( !quiet ) {
		printlog( "Model summary:" )
		print( summary( m ) )
	
		printlog( "Plotting and saving model diagnostics..." )
		pdf( paste0( OUTPUT_DIR, "3-modeldiags",name, ".pdf" ) )
		par( mfrow=c( 2, 2 ) )
		plot( m, labels.id=paste( sdata$Record_number, sdata$Author ) )
		dev.off()

		printlog( "Plotting and saving model residuals..." )
		sdata$resids <- residuals( m )
		p <- ggplot( sdata, aes( Rs_annual, resids ) )
		p <- p + geom_point() + geom_smooth( method='lm' )
		print( p )
		saveplot( paste0( "3-modelresids", name ) )
	}

	printlog( "Test H0 of intercept=0: p-value =", summary( m )$coefficients[ 1, 4 ] )
	
	# Test if slope=1
	#library( smatr )		# can also use summary(lm(y-1*x~x))
	#print( slope.test( sdata$Rs_annual_bahn, sdata$Rs_annual, method="OLS" )$p )
	m1 <- lm( Rs_annual_bahn - 1 * Rs_annual ~ Rs_annual, data=sdata )
	printlog( "Test H0 of slope=1: p-value =", summary( m1 )$coefficients[ 2, 4 ] )
	
	invisible( list( m, m1 ) )
}

# -----------------------------------------------------------------------------
# How much of the inaccuracy in the Rs_annual_bahn~Rs_annual relationship
# is due to inaccuracies in the air temperature dataset?
# need update 2: need calculate sdata$TAIR_SD
# -----------------------------------------------------------------------------

climate_variability_test <- function( sdata ) {
	printlog( SEPARATOR )
	printlog( "How does climate variability affect this relationship?" )
	sdata$TAIR_SD2 <- cut( sdata$TAIR_SD, 3 )
	m <- lm( Rs_annual_bahn~Rs_annual * TAIR_SD2, data=sdata )
	print( summary( m ) )
	p <- qplot( Rs_annual, Rs_annual_bahn, data=sdata, color=TAIR_SD2 )
	p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
	p <- p + scale_color_discrete( "Monthly tair\nvariability" )
	print( p )
	saveplot( "3-var_effect_tair" )	

	sdata$PRECIP_SD2 <- cut( sdata$PRECIP_SD, 3 )
	m <- lm( Rs_annual_bahn~Rs_annual * PRECIP_SD2, data=sdata )
	print( summary( m ) )
	p <- qplot( Rs_annual, Rs_annual_bahn, data=sdata, color=PRECIP_SD2 )
	p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
	p <- p + scale_color_discrete( "Monthly precip\nvariability" )
	print( p )
	saveplot( "3-var_effect_precip" )	
}

# -----------------------------------------------------------------------------
# How much of the inaccuracy in the Rs_annual_bahn~Rs_annual relationship
# is due to inaccuracies in the air temperature dataset?
global_tair_dataset_effect <- function( srdb_orig ) {
	printlog( SEPARATOR, SEPARATOR )
	printlog( "Testing how inaccuracies in global TAIR dataset affect results" )
	printlog( "(This will crap up the log a bit.)" )
	results <- data.frame()
	for( i in c( 10, 8, 6, 4, 2, 1, 0.5 ) ) {
		srdb <- filtration3( srdb_orig, i, quiet=T )
		m <- Rs_annual_bahn_test( srdb, i, quiet=T )[[ 1 ]]
		results <- rbind( results, data.frame( 	tdiff_max=i,
												R2=summary( m )$adj.r.squared, 
												RSE=summary( m )$sigma ) )
	}
#	srdb <- subset( srdb, !is.na( Study_temp ) )
#	m <- Rs_annual_bahn_test( srdb, 0, quiet=T )
#	results <- rbind( results, data.frame( 	tdiff_max=0,
#											R2=summary( m )$adj.r.squared, 
#											RSE=summary( m )$sigma ) )
	printlog( SEPARATOR, SEPARATOR )
	results$R2 <- round( results$R2, 2 )
	results$RSE <- round( results$RSE, 2 )
	print( results )
	d <- melt( results, id.vars=1 )
	p <- qplot( tdiff_max, value, data=d, geom=c( "point", "line" ) ) +
		facet_grid( variable~., scales="free" )
	print( p )
	saveplot( "3-Diagnostic_tair_inaccuracies" )
}

# -----------------------------------------------------------------------------
# What's the effect of annual coverage? We'd expect a better relationship
# when more of the year is measured
AC_test <- function( sdata ) {
	printlog( SEPARATOR )
	printlog( "How does annual coverage affect this relationship?" )
	sdata$AC2 <- cut( sdata$Annual_coverage, 3 ) #c( 0, 0.33, 0.67, 1 ), right=F )
	m <- lm( Rs_annual_bahn~Rs_annual * AC2, data=sdata )
	print( summary( m ) )
	printlog( SEPARATOR )
	printlog( "Model for AC<0.33 only:" )
	print( summary( lm( Rs_annual_bahn ~ Rs_annual, data=subset( sdata, Annual_coverage<0.33 ) ) ) )
	printlog( SEPARATOR )
	printlog( "Model for AC 0.33-0.67 only:" )
	print( summary( lm( Rs_annual_bahn ~ Rs_annual, data=subset( sdata, Annual_coverage>=0.33 & Annual_coverage < 0.67 ) ) ) )
	printlog( SEPARATOR )
	printlog( "Model for AC>=0.67 only:" )
	print( summary( lm( Rs_annual_bahn ~ Rs_annual, data=subset( sdata, Annual_coverage>0.67 ) ) ) )

	p <- qplot( Rs_annual, Rs_annual_bahn, data=subset( sdata, !is.na( AC2 ) ), color=AC2 )
	p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
	print( p )
	saveplot( "3-AC_effect" )	
}


# -----------------------------------------------------------------------------
# How much of the inaccuracy in the Rs_annual_bahn~Rs_annual relationship
# is due to inaccuracies in the air temperature dataset?
RC_test <- function( sdata ) {
	printlog( SEPARATOR )
	printlog( "How does RC contribution affect this relationship?" )
	print( summary( lm( Rs_annual ~ Rs_TAIR * ( RC_annual>0.5 ), data=sdata ) ) )
	printlog( SEPARATOR )
	printlog( "Model for RC>0.5 only:" )
	print( summary( lm( Rs_annual ~ Rs_TAIR, data=subset( sdata, RC_annual>0.5 ) ) ) )
	printlog( SEPARATOR )
	printlog( "Model for RC<=0.5 only:" )
	print( summary( lm( Rs_annual ~ Rs_TAIR, data=subset( sdata, RC_annual<=0.5 ) ) ) )

	p <- ggplot( subset( sdata, !is.na( RC_annual ) ), aes( Rs_annual, Rs_annual_bahn, color=RC_annual>0.5 ) )
	p <- p + geom_point()
	p <- p + geom_smooth( method='lm' )
	p <- p + geom_abline( slope=1, linetype=2 )
	print( p )
	saveplot( "3-RC_effect" )
    invisible( p )
}

# -----------------------------------------------------------------------------
plotdata <- function( sdata, name ) {

	printlog( "******************** water stress test" )
	# TODO here: compute Hogg CMI as in GCB paper
	sdata$waterstress <- "Less water stress"
	sdata[ sdata$LU_MIM < 0, "waterstress" ] <- "More water stress"
	print( summary( lm( Rs_annual_bahn ~ Rs_annual * waterstress, data=sdata ) ) )
	p <- ( qplot( Rs_annual, Rs_annual_bahn, main=name, data=sdata, facets=.~waterstress ) 
			+ stat_smooth( method="lm" )#, aes( group=1 ) )
			+ geom_abline( intercept=0, slope=1, linetype=2 )
			)
	print( p )
	ggsave( paste( OUTDIR, name, "-H2O.pdf", sep="" ) )


	printlog( "******************** mean annual precip test" )
	print( summary( lm( Rs_annual_bahn ~ Rs_annual * MAP, data=sdata ) ) )
	p <- ( qplot( LU_MAP, Rs_annual/Rs_annual_bahn, data=sdata, 
					xlab="MAP (mm)", ylab="Rs_annual divided by Rs_annual_bahn")
			+ geom_hline( yintercept=1, linetype=2 )
			+ geom_smooth() 
	)
	print( p )
	ggsave( paste( OUTDIR, name, "-MAP.pdf", sep="" ) )


	printlog( "******************** residual and histogram plots" )
	sdata$resid <- m$residuals
	sdata$pred <- predict( m )
	print( qplot( pred, resid, color=mtr_out, data=sdata ) )
	ggsave( paste( OUTDIR, name, "-resid.pdf", sep="" ) )
	
	p <- qplot( Rs_umol, data=sdata, binwidth=0.5, fill=Ecosystem_type, xlab="Rs at MAT (µmol/m2/s)" )
	ggsave( paste( OUTDIR, name, "-hist1_Rs.pdf", sep="" ) )

	p <- qplot( Rs_umol, data=sdata, binwidth=0.5, fill=Biome, xlab="Rs at MAT (µmol/m2/s)" )
	ggsave( paste( OUTDIR, name, "-hist2_Rs.pdf", sep="" ) )
	
	invisible( sdata )
}


# -----------------------------------------------------------------------------
# What's the effect of drought? need new drought data
# Need another drought index and re-analysis
# need update 2
# -----------------------------------------------------------------------------

SPI_test <- function( sdata ) {
  printlog( SEPARATOR )
  printlog( "How does drought affect this relationship? (discrete)" )
  sdata$SPI2 <- cut( sdata$SPI, 3 ) #c( 0, 0.33, 0.67, 1 ), right=F )
  m1 <- lm( Rs_annual_bahn~Rs_annual * SPI2, data=sdata )
  print( summary( m1 ) )
  printlog( "How does drought affect this relationship? (continuous)" )
  m2 <- lm( Rs_annual_bahn~Rs_annual * SPI, data=sdata )
  print( summary( m2 ) )
  
  p <- qplot( Rs_annual, Rs_annual_bahn, data=sdata, color=SPI2 )
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
  print( p )
  saveplot( "3-SPI_effect" )
}





# -----------------------------------------------------------------------------
# Main figure comparing Rs_annual with Rs_annual_bahn
# Updateed
# -----------------------------------------------------------------------------
Rs_comparion_figure <- function( srdb, name="" ) {
	printlog( SEPARATOR )
	if( name != "" ) {
		printlog( name )
		name <- paste0( "-", name )
	}
	printlog( SEPARATOR )
	printlog( "Doing main figure comparing Rs_annual and Rs_annual_bahn" )
	p <- ggplot( srdb, aes( Rs_annual, Rs_annual_bahn ) )
	# need figure out calculate geom_errorbarh
	p <- p + geom_errorbarh( aes( xmin=Rs_annual-Rs_annual_err, xmax=Rs_annual+Rs_annual_err), alpha=0.5 )
	p <- p + geom_point( alpha=0.5 )
	p <- p + geom_smooth( method='lm', color='black' )
	p <- p + geom_abline( slope=1, linetype=2 )
	p <- p + xlab( expression( Measured~SR[annual]~(g~C~m^{-2}~yr^{-1}) ) )
	p <- p + ylab( expression( Inferred~SR[annual]~(g~C~m^{-2}~yr^{-1}) ) )
	print( p )
	saveplot( paste0( "3-Rs (Figure 2)", name ) )
    invisible( p )
}

# -----------------------------------------------------------------------------
# Climate space figure
# colnames(srdb)

climate_figure <- function( srdb, name="" ) {
    #d <- subset( d, mat>-30 )
    d <- read.csv( OUTCLIMDATA )
    p <- ggplot( d, aes( MAT, MAP ) )
    p <- p + geom_bin2d( alpha=0.5 ) + scale_fill_gradient( low="lightgrey", high="black" )
    p <- p + xlab( expression( MAT~group("(",paste(degree,C),")")  ) ) + ylab( "MAP (mm)" )
    #p <- p + geom_point( data=srdb, aes( x=5, y=750, color=Biome ) )
    p <- p + geom_jitter( data=srdb, aes( x=MAT_Del, y=MAP_Del, color=Ecosystem_type ) ) #, show_guide=F )
    p <- p + guides( fill=F )
    print( p )
    saveplot( "1-Climate space (Figure 1)" )
    invisible( p )
}


# ------------------------------------------
# ----------     MAIN PROGRAM     ---------- 
# ------------------------------------------

sink( paste0( LOG_DIR, SCRIPT, ".txt" ), split=T )
printlog( "Welcome to", SCRIPT )

loadlibs( c( "ggplot2", "reshape" ) )
theme_set( theme_bw() )

printlog( "Reading", INFN, "..." )


srdb_orig <- read.csv( INFN, stringsAsFactors=F )
srdb <- srdb_orig
srdb_05 <- filtration3( srdb_orig, 0.5, quiet=T )

# Climate space figure
figA <- climate_figure( srdb_orig )

# calculate sdata$TAIR_SD
# colnames (srdb)

# sdata <- srdb

# How accurately can the Bahn (2010) relationship predict observed annual Rs?
mods <- Rs_annual_bahn_test( srdb )	
m <- mods[[ 1 ]]
m1 <- mods[[ 2 ]]

# How accurately can the Bahn (2010) relationship predict observed annual Rs?
mods_05 <- Rs_annual_bahn_test( srdb_05 )	
m_05 <- mods_05[[ 1 ]]
m1_05 <- mods_05[[ 2 ]]

# Make a nice figure of this
figB <- Rs_comparion_figure( srdb )

# -----------------------------------------------------------------------------
# Main figure comparing Rs_annual with Rs_annual_bahn
# After filtration
figB_05 <- Rs_comparion_figure( srdb_05 )

# How do autotrophic- versus heterotrophic-dominated systems differ?
figC <- RC_test( srdb )

# What's the effect of annual coverage?
AC_test( srdb )

# Report updated values for Bahn (2010) relationship based on SRDB
compute_Rs_annual_bahn( srdb )

# How much variability is due to inaccuracies in the global TAIR data?

# Do ecosystems with more-variable climates exhibit different trends?
climate_variability_test( srdb )

# Finished in 2-bahn_climate_udel.R
# srdb <- filtration3( srdb_orig ) 

# Do drought effects different trends?
SPI_test( srdb ) # need a new SPI data

printlog( SEPARATOR )
ODD_ERR <- 30 # %
printlog( "Computing oddballs, threshold of", ODD_ERR, "%" )

srdb_05$Rs_err <- round( with( srdb_05, ( Rs_annual_bahn-Rs_annual ) / Rs_annual ) * 100, 0 )
srdb_05$Rs_dev <- with( srdb_05, Rs_annual_bahn-Rs_annual )
odds <- subset( srdb_05, abs( Rs_err )>ODD_ERR )
printlog( "Oddball count:", nrow( odds ) )
write.csv( odds, "oddballs.csv" )
p1 <- qplot( Rs_annual, Rs_annual_bahn, data=odds, color=abs( Rs_dev ) )
p1 <- p1 + geom_abline() + geom_text( aes( label=paste( Author, Study_number ) ), size=3, vjust=-.5 )
p1 <- p1 + ggtitle( paste0( "within 0.5C, but Rs_err > ", ODD_ERR, "%" ) )
print( p1 )
saveplot( "3-oddballs1" )
p2 <- qplot( abs( Rs_err ), abs( Rs_dev ), data=odds ) + xlab( "Error (%)" ) + ylab( "Deviation (gC)" )
p2 <- p2 + geom_text( aes( label=paste( Author, Study_number ) ), size=3, vjust=-.5 )
p2 <- p2 + ggtitle( paste0( "within 0.5C, but Rs_err > ", ODD_ERR, "%" ) )
print( p2 )
saveplot( "3-oddballs2" )


# TODO: re-compute Bahn relationship CORRECTLY!!!!!

printlog( SEPARATOR )
printlog( "All done with", SCRIPT )
sink()






