
#**************************************************************************
# data preparation
#**************************************************************************

# load Data

rm(list=ls())

HGRsD_DIR <- dirname(rstudioapi::getSourceEditorContext()$path)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()

HGRsD <- read.csv("2.HGRsD_OriginalData.csv")
# HGRsD <- read.csv("AppendixTable1_DGRsD.csv")


HGRsD <- HGRsD[order(HGRsD$MiddleClimate,HGRsD$StudyNumber,HGRsD$TimeLable),] 

# HGRsD$TimeLable[HGRsD$TimeLable==2] <- 1
# HGRsD$TimeLable[HGRsD$TimeLable==4] <- 3
# HGRsD$TimeLable[HGRsD$TimeLable==6] <- 5
# HGRsD$TimeLable[HGRsD$TimeLable==8] <- 7
# HGRsD$TimeLable[HGRsD$TimeLable==10] <- 9
# HGRsD$TimeLable[HGRsD$TimeLable==12] <- 11
# HGRsD$TimeLable[HGRsD$TimeLable==14] <- 13
# HGRsD$TimeLable[HGRsD$TimeLable==16] <- 15
# HGRsD$TimeLable[HGRsD$TimeLable==18] <- 17
# HGRsD$TimeLable[HGRsD$TimeLable==20] <- 19
# HGRsD$TimeLable[HGRsD$TimeLable==22] <- 21
# HGRsD$TimeLable[HGRsD$TimeLable==24] <- 23



head(HGRsD)

# aggHGRsDClimate <- aggHGRsDClimate[,c(-6:-9)]

# levels(MiddleClimate)
# levels(MiddleVegType)
# 
# ClimateName <- c("A",  "B",  "Cf", "Cs", "Cw", "Df", "Dsw", "E" ) 
# vegName <- c("BSV", "CRO", "DF",  "EF",  "GRA", "MF",  "SH",  "WET") 
# 
class(HGRsD$StudyNumber)
class(HGRsD$Measure_DOY)
ID <- sort(unique(HGRsD$StudyNumber), decreasing = FALSE, na.last = TRUE )

min(HGRsD$Tsoil.C., na.rm = T)
max(HGRsD$Tsoil.C., na.rm = T)



#**************************************************************************
# plot
#**************************************************************************

pdf(paste(HGRsD_DIR, "outputs", '1-Diurnal_pattern.pdf', sep = "/"), width=9, height=12)

# tiff("3 Rs diurnal pattern by region.tiff", width = 12, height = 10, pointsize = 1/300, units = 'in', res = 300)

par( mar=c(2, 0.2, 0.2, 0.2)
     , mai=c(0.3, 0.6, 0.0, 0.1)  # by inches, inner margin
     , omi = c(0.35, 0.1, 0.1, 0.6)  # by inches, outer margin 
     , mgp = c(0, 0.3, 0) # set distance of axis
     , tcl = 0.4
     , cex.axis = 1.5
     , mfrow=c(5,2))



#**************************************************************************
# by study
attach(HGRsD)
# aggHGRsDClimate <- summarySE(HGRsD, measurevar="RS_Norm", groupvars=c('MiddleClimate',"StudyNumber",'TimeLable'))


for(i in ID) {
  # i = 1078
  sub_ID <- subset(HGRsD, HGRsD$StudyNumber == i)
  DOY <- sort(unique(sub_ID$Measure_DOY), decreasing = FALSE, na.last = F)
  
  for (j in DOY) {
    # j = 407
    sub_DOY <- subset(sub_ID, sub_ID$Measure_DOY == j)
    
    # plot Rs diurnal pattern
    with ( sub_DOY, 
      
           plot(sub_DOY$RS_Norm ~ sub_DOY$TimeLable
             , type='l', col='black', lty=1
             , pch = 1
             , las = 1
             , cex = 1.5, lwd=2
             , xlab = ""
             , ylab = "" 
             # , xaxt = 'n', yaxt = 'n'
             , xlim=c(-1,24)
             # , ylim=c(0,17)
         )
    )
    
    # add axis
    # axis(side=1,las=1,cex=1, at = seq(from=1, to=24, by=4))
    # axis(side=2,las=1,cex=1, at = seq(from=0, to=17, by=2))
    
    # add label
    varStudynum <- paste(sub_DOY$StudyNumber[1])
    varDOY <- paste(sub_DOY$Measure_DOY[1])
    expr <- paste("ID=",varStudynum, ", DOY=", varDOY, sep = '')
    
    text(x=8, y=max(sub_DOY$RS_Norm*0.8), labels = expr,cex = 1.5, col='blue')
    
    # abline
    # abline(v = 10, lty=2, col='gray')
    abline(h = mean(sub_DOY$RS_Norm), lty=2, col='gray')
    
    
    # add soil temperature curve ******************************************************
    par(new = T)
    
    with (sub_DOY, 
          plot ( sub_DOY$Tsoil.C. ~ sub_DOY$TimeLable
                 , type='l'
                 , pch = 1
                 , las = 1
                 , lwd=2
                 , xlab = ""
                 , ylab = "" 
                 , col = "red"
                 , lty = 2
                 , xaxt = 'n', yaxt = 'n'
                 ,xlim=c(-1,24),ylim=c(-2,50) )
    )
    
    axis(side=4,las=1,cex=1, at = seq(from=0, to=50, by=10))
    
    # abline
    abline(h = mean(sub_DOY$Tsoil.C.), lty=2, col='brown')
    
    # add text
    mtext(side = 1, text = expression("Time (1:00-24:00)" ), line = 1.5, cex=1.25, outer=T, lwd=2)
    mtext(side = 2, text = expression("Rs ( g C m" ^{-2}*" day"^{-1}*" )"), line = -2.25, cex=1.25, outer=T, lwd=2)
    mtext(side = 4, text = expression("Ts ( " * degree~C * ")"), line = 2.25, cex=1.25, outer=T, lwd=2)
    
    
    print (paste (i,"============================ "))
    print(Sys.time())
  }
  
  # add text
  
}


dev.off()



