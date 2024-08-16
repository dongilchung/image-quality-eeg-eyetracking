evTab <- pupilTimeTab_1_all_task

# Define categorical variables
evTab$sub <- factor(evTab$sub)
evTab$task <- factor(evTab$task)
evTab$white_boost <- factor(evTab$white_boost)

nVar = dim(evTab)[2]

# Define vector for results
P_wb <- c(); F_wb <- c(); H_wb <- c();
P_12 <- c(); P_23 <- c(); P_13 <- c();

# ANCOVA loop
for(i in 1:(nVar-5)){
  idx = i + 5
  fit <- aov(get(paste0("evTab",idx)) ~ white_boost*task*valence*arousal + Error(sub/(white_boost*task*valence*arousal)), data = evTab)
  sum <- summary(fit)

  F_wb[i] <- sum$`Error: sub:white_boost`[[1]]$`F value`[1]
  P_wb[i] <- sum$`Error: sub:white_boost`[[1]]$`Pr(>F)`[1]
  H_wb[i] <- P_wb[i]<0.05
  
  # Posthoc test
  # install 'TukeyC' package
  tk <- with(evTab, TukeyC(fit, which='white_boost'))
  
  P_12[i] <- tk$out$Diff_Prob[2,1]
  P_23[i] <- tk$out$Diff_Prob[3,2]
  P_13[i] <- tk$out$Diff_Prob[3,1]
  
  if (i %% 100 == 0){
    print(i) 
  }
}

HTab <- data.frame(H_wb)
FTab <- data.frame(F_wb)
PTab <- data.frame(P_wb)

P12Tab <- data.frame(P_12)
P23Tab <- data.frame(P_23)
P13Tab <- data.frame(P_13)

library(ggplot2)
library(dplyr)


library(openxlsx)
write.xlsx(HTab, file="pupTimeHtab_posthoc.xlsx")
write.xlsx(FTab, file="pupTimeFtab_posthoc.xlsx")
write.xlsx(PTab, file="pupTimePtab_posthoc.xlsx")

write.xlsx(P12Tab, file="pupTimeP12tab_posthoc.xlsx")
write.xlsx(P23Tab, file="pupTimeP23tab_posthoc.xlsx")
write.xlsx(P13Tab, file="pupTimeP13tab_posthoc.xlsx")
