function Residual_MLR_image_based(workpath,subj)

load("Image unit based behavior and EEG data for all subject.mat")

Vivid_rating_P_resi_allsubj=[];
Vivid_rating_beta_resi_allsubj=[];
Vivid_rating_tstat_resi_allsubj=[];

for subj=1:18
P_vivid_resi_ch_time=[];
beta_vivid_resi_ch_time=[];
tstat_vivid_resi_ch_time=[];

for ch=1:31 %FC2 C4 CP2
    P_vivid_time=[];
    beta_vivid_time=[];
    tstat_vivid_time=[];
    y1=[];
    P_vivid_resi_time=[];
    beta_vivid_resi_time=[];
    tstat_vivid_resi_time=[];
    for timepoint = 1:750
        trials = [42*subj-41:42*subj];
        x1 = zscore(image_unit_rating_vi_allsubj(1:42,subj));%4536 x 1
        x2 = zscore(image_unit_rating_val_allsubj(1:42,subj));%4536 x 1
        x3 = zscore(image_unit_rating_aro_allsubj(1:42,subj));%4536 x 1
        E1 = permute(image_unit_EEG_val_allsubj(ch,timepoint,trials),[3 1 2]); % 여기만 바꾸면 됨
         NaN_loc = find(isnan(E1));
        E1(NaN_loc) = [];
        x1(NaN_loc) = []; x2(NaN_loc) = []; x3(NaN_loc) = [];
        y1 = zscore(E1);    
        lm = fitlm([x2 x3], y1); %  y1 ~ B1 * Arousal + B1 * Valence 
        Beta_vivid = table2array(lm.Coefficients(:,1));                
        y1_resi = y1 - x2.* Beta_vivid(2,1) - x3.*Beta_vivid(3,1); %y1_resi = Reflect Arousal and Valence prediction to vivid EEG
        lm_resi = fitlm(x1,y1_resi);        
        P_vivid_resi = table2array(lm_resi.Coefficients(:,4));
        tstat_vivid_resi = table2array(lm_resi.Coefficients(:,3));
        Beta_vivid_resi = table2array(lm_resi.Coefficients(:,1));
        P_vivid_resi_time=[P_vivid_resi_time,P_vivid_resi];
        beta_vivid_resi_time=[beta_vivid_resi_time,Beta_vivid_resi];
        tstat_vivid_resi_time=[tstat_vivid_resi_time,tstat_vivid_resi];       
    end                

    %y1_resi = permute(y1(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750); %y1_resi = Reflect Arousal and Valence prediction to vivid EEG
    %y2_resi = permute(z2(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    
    %y3_resi = permute(z3(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    

    P_vivid_resi_ch_time = cat(3,P_vivid_resi_ch_time,P_vivid_resi_time);
    beta_vivid_resi_ch_time = cat(3,beta_vivid_resi_ch_time,beta_vivid_resi_time);
    tstat_vivid_resi_ch_time = cat(3,tstat_vivid_resi_ch_time,tstat_vivid_resi_time);
end
Vivid_rating_P_resi = P_vivid_resi_ch_time(2,:,:);
Vivid_rating_beta_resi = beta_vivid_resi_ch_time(2,:,:); % block,timepoint,channel
Vivid_rating_tstat_resi = tstat_vivid_resi_ch_time(2,:,:); % block,timepoint,channel

Vivid_rating_P_resi = permute(Vivid_rating_P_resi,[3 2 1]);
Vivid_rating_beta_resi = permute(Vivid_rating_beta_resi,[3 2 1]);
Vivid_rating_tstat_resi = permute(Vivid_rating_tstat_resi,[3 2 1]);

Vivid_rating_P_resi_allsubj = cat(3,Vivid_rating_P_resi_allsubj,Vivid_rating_P_resi);
Vivid_rating_beta_resi_allsubj = cat(3,Vivid_rating_beta_resi_allsubj,Vivid_rating_beta_resi);
Vivid_rating_tstat_resi_allsubj = cat(3,Vivid_rating_tstat_resi_allsubj,Vivid_rating_tstat_resi);
end
save("Residual image based MLR Valence EEG - Vivid subjective rating.- 31 channel individual beta.mat","Vivid_rating_P_resi_allsubj","Vivid_rating_beta_resi_allsubj");
%save("Residual Valence EEG - Vivid subjective rating.- 31 channel individual beta.mat","Vivid_rating_P_resi_allsubj","Vivid_rating_beta_resi_allsubj","Vivid_rating_tstat_resi_allsubj");
%save("Residual Arousal EEG - Vivid subjective rating.- 31 channel individual beta.mat","Vivid_rating_P_resi_allsubj","Vivid_rating_beta_resi_allsubj","Vivid_rating_tstat_resi_allsubj");



Vivid_rating_P_resi_allsubj=[];
Vivid_rating_beta_resi_allsubj=[];
Vivid_rating_tstat_resi_allsubj=[];

for subj=1:18
P_vivid_resi_ch_time=[];
beta_vivid_resi_ch_time=[];
tstat_vivid_resi_ch_time=[];

for ch=1:31 %FC2 C4 CP2
    P_vivid_time=[];
    beta_vivid_time=[];
    tstat_vivid_time=[];
    y1=[];
    P_vivid_resi_time=[];
    beta_vivid_resi_time=[];
    tstat_vivid_resi_time=[];
    for timepoint = 1:750
        trials = [42*subj-41:42*subj];
        x1 = zscore(image_unit_rating_vi_allsubj(1:42,subj));%4536 x 1
        x2 = zscore(image_unit_rating_val_allsubj(1:42,subj));%4536 x 1
        x3 = zscore(image_unit_rating_aro_allsubj(1:42,subj));%4536 x 1
        E1 = permute(image_unit_EEG_aro_allsubj(ch,timepoint,trials),[3 1 2]); % 여기만 바꾸면 됨
         NaN_loc = find(isnan(E1));
        E1(NaN_loc) = [];
        x1(NaN_loc) = []; x2(NaN_loc) = []; x3(NaN_loc) = [];
        y1 = zscore(E1);    
        lm = fitlm([x2 x3], y1); %  y1 ~ B1 * Arousal + B1 * Valence 
        Beta_vivid = table2array(lm.Coefficients(:,1));                
        y1_resi = y1 - x2.* Beta_vivid(2,1) - x3.*Beta_vivid(3,1); %y1_resi = Reflect Arousal and Valence prediction to vivid EEG
        lm_resi = fitlm(x1,y1_resi);        
        P_vivid_resi = table2array(lm_resi.Coefficients(:,4));
        tstat_vivid_resi = table2array(lm_resi.Coefficients(:,3));
        Beta_vivid_resi = table2array(lm_resi.Coefficients(:,1));
        P_vivid_resi_time=[P_vivid_resi_time,P_vivid_resi];
        beta_vivid_resi_time=[beta_vivid_resi_time,Beta_vivid_resi];
        tstat_vivid_resi_time=[tstat_vivid_resi_time,tstat_vivid_resi];       
    end                

    %y1_resi = permute(y1(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750); %y1_resi = Reflect Arousal and Valence prediction to vivid EEG
    %y2_resi = permute(z2(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    
    %y3_resi = permute(z3(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    

    P_vivid_resi_ch_time = cat(3,P_vivid_resi_ch_time,P_vivid_resi_time);
    beta_vivid_resi_ch_time = cat(3,beta_vivid_resi_ch_time,beta_vivid_resi_time);
    tstat_vivid_resi_ch_time = cat(3,tstat_vivid_resi_ch_time,tstat_vivid_resi_time);
end
Vivid_rating_P_resi = P_vivid_resi_ch_time(2,:,:);
Vivid_rating_beta_resi = beta_vivid_resi_ch_time(2,:,:); % block,timepoint,channel
Vivid_rating_tstat_resi = tstat_vivid_resi_ch_time(2,:,:); % block,timepoint,channel

Vivid_rating_P_resi = permute(Vivid_rating_P_resi,[3 2 1]);
Vivid_rating_beta_resi = permute(Vivid_rating_beta_resi,[3 2 1]);
Vivid_rating_tstat_resi = permute(Vivid_rating_tstat_resi,[3 2 1]);

Vivid_rating_P_resi_allsubj = cat(3,Vivid_rating_P_resi_allsubj,Vivid_rating_P_resi);
Vivid_rating_beta_resi_allsubj = cat(3,Vivid_rating_beta_resi_allsubj,Vivid_rating_beta_resi);
Vivid_rating_tstat_resi_allsubj = cat(3,Vivid_rating_tstat_resi_allsubj,Vivid_rating_tstat_resi);
end
save("Residual image based MLR Arousal EEG - Vivid subjective rating.- 31 channel individual beta.mat","Vivid_rating_P_resi_allsubj","Vivid_rating_beta_resi_allsubj");

end



