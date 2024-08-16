

%% Load behavior data, color gamut and repetition mean data
addpath /Users/changhyunlim/Desktop/LG_display/EEG/EEG_data/EEG_realpilot/Behavior_data
file_Path='/Users/changhyunlim/Desktop/LG_display/EEG/eeglab2023.0/AI_EEG';
New_behavior_allsubj=[];
EEG_behavior_allsubj=[];
nan_num_all=[];
for subj=1:19
    if subj == 2 || subj == 10
        continue
    end
%     sub = subj;
%     if subj>=3
%         sub = subj-1;
%     end
%     if subj>=11
%         sub = subj-2;
%     end
    
    filename=['vivid',num2str(subj),'_artifactepoch_baselinepeak_remove'];
    EEG = pop_loadset('filename',[filename,'.set'],'filepath',file_Path);
    EEG_vivid = EEG.data;
    
    filename=['valence',num2str(subj),'_artifactepoch_baselinepeak_remove'];
    EEG = pop_loadset('filename',[filename,'.set'],'filepath',file_Path);
    EEG_valence = EEG.data;
    
    filename=['arousal',num2str(subj),'_artifactepoch_baselinepeak_remove'];
    EEG = pop_loadset('filename',[filename,'.set'],'filepath',file_Path);
    EEG_arousal = EEG.data;
    
    EEG_blocks=cat(3,EEG_vivid,EEG_valence,EEG_arousal);
    
    load("Ancova_used_data"+num2str(subj)+".mat")
    Behavior = table2array(Ancova_data(:,1:9));
    New_behavior = zeros(1512/4,7);
    EEG_behavior = zeros(31,500,1512/4);
    for row = 1:42
        vi_off=find(Behavior(:,6) == IAPS_num(row,1) & Behavior(:,4) == 1 & Behavior(:,9) == 1);
        vi_low=find(Behavior(:,6) == IAPS_num(row,1) & Behavior(:,4) == 2 & Behavior(:,9) == 1);
        vi_high=find(Behavior(:,6) == IAPS_num(row,1) & Behavior(:,4) == 3 & Behavior(:,9) == 1);
        
        val_off=find(Behavior(:,6) == IAPS_num(row,1) & Behavior(:,4) ==1 & Behavior(:,9) == 2);
        val_low=find(Behavior(:,6) == IAPS_num(row,1) & Behavior(:,4) ==2 & Behavior(:,9) == 2);
        val_high=find(Behavior(:,6) == IAPS_num(row,1) & Behavior(:,4) ==3 & Behavior(:,9) == 2);
        
        aro_off=find(Behavior(:,6) == IAPS_num(row,1) & Behavior(:,4) ==1 & Behavior(:,9) == 3);
        aro_low=find(Behavior(:,6) == IAPS_num(row,1) & Behavior(:,4) ==2 & Behavior(:,9) == 3);
        aro_high=find(Behavior(:,6) == IAPS_num(row,1) & Behavior(:,4) ==3 & Behavior(:,9) == 3);
        
        
        
        New_behavior(9*(row-1)+1,:) = mean(Behavior(vi_off,[2:4 6:9]));
        New_behavior(9*(row-1)+2,:) = mean(Behavior(vi_low,[2:4 6:9]));
        New_behavior(9*(row-1)+3,:) = mean(Behavior(vi_high,[2:4 6:9]));
        New_behavior(9*(row-1)+4,:) = mean(Behavior(val_off,[2:4 6:9]));
        New_behavior(9*(row-1)+5,:) = mean(Behavior(val_low,[2:4 6:9]));
        New_behavior(9*(row-1)+6,:) = mean(Behavior(val_high,[2:4 6:9]));
        New_behavior(9*(row-1)+7,:) = mean(Behavior(aro_off,[2:4 6:9]));
        New_behavior(9*(row-1)+8,:) = mean(Behavior(aro_low,[2:4 6:9]));
        New_behavior(9*(row-1)+9,:) = mean(Behavior(aro_high,[2:4 6:9]));
        for ch=1:31
            for timepoint = 1:750
                
                EEG_behavior(ch,timepoint,9*(row-1)+1) = mean(EEG_blocks(ch,timepoint,vi_off),3,'omitnan');
                EEG_behavior(ch,timepoint,9*(row-1)+2) = mean(EEG_blocks(ch,timepoint,vi_low),3,'omitnan');
                EEG_behavior(ch,timepoint,9*(row-1)+3) = mean(EEG_blocks(ch,timepoint,vi_high),3,'omitnan');
                EEG_behavior(ch,timepoint,9*(row-1)+4) = mean(EEG_blocks(ch,timepoint,val_off),3,'omitnan');
                EEG_behavior(ch,timepoint,9*(row-1)+5) = mean(EEG_blocks(ch,timepoint,val_low),3,'omitnan');
                EEG_behavior(ch,timepoint,9*(row-1)+6) = mean(EEG_blocks(ch,timepoint,val_high),3,'omitnan');
                EEG_behavior(ch,timepoint,9*(row-1)+7) = mean(EEG_blocks(ch,timepoint,aro_off),3,'omitnan');
                EEG_behavior(ch,timepoint,9*(row-1)+8) = mean(EEG_blocks(ch,timepoint,aro_low),3,'omitnan');
                EEG_behavior(ch,timepoint,9*(row-1)+9) = mean(EEG_blocks(ch,timepoint,aro_high),3,'omitnan');
                %Rating Valence Whiteboost IAPS Valence Arousal Block
                %New_behavior(:,10) = EEG_behavior(ch,timepoint,:);
            end
        end
        nan_num = sum(sum(sum(isnan(EEG_behavior))));
    end
    New_behavior_allsubj = [New_behavior_allsubj ; New_behavior];
    EEG_behavior_allsubj = cat(3,EEG_behavior_allsubj,EEG_behavior);
    nan_num_all =[nan_num_all;nan_num];
