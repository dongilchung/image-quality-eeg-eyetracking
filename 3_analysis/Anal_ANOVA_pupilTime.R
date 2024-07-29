evTab <- pupilTimeTab_1_all_task

# Define categorical variables
evTab$sub <- factor(evTab$sub)
evTab$task <- factor(evTab$task)
evTab$white_boost <- factor(evTab$white_boost)

nVar = dim(evTab)[2]

# Define vector for results
P_wb <- c(); F_wb <- c(); H_wb <- c();
P_ta <- c(); F_ta <- c(); H_ta <- c();
P_va <- c(); F_va <- c(); H_va <- c(); C_va <- c();
P_ar <- c(); F_ar <- c(); H_ar <- c(); C_ar <- c();
P_wb_ta <- c(); F_wb_ta <- c(); H_wb_ta <- c();
P_wb_va <- c(); F_wb_va <- c(); H_wb_va <- c(); C_wb_va <- matrix(nrow=nVar-5, ncol=2);
P_wb_ar <- c(); F_wb_ar <- c(); H_wb_ar <- c(); C_wb_ar <- matrix(nrow=nVar-5, ncol=2);
P_va_ar <- c(); F_va_ar <- c(); H_va_ar <- c(); C_va_ar <- c();
P_ta_va <- c(); F_ta_va <- c(); H_ta_va <- c(); C_ta_va <- matrix(nrow=nVar-5, ncol=2);
P_ta_ar <- c(); F_ta_ar <- c(); H_ta_ar <- c(); C_ta_ar <- matrix(nrow=nVar-5, ncol=2);

# ANCOVA loop
for(i in 1:(nVar-5)){
  idx = i + 5
  fit <- aov(get(paste0("evTab",idx)) ~ white_boost*task*valence*arousal + Error(sub/(white_boost*task*valence*arousal)), data = evTab)
  sum <- summary(fit)
  
  F_wb[i] <- sum$`Error: sub:white_boost`[[1]]$`F value`[1]
  P_wb[i] <- sum$`Error: sub:white_boost`[[1]]$`Pr(>F)`[1]
  H_wb[i] <- P_wb[i]<0.05
  
  F_ta[i] <- sum$`Error: sub:task`[[1]]$`F value`[1]
  P_ta[i] <- sum$`Error: sub:task`[[1]]$`Pr(>F)`[1]
  H_ta[i] <- P_ta[i]<0.05
  
  F_va[i] <- sum$`Error: sub:valence`[[1]]$`F value`[1]
  P_va[i] <- sum$`Error: sub:valence`[[1]]$`Pr(>F)`[1]
  H_va[i] <- P_va[i]<0.05
  C_va[i] <- fit$`sub:valence`$coefficients[1]
  
  F_ar[i] <- sum$`Error: sub:arousal`[[1]]$`F value`[1]
  P_ar[i] <- sum$`Error: sub:arousal`[[1]]$`Pr(>F)`[1]
  H_ar[i] <- P_ar[i]<0.05
  C_ar[i] <- fit$`sub:arousal`$coefficients[1]
  
  F_wb_ta[i] <- sum$`Error: sub:white_boost:task`[[1]]$`F value`[1]
  P_wb_ta[i] <- sum$`Error: sub:white_boost:task`[[1]]$`Pr(>F)`[1]
  H_wb_ta[i] <- P_wb_ta[i]<0.05
  
  F_va_ar[i] <- sum$`Error: sub:valence:arousal`[[1]]$`F value`[1]
  P_va_ar[i] <- sum$`Error: sub:valence:arousal`[[1]]$`Pr(>F)`[1]
  H_va_ar[i] <- P_va_ar[i]<0.05
  C_va_ar[i] <- t(fit$`sub:valence:arousal`$coefficients[1])
  
  F_wb_va[i] <- sum$`Error: sub:white_boost:valence`[[1]]$`F value`[1]
  P_wb_va[i] <- sum$`Error: sub:white_boost:valence`[[1]]$`Pr(>F)`[1]
  H_wb_va[i] <- P_wb_va[i]<0.05
  C_wb_va[i,1] <- fit$`sub:white_boost:valence`$coefficients[[1]]
  C_wb_va[i,2] <- fit$`sub:white_boost:valence`$coefficients[[2]]
  
  F_wb_ar[i] <- sum$`Error: sub:white_boost:arousal`[[1]]$`F value`[1]
  P_wb_ar[i] <- sum$`Error: sub:white_boost:arousal`[[1]]$`Pr(>F)`[1]
  H_wb_ar[i] <- P_wb_ar[i]<0.05
  C_wb_ar[i,1] <- fit$`sub:white_boost:arousal`$coefficients[[1]]
  C_wb_ar[i,2] <- fit$`sub:white_boost:arousal`$coefficients[[2]]
  
  F_ta_va[i] <- sum$`Error: sub:task:valence`[[1]]$`F value`[1]
  P_ta_va[i] <- sum$`Error: sub:task:valence`[[1]]$`Pr(>F)`[1]
  H_ta_va[i] <- P_ta_va[i]<0.05
  C_ta_va[i,1] <- fit$`sub:task:valence`$coefficients[[1]]
  C_ta_va[i,2] <- fit$`sub:task:valence`$coefficients[[2]]
  
  F_ta_ar[i] <- sum$`Error: sub:task:arousal`[[1]]$`F value`[1]
  P_ta_ar[i] <- sum$`Error: sub:task:arousal`[[1]]$`Pr(>F)`[1]
  H_ta_ar[i] <- P_ta_ar[i]<0.05
  C_ta_ar[i,1] <- fit$`sub:task:arousal`$coefficients[[1]]
  C_ta_ar[i,2] <- fit$`sub:task:arousal`$coefficients[[2]]
  
  if (i %% 100 == 0){
    print(i) 
  }
}

HTab <- data.frame(H_wb,H_ar,H_va,H_ta,H_wb_ar,H_wb_ta,H_wb_va,H_ta_ar,H_ta_va,H_va_ar)
FTab <- data.frame(F_wb,F_ar,F_va,F_ta,F_wb_ar,F_wb_ta,F_wb_va,F_ta_ar,F_ta_va,F_va_ar)
PTab <- data.frame(P_wb,P_ar,P_va,P_ta,P_wb_ar,P_wb_ta,P_wb_va,P_ta_ar,P_ta_va,P_va_ar)
CTab <- data.frame(C_ar,C_va,C_wb_ar,C_wb_va,C_ta_ar,C_ta_va,C_va_ar)

library(ggplot2)
library(dplyr)
CTab <- rename(CTab, "C_wb_ar1"="X1")
CTab <- rename(CTab, "C_wb_ar2"="X2")
CTab <- rename(CTab, "C_wb_va1"="X1.1")
CTab <- rename(CTab, "C_wb_va2"="X2.1")
CTab <- rename(CTab, "C_ta_ar1"="X1.2")
CTab <- rename(CTab, "C_ta_ar2"="X2.2")
CTab <- rename(CTab, "C_ta_va1"="X1.3")
CTab <- rename(CTab, "C_ta_va2"="X2.3")

library(openxlsx)
write.xlsx(HTab, file="pupTimeHtab.xlsx")
write.xlsx(FTab, file="pupTimeFtab.xlsx")
write.xlsx(PTab, file="pupTimePtab.xlsx")
write.xlsx(CTab, file="pupTimeCtab.xlsx")
