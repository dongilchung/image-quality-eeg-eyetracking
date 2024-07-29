pupilTimeTab_1_all_task <- read.csv("C:/Users/Owner/Desktop/pupilTimeTab_1_all_task.csv")
#pupilTimeTab_1_all_task <- read.csv("~/Desktop/pupilTimeTab_1_all_task.csv")
evTab <- pupilTimeTab_1_all_task

library(openxlsx)

# Define categorical variables
evTab$sub <- factor(evTab$sub)
evTab$task <- factor(evTab$task)
evTab$white_boost <- factor(evTab$white_boost)

# nVar = 6 #dim(evTab)[2]
varList = seq(6,dim(evTab)[2],10)
subList = unique(evTab$sub)

n_resampl = 100
set.seed(0)

# Define vector for results
F_wb <- c(); F_ta <- c(); F_va <- c(); F_ar <- c();
F_wb_ta <- c();F_wb_va <- c();
F_wb_ar <- c();F_va_ar <- c();
F_ta_va <- c();F_ta_ar <- c();

condiT = evTab[,1:5]
startTime <- Sys.time()

for(r in 1:n_resampl){
  resampl_idx = sample(subList, replace=TRUE)
  
  for(i in 1:length(varList)){
    var_idx = varList[i]
    tmp_dat = c()
    
    for (s in 1:length(resampl_idx)) {
      tmp_idx = evTab$sub == resampl_idx[s]
      tmp_dat = c(tmp_dat, evTab[tmp_idx,var_idx])
    }
    condiT$dat = tmp_dat
    
    fit <- aov(dat ~ white_boost*task*valence*arousal + Error(sub/(white_boost*task*valence*arousal)), data = condiT)
    sum <- summary(fit)
    
    F_wb[i] <- sum$`Error: sub:white_boost`[[1]]$`F value`[1]
    F_ta[i] <- sum$`Error: sub:task`[[1]]$`F value`[1]
    F_va[i] <- sum$`Error: sub:valence`[[1]]$`F value`[1]
    F_ar[i] <- sum$`Error: sub:arousal`[[1]]$`F value`[1]
    
    F_wb_ta[i] <- sum$`Error: sub:white_boost:task`[[1]]$`F value`[1]
    F_va_ar[i] <- sum$`Error: sub:valence:arousal`[[1]]$`F value`[1]
    F_wb_va[i] <- sum$`Error: sub:white_boost:valence`[[1]]$`F value`[1]
    F_wb_ar[i] <- sum$`Error: sub:white_boost:arousal`[[1]]$`F value`[1]
    F_ta_va[i] <- sum$`Error: sub:task:valence`[[1]]$`F value`[1]
    F_ta_ar[i] <- sum$`Error: sub:task:arousal`[[1]]$`F value`[1]
    
    if (i %% 20 == 0){
      message("resampling: ", i, "/", length(varList))
    }
  }
  
  # save
  FTab <- data.frame(F_wb,F_ar,F_va,F_ta,F_wb_ar,F_wb_ta,F_wb_va,F_ta_ar,F_ta_va,F_va_ar)
  write.xlsx(FTab, file=paste0("C:/Users/Owner/Desktop/pupResults_1/pupTimeFtab_", r,".xlsx"))
  
  if (r %% 1 == 0){
    currTime <- Sys.time()
    durTime = difftime(currTime, startTime, units = "secs")[[1]]/60
    totalTime = durTime/r*n_resampl
    remainedTime = totalTime-durTime
    
    message("Trial: ", r , " / ", n_resampl)
    message(round(durTime,2)," / ", round(totalTime,2), " mins (-", round(remainedTime,2), " mins)")
  }
  
}