end
% EEG_behavior nan data fill up with adjacent channel


%31 x 750 x 1512/4 x 17. 특정 ch,timepoint일 때마다 데이터를 불러와서 y값으로 받으면 되지.
subj_array_all=[];
for subj=1:17
    subj_array = ones(378,1)*subj;
    subj_array_all=[subj_array_all;subj_array];
end
New_behavior_allsubj(:,8) = subj_array_all;

% For eliminating nan data
CH_adjacent = transpose([3 29 7 6 4 4 3 7 10 9 8 8 14 13 14 17 16 17 13 19 26 20 24 23 27 25 26 30 29 29 1]);
for ch=1:31
    for timepoint=1:750
        for trial=1:size(EEG_behavior_allsubj,3)
            if isnan(EEG_behavior_allsubj(ch,timepoint,trial))
                EEG_behavior_allsubj(ch,timepoint,trial) = EEG_behavior_allsubj(CH_adjacent(ch),timepoint,trial);
                if isnan(EEG_behavior_allsubj(CH_adjacent(ch),timepoint,trial))
                    EEG_behavior_allsubj(ch,timepoint,trial) = EEG_behavior_allsubj(CH_adjacent(ch)-1,timepoint,trial);
                end
            
            end
        end
    end
end


T1 = array2table(New_behavior_allsubj, 'VariableNames', {'rating', 'valence', 'whiteboost','Image number','Valence','Arousal','Block','subj'});

%save("Ancova_allsubj_data","New_behavior_allsubj","EEG_behavior_allsubj")

save("Ancova_allsubj_data_nanmean","New_behavior_allsubj","EEG_behavior_allsubj")

%data for cluster based permutation test 
Ancova_permu_WB_all = [];
for permu = 1:10
    load("Ancova_resampling_100times_"+num2str(permu)+".mat")
    Ancova_Vector = Ancova_statistics.F_val_wb_all;
    
    Ancova_permu_WB = reshape(Ancova_Vector, [num_ch, num_timepoint, num_iter]);
    Ancova_permu_WB_all = cat(3,Ancova_permu_WB_all,Ancova_permu_WB);
end
save("Ancova_1000permutation_WB_all.mat","Ancova_permu_WB_all")
