# 1-bahn_climate_udel.R
# BBL December 2013

# Climate data for Bahn analysis
# This script reads in srdb data file and looks up climate and PDSI data for each
# record. It now does this using direct extraction from netCDF files, which is 
# much faster than older nearest-neighbor method.

# install.packages('ncdf4')
# install.packages('ggplot2')
# install.packages('reshape')

rm (list = ls())
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()

loadlibs( c( "ggplot2", "reshape" ) )

source( "0-header.R" )

SRDB_DIR    <- "E:/PNNL/bahn-rs-test/srdb_v4"
SCRIPT			<- "1-bahn_climate_udel.R"
INFN		  	<- "srdb-data-v4-climate.csv"
OUTFN 			<- "srdb-data-climate.csv"



# ==============================================================================
# Main: plot and check results

sink( paste0( LOG_DIR, SCRIPT, ".txt" ), split=T )
printlog( "Welcome to", SCRIPT )

theme_set( theme_bw() )

# Read in SRDB
fn <- paste( SRDB_DIR, INFN, sep="/" )
printlog( "Reading", fn )
srdb <- read.csv( fn, stringsAsFactors=F )
printdims( srdb )


# LONPOS 			<- ( ( srdb$Longitude + LONSIZE/2 ) %% ( LONSIZE/2 ) ) * 2 + 1
# LATPOS 			<- ( 90 - srdb$Latitude ) * 2 + 1
# LONPOS_PDSI 	<- ( srdb$Longitude - -180 ) / 360 * PDSI_LONSIZE
# LATPOS_PDSI 	<- ( srdb$Latitude - -90 ) / 180 * PDSI_LATSIZE
# YEARMIN 		<- round( srdb$Study_midyear - srdb$YearsOfData/2.01 )
# YEARMAX 		<- round( srdb$Study_midyear + srdb$YearsOfData/2.01 )


colnames (srdb)

srdb[srdb$MAP > 4000 & !is.na(srdb$MAP),]$MAP_Del

p1 <- qplot( MAT, MAT_Del, data=srdb ) + geom_abline( slope=1, linetype = "dotdash", size = 1.5, col = "red") + geom_smooth( method='lm' )
print( p1 )
saveplot( "1-Diagnostic_MAT_MATDel" )

p2 <- qplot( Study_temp, TAnnual_Del, data=srdb ) + geom_abline( slope=1, linetype = "dotdash", size = 1.5, col = "red") + geom_smooth( method='lm' )
print( p2 )
saveplot( "2-Diagnostic_MAT_TAnnualDel" )

p3 <- qplot( MAP, MAP_Del, data=srdb ) +  geom_abline( slope=1, linetype = "dotdash", size = 1.5, col = "red") + geom_smooth( method='lm' )
print( p3 )
saveplot( "3-Diagnostic_MAP_MAPDel" )

p4 <- qplot( Study_precip, PAnnual_Del, data=srdb ) +  geom_abline( slope=1, linetype = "dotdash", size = 1.5, col = "red") + geom_smooth( method='lm' )
print( p4 )
saveplot( "4-Diagnostic_MAP_PAnnualDel" )

printlog( "Closing files..." )


printlog( "All done with", SCRIPT )
sink()
