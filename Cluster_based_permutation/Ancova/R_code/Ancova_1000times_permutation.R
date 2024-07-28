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

#install.packages("R.matlab")
# install.packages("data.table")
# library(data.table)
# MAT 파일 읽기

#file_path <- "/Volumes/samba/Office/Users/chlim/LG_task/LG_permutation/Ancova_allsubj_data_nanmean.mat"
file_path <- "/home/samba/Office/Users/chlim/LG_task/LG_permutation/Ancova_allsubj_data_nanmean.mat"
datas <- readMat(file_path)

# array를 table로 전환
#install.packages("data.table")
# data.table 패키지 로드


behavior_allsubj <- datas[2]
behavior_frame <- as.data.frame(behavior_allsubj)
# 열 이름 설정
colnames(behavior_frame) <- c("rating", "valence", "whiteboost","Image number", "Valence","Arousal","Block","subj")

# 데이터 프레임을 테이블로 변환
#behavior_table <- as.data.table(data_df)

EEG_behavior_allsubj <- datas[[1]] # list -> array, use [[]]


num_ch = 4;
num_timepoint = 3;
num_iter = 2;

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

# P_val_wb_all <- matrix(nrow = 31, ncol = num_timepoint)
# F_val_wb_all <- matrix(nrow = 31, ncol = num_timepoint)
# P_val_valence_all <- matrix(nrow = 31, ncol = num_timepoint)
# P_val_arousal_all <- matrix(nrow = 31, ncol = 750)
# P_val_wb_block_all <- matrix(nrow = 31, ncol = 750)
# F_val_wb_block_all <- matrix(nrow = 31, ncol = 750)
# P_val_wb_val_all <- matrix(nrow = 31, ncol = 750)
# F_val_wb_val_all <- matrix(nrow = 31, ncol = 750)
# P_val_wb_aro_all <- matrix(nrow = 31, ncol = 750)
# F_val_wb_aro_all <- matrix(nrow = 31, ncol = 750)

# sum_list <- vector("list", length = num_ch)
# # fit_list <- vector("list", length = num_ch)
# #
# for (i in 1:num_ch) {
#   sum_list[[i]] <- vector("list", length = num_timepoint)
#   # fit_list[[i]] <- vector("list", length = num_timepoint)
#   for (j in 1:num_timepoint) {
#     # 각 ch와 timepoint에 해당하는 result를 저장할 리스트 초기화
#     sum_list[[i]][[j]] <- vector("list", length = num_timepoint)
#     # fit_list[[i]][[j]] <- vector("list", length = fit_results)
#     for (k in 1:num_iter) {
#       sum_list[[i]][[j]][[k]] <- vector("list", length = num_iter)
#        for (m in 1:17) {
#          sum_list[[i]][[j]][[k]][[m]] <- vector("list", length = 17)
#        
#        }
#     }
#   }
# }

for (sample in 1:num_iter){
  
  
  random_subj <- sample(1:17, 17, replace = TRUE) ; # 17 subj 중복 포함 랜덤 추출
  #shuffled_data = data.frame(matrix(NA, nrow = nrow(behavior_table), ncol = ncol(behavior_table))) # shuffled_table 구조 생성
  shuffled_location = vector(length = 6426) # shuffled_table 구조 생성
  for (i in 1:17) {
    random_indices = which(behavior_frame$subj == random_subj[i]) # 랜덤 추출된 subj의 위치 받아오기
    
    start_idx <- 378 * (i - 1) + 1 #subj당 trial개수 지정
    end_idx <- 378 * i
    shuffled_location[start_idx:end_idx] <- random_indices # 위치 저장
    #shuffled_data[start_idx:end_idx,] <- behavior_table[random_indices,]; #result_table에서 shuffled_data로 데이터 받아오기
  }
  #shuffled_location <- as.vector(shuffled_location)
  
  #behavior_array <- as.data.frame(behavior_table);
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
      extracted_data <- EEG_behavior_allsubj[ch, timepoint, , drop = F] # 1x1x6426 데이터 추출
      extracted_reshape <- as.vector(extracted_data) # 6426 x 1로 변환
      shuffled_EEG = extracted_reshape[shuffled_location];
      result_table <- cbind(behavior_shuffled_table, shuffled_EEG) # behavior와 EEG data 결합
      colnames(result_table)[9] <- "EEG" #최종 테이블
      
      
      
      #subj_groups <- split(evTab, evTab$subj)
      
      # 테이블 확인
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
    # P_val_wb_all[ch, ] <- p_val_wb_tp # White boost main effect
    # F_val_wb_all[ch, ] <- F_val_wb_tp  
    # 
    # P_val_valence_all[ch, ] <- p_val_valence_tp # Valence covariate
    # P_val_arousal_all[ch, ] <- p_val_arousal_tp # Arousal covariate
    
    # coeff_wb_all[ch, ] <- coeff_wb_tp
    # coeff_valence_all[ch, ] <- coeff_valence_tp
    # coeff_arousal_all[ch, ] <- coeff_arousal_tp
    # 
    # P_val_wb_block_all[ch, ] <- p_val_wb_block_tp # White boost x Block condition interaction
    # F_val_wb_block_all[ch, ] <- F_val_wb_block_tp
    # 
    # P_val_wb_val_all[ch, ] <- p_val_wb_val_tp # White boost x Valence interaction
    # F_val_wb_val_all[ch, ] <- F_val_wb_val_tp
    # 
    # P_val_wb_aro_all[ch, ] <- p_val_wb_aro_tp # White boost x Arousal interaction
    # F_val_wb_aro_all[ch, ] <- F_val_wb_aro_tp
    #   
  } # ch
  
} # iter

