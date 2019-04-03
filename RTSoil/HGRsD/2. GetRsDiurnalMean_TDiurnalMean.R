
#**************************************************************************
# Step 1: data preparation
#**************************************************************************

# load Data

rm(list=ls())

library(ggplot2)
library("ggpubr")

HGRsD_DIR  <- dirname(rstudioapi::getSourceEditorContext()$path)

setwd(HGRsD_DIR)
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

#**************************************************************************
# Step 2: get Rs_diurnal_mean and Ts_diurnal_mean
#**************************************************************************
ID <- sort(unique(HGRsD$StudyNumber), decreasing = FALSE, na.last = TRUE )

Rs_diurnal_bahn <- as.data.frame(matrix(NA, nrow = 0, ncol = 7))

# test
# i = 1021
# j = 118
# sub_ID <- subset(HGRsD, HGRsD$StudyNumber == i)
# sub_DOY <- subset(sub_ID, sub_ID$Measure_DOY == j)

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
    
    
    print (paste (i,"============================ ", j))
    print(Sys.time())
    
  }
  
}

colnames(Rs_diurnal_bahn) <- c("ID", "DOY", "Rs_diurnal_mean", "Ts_diurnal_mean", "Rs_Ts_mean", "Time_label", "Rs_diurnal_bahn")

Rs_diurnal_bahn <- Rs_diurnal_bahn[!is.na(Rs_diurnal_bahn$Rs_diurnal_bahn), ]

#**************************************************************************
# Step 3: plot
#**************************************************************************

p1 <- qplot(Rs_diurnal_mean, Rs_diurnal_bahn, data = Rs_diurnal_bahn) + 
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red", size = 1.5) + 
  theme_bw() +
  geom_smooth(method = "lm") + 
  xlab (expression ("Measured diurnal Rs (g C m"^-2 * " d"^-1* ")") ) +
  ylab (expression ("Predicted diurnal Rs by Bahn (g C m"^-2 * " d"^-1* ")") )

p2 <- qplot(Rs_diurnal_mean, Rs_Ts_mean,  data = Rs_diurnal_bahn) + 
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red", size = 1.5) + 
  theme_bw() +
  geom_smooth(method = "lm") + 
  xlab (expression ("Measured diurnal Rs (g C m"^-2 * " d"^-1* ")") ) +
  ylab (expression ("Rs when reach diurnal Ts (g C m"^-2 * " d"^-1* ")") )

# histgram of time_label
p3 <- qplot(Time_label, geom="histogram", data = Rs_diurnal_bahn, bins = 48)  + theme_bw() +
  xlab (expression ("Time period reach diurnal mean Ts (" * degree~C * ")") ) +
  ylab ('Frequency (n)')


tiff(paste(HGRsD_DIR, "outputs", "2. Bahn_diurnal_test.tiff", sep = "/"), width = 6, height = 12, pointsize = 1/300, units = 'in', res = 300)
# put 3 panels together
ggarrange(p1, p2, p3, nrow = 3) 

dev.off()

