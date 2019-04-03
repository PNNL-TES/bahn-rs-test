
# ****************************************************************************************************
# Basic functions
# ****************************************************************************************************

# 1 write data log wirh time-stamped output function
printlog <- function( msg="", ..., ts=TRUE, cr=TRUE ) {
  if( ts ) cat( date(), " " )
  cat( msg, ... )
  if( cr ) cat( "\n")
} # printlog

# 2 --------------------------------------------------------------------------------

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

# loadlibs(c("caTools"))

# 3 --------------------------------------------------------------------------------
# Print dimensions of data frame
printdims <- function( d, dname=deparse( substitute( d ) ) ) {
  stopifnot( is.data.frame( d ) )
  printlog( dname, "rows =", nrow( d ), "cols =", ncol( d ) )
} # printdims

# 4 --------------------------------------------------------------------------------
# not in function
'%!in%' <- function(x,y)!('%in%'(x,y))

# 5 --------------------------------------------------------------------------------
# aggregate function 
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=F,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     median = median   (xx[[col]], na.rm=na.rm),
                     #do.call("rbind", tapply(xx[[col]], measurevar, quantile, c(0.25, 0.5, 0.75)))
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval:
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

# 6 --------------------------------------------------------------------------------
# Save a ggplot figure, if not sepecify outputDir
saveplot <- function(outputDir, pname, p=last_plot(), ptype=".pdf" ) {
  fn <- paste0( outputDir, pname, ptype )
  printlog( "Saving", fn )
  ggsave( fn, p )
} # saveplot


