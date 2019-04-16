
# ****************************************************************************************************
# I. Rs_MDT ~ Rs_diurnal
# ****************************************************************************************************

# Rs_mat for Rs_diurnal
Rs_mat_Rs_diurnal <- function () {
  HGRsD_dir <- "HGRsD"
  HGRsD <- read.csv(paste(HGRsD_dir, "2.HGRsD_OriginalData.csv", sep="/"))
  HGRsD <- HGRsD[order(HGRsD$MiddleClimate,HGRsD$StudyNumber,HGRsD$TimeLable),] 
  ID <- sort(unique(HGRsD$StudyNumber), decreasing = FALSE, na.last = TRUE )
  Rs_diurnal_bahn <- as.data.frame(matrix(NA, nrow = 0, ncol = 7))
  for (i in ID) {
    sub_ID <- subset(HGRsD, HGRsD$StudyNumber == i)
    DOY <- sort(unique(sub_ID$Measure_DOY), decreasing = FALSE, na.last = F)
    
    for (j in DOY) {
      sub_DOY <- subset(sub_ID, sub_ID$Measure_DOY == j)
      # get Rs_mean
      Rs_mean <- mean(sub_DOY$RS_Norm)
      # get Ts_mean
      Ts_mean <- ifelse(length(sub_DOY$Tsoil.C.)>=6, mean(sub_DOY$Tsoil.C.), NA )
      
      # Rs_Ts_mean - Rs when sil temperature reach diurnal mean
      # first get time period reach daily mean Ts
      # attach(sub_DOY)
      # min(abs(Rs_mean - RS_Norm))
      # which( abs(Rs_mean - RS_Norm) == min(abs(Rs_mean - RS_Norm)) )
      # subset( sub_DOY, region == which( abs(Rs_mean - RS_Norm) == min(abs(Rs_mean - RS_Norm)) ) ,
      #         select=c(RS_Norm) )
      # ? subset()
      sub_DOY[which( abs(Rs_mean - sub_DOY$RS_Norm) == min(abs(Rs_mean - sub_DOY$RS_Norm)) ), ]$RS_Norm
      
      Rs_Ts_mean <- ifelse( is.na(Ts_mean), NA
                            , sub_DOY[which( abs(Rs_mean - sub_DOY$RS_Norm) == min(abs(Rs_mean - sub_DOY$RS_Norm)) ), ]$RS_Norm )
      
      Time_label <- ifelse( is.na(Ts_mean), NA
                            ,sub_DOY[which( abs(Rs_mean - sub_DOY$RS_Norm) == min(abs(Rs_mean - sub_DOY$RS_Norm)) ), ]$TimeLable )
      
      # use bahn approach calculate Rs_bahn
      Rs_bahn <- 455.8 * ( Rs_Ts_mean ^ 1.0054 )/365.5
      
      sub_diurnal_Rs_bahn <- c(i, j, Rs_mean, Ts_mean,Rs_Ts_mean, Time_label, Rs_bahn)
      # colnames(sub_diurnal_Rs_bahn) <- colnames(Rs_diurnal_bahn)
      Rs_diurnal_bahn <- rbind(Rs_diurnal_bahn, sub_diurnal_Rs_bahn)
    }
  }
  
  colnames(Rs_diurnal_bahn) <- c("ID", "DOY", "Rs_diurnal_mean", "Ts_diurnal_mean", "Rs_Ts_mean", "Time_label", "Rs_diurnal_bahn")
  Rs_diurnal_bahn <- Rs_diurnal_bahn[!is.na(Rs_diurnal_bahn$Rs_diurnal_bahn), ]
  
  p2 <- qplot(Rs_Ts_mean, Rs_diurnal_mean, data = Rs_diurnal_bahn) + 
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red", size = 1.5) + 
    geom_smooth(method = "lm") + 
    xlab (expression ("Measured diurnal Rs (g C m"^-2 * " d"^-1* ")") ) +
    ylab (expression ("Rs when reach diurnal Ts (g C m"^-2 * " d"^-1* ")") )
  
  # histgram of time_label
  p3 <- qplot(Time_label, geom="histogram", data = Rs_diurnal_bahn, bins = 48) +
    xlab (expression ("Time period reach diurnal mean Ts (" * degree~C * ")") ) +
    ylab ('Frequency (n)')
  
  print (plot_grid(p2, p3, ncol = 2, labels = c('( a )', '( b )')
                   , vjust = c(3.5,3.5), hjust = c(-2.5, -2) ))
  invisible (list(p2, p3))
}


# ****************************************************************************************************
# II. Filtration functions for bahn-rs-analysis
# ****************************************************************************************************

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
                "mtr_out", "Rs_TAIR_units", "Rs_TAIR", "Rs_annual_bahn", "TAIR_dev", "TAIR_LTM_dev"  )
  
  srdb <- srdb_orig[ fields ]	
  srdb <- subset( srdb, Rs_annual < 2500 ) # test whether two extreme points pull the slope off 1
  srdb
} # filtration

# function to remove part of records

# -----------------------------------------------------------------------------
filtration_mk <- function( srdb, fil_type = F, var=F, mk=T ) {
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
                "SPI", "pdsi_pm_mean",
                "mtr_out", "Rs_TAIR_units", "Rs_TAIR", "Rs_annual_bahn", "TAIR_dev", "TAIR_LTM_dev", "Rs_TAIR_TAnnual"
  )
  
  srdb <- srdb_orig[ fields ]	
  if (mk) {srdb <- subset( srdb, fil_type %!in% var )} else {
    srdb <- subset( srdb, fil_type %in% var )
  }
  srdb
} # filtration

# -----------------------------------------------------------------------------
filtration3 <- function( srdb, tdiff_max, quiet=F ) {
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
  
    srdb <- subset( srdb, is.na( Study_temp ) | TAIR_LTM_dev <= tdiff_max )
    # srdb <- subset( srdb, is.na( Study_temp ) | TAIR_dev <= tdiff_max )
  
  srdb
} 


