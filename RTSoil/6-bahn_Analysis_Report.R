## ---- echo=FALSE---------------------------------------------------------



## ------------------------------------------------------------------------



## ----message=FALSE, results='hide'---------------------------------------
library(knitr)
knit('6-bahn_Analysis_Report.Rmd', tangle=TRUE)
source( '3-bahn_analysis.R' )


## ------------------------------------------------------------------------
srdb_orig <- read.csv( INFN, stringsAsFactors=F )
srdb <- srdb_orig
srdb_05 <- filtration3( srdb_orig, 0.5, quiet=T )


## ------------------------------------------------------------------------
figA <- climate_figure( srdb_orig )

