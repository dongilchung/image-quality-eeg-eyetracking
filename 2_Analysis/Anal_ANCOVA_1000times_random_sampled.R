## 100 times random sampled ANCOVA statistics for cluster-based permutation test
## we launched this code for 10 times, get 1000 times random sampled ANCOVA statistics
library(R.matlab)

#rstan_options(auto_write = TRUE)
#options(mc.cores = 2)
options(mc.cores = parallel::detectCores())
## for server
setwd("/home/samba/Office/Users/chlim/LG_task/LG_permutation")
## for local
#setwd("/Volumes/samba/Office/Users/chlim/LG_task/LG_permutation")

## for local
# chainNum <- 1
# groupNum <- 1

## for server
args <- commandArgs(trailingOnly = TRUE);
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else {
  chainNum <- args[1];
  # groupNum <- argsC[2]; #1:grp1 gain, 2:grp2 loss 3:grp2 gain, 2:grp2 loss
}


#file_path <- "/Volumes/samba/Office/Users/chlim/LG_task/LG_permutation/Ancova_allsubj_data_nanmean.mat"
file_path <- "/home/samba/Office/Users/chlim/LG_task/LG_permutation/Ancova_allsubj_data_nanmean.mat"
datas <- readMat(file_path)



behavior_allsubj <- datas[2]
behavior_frame <- as.data.frame(behavior_allsubj)
colnames(behavior_frame) <- c("rating", "valence", "whiteboost","Image number", "Valence","Arousal","Block","subj")

EEG_behavior_allsubj <- datas[[1]] # list -> array, use [[]]

num_ch = 31;
num_timepoint = 750;
num_iter = 100;

num_results = 17;
fit_results = 18;

coeff_wb_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
coeff_valence_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
coeff_arousal_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
#coeff_wb_val_iter <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
#coeff_wb_aro_iter <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
#coeff_wb_block_iter <- array(NA, dim = c(num_ch, num_timepoint, num_iter))

P_val_wb_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
F_val_wb_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
P_val_valence_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
P_val_arousal_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
P_val_wb_block_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
F_val_wb_block_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
P_val_wb_val_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
F_val_wb_val_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
P_val_wb_aro_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))
F_val_wb_aro_all <- array(NA, dim = c(num_ch, num_timepoint, num_iter))

