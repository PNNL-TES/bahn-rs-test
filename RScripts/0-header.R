# 0-header.R
# BBL December 2013

# Common definitions and functions
# Source'd by all the processing scripts (1-, 2-, etc) before they run

OUTPUT_DIR		<- "outputs/"
LOG_DIR			<- "logs/"
SEPARATOR		<- "-------------------"

OUTCLIMDATA     <- paste0( "summarized_climate.csv" )

getwd()

# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
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


# ==============================================================================
# Main

if( !file.exists( OUTPUT_DIR ) ) {
	printlog( "Creating", OUTPUT_DIR )
	dir.create( OUTPUT_DIR )
}
if( !file.exists( LOG_DIR ) ) {
	printlog( "Creating", LOG_DIR )
	dir.create( LOG_DIR )
}
