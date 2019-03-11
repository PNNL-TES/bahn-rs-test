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
# Main: begin
# To do this in SQL

# sink( paste0( LOG_DIR, SCRIPT, ".txt" ), split=T )
# printlog( "Welcome to", SCRIPT )
# 
# theme_set( theme_bw() )
# 
# # Read in SRDB
# fn <- paste( SRDB_DIR, INFN, sep="/" )
# printlog( "Reading", fn )
# srdb <- read.csv( fn, stringsAsFactors=F )
# printdims( srdb )
# 
# 
# # LONPOS 			<- ( ( srdb$Longitude + LONSIZE/2 ) %% ( LONSIZE/2 ) ) * 2 + 1
# # LATPOS 			<- ( 90 - srdb$Latitude ) * 2 + 1
# # LONPOS_PDSI 	<- ( srdb$Longitude - -180 ) / 360 * PDSI_LONSIZE
# # LATPOS_PDSI 	<- ( srdb$Latitude - -90 ) / 180 * PDSI_LATSIZE
# # YEARMIN 		<- round( srdb$Study_midyear - srdb$YearsOfData/2.01 )
# # YEARMAX 		<- round( srdb$Study_midyear + srdb$YearsOfData/2.01 )
# 
# 
# for( i in 1:nrow( srdb ) ) {	# Could do this slightly more efficiently using ddply
#   
#   printlog( i, srdb[ i, "Author" ], "#", srdb[ i, "Record_number" ], srdb[ i, "Country" ] )
#   printlog( "  Study_midyear =", srdb[ i, "Study_midyear" ], 
#             srdb[ i, "YearsOfData" ], srdb[ i, "Longitude" ], srdb[ i, "Latitude" ] )
#   
#   lonpos <- max( 1, LONPOS[ i ] )
#   latpos <- max( 1, LATPOS[ i ] )
#   # lonpos_pdsi <- max( 1, LONPOS_PDSI[ i ] ) # need a new PDSI data
#   # latpos_pdsi <- max( 1, LATPOS_PDSI[ i ] ) # need a new PDSI data
#   
#   mean_tair <- 0
#   sd_tair <- 0
#   mean_precip <- 0
#   sd_precip <- 0
#   max_pdsi <- 0
#   nyr <- 0
#   for( yr in seq( YEARMIN[ i ], YEARMAX[ i ], by=1 ) ) {
#     
#     if( yr>2017 ) {
#       printlog( "  ** NO DATA PAST 2010; skipping **" )
#       next
#     }
#     
#     # compute positions in file
#     timepos <- ( yr-1900 ) * 12 + 1
#     # timepos_pdsi	<- (yr-1850 ) * 12 + 1 # need a new PDSI data
#     printlog( "  ", yr, lonpos, latpos, timepos )
#     
#     pointcol <- "lightgrey"
#     
#     # Match SRDB with climate data source
#     
#     tair_val <- get_pointdata( air.mon.mean, "air", c( lonpos, latpos, timepos ), c( 1, 1, 12 ), boxsize=0 )
#     tair_sd <- get_pointdata( air.mon.mean, "air", c( lonpos, latpos, timepos ), c( 1, 1, 12 ), boxsize=0, FUN='sd' )
#     precip_val <- get_pointdata( precip.mon.total, "precip", c( lonpos, latpos, timepos ), c( 1, 1, 12 ), boxsize=0 )
#     precip_sd <- get_pointdata( precip.mon.total, "precip", c( lonpos, latpos, timepos ), c( 1, 1, 12 ), boxsize=0, FUN='sd' )
#     pdsi_val <- get_pointdata( pdsi, "pdsi", c( lonpos_pdsi, latpos_pdsi, timepos_pdsi ), c( 1, 1, 12 ), boxsize=0, FUN='max' )
#     
#     mean_tair <- mean_tair + tair_val
#     sd_tair <- sd_tair + tair_sd
#     mean_precip <- mean_precip + precip_val * 12
#     sd_precip <- sd_precip + precip_sd
#     # max_pdsi <- max( max_pdsi, pdsi_val ) # need a new PDSI data
#     nyr <- nyr + 1
#   }
#   
#   if( !is.finite( mean_tair ) ) {
#     pointcol <- "red"
#   }
#   points( lonpos/LONSIZE, latpos/LATSIZE, col=pointcol )
#   #	points( lonpos_pdsi/PDSI_LONSIZE, latpos_pdsi/PDSI_LATSIZE, col=pointcol )
#   #readline()
#   
#   mean_tair <- mean_tair / nyr
#   sd_tair <- sd_tair / nyr
#   mean_precip <- mean_precip / nyr
#   sd_precip <- sd_precip / nyr
#   lt_mean_tair <- get_pointdata( air.mon.ltm, "air", c( lonpos, latpos, 1 ), c( 1, 1, 12 ), boxsize=0 )
#   lt_mean_precip <- get_pointdata( precip.mon.ltm, "precip", c( lonpos, latpos, 1 ), c( 1, 1, 12 ), boxsize=0 ) * 12
#   printlog( "  OK. Tair =", mean_tair, lt_mean_tair, "Precip =", mean_precip, lt_mean_precip, "PDSI =", max_pdsi, "Years =", nyr )
#   
#   srdb[ i, "TAIR" ] <- mean_tair
#   srdb[ i, "TAIR_SD" ] <- sd_tair
#   srdb[ i, "TAIR_LTM" ] <- lt_mean_tair
#   srdb[ i, "PRECIP" ] <- mean_precip
#   srdb[ i, "PRECIP_SD" ] <- sd_precip
#   srdb[ i, "PRECIP_LTM" ] <- lt_mean_precip
#   srdb[ i, "PDSI" ] <- max_pdsi
# }
# 
# printlog( "Done with lookup. Changing precip to mm..." )
# srdb$PRECIP <- srdb$PRECIP * 10
# srdb$PRECIP_SD <- srdb$PRECIP_SD * 10
# srdb$PRECIP_LTM <- srdb$PRECIP_LTM * 10
# 
# printlog( "Writing", OUTFN )
# write.csv( srdb, OUTFN, row.names=F )
# print( summary( srdb[ , c( "TAIR", "TAIR_SD", "TAIR_LTM", "PRECIP", "PRECIP_SD", "PRECIP_LTM", "PDSI" ) ] ) )
# 
# printlog( "Making data for climate distribution plot..." )
# tair_m <- matrix( 0, nrow=LONSIZE, ncol=LATSIZE )
# precip_m <- matrix( 0, nrow=LONSIZE, ncol=LATSIZE )
# for( i in 1:12 ) {
#   tair_m <- tair_m + get.var.ncdf( air.mon.ltm, "air", start=c( 1, 1, i ), count=c( -1, -1, 1 ) )
#   precip_m <- precip_m + get.var.ncdf( precip.mon.ltm, "precip", start=c( 1, 1, i ), count=c( -1, -1, 1 ) )
# }
# d <- data.frame( mat=melt( tair_m/12 )$value, map=melt( precip_m*10 )$value )
# 
# printlog( "Writing..." )
# write.csv( d, OUTCLIMDATA, row.names=F )

# ==============================================================================
# Main end


# ==============================================================================
# plot and check results

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