for (sample in 1:num_iter){

  
  random_subj <- sample(1:17, 17, replace = TRUE) ; # 17 subj combination with repetition
  shuffled_location = vector(length = 6426) # shuffled_table structure
  for (i in 1:17) {
    random_indices = which(behavior_frame$subj == random_subj[i]) # location of random sampled subj
    
    start_idx <- 378 * (i - 1) + 1 #trial numbers for each subj
    end_idx <- 378 * i
    shuffled_location[start_idx:end_idx] <- random_indices # save the location
   }
 
  behavior_shuffled_table <- behavior_frame[shuffled_location,]

for (ch in 1:num_ch) {
  # coeff_valence_tp <- numeric(0);
  # coeff_arousal_tp <- numeric(0);
  # coeff_wb_tp<- numeric(0);
  # p_val_wb_tp <- numeric(0);
  # F_val_wb_tp <- numeric(0);
  # p_val_valence_tp <- numeric(0);
  # p_val_arousal_tp <- numeric(0);
  # p_val_wb_block_tp <- numeric(0);
  # F_val_wb_block_tp <- numeric(0);
  # p_val_wb_val_tp <- numeric(0);
  # F_val_wb_val_tp <- numeric(0);
  # p_val_wb_aro_tp <- numeric(0);
  # F_val_wb_aro_tp <- numeric(0);  
  
  for (timepoint in 1:num_timepoint) {
    extracted_data <- EEG_behavior_allsubj[ch, timepoint, , drop = F] # 1x1x6426 data extraction
    extracted_reshape <- as.vector(extracted_data) # change to 6426 x 1
    shuffled_EEG = extracted_reshape[shuffled_location];
    result_table <- cbind(behavior_shuffled_table, shuffled_EEG) # behavior and EEG data merge
    colnames(result_table)[9] <- "EEG" #Final table

# Table
evTab <- result_table

# Define categorical variables
evTab$subj <- factor(evTab$subj)
evTab$Block <- factor(evTab$Block)
evTab$whiteboost <- factor(evTab$whiteboost)


# ANCOVA with repeated measure design and 2 covariates
# need to replace 'color_gamut' with arousal here
fit <- aov(EEG ~ whiteboost*Block*Valence*Arousal + Error(subj/(whiteboost*Block*Valence*Arousal)), data = evTab)
sum <- summary(fit)
#sum_list[[ch]][[timepoint]][[sample]] <- sum
# fit_list[[ch]][[timepoint]][[sample]] <- fit

# Extract results
# main effect of white boost
df <- sum$`Error: subj:whiteboost`[[1]]$Df
coeff_wb <- sum$`Error: subj:whiteboost`[[1]]$`F value`[1]
# coeff_wb_tp <- c(coeff_wb_tp,coeff_wb)

F_val_wb <- sum$`Error: subj:whiteboost`[[1]]$`F value`[1]
p_val_wb <- sum$`Error: subj:whiteboost`[[1]]$`Pr(>F)`[1]
# p_val_wb_tp <- c(p_val_wb_tp, p_val_wb)
# F_val_wb_tp <- c(F_val_wb_tp, F_val_wb)

# main effect of Valence (covariate)
coeff_valence <- fit$`subj:Valence`$coefficients[1]
p_val_valence <- sum$`Error: subj:Valence`[[1]]$`Pr(>F)`[1]

# main effect of Arousal (covariate)
coeff_arousal <- fit$`subj:Arousal`$coefficients[1]
p_val_arousal <- sum$`Error: subj:Arousal`[[1]]$`Pr(>F)`[1]

# interaction effect between white boost & Block
df <- sum$`Error: subj:whiteboost:Block`[[1]]$Df
F_val_wb_block <- sum$`Error: subj:whiteboost:Block`[[1]]$`F value`[1]
p_val_wb_block <- sum$`Error: subj:whiteboost:Block`[[1]]$`Pr(>F)`[1]

# interaction effect between white boost & Valence (covariate)
df <- sum$`Error: subj:whiteboost:Valence`[[1]]$Df
coeff_wb_val <- fit$`subj:whiteboost:Valence`$coefficients[1:2] # not sure how interpret this
F_val_wb_val <- sum$`Error: subj:whiteboost:Valence`[[1]]$`F value`[1]
p_val_wb_val <- sum$`Error: subj:whiteboost:Valence`[[1]]$`Pr(>F)`[1]

# interaction effect between white boost & Valence (covariate)
df <- sum$`Error: subj:whiteboost:Arousal`[[1]]$Df
coeff_wb_aro <- fit$`subj:whiteboost:Arousal`$coefficients[1:2] # not sure how interpret this
F_val_wb_aro <- sum$`Error: subj:whiteboost:Arousal`[[1]]$`F value`[1]
p_val_wb_aro <- sum$`Error: subj:whiteboost:Arousal`[[1]]$`Pr(>F)`[1]

coeff_wb_all[ch,timepoint,sample] <- coeff_wb;
coeff_arousal_all[ch,timepoint,sample] <- coeff_valence;
coeff_valence_all[ch,timepoint,sample] <- coeff_arousal;
P_val_wb_all[ch,timepoint,sample] <- p_val_wb;
F_val_wb_all[ch,timepoint,sample] <- F_val_wb;
P_val_valence_all[ch,timepoint,sample] <- p_val_valence;
P_val_arousal_all[ch,timepoint,sample] <- p_val_arousal;
P_val_wb_block_all[ch,timepoint,sample] <- p_val_wb_block;
F_val_wb_block_all[ch,timepoint,sample] <- F_val_wb_block;
P_val_wb_val_all[ch,timepoint,sample] <- p_val_wb_val;
F_val_wb_val_all[ch,timepoint,sample] <- F_val_wb_val;
P_val_wb_aro_all[ch,timepoint,sample] <- p_val_wb_aro;
F_val_wb_aro_all[ch,timepoint,sample] <- F_val_wb_aro;
} # timepoint
} # ch
} # iter
Ancova_statistics = list(P_val_wb_all = P_val_wb_all, F_val_wb_all = F_val_wb_all, P_val_valence_all = P_val_valence_all, P_val_arousal_all = P_val_arousal_all
                         ,P_val_wb_block_all = P_val_wb_block_all, F_val_wb_block_all = F_val_wb_block_all, P_val_wb_val_all = P_val_wb_val_all,
                         F_val_wb_val_all = F_val_wb_val_all, P_val_wb_aro_all = P_val_wb_aro_all, F_val_wb_aro_all = F_val_wb_aro_all, coeff_valence_all = coeff_valence_all, coeff_arousal_all = coeff_arousal_all, 
                         coeff_wb_all = coeff_wb_all);

fname = paste("Ancova_resampling_100times_",chainNum,".mat",sep="");
writeMat(fname,Ancova_statistics = Ancova_statistics)



# # Posthoc test
# # install 'TukeyC' package
# tk <- with(evTab, TukeyC(fit, which='whiteboost'))
# summary(tk)
# 
# tk <- with(evTab, TukeyC(fit, which='whiteboost:Block', fl1=1))
# summary(tk)
# saveRDS(x_out, file="x_out.Rda")
# x_out1 <- readRDS(file="x_out.Rda")