
rm (list = ls())
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()
source( "0-header.R" )

# install.packages("gridExtra")
library("gridExtra")
INFN 			<- "MGRsD-data-processed.csv"
loadlibs( c( "ggplot2", "reshape" ) )
theme_set( theme_bw() )
srdb <- read.csv( INFN, stringsAsFactors=F )

# -----------------------------------------------------------------------------
# Function plot and compare TS, TAnnnual, MAT calculated Rs_bahn with Rs_Annual
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
# See how Rs_annual is related to Rs_annual_bahn (using TS, T_Annual, and MAT as predictor)
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


# ----------------------------------------------------------------------------- BEGAIN
# See how Rs_annual is related to Rs_annual_bahn_Temp
TSTSMAT_test(srdb, srdb$Rs_annual_bahn, panel_lab = '(a) TS as predictor')
test_TS <- Rs_annual_bahn_test(srdb, srdb$Rs_annual_bahn)
m_TS <- test_TS[[ 1 ]]
m1_TS <- test_TS[[ 2 ]]
intercept_test <- summary( m_TS )$coefficients[ 1, 4 ]
slope_test <- summary( m1_TS )$coefficients[ 2, 4 ]
intercept_test
slope_test

# TAnnual
TSTSMAT_test(srdb, srdb$Rs_annual_bahn_TAnnual, panel_lab = '(b) T_Annual as predictor')
test_TAnnual <- Rs_annual_bahn_test(srdb, srdb$Rs_annual_bahn_TAnnual)
m_TAnnual <- test_TAnnual[[ 1 ]]
m1_TAnnual <- test_TAnnual[[ 2 ]]
intercept_test <- summary( m_TAnnual )$coefficients[ 1, 4 ]
slope_test <- summary( m1_TAnnual )$coefficients[ 2, 4 ]
intercept_test
slope_test

# MAT
subset(srdb,is.na(srdb$Rs_annual_bahn_TAnnual) )

TSTSMAT_test(srdb, srdb$Rs_annual_bahn_MAT, panel_lab = '(c) MAT as predictor')
test_MAT <- Rs_annual_bahn_test(srdb, srdb$Rs_annual_bahn_MAT)
m_MAT <- test_MAT[[ 1 ]]
m1_MAT <- test_MAT[[ 2 ]]
intercept_test <- summary( m_MAT )$coefficients[ 1, 4 ]
slope_test <- summary( m1_MAT )$coefficients[ 2, 4 ]
intercept_test
slope_test

# ----------------------------------------------------------------------------- END
getwd()
# output figure
tiff("/Users/jian107/PNNL/bahn-rs-test/RTSoil/outputs/5-TSTAMAT_comparison.tiff", width = 6, height = 8, pointsize = 1/300, units = 'in', res = 300)
grid.arrange(TSTSMAT_test(srdb, srdb$Rs_annual_bahn, panel_lab = '(a) TS as predictor')
             , TSTSMAT_test(srdb, srdb$Rs_annual_bahn_TAnnual, panel_lab = '(b) T_Annual as predictor')
             , TSTSMAT_test(srdb, srdb$Rs_annual_bahn_MAT, panel_lab = '(c) MAT as predictor'), ncol = 1, nrow = 3)
dev.off()

print( summary( lm( srdb$Rs_annual_bahn ~ srdb$Rs_annual, data=srdb ) ) )