Ancova_statistics = list(P_val_wb_all = P_val_wb_all, F_val_wb_all = F_val_wb_all, P_val_valence_all = P_val_valence_all, P_val_arousal_all = P_val_arousal_all
                         ,P_val_wb_block_all = P_val_wb_block_all, F_val_wb_block_all = F_val_wb_block_all, P_val_wb_val_all = P_val_wb_val_all,
                         F_val_wb_val_all = F_val_wb_val_all, P_val_wb_aro_all = P_val_wb_aro_all, F_val_wb_aro_all = F_val_wb_aro_all, coeff_valence_all = coeff_valence_all, coeff_arousal_all = coeff_arousal_all, 
                         coeff_wb_all = coeff_wb_all);

fname = paste("Ancova_resampling_test_",chainNum,".mat",sep="");
writeMat(fname,Ancova_statistics = Ancova_statistics)

#datas = readMat("Ancova_resampling_5times_1.mat")

#datas <- readMat(file_path)

# fname2 = paste("Ancova_sum_101times_",chainNum,".mat",sep="");
# writeMat(fname2, sum_list = sum_list)

saveRDS(Ancova_statistics, file = "Ancova_result.rds")
# # 데이터 읽기
# loaded_data <- readRDS(file = "Ancova_result.rds")
# 
# library(R.matlab)

#Mat file로 저장

# data_df <- as.data.frame(Ancova_statistics)
# # 열 이름 설정
# colnames(data_df) <- c("Whiteboost_P", "Whiteboost_F", "Valence_P","Arousal_P", "Whiteboost_block_P","Whiteboost_block_F","Whiteboost_Valence_P","Whiteboost_Valence_F"
#                        ,"Whiteboost_Arousal_P","Whiteboost_Arousal_F")
# 
# # 데이터 프레임을 테이블로 변환
# Ancova_table <- as.data.table(data_df)
#writeMat(P_val_wb, file = P_val_wb_all)
# writeMat("Ancova_750_datas.mat", Ancova_statistics = Ancova_statistics)
# writeMat("Ancova_sum.mat", sum_list = sum_list)
# writeMat("Ancova_fit.mat", fit_list = fit_list)
#writeMat("Ancova_ta.mat", Ancova_table = Ancova_table)
# 테이블 확인
# head(behavior_table)



# # Posthoc test
# # install 'TukeyC' package
# tk <- with(evTab, TukeyC(fit, which='whiteboost'))
# summary(tk)
# 
# tk <- with(evTab, TukeyC(fit, which='whiteboost:Block', fl1=1))
# summary(tk)
# saveRDS(x_out, file="x_out.Rda")
# x_out1 <- readRDS(file="x_out.Rda")
# 
# #P_val_wb_all <- matrix(nrow = 31, ncol = num_timepoint)
# P_val_wb_all <- array(1:18, dim = c(3, 3,2))
# 
# # .mat 파일로 저장
# naming = list(P_val_wb_all = P_val_wb_all);
# library(R.matlab)
# fname <- paste("Ancova_resampling_34times_", chainNum, ".mat", sep = "")
# writeMat(fname, naming = naming)
