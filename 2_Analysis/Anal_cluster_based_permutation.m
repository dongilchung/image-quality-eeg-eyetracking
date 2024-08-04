%LG_cluster_correction
% load seed_state(for stable random number generation) and chan_hood
% (neighbor channel matrix, make with spatial_neighbors(chanlocs_new,40)
% function)
addpath '/Volumes/samba/Office/Users/chlim/LG_task/LG_permutation/Script/dmgroppe-Mass_Univariate_ERP_Toolbox-d1e60d4'
load('/Volumes/samba/Office/Users/hrJang/OBL/eeg/cluster_seed_state.mat');
% load neighbor channel information with 4.19cm criteria  
%load('/Volumes/samba/Office/Users/hrJang/OBL/eeg/cluster_chan_hood40.mat');
addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation/Script
load("chan_hood_LG_5cm.mat")
%% Ancova 1000 permutation, alpha level 0.05, 1 tailed, cluster inclusion threshold 0.005
addpath /Users/changhyunlim/Desktop/LG_display/EEG/EEG_data/EEG_realpilot/Behavior_data/Behavior_data_analysis/Figures/Figures_0828/Multiple_linear_regression
%load("Residual Vivid EEG ~ Vivid subjective rating,31channel.mat")
load("White boosting condtion for all block.mat")
data = IAPS_highboost_ERP_allsubj - IAPS_noboost_ERP_allsubj;
%load("3 Whiteboosting level difference_valence.mat")
%data = Whiteboost_ERP_highoff_difference;
%[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm1(data, chan_hood_40, 1000, 0.05, 0, 0.001, 2, seed_state, 0);
%[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm1(data, chan_hood_5cm, 1000, 0.05, 0, 0.001, 2, seed_state, 0);

%% 1000 permutation with Ancova
addpath '/Users/changhyunlim/Desktop/LG_display/EEG/EEG_data/EEG_realpilot/Behavior_data/Behavior_data_analysis/Figures/Figures_0828/Multiple_linear_regression/Permutation/Script/dmgroppe-Mass_Univariate_ERP_Toolbox-d1e60d4'
addpath '/Volumes/samba/Office/Users/chlim/LG_task/LG_permutation'
addpath '/Users/changhyunlim/Desktop/LG_display/EEG/EEG_data/EEG_realpilot/Behavior_data/Behavior_data_analysis/Figures/Figures_0828/Multiple_linear_regression/Permutation/Script'
load('/Volumes/samba/Office/Users/hrJang/OBL/eeg/cluster_seed_state.mat');
load("Ancova_750_datas.mat");
load("Ancova_1000permutation_WB_all.mat")
%load("Ancova_1000permutation_WB_block_all.mat")
load("chan_hood_LG_5cm.mat")
%load("chan_hood_LG_4_17cm.mat")

%Ancova_Whiteboost_P = Ancova_statistics.P_val_wb_all;
%Ancova_Whiteboost_F = Ancova_statistics.F_val_wb_all;
load("Ancova_750_datas.mat");
%data = Ancova_statistics.F_val_wb_all;
data = Ancova_statistics.F_val_wb_block_all;
%[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm_F(data, chan_hood_5cm, 1000, 0.05, 1, 0.005, 2, seed_state, 0,Ancova_permu_WB_all);
[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm_F(data, chan_hood_5cm, 1000, 0.05, 1, 0.005, 2, seed_state, 0,Ancova_permu_WB_block_all);

%% MLR, Test beta coefficient is different with 0, two tailed, alpha level 0.05(Collins, A. G. E., & Frank, M. J. (2016))
%load("Residual Vivid EEG ~ Vivid subjective rating,31channel.mat")
%load("Multiple Arousal EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat")
addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation
load("MLR image based Vividness EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat")
Vivid_rating_beta_allsubj(:,:,4) = [];
data = Vivid_rating_beta_allsubj;
%load("Residual image based MLR Vivid EEG - Vivid subjective rating.- 31 channel individual beta.mat")
%load("chan_hood_LG_5cm.mat")
%Vivid_rating_beta_allsubj(:,:,2) = [];
%data = Vivid_rating_beta_allsubj;
Vivid_rating_beta_resi_allsubj(:,:,4) = [];
data_resi = Vivid_rating_beta_resi_allsubj;%When comparing two ERP data are different, use ERP data 
%When comparing regression beta is significantly different with 0, use beta data
                                                   %clust_perm1(data,chan_hood,n_perm,fwer,tail,thresh_p,verblevel,seed_state,freq_domain)
%[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm2(IAPS_highboost_all,IAPS_noboost_all, chan_hood_5cm, 1000, 0.05, 0, 0.01, 2, seed_state, 0);

%[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm1(data, chan_hood_5cm, 1000, 0.05, 0, 0.001, 2, seed_state, 0);
[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm1(data, chan_hood_5cm, 1000, 0.05, 0, 0.005, 2, seed_state, 0);
%[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm1(data_resi, chan_hood_5cm, 1000, 0.05, 0, 0.005, 2, seed_state, 0);

Sig_clust_pos = [];
Pos_Sig_clust_id = find(clust_info.pos_clust_pval <= 0.05);
n_sig_clust = length(Pos_Sig_clust_id);
for id = 1:n_sig_clust
    use_ids = find(clust_info.pos_clust_ids == Pos_Sig_clust_id(id));
    [Sig_clust_pos(id).channel,Sig_clust_pos(id).time ] = find(clust_info.pos_clust_ids == Pos_Sig_clust_id(id));
    Sig_clust_pos(id).id = Pos_Sig_clust_id(id);
    Sig_clust_pos(id).pval = clust_info.pos_clust_pval(Pos_Sig_clust_id(id));
    Sig_clust_pos(id).t = t_orig(use_ids);
end

Sig_clust_neg = [];
Neg_Sig_clust_id = find(clust_info.neg_clust_pval <= 0.05);
n_sig_clust = length(Neg_Sig_clust_id);
for id = 1:n_sig_clust
    use_ids = find(clust_info.neg_clust_ids == Neg_Sig_clust_id(id));
    [Sig_clust_neg(id).channel,Sig_clust_neg(id).time ] = find(clust_info.neg_clust_ids == Neg_Sig_clust_id(id));
    Sig_clust_neg(id).id = Neg_Sig_clust_id(id);
    Sig_clust_neg(id).pval = clust_info.neg_clust_pval(Neg_Sig_clust_id(id));
    Sig_clust_neg(id).t = t_orig(use_ids);
end
L


%save("Significant cluster in Multiple Arousal EEG ~ Valence.mat","Sig_clust_pos","Sig_clust_neg")
%save("Significant cluster image based linear regression Vivid EEG ~ Vividness - 17 subjects - thresh_p_0.005.mat","Sig_clust_pos")
save("Significant cluster image based residual regression Vivid EEG ~ Vividness - 17 subjects - thresh_p_0.005.mat","Sig_clust_pos")
%save("Significant cluster White boosting effect across block","Sig_clust_pos","Sig_clust_neg")

% data = Valence_rating_beta_resi;
% data = permute(Vivid_rating_beta_resi,[3 2 1]);
% data = cat(3,data,data);
% [pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm1(data, chan_hood_40, 1000, 0.05, 0, 0.001, 2, seed_state, 0);

%  save('OBL_cluster_Corrected_pval_APE_Gain.mat','pval', 't_orig', 'clust_info', 'seed_state', 'est_alpha');
% save('OBL_cluster_Corrected_pval_Q_Loss_timelocked_max.mat','pval', 't_orig', 'clust_info', 'seed_state', 'est_alpha');
%  save('OBL_cluster_Corrected_pval_OPE_Gain_timelocked_max.mat','pval', 't_orig', 'clust_info', 'seed_state', 'est_alpha');
% save('OBL_cluster_Corrected_pval_PE_Loss_timelocked_max.mat','pval', 't_orig', 'clust_info', 'seed_state', 'est_alpha');
% save('OBL_cluster_Corrected_pval_PE_Gain_timelocked_max.mat','pval', 't_orig', 'clust_info', 'seed_state', 'est_alpha');
% save('OBL_cluster_Corrected_pval_PE_Gain.mat','pval', 't_orig', 'clust_info', 'seed_state', 'est_alpha');
% save('OBL_cluster_Corrected_pval_PE_Loss.mat','pval', 't_orig', 'clust_info', 'seed_state', 'est_alpha');
% save('OBL_cluster_Corrected_pval_APE_Loss_timelocked_max.mat','pval', 't_orig', 'clust_info', 'seed_state', 'est_alpha');
%save('OBL_cluster_Corrected_pval_APE_Loss_stimulus.mat','pval', 't_orig', 'clust_info', 'seed_state', 'est_alpha');

%% Test Ancova statistic values
addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation
load("Ancova_datas.mat")
addpath /Users/changhyunlim/Desktop/LG_display/EEG/EEG_data/EEG_realpilot/Behavior_data/Behavior_data_analysis/Figures/Figures_0828/Multiple_linear_regression/Permutation/Script
load("chan_hood_LG_5cm.mat")
load("chan_hood_LG_4_17cm.mat")

Ancova_Whiteboost_P = Ancova_statistics.P_val_wb_all;
Ancova_Whiteboost_F = Ancova_statistics.F_val_wb_all;

Ancova_valence_P = Ancova_statistics.P_val_valence_all;
Ancova_arousal_P = Ancova_statistics.P_val_arousal_all;
Ancova_whiteboost_block_P = Ancova_statistics.P_val_wb_block_all;
Ancova_whiteboost_block_F = Ancova_statistics.F_val_wb_block_all;
Ancova_whiteboost_val_P = Ancova_statistics.P_val_wb_val_all;
Ancova_whiteboost_val_F = Ancova_statistics.F_val_wb_val_all;
Ancova_whiteboost_aro_P = Ancova_statistics.P_val_wb_aro_all;
Ancova_whiteboost_aro_F = Ancova_statistics.F_val_wb_aro_all;

data = Ancova_Whiteboost_F_fill;
data = cat(3,data,Ancova_Whiteboost_F_fill);

[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm1(data, chan_hood_5cm, 1000, 0.05, 0, 0.001, 2, seed_state, 0);
[pval, t_orig, clust_info2, seed_state, est_alpha] = clust_perm1(data, chan_hood_40, 1000, 0.05, 0, 0.001, 2, seed_state, 0);
% [PE_pval_Loss, PE_t_orig_Loss, clust_info_Loss, PE_seed_state_Loss, PE_est_alpha_Loss] = clust_perm1(Beta_PE_Loss, chan_hood40, 1000, 0.05, 0, 0.001, 2, seed_state, 0);
% save('OBL_cluster_Corrected_pval_PE.mat','PE_pval','PE_pval_Loss','clust_info', 'PE_seed_state', 'PE_est_alpha','PE_t_orig_Loss', 'clust_info_Loss', 'PE_seed_state_Loss', 'PE_est_alpha_Loss');
% % max timelocked APE
% % [TAPE_max_pval, TAPE_max_t_orig, TAPE_max_clust_info, TAPE_max_seed_state, TAPE_est_alpha] = clust_perm1(timelocked_data{3}(:,:,:), chan_hood40, 1000, 0.05, 0, 0.001, 2, seed_state, 0);
% [PE_max_pval, PE_max_t_orig, PE_max_clust_info, PE_max_seed_state, PE_est_alpha] = clust_perm1(timelocked_data{3}(:,:,:), chan_hood40, 1000, 0.05, 0, 0.001, 2, seed_state, 0);
% [PE_max_pval_Loss, PE_max_t_orig_Loss, PE_max_clust_info_Loss, PE_max_seed_state_Loss, PE_est_alpha_Loss] = clust_perm1(timelocked_data_Loss{3}(:,:,:), chan_hood40, 1000, 0.05, 0, 0.001, 2, seed_state, 0);
% 
% save('OBL_cluster_Corrected_pval_PE_timelocked_max.mat','PE_max_pval', 'PE_max_t_orig', 'PE_max_clust_info', 'PE_max_seed_state', 'PE_est_alpha','PE_max_pval_Loss', 'PE_max_t_orig_Loss', 'PE_max_clust_info_Loss', 'PE_max_seed_state_Loss', 'PE_est_alpha_Loss');
% 
% [OPE_pval_Loss, OPE_t_orig, Oclust_info, OPE_seed_state, OPE_est_alpha] = clust_perm1(Beta_OPE_Loss, chan_hood40, 1000, 0.05, 0, 0.001, 2, seed_state, 0);

%% find significant cluster
% number of positive cluster which is significant

% t_all=[];
% for timepoint = 1:750
%     t_ch=[];
%     for ch = 1:31
%         [R,P,ci,t] = ttest(Whiteboost_ERP_highoff_difference(ch,timepoint,:));
%         t_ch = [t_ch;t.tstat];
%     end
%     t_all =[t_all,t_ch];
% end
% a = find(abs(t_all)>4)

%save("Significant cluster in Multiple Valence EEG ~ Valence.mat","Sig_clust_pos","Sig_clust_neg")
%save("cluster based permutation t test - Whiteboosting - valence.mat","Sig_clust_pos")
