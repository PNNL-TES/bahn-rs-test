
# create function 

# not in function
'%!in%' <- function(x,y)!('%in%'(x,y))

# Time-stamped output function
printlog <- function( msg="", ..., ts=TRUE, cr=TRUE ) {
  if( ts ) cat( date(), " " )
  cat( msg, ... )
  if( cr ) cat( "\n")
} # printlog

# -----------------------------------------------------------------------------
# Print dimensions of data frame
printdims <- function( d, dname=deparse( substitute( d ) ) ) {
  stopifnot( is.data.frame( d ) )
  printlog( dname, "rows =", nrow( d ), "cols =", ncol( d ) )
} # printdims

# -----------------------------------------------------------------------------
# Save a figure
saveplot <- function( pname, p=last_plot(), ptype=".pdf" ) {
  fn <- paste0( OUTPUT_DIR, pname, ptype )
  printlog( "Saving", fn )
  ggsave( fn, p )
} # saveplot


# Load requested libraries
loadlibs <- function( liblist ) {
  printlog( "Loading libraries..." )
  loadedlibs <- vector()
  for( lib in liblist ) {
    printlog( "Loading", lib )
    loadedlibs[ lib ] <- require( lib, character.only=T )
    if( !loadedlibs[ lib ] )
      stop( "this package is not installed!" )
  }
  invisible( loadedlibs )
} # loadlibs

# ----------------------------------------------------------------------------- Filtration functions begin
# get ride of extreme high values
filtration1 <- function( srdb ) {
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
  
  srdb <- srdb_orig[ fields ]	
  
  srdb <- subset( srdb, Rs_annual_bahn < 3500 ) # test whether two extreme points pull the slope off 1
  
  srdb
} # filtration

# function to remove part of records
filtration_mv <- function( srdb, var=F ) {
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
  
  srdb <- srdb_orig[ fields ]	
  
  srdb <- subset( srdb, Ecosystem_type != var )
  
  srdb
} # filtration

# function only keep selected records
filtration_kp <- function( srdb, var=F ) {
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
  
  srdb <- srdb_orig[ fields ]	
  
  srdb <- subset( srdb, Ecosystem_type == var )
  
  srdb
} # filtration

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
  
  
  srdb <- srdb_orig[ fields ]		
  printdims( srdb )
  
  srdb <- subset( srdb, !is.na( Rs_annual ) & !is.na( Rs_annual_bahn ) )
  
  srdb <- subset( srdb, !mtr_out ) # filt mtr_out == true (out of temperature range)
  
  srdb <- subset( srdb, Meas_method %in% c( "IRGA", "Gas chromatography" ) )
  
  srdb <- subset( srdb, Ecosystem_type != "Agriculture" )
  
  
  # (Temporary?) excludes; values weird but can't find anything wrong
  srdb <- subset( srdb, !( Study_number %in% c( 
    # 4614, # checked, extreme high value
    5227 # checked, model in the paper may not right
  ) ) )
  
  
  srdb <- subset( srdb, is.na( MAT ) | TAIR_LTM_dev <= tdiff_max )
  
  srdb <- subset( srdb, is.na( Study_temp ) | TAIR_dev <= tdiff_max )
  
  srdb
} 

# -----------------------------------------------------------------------------# filtration END





# -----------------------------------------------------------------------------
# Function 2: Re-compute the relationship between Rs_annual and RS@MAT
compute_Rs_annual_bahn <- function( sdata, name="" ) {
  printlog( SEPARATOR )
  printlog( "Bahn relationship for these data:" )
  m1 <- lm( Rs_annual ~ Rs_TAIR, data=sdata )
  print( summary( m1 ) )
}

# -----------------------------------------------------------------------------
# Function 3: See how Rs_annual is related to Rs_annual_bahn
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
# Function 4: How much of the inaccuracy in the Rs_annual_bahn~Rs_annual relationship
# is due to inaccuracies in the air temperature dataset?

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
# Function 5: How much of the inaccuracy in the Rs_annual_bahn~Rs_annual relationship
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
# Function 6: What's the effect of annual coverage? We'd expect a better relationship
# when more of the year is measured
# This test is meaningless because the studies include here all > 1yr data