# -----------------------------------------------------------------------------
# filt function 4: How much of the inaccuracy in the Rs_annual~Rs_annual_bahn relationship
# is due to inaccuracies in the air temperature dataset?
filtration4 <- function( srdb, pdiff_max=50, quiet=F ) {
  fields <- c( 	"Record_number", "Study_number",
                "Author", "Site_name", "Study_midyear", "YearsOfData", 
                "Latitude", "Longitude", "Biome", "Ecosystem_type", 
                "MAT", "MAP", "Study_temp", "Study_precip",
                "Meas_interval", "Annual_coverage", "Meas_method",
                "Rs_annual", "Rs_annual_err", "Rs_wet", "Rs_dry", "RC_annual",
                "Model_type", "R10",
                "TAnnual_Del", "TAIR_SD", 
                "PAnnual_Del", "PRECIP_SD", 
                "MAP_Del", 
                "SPI",
                "mtr_out", "Rs_TAIR_units", "Rs_TAIR", "Rs_annual_bahn", "TAIR_dev", "TAIR_LTM_dev"
  )
  
  srdb <- srdb_orig[ fields ]		
  printdims( srdb )
  
  srdb$PRECIP_MAP_dev <- abs(srdb$MAP_Del - srdb$MAP)
  
    # srdb <- subset( srdb, is.na( MAT ) | TAIR_LTM_dev <= tdiff_max )
  srdb <- subset( srdb, !is.na( MAP ) & PRECIP_MAP_dev <= pdiff_max )
  
  srdb
} 

# colnames(srdb)
# max(abs(srdb$MAP_Del - srdb$MAP), na.rm = T)


# ****************************************************************************************************
# III. Method functions
# ****************************************************************************************************


climate_figure <- function( srdb, name="" ) {
  sdata <- srdb
  #d <- subset( d, mat>-30 )
  d <- read.csv( OUTCLIMDATA )
  p <- ggplot( d, aes( MAT, MAP ) )
  p <- p + geom_bin2d( alpha=0.5 ) + scale_fill_gradient( low="lightgrey", high="black" )
  p <- p + xlab( expression( MAT~group("(",paste(degree,C),")")  ) ) + ylab( "MAP (mm)" )
  #p <- p + geom_point( data=sdata, aes( x=5, y=750, color=Biome ) )
  p <- p + geom_jitter( data=sdata, aes( x=MAT_Del, y=MAP_Del, color=Ecosystem_type ) ) #, show_guide=F )
  p <- p + guides( fill=F ) + ggtitle("Rs samples covered MAT/MAP") +
    theme(legend.position = c(0.25, 0.65), legend.background = element_rect(fill = alpha('white', 0), size = 0.75))
  print( p )
  invisible( p )
}

# -----------------------------------------------------------------------------
# Function 3.2: Repationship between Rs_annual and Rs_mat (Rs_TAIR, means Rs measured at MAT moment)
compare_Rs_annual_Rs_TAIR <- function( sdata, name="" ) {
  printlog( SEPARATOR )
  printlog( "Bahn relationship for these data:" )
  sdata$Rs_TAIR <- sdata$Rs_TAIR * 365
  m <- lm(Rs_annual ~ Rs_TAIR, data=sdata )
  print( summary( m ) )
  p <- p <- qplot(Rs_TAIR, Rs_annual, data=sdata )
  p <- p + geom_smooth(method = 'lm') + geom_abline(linetype = 2) +
    ggtitle("Rs_Annual vs. Rs_MAT") + 
    ylab(expression("Rs_annual (g C m"^2 * "yr" ^-1 * ")"))+
    xlab(expression("Rs_mast (g C m"^2 * "yr" ^-1 * ")"))
  print(p)
  p_inter <- round(summary( m )$coefficients[ 1, 4 ], 4)
  
  # method 1: model y-1*x ~ x, this actually test whether slope differ from 0 for the y-1*x ~ x
  print(paste0('first method', SEPARATOR, 'test whether intercept=0 and slope=0 for [y-1x ~ x] model'))
  m1 <- lm( Rs_annual - 1 * Rs_TAIR ~ Rs_TAIR, data=sdata )
  p_slope <- summary( m1 )$coefficients[ 2, 4 ]
  print( paste('p_intercept = ', p_inter, ', p_slope = ', p_slope, sep = '') )
  
  # method 2: this test slope differ from 1
  print(paste0('second method', SEPARATOR, 'test intercept and check whether get same results'))
  t_inter <- (summary(m)$coefficients[1, 1] - 0)/summary(m)$coefficients[1, 2]
  p_inter <- 2*pt(t_inter, m$df, lower=FALSE)
  print( paste0('t_inter = ', round(t_inter, 3), ', p_inter = ', p_inter,3) )
  
  print(paste0('second method', SEPARATOR, 'test whether intercept differ from 1'))
  t_slope <- abs((summary(m)$coefficients[2, 1] - 1)/summary(m)$coefficients[2, 2])
  p_slope <- 2*pt(t_slope, m$df, lower=FALSE)
  print( paste0('t_slope = ', round(t_slope, 3), ', p_slope = ', p_slope) )
}

