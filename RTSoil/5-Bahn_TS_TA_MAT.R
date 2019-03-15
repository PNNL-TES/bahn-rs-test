
INFN 			<- "MGRsD-data-processed.csv"
loadlibs( c( "ggplot2", "reshape" ) )
theme_set( theme_bw() )
srdb <- read.csv( INFN, stringsAsFactors=F )

TSTSMAT_test <- function( sdata, bahn ) {
  
  m1 <- lm( bahn ~ Rs_annual, data=sdata )
  print( summary( m1 ) )
  
  p <- qplot( Rs_annual, bahn, data=sdata, ylim = c(0,7000) ) + geom_point( alpha = 0.1 )
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
  print (p)
  # saveplot( paste("5-TSTAMAT_comparison",bahn,"_" ))
}


TSTSMAT_test(srdb, srdb$Rs_annual_bahn)
TSTSMAT_test(srdb, srdb$Rs_annual_bahn_TAnnual)
TSTSMAT_test(srdb, srdb$Rs_annual_bahn_MAT)


print( summary( lm( srdb$Rs_annual_bahn ~ srdb$Rs_annual, data=srdb ) ) )
