# 1-bahn_climate_udel.R
# BBL December 2013

# Climate data for Bahn analysis
# This script reads in srdb data file and looks up climate and PDSI data for each
# record. It now does this using direct extraction from netCDF files, which is 
# much faster than older nearest-neighbor method.

source( "0-header.R" )

SCRIPT			<- "1-bahn_climate_udel.R"
INFN			<- "srdb-data.csv"
OUTFN 			<- "srdb-data-climate.csv"

CLIMATE_DIR		<- "~/Data/UDel/"
LONSIZE			<- 720
LATSIZE			<- 360
PDSI_DIR		<- "~/Data/NCAR_PDSI/"
PDSI_LONSIZE	<- 144
PDSI_LATSIZE	<- 55
SRDB_DIR 		<- "./" # "./srdb_20131218a/"

# -----------------------------------------------------------------------------
# Open a netCDF file and return handle
open_ncdf <- function( fn, datadir="." ) {
	fqfn <- paste( datadir, fn, sep="/" )
	printlog( "Opening", fqfn )
	stopifnot( file.exists( fqfn ) )
	open.ncdf( fqfn )
} # open_ncdf

# -----------------------------------------------------------------------------
# Test code to visualize standard deviation of climate data. Normally not used
testsd <- function() {
	precip.mon.ltm <- open_ncdf( "precip.mon.ltm.v301.nc", CLIMATE_DIR )
	d <- data.frame()
	for( i in 1:12) {
		d1 <- get.var.ncdf(precip.mon.ltm,"precip",c(1,1,i),c(-1,-1,1))
		d <- rbind(d,melt(d1))
	}

	d2 <- ddply(d,.(X1,X2),summarise,value_sd = sd(value),.progress="text") # slow!
	qplot(X1,X2,data=d2,color=value_sd)
}

# -----------------------------------------------------------------------------
# Get netCDF data from a box around grid point. Recursive
get_pointdata <- function( ncid, varname, startdata, countdata, boxsize, maxbs=10, FUN='mean' ) {

	f <- match.fun( FUN )
	sdata <- startdata
	cdata <- countdata
	sdata[ 1 ] <- max( 1, sdata[ 1 ]-boxsize )
	sdata[ 2 ] <- max( 1, sdata[ 2 ]-boxsize )
	cdata[ 1 ] <- min( LONSIZE, cdata[ 1 ]+boxsize*2 )
	cdata[ 2 ] <- min( LATSIZE, cdata[ 2 ]+boxsize*2 )
	printlog( "  Trying", varname, boxsize, "start", sdata, ", count", cdata )
	vals <- get.var.ncdf( ncid, varname, start=sdata, count=cdata )
	val_mean <- f( vals, na.rm=T )

	if( !is.finite( val_mean ) & boxsize < maxbs ) {
		return( get_pointdata( ncid, varname, startdata, countdata, boxsize+1 ) )	# recurse w/ bigger box
	} else {
		return( val_mean ) 
	}
} # get_pointdata

# -----------------------------------------------------------------------------
# Filter to data with annual Rs, model_type of exponential, long/lat, etc.
filtration1 <- function( srdb ) {
	srdb <- subset( srdb, !is.na( Latitude ) & !is.na( Longitude ) )
	printlog( "Filtered for lat/long:", nrow( srdb ) )
	srdb <- subset( srdb, !is.na( Study_midyear ) & !is.na( YearsOfData ) )
	printlog( "Filtered for Study_midyear and YearsOfData:", nrow( srdb ) )
	srdb <- srdb[ !is.na( srdb$Rs_annual) & srdb$Rs_annual > 0, ]
	printlog( "Filtered for annual Rs:", nrow( srdb ) )
	srdb <- srdb[ srdb$Model_output_units != "", ]
	printlog( "Filtered for non-empty model units:", nrow( srdb ) )
	srdb <- srdb[ !is.na( srdb$Model_paramA ) & !is.na( srdb$Model_paramA ), ]
	printlog( "Filtered for non-empty model parameters:", nrow( srdb ) )
	srdb <- srdb[ srdb$Manipulation=="None", ]
	printlog( "Filtered for non-manipulated:", nrow( srdb ) )
	return( srdb )
} # filtration


# ==============================================================================
# Main