# -----------------------------------------------------------------------------
# Function 3.3: whether different TS source have effect
TS_Source_test <- function( sdata ) { 
  sdata$Ts_Source <- 
    ifelse( sdata$TS_Source == 'Rs_Ts_Relationship', "Rs Ts Relationship"
            , ifelse(sdata$TS_Source == 'MGRsD', "From MGRsD",
                     ifelse(grepl("TAIR_Del", sdata$TS_Source, fixed = TRUE), 'Partly from TAIR', "From Paper" ) )  )
  
  p <- ggplot(sdata, aes(log(Rs_annual_bahn), log(Rs_annual), color=factor(Ts_Source) ) ) + geom_point( alpha = 0.5, size = 2) +
    ggtitle("Test Ts sources") + geom_smooth( method='lm' ) + geom_abline( linetype=2, size= 1.25) +
    xlab (expression ("ln (Rs_annual_bahn) (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("ln (Rs_annual) (g C m"^-2*"yr"^-1* ")")) +
    theme(legend.title = element_blank())
    # scale_fill_discrete(name = "Ts source", labels = c("MGRsD", "Papers", "Partly from TAIR", "Rs Ts Relationship"))
      
  print( p )
  
  m <- lm(Rs_annual ~ Rs_annual_bahn, data=sdata)
  print( summary(m) )
  p_inter <- round(summary(m)$coefficients[1, 4], 4)
  print(p_inter)
  
  # Test whether slope differ from 1
  print(paste0(SEPARATOR, 'test whether intercept differ from 1'))
  t_slope <- abs((summary(m)$coefficients[2, 1] - 1)/summary(m)$coefficients[2, 2])
  p_slope <- 2*pt(t_slope, m$df, lower=FALSE)
  print( paste0('t_slope = ', round(t_slope, 3), ', p_slope = ', p_slope) )
  
  print( summary( lm( Rs_annual ~ Rs_annual_bahn * Ts_Source, data=sdata ) ) )
  
}


# -----------------------------------------------------------------------------
# Function 3.4: What's the effect of annual coverage? We'd expect a better relationship
# when more of the year is measured
# This test is meaningless because the studies include here all > 1yr data
AC_test <- function( sdata, coverage, var_title ) {
  printlog( SEPARATOR )
  printlog( "How does annual coverage affect this relationship?" )
  sdata$AC2 <- cut( coverage, c( 0, 0.5, 0.95, 1 ), right=T )  #c( 0, 0.33, 0.67, 1 ), right=F )
  m <- lm( Rs_annual ~ Rs_annual_bahn * AC2, data=sdata )
  print( summary( m ) )
  
  p <- ggplot( aes(log(Rs_annual_bahn), log(Rs_annual), color=AC2), data=subset( sdata, !is.na( AC2 ) ) ) + geom_point(alpha=0.25, size = 2)
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 ) +
    ggtitle(var_title) + theme(legend.position = 'bottom') +
    xlab (expression ("ln (Rs_annual_bahn) (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("ln (Rs_annual) (g C m"^-2*"yr"^-1* ")")) +
    theme(legend.title = element_blank())
  
}



# ****************************************************************************************************
#  IV. Analysis Functions: Re-compute the relationship between Rs_annual and RS@MAT
# ****************************************************************************************************

# Function 4.1.1: plot and compare TS, TAnnnual, MAT calculated Rs_bahn with Rs_Annual
TSTSMAT_test <- function( sdata, bahn, panel_lab, var_title ) {
  
  m1 <- lm( bahn ~ Rs_annual, data=sdata )
  print( summary( m1 ) )
  
  p <- qplot( Rs_annual, bahn, data=sdata, ylim = c(0,7000) ) + geom_point( alpha = 0.1 )
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 ) + xlab(expression('Rs_Annual (g C/m'^2 * '/yr)')) +
    ylab(expression('Rs_bahn (g C/m'^2 * '/yr)' ) ) +
    annotate(geom="text", x=200, y=6200, label = panel_lab, color="black", hjust = 0) + 
    ggtitle (var_title)
  
  print (p)
  # saveplot( paste("5-TSTAMAT_comparison",bahn,"_" ))
}


# -----------------------------------------------------------------------------
# Function 4.2.1: Main figure comparing Rs_annual with Rs_annual_bahn
Rs_comparion_figure <- function( srdb, name="", var_title ) {
  sdata <- srdb
  printlog( SEPARATOR )
  if( name != "" ) {
    printlog( name )
    name <- paste0( "-", name )
  }
  printlog( SEPARATOR )
  printlog( "Doing main figure comparing Rs_annual and Rs_annual_bahn" )
  p <- ggplot( sdata, aes( Rs_annual_bahn, Rs_annual ) )
  # need figure out calculate geom_errorbarh
  # p <- p + geom_errorbarh( aes( xmin=Rs_annual-Rs_annual_err, xmax=Rs_annual+Rs_annual_err), alpha=0.5 )
  p <- p + geom_point( alpha=0.5 )
  p <- p + geom_smooth( method='lm', color='black' )
  p <- p + geom_abline( slope=1, linetype=2 )
  p <- p + ylab( expression( Measured~SR[annual]~(g~C~m^{-2}~yr^{-1}) ) )
  p <- p + xlab( expression( SR[annual]~bahn~(g~C~m^{-2}~yr^{-1}) ) ) +
    ggtitle (var_title)
  print( p )
  invisible( p )
}


# -----------------------------------------------------------------------------
# Function 4.2.2: See how Rs_annual is related to Rs_annual_bahn (using TS, T_Annual, and MAT as predictor)

Rs_annual_bahn_test <- function( sdata, temp, name="", quiet=F, var_title, res_title ) {
  printlog( SEPARATOR )
  printlog( "How are Rs_annual and Rs_annual_bahn_Temp related?" )
  printdims( sdata )
  
  Rs_bahn <- sdata[, colnames(sdata)==temp]
  p <- ggplot( sdata, aes( log(Rs_bahn), log(Rs_annual) ) )
  # need figure out calculate geom_errorbarh
  # p <- p + geom_errorbarh( aes( xmin=Rs_annual-Rs_annual_err, xmax=Rs_annual+Rs_annual_err), alpha=0.5 )
  p <- p + geom_point( alpha=0.25 )
  p <- p + geom_smooth( method='lm', color='black' )
  p <- p + geom_abline( slope=1, linetype=2 )
  p <- p + ylab( expression( ln (Measured~R[Sannual])~(g~C~m^{-2}~yr^{-1}) ) )
  p <- p + xlab( expression( ln (R[Sannual]~bahn)~(g~C~m^{-2}~yr^{-1}) ) ) +
    ggtitle (var_title)
  
  m <- lm( Rs_annual ~ Rs_bahn, data=sdata )
  print( summary( m ) )
    
  printlog( SEPARATOR )  
  printlog( "Plotting and saving model diagnostics..." )
  
  printlog( "Plotting and saving model residuals..." )
  sdata$standardized_resids <- rstandard( m )
  sdata$Rs_fitted <- fitted.values(m)
  p1 <- ggplot( sdata, aes( log(Rs_fitted), standardized_resids )  )  +
    ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
    xlab( expression( ln (Fitted~R[Sannual])~(g~C~m^{-2}~yr^{-1}) ) ) +
    ggtitle (res_title)
  
  p1 <- p1 + geom_point( col=alpha('black', 0.25) ) + ylim(-5, 8) + geom_smooth( method='lm' )
  # ggarrange(p, p1, ncol = 2) 
  print( plot_grid(p, p1, labels = c("( a )", "( b )"), vjust = 4, hjust = c(-2.5,-2) ) )
  
  par( mar=c(3, 2, 2, 1)
       , mai=c(0.5, 0.5, 0.1, 0.1)  # by inches, inner margin
       , omi = c(0.3, 0.4, 0.1, 0.1)  # by inches, outer margin 
       , mgp = c(1.1, 0.2, 0) # set distance of axis
       , tcl = 0.4
       , cex.axis = 1
       , mfrow=c(2,2))
  plot( m, labels.id=paste( sdata$Record_number, sdata$Author ) )
  
  # Test if slope=1
  #library( smatr )		# can also use summary(lm(y-1*x~x))
  #print( slope.test( sdata$Rs_annual_bahn, sdata$Rs_annual, method="OLS" )$p )
  print(paste0(SEPARATOR, 'Test whether intercept differ from 1'))
  t_slope <- abs((summary(m)$coefficients[2, 1] - 1)/summary(m)$coefficients[2, 2])
  p_slope <- round( 2*pt(t_slope, m$df, lower=FALSE), 5 )
  print( paste0('t_slope = ', round(t_slope, 3), ', p_slope = ', p_slope, ', df = ', m$df ) )
  
  invisible(list( m, p, p1 ) )
}



# -----------------------------------------------------------------------------
# Function 4.2: Test outlier

Outlier_test <- function( sdata, temp, name="", quiet=F, var_title, res_title, var_outlier ) {
  printlog( SEPARATOR )
  printlog( "How are Rs_annual and Rs_annual_bahn_Temp related?" )
  printdims( sdata )
  
  Rs_bahn <- sdata[, colnames(sdata)==temp]
  p <- ggplot( sdata, aes( log(Rs_bahn), log(Rs_annual) ) )
  # need figure out calculate geom_errorbarh
  # p <- p + geom_errorbarh( aes( xmin=Rs_annual-Rs_annual_err, xmax=Rs_annual+Rs_annual_err), alpha=0.5 )
  p <- p + geom_point( alpha=0.25 )
  p <- p + geom_smooth( method='lm', color='black' )
  p <- p + geom_abline( slope=1, linetype=2 )
  p <- p + ylab( expression( Measured~R[Sannual]~(g~C~m^{-2}~yr^{-1}) ) )
  p <- p + xlab( expression( R[Sannual]~bahn~(g~C~m^{-2}~yr^{-1}) ) ) +
    ggtitle (var_title)
  
  m <- lm( Rs_annual ~ Rs_bahn, data=sdata )
  print( summary( m ) )
    
  printlog( SEPARATOR )  
  printlog( "Plotting and saving model diagnostics..." )
  
  printlog( "Plotting and saving model residuals..." )
  sdata$standardized_resids <- rstandard( m )
  p1 <- ggplot( sdata, aes( Rs_bahn, standardized_resids )  )  +
    ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
    xlab( expression( Fitted~R[Sannual]~(g~C~m^{-2}~yr^{-1}) ) ) +
    ggtitle (res_title)
  
  p1 <- p1 + geom_point( col=alpha('black', 0.5) ) + ylim(-5, 8) + geom_smooth( method='lm' )
  # ggarrange(p, p1, ncol = 2) 
  print( plot_grid(p, p1, labels = c("( a )", "( b )"), vjust = 4, hjust = c(-2.5,-2) ) )
  
  par( mar=c(3, 2, 2, 1)
       , mai=c(0.5, 0.5, 0.1, 0.1)  # by inches, inner margin
       , omi = c(0.3, 0.4, 0.1, 0.1)  # by inches, outer margin 
       , mgp = c(1.1, 0.2, 0) # set distance of axis
       , tcl = 0.4
       , cex.axis = 1
       , mfrow=c(2,2))
  plot( m, labels.id=paste( sdata$Record_number, sdata$Author ) )
  
  # Test if slope=1
  #library( smatr )		# can also use summary(lm(y-1*x~x))
  #print( slope.test( sdata$Rs_annual_bahn, sdata$Rs_annual, method="OLS" )$p )
  print(paste0(SEPARATOR, 'Test whether intercept differ from 1'))
  t_slope <- abs((summary(m)$coefficients[2, 1] - 1)/summary(m)$coefficients[2, 2])
  p_slope <- round( 2*pt(t_slope, m$df, lower=FALSE), 5 )
  print( paste0('t_slope = ', round(t_slope, 3), ', p_slope = ', p_slope, ', df = ', m$df ) )
  
  # -------------------+++++-------------------
  print(SEPARATOR)
  print('Remove outlier and test again')
  # Test whether slope differ from 1
  
  cooks_count <- 0		# if 0, outlier code is disabled
  influentials <- which( cooks.distance( m ) > var_outlier )
  print(influentials)
  cooks_count <- length( influentials )
  print( paste("Influential outliers =", cooks_count ))
  if( cooks_count > 0 ) {
    print( sdata[ influentials, "Record_number" ] )
    sdata <- sdata[ -influentials, ]
    
    Rs_bahn <- sdata[,colnames(sdata)==temp]
    m <- lm( Rs_annual ~ Rs_bahn, data=sdata )
    print( summary( m ) )
    # 
    p <- ggplot( sdata, aes( Rs_bahn, Rs_annual ) )
    # need figure out calculate geom_errorbarh
    # p <- p + geom_errorbarh( aes( xmin=Rs_annual-Rs_annual_err, xmax=Rs_annual+Rs_annual_err), alpha=0.5 )
    p <- p + geom_point( alpha=0.25 )
    p <- p + geom_smooth( method='lm', color='black' )
    p <- p + geom_abline( slope=1, linetype=2 )
    p <- p + ylab( expression( Measured~R[Sannual]~(g~C~m^{-2}~yr^{-1}) ) )
    p <- p + xlab( expression( R[Sannual]~bahn~(g~C~m^{-2}~yr^{-1}) ) ) +
      ggtitle (var_title)
    
    sdata$standardized_resids <- rstandard( m )
    p1 <- ggplot( sdata, aes( Rs_bahn, standardized_resids )  )  +
      ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
      xlab( expression( Measured~R[Sannual]~(g~C~m^{-2}~yr^{-1}) ) ) +
      ggtitle (res_title)
    
    p1 <- p1 + geom_point( col = alpha('black', 0.25) ) + geom_smooth( method='lm' ) +  ylim(-5, 8)
    # ggarrange(p, p1, ncol = 2) 
    print( plot_grid(p, p1, labels = c("( c )", "( d )"), vjust = 4, hjust = c(-2.5,-2) ) )
    
    
    printlog( SEPARATOR )
    printlog( "Plotting and saving model diagnostics..." )
    # 
    par( mfrow=c( 2, 2 ) )
    plot( m, labels.id=paste( sdata$Record_number, sdata$Author ) )
    
    # Test if slope=1
    print(paste0(SEPARATOR, 'Test whether intercept differ from 1 when outlier removed'))
    t_slope <- abs((summary(m)$coefficients[2, 1] - 1)/summary(m)$coefficients[2, 2])
    p_slope <- round( 2*pt(t_slope, m$df, lower=FALSE), 5 )
    print( paste0('t_slope = ', round(t_slope, 3), ', p_slope = ', p_slope, ', df = ', m$df ) )
  } 
  
  invisible(list( m, p, p1 ) )
}
# Rs_annual_bahn_test <- function( sdata, temp, name="", quiet=F, var_title ) {
#   
#   printlog( SEPARATOR )
#   if( name != "" ) {
#     printlog( name )
#     name <- paste0( "-", name )
#   }
#   printlog( "How are Rs_annual and Rs_annual_bahn_Temp related?" )
#   printdims( sdata )
#   
#   cooks_count <- 0		# if 0, outlier code is disabled
#   m <- lm( Rs_annual ~ temp, data=sdata )
#   while( cooks_count > 0 ) {
#     m <- lm( Rs_annual ~ temp, data=sdata )
#     influentials <- which( cooks.distance( m ) > 0.5 )
#     cooks_count <- length( influentials )
#     printlog( "Influential outliers =", cooks_count )
#     if( cooks_count > 0 ) {
#       print( sdata[ influentials, "Record_number" ] )
#       sdata <- sdata[ -influentials, ]	
#     }
#   }
#   
#   if( !quiet ) {
#     printlog( "Model summary:" )
#     print( summary( m ) )
#     
#     printlog( "Plotting and saving model diagnostics..." )
#     pdf( paste0( OUTPUT_DIR, "3-modeldiags",name, ".pdf" ) )
#     par( mfrow=c( 2, 2 ) )
#     plot( m, labels.id=paste( sdata$Record_number, sdata$Author ) )
#     dev.off()
#     
#     printlog( "Plotting and saving model residuals..." )
#     sdata$resids <- residuals( m )
#     p <- ggplot( sdata, aes( Rs_annual, resids )  )  +
#       ggtitle (var_title)
#       
#     p <- p + geom_point(  ) + geom_smooth( method='lm' ) +  ylim(-2500, 2500)
#     print( p )
#   }
#   
#   # Test if slope=1
#   #library( smatr )		# can also use summary(lm(y-1*x~x))
#   #print( slope.test( sdata$Rs_annual_bahn, sdata$Rs_annual, method="OLS" )$p )
#   print(paste0(SEPARATOR, 'Test whether intercept differ from 1'))
#   t_slope <- abs((summary(m)$coefficients[2, 1] - 1)/summary(m)$coefficients[2, 2])
#   p_slope <- round( 2*pt(t_slope, m$df, lower=FALSE), 5 )
#   print( paste0('t_slope = ', round(t_slope, 3), ', p_slope = ', p_slope, ', df = ', m$df ) )
#   invisible( list( m ) )
# }


# -----------------------------------------------------------------------------
# Function 4.2.4: How much of the inaccuracy in the Rs_annual~Rs_annual_bahn relationship
# is due to inaccuracies in the air temperature dataset?

RC_test <- function( sdata, var_title ) {
  printlog( SEPARATOR )
  printlog( "How does RC contribution affect this relationship?" )
  print( summary( lm( Rs_annual ~ Rs_annual_bahn * ( RC_annual>0.5 ), data=sdata ) ) )
  printlog( SEPARATOR )
  printlog( "Model for RC>0.5 only:" )
  print( summary( lm( Rs_annual ~ Rs_annual_bahn, data=subset( sdata, RC_annual>0.5 ) ) ) )
  printlog( SEPARATOR )
  printlog( "Model for RC<=0.5 only:" )
  print( summary( lm( Rs_annual ~ Rs_annual_bahn, data=subset( sdata, RC_annual<=0.5 ) ) ) )
  
  p <- ggplot( subset( sdata, !is.na( RC_annual ) ), aes( Rs_annual_bahn, Rs_annual, color=RC_annual>0.5 ) )
  p <- p + geom_point()
  p <- p + geom_smooth( method='lm' )
  p <- p + geom_abline( slope=1, linetype=2 ) + ggtitle (var_title) +
    xlab (expression ("ln (Rs_annual_bahn) (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("ln (Rs_annual) (g C m"^-2*"yr"^-1* ")")) 
  print( p )
  # saveplot(outputDir = OUTPUT_DIR,pname = "3-RC_effect" )
  invisible( p )
}

# colnames(srdb_v4)
# test whether Q10 differ from Ra and Rh dominated sites
Q10_test <- function(sdata, Q10_type, var_title) {
  printlog(SEPARATOR)
  n_col <- colnames(sdata) == Q10_type
  sdata <- sdata[!is.na(sdata[,n_col]), ]
  sdata <- sdata[!is.na(sdata$RC_annual), ]
  sdata$Q10 <- sdata[, colnames(sdata) == Q10_type]
  sdata <- sdata[sdata$Q10 > 0, ]
  sdata$Ra_Rh_dom <- ifelse(sdata$RC_annual>0.5, 'Ra_dom', 'Rh_dom')
  
  print(paste0('**********ANOVA**********', Q10_type))
  anova <- aov(Q10 ~ Ra_Rh_dom, data = sdata)
  print (summary(anova))
  
  p <- ggplot(sdata, aes(Q10, color=RC_annual>0.5, fill = RC_annual>0.5) ) + geom_density(stat = 'density', alpha = 0.25 ) +
    ggtitle(var_title) +
    xlab(expression(Q[10])) +
    theme(legend.position = c(0.75,0.65), legend.background = element_rect(colour = 'transparent', fill = alpha('white', 0), size = 0.75) )
  
}

R10_test <- function (sdata, R10_type, var_title) {
  printlog(SEPARATOR)
  sdata <- sdata[!is.na(sdata$RC_annual), ]
  sdata <- sdata[!is.na(sdata$R10), ]
  sdata$R10 <- sdata[, colnames(sdata) == R10_type]
  
  p <- ggplot(sdata, aes(R10, color=RC_annual>0.5, fill = RC_annual>0.5) ) + geom_density(stat = 'density', alpha = 0.25 ) +
    ggtitle(var_title) + xlab(expression( R[10] ))
  print(p)
}


# --------------------------------------------------------------------------------
# Function 4.2.6: How much of the inaccuracy in the Rs_annual~Rs_annual_bahn relationship
# is due to inaccuracies in the air temperature dataset?

# Function: Climate space figure
# colnames(srdb)
climate_Del_test <- function () {
  sdata <- srdb
  p1 <- qplot( MAT_Del, MAT,  data=sdata ) + geom_abline( slope=1, linetype = "dotdash", size = 1.5, col = "red") + geom_smooth( method='lm' ) 
  p2 <- qplot( TAnnual_Del, Study_temp, data=sdata ) + geom_abline( slope=1, linetype = "dotdash", size = 1.5, col = "red") + geom_smooth( method='lm' ) 
  p3 <- qplot( MAP_Del, MAP, data=sdata ) +  geom_abline( slope=1, linetype = "dotdash", size = 1.5, col = "red") + geom_smooth( method='lm' ) 
  p4 <- qplot( PAnnual_Del, Study_precip, data=sdata ) +  geom_abline( slope=1, linetype = "dotdash", size = 1.5, col = "red") + geom_smooth( method='lm' )
  
  print (plot_grid (p1, p2, p3, p4, ncol = 2, nrow = 2, labels = c("( a )", '( b )', '( c )', '( d )'), vjust = 2.0, hjust = -2.0 ) )
  invisible(list(p1,p2,p3,p4))
}

# Function test variability
climate_variability_test <- function( sdata, var_title_T, var_title_P ) {
  printlog( SEPARATOR )
  printlog( "How does climate variability affect this relationship?" )
  sdata$TAIR_SD2 <- cut( sdata$TAIR_SD, 3 )
  m <- lm( Rs_annual~Rs_annual_bahn * TAIR_SD2, data=sdata )
  print( summary( m ) )
  p <- ggplot(sdata, aes(log(Rs_annual_bahn), log(Rs_annual), color=factor(TAIR_SD2) )) + geom_point(alpha = 0.25, size = 2) +
    xlab (expression ("ln (Rs_annual_bahn) (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("ln (Rs_annual) (g C m"^-2*"yr"^-1* ")")) 
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
  p <- p + scale_color_discrete( "Monthly tair\nvariability" ) + 
    ggtitle(var_title_T) + 
    theme(legend.position = c(0.75, 0.2), legend.background = element_rect(colour = 'transparent', fill = alpha('white', 0), size = 0.75) ) 
    
  # print( p )
  # saveplot(outputDir = OUTPUT_DIR, pname = "4.2.6_var_effect_tair" )	
  
  sdata$PRECIP_SD2 <- cut( sdata$PRECIP_SD, 3 )
  m <- lm( Rs_annual~Rs_annual_bahn * PRECIP_SD2, data=sdata )
  print( summary( m ) )
  p2 <- ggplot(sdata, aes(Rs_annual_bahn, Rs_annual, color=factor(PRECIP_SD2)) ) + geom_point(alpha = 0.25, size = 2)
  p2 <- p2 + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
  p2 <- p2 + scale_color_discrete( "Monthly precip\nvariability" ) + 
    ggtitle (var_title_P) + 
    theme(legend.position = c(0.75, 0.2), legend.background = element_rect(colour = 'transparent', fill = alpha('white',0), size = 0.75))+
    xlab (expression ("ln (Rs_annual_bahn) (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("ln (Rs_annual) (g C m"^-2*"yr"^-1* ")"))
  # print( p2 )
 	print(plot_grid(p, p2, ncol = 2, labels = c('( a )', '( b )'), vjust = 4, hjust = c(-2.25, -2.25) ) )
 	
 	invisible (list (p, p2, m) )
}


# -----------------------------------------------------------------------------
# Function 4.2.7: What's the effect of drought? need new drought data
# Need another drought index and re-analysis
# cut( srdb$SPI, breaks = seq(-3,5,2) )

# Function: MAP test
# min(srdb_orig$MAP_Del, na.rm = T)
# max(srdb_orig$MAP_Del, na.rm = T)
climate_MAP_test <- function( sdata, var_title, res_title ) {
  sdata$MAP_Del2 <- cut( sdata$MAP_Del, 10 )
  m <- lm( Rs_annual ~ Rs_annual_bahn * MAP_Del, data=sdata )
  print( summary( m ) )
  sdata$standardized_resids <- rstandard( m )
  p <- ggplot( aes(log(Rs_annual_bahn), log(Rs_annual), color=MAP_Del2), data=sdata ) + geom_point (alpha = 0.25, size = 2) +
    theme(legend.position = c(0.8,0.3), legend.background = element_rect(fill = alpha('white', 0), alpha('white', 0))
          , legend.title = element_blank(), legend.text=element_text(size = 7.5)
          ) + 
    theme(legend.key = element_rect(colour = alpha('white', 0), fill = alpha('white', 0))) + # make legend key fill transparent
    xlab (expression ("ln (Rs_annual_bahn) (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("ln (Rs_annual) (g C m"^-2*"yr"^-1* ")")) +
    scale_fill_discrete (labels = c("(201, 695]", "(695, 1170]", "(1170, 1650]", "(1650, 2130]"
                                   , "(2610, 3090]", "(3090, 3560]", "3560, 4040]", "(4520, 5000]")) 
    
    
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
  p <- p + scale_color_discrete( "MAP" ) + ggtitle (var_title)
  
  p1 <- ggplot( sdata, aes( MAP_Del, standardized_resids )  )  +
    ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
    xlab( expression( MAP~(mm) ) ) + ggtitle (res_title)
  
  p1 <- p1 + geom_point( alpha = 0.25 ) + geom_smooth( method='lm' ) +  ylim(-5, 8)
  # ggarrange(p, p1, ncol = 2) 
  print( plot_grid(p, p1, labels = c("( a )", "( b )"), ncol = 2, vjust = 4, hjust = c(-2.25, -2.25) ) )
  invisible (list (p, p1) )
}

# -----------------------------------------------------------------------------
SPI_test <- function( sdata, var_title = NA ) {
  printlog( SEPARATOR )
  printlog( "How does drought affect this relationship? (discrete)" )
  sdata$SPI2 <- cut( sdata$SPI, breaks = seq(-3, 5, 2) ) #c( 0, 0.33, 0.67, 1 ), right=F )
  printlog( "How does drought affect this relationship? (discrete)" )
  m <- lm( Rs_annual ~ Rs_annual_bahn, data=sdata )
  print( summary( m ) )
  sdata$standardized_resids <- rstandard( m )
  p <- ggplot( aes(log(Rs_annual_bahn), log(Rs_annual), color=SPI2), data=sdata ) + geom_point(alpha=0.25, size = 1) +
    theme(legend.position = c(0.85,0.3), legend.title = element_blank()
          , legend.background = element_rect(colour = 'transparent', fill = alpha('white',0), size = 0.75))
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
  p <- p + scale_color_discrete( "SPI" ) +
    xlab( expression( ln (Rs_bahn)~(g~C~m^{-2}~yr^{-1}) ) ) + 
    ylab( expression( ln (Rs_annual)~(g~C~m^{-2}~yr^{-1}) ) ) 
  
  p1 <- ggplot( sdata, aes( SPI, standardized_resids )  )  +
    ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
    xlab( expression( SPI ) ) 
  
  p1 <- p1 + geom_point( alpha = 0.25 ) + geom_smooth( method='lm' ) +  ylim(-5, 8)
  # ggarrange(p, p1, ncol = 2) 
  
  printlog( "How does drought affect this relationship? (continuous)" )
  m2 <- lm( Rs_annual~Rs_annual_bahn * SPI, data=sdata )
  print( summary( m2 ) )
  sdata$standardized_resids <- rstandard( m2 )
  
  p2 <- ggplot( sdata, aes( pdsi_pm_mean, standardized_resids )  )   
  
  p2 <- p2 + geom_point( alpha = 0.25 ) + geom_smooth( method='lm' ) +  ylim(-5, 8)+
    ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
    xlab( expression( SPI ) ) 
  # ggarrange(p, p1, ncol = 2) 
  print( plot_grid(p, p1, p2, labels = c("( a )", "( b )", "( c )"), ncol = 3, align = 'v', vjust = c(4,4,4), hjust = -2.5 ) )
  
  invisible (list(m, m2, p, p1, p2))
}

# -----------------------------------------------------------------------------
PDSI_test <- function( sdata, var_title=F ) {
  printlog( SEPARATOR )
  printlog( "How does drought affect this relationship? (discrete)" )
  sdata$PDSI2 <- cut( sdata$pdsi_pm_mean, breaks = 4 ) #c( 0, 0.33, 0.67, 1 ), right=F )
  m <- lm( Rs_annual ~ Rs_annual_bahn, data=sdata )
  print( summary( m ) )
  
  sdata$standardized_resids <- rstandard( m )
  p <- ggplot( aes(log(Rs_annual_bahn), log(Rs_annual), color=PDSI2), data=sdata ) + geom_point(alpha=0.25, size = 1) +
    theme(legend.position = c(0.75,0.2), legend.title = element_blank()
          , legend.background = element_rect(fill = alpha('white',0), colour = 'transparent', size = 0.75))
  p <- p + geom_smooth( method='lm' ) + geom_abline( linetype=2 )
  p <- p + scale_color_discrete( "PDSI" ) +
    xlab( expression( ln (Rs_bahn)~(g~C~m^{-2}~yr^{-1}) ) ) + 
    ylab( expression( ln (Rs_annual)~(g~C~m^{-2}~yr^{-1}) ) ) 
  
  p1 <- ggplot( sdata, aes( pdsi_pm_mean, standardized_resids )  )  +
    ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
    xlab( expression( PDSI ) ) 
  
  p1 <- p1 + geom_point( alpha = 0.25 ) + geom_smooth( method='lm' ) +  ylim(-5, 8)
  # ggarrange(p, p1, ncol = 2) 
  
  printlog( "How does drought affect this relationship? (continuous)" )
  m2 <- lm( Rs_annual ~ Rs_annual_bahn * pdsi_pm_mean, data=sdata )
  print( summary( m2 ) )
  sdata$standardized_resids <- rstandard( m2 )
  p2 <- ggplot( sdata, aes( pdsi_pm_mean, standardized_resids )  )  +
    ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
    xlab( expression( PDSI ) ) 
  
  p2 <- p2 + geom_point( alpha = 0.25 ) + geom_smooth( method='lm' ) +  ylim(-5, 8)
  # ggarrange(p, p1, ncol = 2) 
  print( plot_grid(p, p1, p2, labels = c("( a )", "( b )", "( c )"), ncol = 3, align = 'v', vjust = c(4,4,4), hjust = -2.5 ) )
  
  invisible (list(m, m2, p, p1, p2))
}

# ****************************************************************************************************
#  V. New modeling, same pormat as Bahn but with updated parameters
# ****************************************************************************************************

bahn_vs_new <- function( sdata, temp, name="", quiet=F, var_title, res_title ) {
  printlog( SEPARATOR )
  printlog( "How are Rs_annual and Rs_annual_bahn_Temp related?" )
  printdims( sdata )
  
  Rs_bahn <- sdata[, colnames(sdata)==temp]
  p <- ggplot( sdata, aes( log(Rs_bahn), log(Rs_annual) ) )
  # need figure out calculate geom_errorbarh
  # p <- p + geom_errorbarh( aes( xmin=Rs_annual-Rs_annual_err, xmax=Rs_annual+Rs_annual_err), alpha=0.5 )
  p <- p + geom_point(col = 'black', alpha=0.1, size = 2 )
  p <- p + geom_smooth( method='lm', color='black' )
  p <- p + geom_abline( slope=1, linetype=2 )
  p <- p + ylab( expression( ln(R[Sannual]) ) )
  p <- p + xlab( expression( ln(R[Sannual]~bahn) ) ) +
    ggtitle (var_title)
  
  m <- lm( Rs_annual ~ Rs_bahn, data=sdata )
  print( summary( m ) )
  
  # method 2: this test slope differ from 1
  print(paste0('second method', SEPARATOR, 'test whether intercept differ from 1'))
  t_slope <- abs((summary(m)$coefficients[2, 1] - 1)/summary(m)$coefficients[2, 2])
  p_slope <- 2*pt(t_slope, m$df, lower=FALSE)
  print( paste0('t_slope = ', round(t_slope, 3), ', p_slope = ', p_slope) )
  
  printlog( "Plotting and saving model diagnostics..." )
  printlog( "Plotting and saving model residuals..." )
  
  sdata$standardized_resids <- rstandard( m )
  p1 <- ggplot( sdata, aes( SPI, standardized_resids )  )  +
    # ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
    ylab( expression( Standardized~residual ) ) +
    xlab( expression( SPI ) ) +
    ggtitle (res_title) + geom_point( col=alpha('black', 0.1), size = 2 ) + ylim(-5, 8) + geom_smooth( method='lm' )
  
  p2 <- ggplot( sdata, aes( pdsi_pm_mean, standardized_resids )  )  +
    ylab( expression( Standardized~residual ) ) + 
    xlab( expression( PDSI ) ) +
    ggtitle (res_title) + geom_point( col=alpha('black', 0.1), size = 2 ) + ylim(-5, 8) + geom_smooth( method='lm' )
  # ggarrange(p, p1, ncol = 2) 
   p3 <- plot_grid(p, p1, p2, ncol = 3)
   
   return(p3)
  
  invisible(list( m, p, p1, p2 ) )
}


# ****************************************************************************************************
#  VI. New add functions, not used yet
# ****************************************************************************************************
# Function 5.1: plot data

plot_Rs_vs_bahn <- function( sdata ) {
  printlog( "********************" )
  # TODO here: compute Hogg CMI as in GCB paper
  
  # 1. overall data
  p <- ggplot (sdata, aes(Rs_annual_bahn, Rs_annual)) + geom_point(alpha = 0.25, aes(col = factor(Biome))) + geom_smooth(method = 'lm') +
    theme(legend.position = c(0.75, 0.25)
          , legend.background = element_rect(fill = alpha('white', 0), colour = alpha('white', 0))
          , legend.title = element_blank()) +
    xlab (expression ("ln (Rs_annual_bahn) (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("ln (Rs_annual) (g C m"^-2*"yr"^-1* ")")) + geom_abline( slope=1, linetype=2, size = 1.25 ) 
  
  m <- lm( Rs_annual ~ Rs_annual_bahn, data=sdata )
  
  sdata$standardized_resids <- rstandard( m )
  p1 <- ggplot( sdata, aes( SPI, standardized_resids )  )  +
    # ylab( expression( Standardized~residual~(g~C~m^{-2}~yr^{-1}) ) ) + 
    ylab( expression( Standardized~residual ) ) +
    xlab( expression( SPI ) ) +
    geom_point( col=alpha('black', 0.1), size = 2 ) + ylim(-5, 8) + geom_smooth( method='lm' )
  
  p2 <- ggplot( sdata, aes( pdsi_pm_mean, standardized_resids )  )  +
    ylab( expression( Standardized~residual ) ) + 
    xlab( expression( PDSI ) ) +
    geom_point( col=alpha('black', 0.1), size = 2 ) + ylim(-5, 8) + geom_smooth( method='lm' )
  # ggarrange(p, p1, ncol = 2) 
  
  # Comparing Ra vs Rc dominate sites
  p_RC <- ggplot( subset( sdata, !is.na( RC_annual ) ), aes( Rs_annual_bahn, Rs_annual, color=RC_annual>0.5 ) )
  p_RC <- p_RC + geom_point()
  p_RC <- p_RC + geom_smooth( method='lm' )
  p_RC <- p_RC + geom_abline( slope=1, linetype=2, size = 1.25 ) + 
    xlab (expression ("Rs_annual_bahn (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("Rs_annual (g C m"^-2*"yr"^-1* ")"))  +
    theme(legend.position = c(0.75, 0.25), legend.background = element_rect(fill = alpha('white', 0), colour = alpha('white', 0) ))
  
  # By Biome
  p_bome <- ggplot( sdata, aes( log(Rs_annual_bahn), log(Rs_annual), color= Biome) )
  p_bome <- p_bome + geom_point(alpha = 0.2, size = 2) 
  p_bome <- p_bome + geom_smooth( method='lm' )
  p_bome <- p_bome + geom_abline( slope=1, linetype=2, size = 1.25 ) +
    theme(legend.position = c(0.75, 0.25), legend.title = element_blank()
          , legend.background = element_rect(fill = alpha('white', 0), colour = alpha('white', 0) )) +
    xlab (expression ("ln (Rs_annual_bahn) (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("ln (Rs_annual) (g C m"^-2*"yr"^-1* ")"))  
  
  # By Ecosystem
  subdata <- sdata[sdata$Ecosystem_type != 'Desert' & sdata$Ecosystem_type != 'Natural' & sdata$Ecosystem_type != 'Savanna', ]
  p_eco <- ggplot( subdata, aes( log(Rs_annual_bahn), log(Rs_annual), color= Ecosystem_type) )
  p_eco <- p_eco + geom_point(alpha = 0.2, size = 2) 
  p_eco <- p_eco + geom_smooth( method='lm' )
  p_eco <- p_eco + geom_abline( slope=1, linetype=2, size = 1.25 ) +
    theme(legend.position = c(0.75, 0.25), legend.title = element_blank()
          , legend.background = element_rect(fill = alpha('white', 0), colour = alpha('white', 0) )) +
    xlab (expression ("ln (Rs_annual_bahn) (g C m"^-2*"yr"^-1* ")")) +
    ylab (expression ("ln (Rs_annual) (g C m"^-2*"yr"^-1* ")"))  
  
  print( plot_grid(p, p1, p2, p_RC, p_bome, p_eco, ncol = 3
                   , labels = c("a", "b", "c", "d", "e", "f")
                   , hjust = c(-7,-6.5,-6.5,-7.5,-6.5,-9.5), vjust = c(3)
                   ) )
  invisible( list(sdata, p, p1, p2, p_RC, p_bome, p_eco ))
}

# sort(unique(srdb$Ecosystem_type))
