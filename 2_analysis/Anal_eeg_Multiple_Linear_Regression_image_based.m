function MLR_image_based(workpath,subj)

load("Image unit based behavior and EEG data for all subject.mat")%Figures_0828/Multiple_linear_regression/image based MLR
Vivid_rating_P_allsubj=[];
Vivid_rating_beta_allsubj=[];
Vivid_rating_tstat_allsubj=[];
Arousal_rating_P_allsubj=[];
Arousal_rating_beta_allsubj=[];
Arousal_rating_tstat_allsubj=[];
Valence_rating_P_allsubj=[];
Valence_rating_beta_allsubj=[];
Valence_rating_tstat_allsubj=[];
for subj=1:18
P_vivid_ch_time=[];
beta_vivid_ch_time=[];
tstat_vivid_ch_time=[];

for ch=1:31 %FC2 C4 CP2
    P_vivid_time=[];
    beta_vivid_time=[];
    tstat_vivid_time=[];
    y1=[];
    P_vivid_time=[];
    beta_vivid_time=[];
    tstat_vivid_time=[];
    for timepoint = 1:750
      trials = [42*subj-41:42*subj];
        x1 = zscore(image_unit_rating_vi_allsubj(1:42,subj));%4536 x 1
        x2 = zscore(image_unit_rating_val_allsubj(1:42,subj));%4536 x 1
        x3 = zscore(image_unit_rating_aro_allsubj(1:42,subj));%4536 x 1
        E1 = permute(image_unit_EEG_vi_allsubj(ch,timepoint,trials),[3 1 2]); % 여기만 바꾸면 됨
        NaN_loc = find(isnan(E1));
        E1(NaN_loc) = [];
        x1(NaN_loc) = []; x2(NaN_loc) = []; x3(NaN_loc) = [];
        y1 = zscore(E1);    
        lm = fitlm([x1 x2 x3], y1); %  
        Beta_vivid = table2array(lm.Coefficients(:,1));                
        P_vivid = table2array(lm.Coefficients(:,4));
        tstat_vivid = table2array(lm.Coefficients(:,3));
        P_vivid_time=[P_vivid_time,P_vivid];
        beta_vivid_time=[beta_vivid_time,Beta_vivid];
        tstat_vivid_time=[tstat_vivid_time,tstat_vivid];       
    end                

    %y1 = permute(y1(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750); %y1 = Reflect Arousal and Valence prediction to vivid EEG
    %y2 = permute(z2(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    
    %y3 = permute(z3(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    

    P_vivid_ch_time = cat(3,P_vivid_ch_time,P_vivid_time);
    beta_vivid_ch_time = cat(3,beta_vivid_ch_time,beta_vivid_time);
    tstat_vivid_ch_time = cat(3,tstat_vivid_ch_time,tstat_vivid_time);
end
Vivid_rating_P = P_vivid_ch_time(2,:,:);
Vivid_rating_beta = beta_vivid_ch_time(2,:,:); % block,timepoint,channel
Vivid_rating_tstat = tstat_vivid_ch_time(2,:,:); % block,timepoint,channel

Arousal_rating_P = P_vivid_ch_time(3,:,:);
Arousal_rating_beta = beta_vivid_ch_time(3,:,:); % block,timepoint,channel
Arousal_rating_tstat = tstat_vivid_ch_time(3,:,:); % block,timepoint,channel

Valence_rating_P = P_vivid_ch_time(4,:,:);
Valence_rating_beta = beta_vivid_ch_time(4,:,:); % block,timepoint,channel
Valence_rating_tstat = tstat_vivid_ch_time(4,:,:); % block,timepoint,channel

%Change the dimension to channel x timepoint x subj
Vivid_rating_P = permute(Vivid_rating_P,[3 2 1]);
Vivid_rating_beta = permute(Vivid_rating_beta,[3 2 1]);
Vivid_rating_tstat = permute(Vivid_rating_tstat,[3 2 1]);

Arousal_rating_P = permute(Arousal_rating_P,[3 2 1]);
Arousal_rating_beta = permute(Arousal_rating_beta,[3 2 1]);
Arousal_rating_tstat = permute(Arousal_rating_tstat,[3 2 1]);

Valence_rating_P = permute(Valence_rating_P,[3 2 1]);
Valence_rating_beta = permute(Valence_rating_beta,[3 2 1]);
Valence_rating_tstat = permute(Valence_rating_tstat,[3 2 1]);

%Accumulate data for all subj
Vivid_rating_P_allsubj = cat(3,Vivid_rating_P_allsubj,Vivid_rating_P);
Vivid_rating_beta_allsubj = cat(3,Vivid_rating_beta_allsubj,Vivid_rating_beta);
Vivid_rating_tstat_allsubj = cat(3,Vivid_rating_tstat_allsubj,Vivid_rating_tstat);

Arousal_rating_P_allsubj = cat(3,Arousal_rating_P_allsubj,Arousal_rating_P);
Arousal_rating_beta_allsubj = cat(3,Arousal_rating_beta_allsubj,Arousal_rating_beta);
Arousal_rating_tstat_allsubj = cat(3,Arousal_rating_tstat_allsubj,Arousal_rating_tstat);

Valence_rating_P_allsubj = cat(3,Valence_rating_P_allsubj,Valence_rating_P);
Valence_rating_beta_allsubj = cat(3,Valence_rating_beta_allsubj,Valence_rating_beta);
Valence_rating_tstat_allsubj = cat(3,Valence_rating_tstat_allsubj,Valence_rating_tstat);
end
save("MLR image based Vividness EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat","Vivid_rating_P_allsubj","Vivid_rating_beta_allsubj",...
"Vivid_rating_tstat_allsubj","Arousal_rating_P_allsubj","Arousal_rating_beta_allsubj","Arousal_rating_tstat_allsubj",...
"Valence_rating_P_allsubj","Valence_rating_beta_allsubj","Valence_rating_tstat_allsubj");


Vivid_rating_P_allsubj=[];
Vivid_rating_beta_allsubj=[];
Vivid_rating_tstat_allsubj=[];
Arousal_rating_P_allsubj=[];
Arousal_rating_beta_allsubj=[];
Arousal_rating_tstat_allsubj=[];
Valence_rating_P_allsubj=[];
Valence_rating_beta_allsubj=[];
Valence_rating_tstat_allsubj=[];
for subj=1:18
P_vivid_ch_time=[];
beta_vivid_ch_time=[];
tstat_vivid_ch_time=[];

for ch=1:31 %FC2 C4 CP2
    P_vivid_time=[];
    beta_vivid_time=[];
    tstat_vivid_time=[];
    y1=[];
    P_vivid_time=[];
    beta_vivid_time=[];
    tstat_vivid_time=[];
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
        lm = fitlm([x1 x2 x3], y1); %  y1 ~ B1 * Arousal + B1 * Valence 
        Beta_vivid = table2array(lm.Coefficients(:,1));                
        P_vivid = table2array(lm.Coefficients(:,4));
        tstat_vivid = table2array(lm.Coefficients(:,3));
        P_vivid_time=[P_vivid_time,P_vivid];
        beta_vivid_time=[beta_vivid_time,Beta_vivid];
        tstat_vivid_time=[tstat_vivid_time,tstat_vivid];       
    end                

    %y1 = permute(y1(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750); %y1 = Reflect Arousal and Valence prediction to vivid EEG
    %y2 = permute(z2(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    
    %y3 = permute(z3(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    

    P_vivid_ch_time = cat(3,P_vivid_ch_time,P_vivid_time);
    beta_vivid_ch_time = cat(3,beta_vivid_ch_time,beta_vivid_time);
    tstat_vivid_ch_time = cat(3,tstat_vivid_ch_time,tstat_vivid_time);
end
Vivid_rating_P = P_vivid_ch_time(2,:,:);
Vivid_rating_beta = beta_vivid_ch_time(2,:,:); % block,timepoint,channel
Vivid_rating_tstat = tstat_vivid_ch_time(2,:,:); % block,timepoint,channel

Arousal_rating_P = P_vivid_ch_time(3,:,:);
Arousal_rating_beta = beta_vivid_ch_time(3,:,:); % block,timepoint,channel
Arousal_rating_tstat = tstat_vivid_ch_time(3,:,:); % block,timepoint,channel

Valence_rating_P = P_vivid_ch_time(4,:,:);
Valence_rating_beta = beta_vivid_ch_time(4,:,:); % block,timepoint,channel
Valence_rating_tstat = tstat_vivid_ch_time(4,:,:); % block,timepoint,channel

%Change the dimension to channel x timepoint x subj
Vivid_rating_P = permute(Vivid_rating_P,[3 2 1]);
Vivid_rating_beta = permute(Vivid_rating_beta,[3 2 1]);
Vivid_rating_tstat = permute(Vivid_rating_tstat,[3 2 1]);

Arousal_rating_P = permute(Arousal_rating_P,[3 2 1]);
Arousal_rating_beta = permute(Arousal_rating_beta,[3 2 1]);
Arousal_rating_tstat = permute(Arousal_rating_tstat,[3 2 1]);

Valence_rating_P = permute(Valence_rating_P,[3 2 1]);
Valence_rating_beta = permute(Valence_rating_beta,[3 2 1]);
Valence_rating_tstat = permute(Valence_rating_tstat,[3 2 1]);

%Accumulate data for all subj
Vivid_rating_P_allsubj = cat(3,Vivid_rating_P_allsubj,Vivid_rating_P);
Vivid_rating_beta_allsubj = cat(3,Vivid_rating_beta_allsubj,Vivid_rating_beta);
Vivid_rating_tstat_allsubj = cat(3,Vivid_rating_tstat_allsubj,Vivid_rating_tstat);

Arousal_rating_P_allsubj = cat(3,Arousal_rating_P_allsubj,Arousal_rating_P);
Arousal_rating_beta_allsubj = cat(3,Arousal_rating_beta_allsubj,Arousal_rating_beta);
Arousal_rating_tstat_allsubj = cat(3,Arousal_rating_tstat_allsubj,Arousal_rating_tstat);

Valence_rating_P_allsubj = cat(3,Valence_rating_P_allsubj,Valence_rating_P);
Valence_rating_beta_allsubj = cat(3,Valence_rating_beta_allsubj,Valence_rating_beta);
Valence_rating_tstat_allsubj = cat(3,Valence_rating_tstat_allsubj,Valence_rating_tstat);
end
save("MLR image based Valence EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat","Vivid_rating_P_allsubj","Vivid_rating_beta_allsubj","Vivid_rating_tstat_allsubj","Arousal_rating_P_allsubj","Arousal_rating_beta_allsubj","Arousal_rating_tstat_allsubj","Valence_rating_P_allsubj","Valence_rating_beta_allsubj","Valence_rating_tstat_allsubj");











Vivid_rating_P_allsubj=[];
Vivid_rating_beta_allsubj=[];
Vivid_rating_tstat_allsubj=[];
Arousal_rating_P_allsubj=[];
Arousal_rating_beta_allsubj=[];
Arousal_rating_tstat_allsubj=[];
Valence_rating_P_allsubj=[];
Valence_rating_beta_allsubj=[];
Valence_rating_tstat_allsubj=[];
for subj=1:18
P_vivid_ch_time=[];
beta_vivid_ch_time=[];
tstat_vivid_ch_time=[];

for ch=1:31 %FC2 C4 CP2
    P_vivid_time=[];
    beta_vivid_time=[];
    tstat_vivid_time=[];
    y1=[];
    P_vivid_time=[];
    beta_vivid_time=[];
    tstat_vivid_time=[];
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
        lm = fitlm([x1 x2 x3], y1); %  y1 ~ B1 * Arousal + B1 * Valence 
        Beta_vivid = table2array(lm.Coefficients(:,1));                
        P_vivid = table2array(lm.Coefficients(:,4));
        tstat_vivid = table2array(lm.Coefficients(:,3));
        P_vivid_time=[P_vivid_time,P_vivid];
        beta_vivid_time=[beta_vivid_time,Beta_vivid];
        tstat_vivid_time=[tstat_vivid_time,tstat_vivid];       
    end                

    %y1 = permute(y1(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750); %y1 = Reflect Arousal and Valence prediction to vivid EEG
    %y2 = permute(z2(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    
    %y3 = permute(z3(ch,1:750,:),[3 2 1]) - x2.* beta_vivid_time(2,1:750) - x3.*beta_vivid_time(3,1:750);    

    P_vivid_ch_time = cat(3,P_vivid_ch_time,P_vivid_time);
    beta_vivid_ch_time = cat(3,beta_vivid_ch_time,beta_vivid_time);
    tstat_vivid_ch_time = cat(3,tstat_vivid_ch_time,tstat_vivid_time);
end
Vivid_rating_P = P_vivid_ch_time(2,:,:);
Vivid_rating_beta = beta_vivid_ch_time(2,:,:); % block,timepoint,channel
Vivid_rating_tstat = tstat_vivid_ch_time(2,:,:); % block,timepoint,channel

Arousal_rating_P = P_vivid_ch_time(3,:,:);
Arousal_rating_beta = beta_vivid_ch_time(3,:,:); % block,timepoint,channel
Arousal_rating_tstat = tstat_vivid_ch_time(3,:,:); % block,timepoint,channel

Valence_rating_P = P_vivid_ch_time(4,:,:);
Valence_rating_beta = beta_vivid_ch_time(4,:,:); % block,timepoint,channel
Valence_rating_tstat = tstat_vivid_ch_time(4,:,:); % block,timepoint,channel

%Change the dimension to channel x timepoint x subj
Vivid_rating_P = permute(Vivid_rating_P,[3 2 1]);
Vivid_rating_beta = permute(Vivid_rating_beta,[3 2 1]);
Vivid_rating_tstat = permute(Vivid_rating_tstat,[3 2 1]);

Arousal_rating_P = permute(Arousal_rating_P,[3 2 1]);
Arousal_rating_beta = permute(Arousal_rating_beta,[3 2 1]);
Arousal_rating_tstat = permute(Arousal_rating_tstat,[3 2 1]);

Valence_rating_P = permute(Valence_rating_P,[3 2 1]);
Valence_rating_beta = permute(Valence_rating_beta,[3 2 1]);
Valence_rating_tstat = permute(Valence_rating_tstat,[3 2 1]);

%Accumulate data for all subj
Vivid_rating_P_allsubj = cat(3,Vivid_rating_P_allsubj,Vivid_rating_P);
Vivid_rating_beta_allsubj = cat(3,Vivid_rating_beta_allsubj,Vivid_rating_beta);
Vivid_rating_tstat_allsubj = cat(3,Vivid_rating_tstat_allsubj,Vivid_rating_tstat);

Arousal_rating_P_allsubj = cat(3,Arousal_rating_P_allsubj,Arousal_rating_P);
Arousal_rating_beta_allsubj = cat(3,Arousal_rating_beta_allsubj,Arousal_rating_beta);
Arousal_rating_tstat_allsubj = cat(3,Arousal_rating_tstat_allsubj,Arousal_rating_tstat);

Valence_rating_P_allsubj = cat(3,Valence_rating_P_allsubj,Valence_rating_P);
Valence_rating_beta_allsubj = cat(3,Valence_rating_beta_allsubj,Valence_rating_beta);
Valence_rating_tstat_allsubj = cat(3,Valence_rating_tstat_allsubj,Valence_rating_tstat);
end
 
save("MLR image based Arousal EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat","Vivid_rating_P_allsubj","Vivid_rating_beta_allsubj",...
"Vivid_rating_tstat_allsubj","Arousal_rating_P_allsubj","Arousal_rating_beta_allsubj","Arousal_rating_tstat_allsubj",...
"Valence_rating_P_allsubj","Valence_rating_beta_allsubj","Valence_rating_tstat_allsubj");
end