sink( paste0( LOG_DIR, SCRIPT, ".txt" ), split=T )
printlog( "Welcome to", SCRIPT )

loadlibs( c( "ncdf", "ggplot2", "reshape" ) )
theme_set( theme_bw() )

fn <- paste( SRDB_DIR, INFN, sep="/" )
printlog( "Reading", fn )
srdb <- read.csv( fn, stringsAsFactors=F )
printdims( srdb )

srdb <- filtration1( srdb )

LONPOS 			<- ( ( srdb$Longitude + LONSIZE/2 ) %% ( LONSIZE/2 ) ) * 2 + 1
LATPOS 			<- ( 90 - srdb$Latitude ) * 2 + 1
LONPOS_PDSI 	<- ( srdb$Longitude - -180 ) / 360 * PDSI_LONSIZE
LATPOS_PDSI 	<- ( srdb$Latitude - -90 ) / 180 * PDSI_LATSIZE
YEARMIN 		<- round( srdb$Study_midyear - srdb$YearsOfData/2.01 )
YEARMAX 		<- round( srdb$Study_midyear + srdb$YearsOfData/2.01 )

air.mon.ltm <- open_ncdf( "air.mon.ltm.v301.nc", CLIMATE_DIR )
air.mon.mean <- open_ncdf( "air.mon.mean.v301.nc", CLIMATE_DIR )
precip.mon.ltm <- open_ncdf( "precip.mon.ltm.v301.nc", CLIMATE_DIR )
precip.mon.total <- open_ncdf( "precip.mon.total.v301.nc", CLIMATE_DIR )
pdsi <- open_ncdf( "pdsi.mon.mean.selfcalibrated.nc", PDSI_DIR )

printlog( "Generating map..." )
tairmap <- get.var.ncdf( air.mon.mean, "air", 
	start=c( 1, 1, 1 ), count=c( -1, -1, 1 ) )
#rotate <- function(x) t(apply(x, 2, rev))
image( tairmap )
pdsimap <- get.var.ncdf( pdsi, "pdsi", start=c( 1, 1, 5+12*100 ), count=c( -1, -1, 1 ) )
#image( pdsimap )

for( i in 1:nrow( srdb ) ) {	# Could do this slightly more efficiently using ddply
	
	printlog( i, srdb[ i, "Author" ], "#", srdb[ i, "Record_number" ], srdb[ i, "Country" ] )
	printlog( "  Study_midyear =", srdb[ i, "Study_midyear" ], 
		srdb[ i, "YearsOfData" ], srdb[ i, "Longitude" ], srdb[ i, "Latitude" ] )

	lonpos <- max( 1, LONPOS[ i ] )
	latpos <- max( 1, LATPOS[ i ] )
	lonpos_pdsi <- max( 1, LONPOS_PDSI[ i ] )
	latpos_pdsi <- max( 1, LATPOS_PDSI[ i ] )

	mean_tair <- 0
	sd_tair <- 0
	mean_precip <- 0
	sd_precip <- 0
	max_pdsi <- 0
	nyr <- 0
	for( yr in seq( YEARMIN[ i ], YEARMAX[ i ], by=1 ) ) {
		
		if( yr>2010 ) {
			printlog( "  ** NO DATA PAST 2010; skipping **" )
			next
		}
		
		# compute positions in file
		timepos <- ( yr-1900 ) * 12 + 1
		timepos_pdsi	<- (yr-1850 ) * 12 + 1
		printlog( "  ", yr, lonpos, latpos, timepos )
		
		pointcol <- "lightgrey"
		tair_val <- get_pointdata( air.mon.mean, "air", c( lonpos, latpos, timepos ), c( 1, 1, 12 ), boxsize=0 )
		tair_sd <- get_pointdata( air.mon.mean, "air", c( lonpos, latpos, timepos ), c( 1, 1, 12 ), boxsize=0, FUN='sd' )
		precip_val <- get_pointdata( precip.mon.total, "precip", c( lonpos, latpos, timepos ), c( 1, 1, 12 ), boxsize=0 )
		precip_sd <- get_pointdata( precip.mon.total, "precip", c( lonpos, latpos, timepos ), c( 1, 1, 12 ), boxsize=0, FUN='sd' )
		pdsi_val <- get_pointdata( pdsi, "pdsi", c( lonpos_pdsi, latpos_pdsi, timepos_pdsi ), c( 1, 1, 12 ), boxsize=0, FUN='max' )
		
		mean_tair <- mean_tair + tair_val
		sd_tair <- sd_tair + tair_sd
		mean_precip <- mean_precip + precip_val * 12
		sd_precip <- sd_precip + precip_sd
		max_pdsi <- max( max_pdsi, pdsi_val )
		nyr <- nyr + 1
	}

	if( !is.finite( mean_tair ) ) {
			pointcol <- "red"
	}
	points( lonpos/LONSIZE, latpos/LATSIZE, col=pointcol )
#	points( lonpos_pdsi/PDSI_LONSIZE, latpos_pdsi/PDSI_LATSIZE, col=pointcol )
	#readline()

	mean_tair <- mean_tair / nyr
	sd_tair <- sd_tair / nyr
	mean_precip <- mean_precip / nyr
	sd_precip <- sd_precip / nyr
	lt_mean_tair <- get_pointdata( air.mon.ltm, "air", c( lonpos, latpos, 1 ), c( 1, 1, 12 ), boxsize=0 )
	lt_mean_precip <- get_pointdata( precip.mon.ltm, "precip", c( lonpos, latpos, 1 ), c( 1, 1, 12 ), boxsize=0 ) * 12
	printlog( "  OK. Tair =", mean_tair, lt_mean_tair, "Precip =", mean_precip, lt_mean_precip, "PDSI =", max_pdsi, "Years =", nyr )

	srdb[ i, "TAIR" ] <- mean_tair
	srdb[ i, "TAIR_SD" ] <- sd_tair
	srdb[ i, "TAIR_LTM" ] <- lt_mean_tair
	srdb[ i, "PRECIP" ] <- mean_precip
	srdb[ i, "PRECIP_SD" ] <- sd_precip
	srdb[ i, "PRECIP_LTM" ] <- lt_mean_precip
	srdb[ i, "PDSI" ] <- max_pdsi
}