AC_test <- function( sdata, coverage, var_sav ) {
  printlog( SEPARATOR )
  printlog( "How does annual coverage affect this relationship?" )
  sdata$AC2 <- cut( coverage, c( 0, 0.5, 0.95, 1 ), right=T )  #c( 0, 0.33, 0.67, 1 ), right=F )
  m <- lm( Rs_annual_bahn~Rs_annual * AC2, data=sdata )
  print( summary( m ) )
  printlog( SEPARATOR )
  printlog( "Model for AC<0.33 only:" )
  print( summary( lm( Rs_annual_bahn ~ Rs_annual, data=subset( sdata, Annual_TS_Coverage<0.33 ) ) ) )
  printlog( SEPARATOR )
  printlog( "Model for AC 0.33-0.67 only:" )
  print( summary( lm( Rs_annual_bahn ~ Rs_annual, data=subset( sdata, Annual_TS_Coverage>=0.33 & Annual_TS_Coverage < 0.67 ) ) ) )
  printlog( SEPARATOR )
  printlog( "Model for AC>=0.67 only:" )
  print( summary( lm( Rs_annual_bahn ~ Rs_annual, data=subset( sdata, Annual_TS_Coverage>0.67 ) ) ) )
  
  p <- qplot( Rs_annual, Rs_annual_bahn, data=subset( sdata, !is.na( AC2 ) ), color=AC2 )
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
  print( p )
  saveplot( paste("3-AC_effect", var_sav))	
}


# -----------------------------------------------------------------------------
# Function 7: How much of the inaccuracy in the Rs_annual_bahn~Rs_annual relationship
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
# Function 8: flot data

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
# Function 9: What's the effect of drought? need new drought data
# Need another drought index and re-analysis
# cut( srdb$SPI, breaks = seq(-3,5,2) )

SPI_test <- function( sdata ) {
  printlog( SEPARATOR )
  printlog( "How does drought affect this relationship? (discrete)" )
  sdata$SPI2 <- cut( sdata$SPI, breaks = seq(-3,5,2) ) #c( 0, 0.33, 0.67, 1 ), right=F )
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
# Function 10: Main figure comparing Rs_annual with Rs_annual_bahn
# Updateed

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
# Function 11: Climate space figure
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

# -----------------------------------------------------------------------------
# Function 12: whether different TS source have effect

TS_Source_test <- function( sdata ) { 
  sdata$TS_Source2 <- 
    ifelse( sdata$TS_Source == 'Rs_Ts_Relationship', "Rs Ts Relationship"
            , ifelse(sdata$TS_Source == 'MGRsD', "From MGRsD",
                     ifelse(grepl("TAIR_Del", sdata$TS_Source, fixed = TRUE), 'Partly from TAIR', "From Paper" ) )  )
  
  p <- qplot( Rs_annual, Rs_annual_bahn, data=sdata, color=TS_Source2 )
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
  print( p )
  saveplot( "6-TS_Source_effect" )
}

# -----------------------------------------------------------------------------
# Function 13: plot and compare TS, TAnnnual, MAT calculated Rs_bahn with Rs_Annual
TSTSMAT_test <- function( sdata, bahn, panel_lab ) {
  
  m1 <- lm( bahn ~ Rs_annual, data=sdata )
  print( summary( m1 ) )
  
  p <- qplot( Rs_annual, bahn, data=sdata, ylim = c(0,7000) ) + geom_point( alpha = 0.1 )
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 ) + xlab(expression('Rs_Annual (g C/m'^2 * '/yr)')) +
    ylab(expression('Rs_bahn (g C/m'^2 * '/yr)' ) ) +
    annotate(geom="text", x=200, y=6200, label = panel_lab, color="black", hjust = 0)
  
  print (p)
  # saveplot( paste("5-TSTAMAT_comparison",bahn,"_" ))
}


# -----------------------------------------------------------------------------
# Function 14: See how Rs_annual is related to Rs_annual_bahn (using TS, T_Annual, and MAT as predictor)
Rs_annual_bahn_test <- function( sdata, temp, name="", quiet=F ) {
  printlog( SEPARATOR )
  if( name != "" ) {
    printlog( name )
    name <- paste0( "-", name )
  }
  printlog( "How are Rs_annual and Rs_annual_bahn_Temp related?" )
  printdims( sdata )
  
  cooks_count <- 0		# if 0, outlier code is disabled
  m <- lm( temp ~ Rs_annual, data=sdata )
  while( cooks_count > 0 ) {
    m <- lm( temp ~ Rs_annual, data=sdata )
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
  m1 <- lm( temp - 1 * Rs_annual ~ Rs_annual, data=sdata )
  printlog( "Test H0 of slope=1: p-value =", summary( m1 )$coefficients[ 2, 4 ] )
  
  invisible( list( m, m1 ) )
}



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


