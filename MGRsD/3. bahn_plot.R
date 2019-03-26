# 3-bahn_plot.R
# BBL December 2013

# Take Rs database and compute RS@MAT: soil respiration at mean annual air temperature


rm (list = ls())

MGRsD_DIR  <- dirname(rstudioapi::getSourceEditorContext()$path)

setwd(MGRsD_DIR)
getwd()
# install.packages("ggpubr")
source( "0-header.R" )
# install.packages("stringr")
loadlibs( c( "ggplot2", "stringr", "ggpubr" ) )


srdb <- read.csv( "MGRsD-Bahn-processed.csv", stringsAsFactors=F )
printdims( srdb )


#**************************************************************************
# Step 2: plot
#**************************************************************************

which(colnames(srdb) == 'Rs1')
which(colnames(srdb) == 'Rs12')
which(colnames(srdb) == 'Rs_bahn_Jan')

pdf(file =paste(MGRsD_DIR, 'outputs', '3.1 Rs va Rs_bahn by month.pdf', sep = "/") , width=9, height=9)
# tiff("1 Rs Monthlyl pattern by region.tiff", width = 12, height = 10, pointsize = 1/300, units = 'in', res = 300)

varMon <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

par( mar=c(2, 0.2, 0.2, 0.2)
     , mai=c(0.3, 0.3, 0.0, 0.1)  # by inches, inner margin
     , omi = c(0.35, 0.4, 0.1, 0.16)  # by inches, outer margin 
     , mgp = c(0, 0.3, 0) # set distance of axis
     , tcl = 0.4
     , cex.axis = 1.5
     , mfrow=c(3,2))


sub_bahn <- as.data.frame(matrix(NA, nrow = 0, ncol = 3))

for(i in c(73:84)) {
  
  subdata <- srdb[!is.na( srdb[,i] ) & !is.na( srdb[,i+12]),]
  subdata[,i+12] <- subdata[,i+12]/365
  subdata <- subdata[subdata[,i+12] < 20,]
  
  sub_i <- cbind(subdata[,i], subdata[,i+12], i-72)
  sub_bahn <- rbind(sub_bahn, sub_i)
  
  plot(subdata[,i], subdata[,i+12]
       , xlim = c(0, max(max(subdata[,i]), max(subdata[,i+12]))  )
       , ylim = c(0, max(max(subdata[,i]), max(subdata[,i+12]))  )
       , main = ""
       , xlab = ""
       , ylab = ""
       , pch = 16
       , col = "gray"
  )
  grid()
  abline(0,1, lwd=2, col='red', lty = 2 )
  abline(lm(subdata[,i+12] ~ subdata[,i]), lty = 1, lwd=2, col="black")
  text (1, max(max(subdata[,i]), max(subdata[,i+12]))*0.9, varMon[i-72], cex = 1.25)
  
}

mtext(side = 1, text = expression("Measured monthly Rs (g C m"^2* "d"^-1*")") , line = 0.75, cex=1.25, font=2, outer=T)
mtext(side = 2, text = expression("Predicted monthly Rs by Bahn (g C m"^2* "d"^-1*")"), line = 0.35, cex=1.25, font=2, outer=T, las=0)

dev.off()


colnames(sub_bahn) <- c("Rs_Month", "Rs_Month_bahn", "Month")

max(sub_bahn$Rs_Month)
max(sub_bahn$Rs_Month_bahn)


# max(srdb$Rs1, na.rm = T)

tiff( paste(MGRsD_DIR, 'outputs', "3.2 Rs Monthlyl bahn test.tiff", sep = '/'), width = 8, height = 6, pointsize = 1/300, units = 'in', res = 300)

qplot(Rs_Month, Rs_Month_bahn, data = sub_bahn) + theme_bw() +
    geom_abline (intercept = 0, slope = 1, color = "red", linetype = "dashed", size = 1.5) +
    xlab (expression ("Measured monthly Rs (g C m"^-2 * " d"^-1* ")") ) +
    ylab (expression ("Predicted monthly Rs by Bahn (g C m"^-2 * " d"^-1* ")") ) +
    geom_smooth( method = "lm")

dev.off()