printlog( "Done with lookup. Changing precip to mm..." )
srdb$PRECIP <- srdb$PRECIP * 10
srdb$PRECIP_SD <- srdb$PRECIP_SD * 10
srdb$PRECIP_LTM <- srdb$PRECIP_LTM * 10

printlog( "Writing", OUTFN )
write.csv( srdb, OUTFN, row.names=F )
print( summary( srdb[ , c( "TAIR", "TAIR_SD", "TAIR_LTM", "PRECIP", "PRECIP_SD", "PRECIP_LTM", "PDSI" ) ] ) )

printlog( "Making data for climate distribution plot..." )
tair_m <- matrix( 0, nrow=LONSIZE, ncol=LATSIZE )
precip_m <- matrix( 0, nrow=LONSIZE, ncol=LATSIZE )
for( i in 1:12 ) {
	tair_m <- tair_m + get.var.ncdf( air.mon.ltm, "air", start=c( 1, 1, i ), count=c( -1, -1, 1 ) )
	precip_m <- precip_m + get.var.ncdf( precip.mon.ltm, "precip", start=c( 1, 1, i ), count=c( -1, -1, 1 ) )
}
d <- data.frame( mat=melt( tair_m/12 )$value, map=melt( precip_m*10 )$value )

printlog( "Writing..." )
write.csv( d, OUTCLIMDATA, row.names=F )

p1 <- qplot( MAT, TAIR_LTM, data=srdb ) + geom_abline( slope=1 ) + geom_smooth( method='lm' )
print( p1 )
saveplot( "1-Diagnostic_tair" )

p2 <- qplot( Study_temp, TAIR, data=srdb ) + geom_abline( slope=1 ) + geom_smooth( method='lm' )
print( p2 )
saveplot( "1-Diagnostic_tair2" )

p3 <- qplot( MAP, PRECIP_LTM, data=srdb ) + geom_abline( slope=1 ) + geom_smooth( method='lm' )
print( p3 )
saveplot( "1-Diagnostic_precip" )

printlog( "Closing files..." )
close.ncdf( air.mon.ltm )
close.ncdf( air.mon.mean )
close.ncdf( precip.mon.ltm )
close.ncdf( precip.mon.total )
close.ncdf( pdsi )

printlog( "All done with", SCRIPT )
sink()
