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

source( "0-header.R" )
loadlibs( c( "ggplot2", "reshape" ) )


SRDB_DIR    <- "~/PNNL/bahn-rs-test/MGRsD"
SCRIPT			<- "1-bahn_climate_udel.R"
INFN		  	<- "MGRsD-data-v4-TSoil.csv"
OUTFN 			<- "MGRsD-data-climate.csv"


# ==============================================================================
# plot and check results

# Read in SRDB
fn <- paste( SRDB_DIR, INFN, sep="/" )
printlog( "Reading", fn )
srdb <- read.csv( fn, stringsAsFactors=F )
printdims( srdb )

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


# ==============================================================================
# Output MGRsD-data-climate.csv

sink( paste0( LOG_DIR, SCRIPT, ".txt" ), split=T )
printlog( "Welcome to", SCRIPT )

theme_set( theme_bw() )


printlog( "Done with lookup. Changing precip to mm..." )


printlog( "Writing", OUTFN )
write.csv( srdb, OUTFN, row.names=F )
print( summary( srdb[ , c( "TAnnual_Del", "TAIR_SD", "PAnnual_Del", "PRECIP_SD", "SPI" ) ] ) )

printlog( "Making data for climate distribution plot..." )

printlog( "Writing..." )
# write.csv( d, OUTCLIMDATA, row.names=F )

sink()

# ==============================================================================
# Output MGRsD-data-climate.csv END


