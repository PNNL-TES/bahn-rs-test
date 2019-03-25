
#**************************************************************************
# data preparation
#**************************************************************************

# load Data

rm(list=ls())

MGRsD_DIR  <- dirname(rstudioapi::getSourceEditorContext()$path)

setwd(MGRsD_DIR)
getwd()

MGRsD <- read.csv("MGRsD_M_FQ.csv")

MGRsD <- MGRsD[order(MGRsD$StudyNumber,MGRsD$Measure_Year, MGRsD$Measure_Month, MGRsD$Measure_DOY),] 

head(MGRsD)

class(MGRsD$StudyNumber)
class(MGRsD$Measure_DOY)
ID <- sort(unique(MGRsD$StudyNumber), decreasing = FALSE, na.last = TRUE )

min(MGRsD$Tsoil.C., na.rm = T)
max(MGRsD$Tsoil.C., na.rm = T)



#**************************************************************************
# plot
#**************************************************************************

pdf(file = paste(MGRsD_DIR, 'outputs', '1. Rs Monthly pattern by study and MON.pdf', sep = "/"), width=9, height=12)
# tiff("1 Rs Monthlyl pattern by region.tiff", width = 12, height = 10, pointsize = 1/300, units = 'in', res = 300)

par( mar=c(2, 0.2, 0.2, 0.2)
     , mai=c(0.3, 0.6, 0.0, 0.1)  # by inches, inner margin
     , omi = c(0.35, 0.1, 0.1, 0.6)  # by inches, outer margin 
     , mgp = c(0, 0.3, 0) # set distance of axis
     , tcl = 0.4
     , cex.axis = 1.5
     , mfrow=c(5,2))



#**************************************************************************
# by study
attach(MGRsD)
# aggMGRsDClimate <- summarySE(MGRsD, measurevar="RS_Norm", groupvars=c('MiddleClimate',"StudyNumber",'TimeLable'))


for(i in ID) {
  # i = 20015
  sub_ID <- subset(MGRsD, MGRsD$StudyNumber == i)
  MON <- sort(unique(sub_ID$Measure_Month), decreasing = FALSE, na.last = F)
  
  for (j in MON) {
    # j = 4
    sub_MON <- subset(sub_ID, sub_ID$Measure_Month == j)
    
    # plot Rs diurnal pattern
    with ( sub_MON, 
      
           plot(sub_MON$RS_Norm ~ sub_MON$Measure_DOY
             , type='l', col='black', lty=1
             , pch = 1
             , las = 1
             , cex = 1.5, lwd=2
             , xlab = ""
             , ylab = "" 
             # , xaxt = 'n', yaxt = 'n'
             # , xlim=c(-1,24)
             # , ylim=c(0,17)
         )
    )
    
    # add axis
    # axis(side=1,las=1,cex=1, at = seq(from=1, to=24, by=4))
    # axis(side=2,las=1,cex=1, at = seq(from=0, to=17, by=2))
    
    # add label
    varStudynum <- paste(sub_MON$StudyNumber[1])
    varMon <- paste(sub_MON$Measure_Month[1])
    expr <- paste("ID=",varStudynum, ", Month=", varMon, sep = '')
    
    text(x=min(sub_MON$Measure_DOY)+5, y=max(sub_MON$RS_Norm*0.8), labels = expr,cex = 1.5, col='blue')
    
    # abline
    # abline(v = 10, lty=2, col='gray')
    abline(h = mean(sub_MON$RS_Norm), lty=2, col='gray')
    
    
    # add soil temperature curve ******************************************************
    par(new = T)
    
    with (sub_MON, 
          plot ( sub_MON$Tsoil.C. ~ sub_MON$Measure_DOY
                 , type='l'
                 , pch = 1
                 , las = 1
                 , lwd=2
                 , xlab = ""
                 , ylab = "" 
                 , col = "red"
                 , lty = 2
                 , xaxt = 'n', yaxt = 'n'
                 # ,xlim=c(-1,24)
                 ,ylim=c(-5,40) )
    )
    
    axis(side=4,las=1,cex=1, at = seq(from=0, to=40, by=10))
    
    # abline
    abline(h = mean(sub_MON$Tsoil.C.), lty=2, col='brown')
    
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



