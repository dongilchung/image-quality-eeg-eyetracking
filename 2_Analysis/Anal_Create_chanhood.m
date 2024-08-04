%Create_chan_hood
%F7-FC5: 4-6 F8-FC6:27-30 CP5-P7:11-15 CP6-P8:20-22
connect =[4,6;27,30;11,15;20,22];
chan_hood40_LG = zeros(31,31);
for loc = 1:31
    chan_hood40_LG(loc,loc) = 1;
end

for row = 1:4
    chan_hood40_LG(connect(row,1),connect(row,2)) = 1;
    chan_hood40_LG(connect(row,2),connect(row,1)) = 1;
end
save("chan_hood47_LG_5cm.mat","chan_hood40_LG")

max_dist = 67.2;
chan_hood_7cm=spatial_neighbors(chanlocation,max_dist);


max_dist = 57.2;
chan_hood_6cm=spatial_neighbors(chanlocation,max_dist);

max_dist = 47.7;
chan_hood_5cm=spatial_neighbors(chanlocation,max_dist);
save("chan_hood_LG_5cm.mat","chan_hood_5cm")

max_dist = 40;
chan_hood_40=spatial_neighbors(chanlocation,max_dist);
save("chan_hood_LG_4_17cm.mat","chan_hood_40")




%Create White boosting mat file
addpath /Users/changhyunlim/Desktop/LG_display/EEG/EEG_data/EEG_realpilot/Behavior_data/Behavior_data_analysis/Figures/Figures_0828/Multiple_linear_regression
load("3 Whiteboosting level EEG - Vividness.mat")
Whiteboost_ERP_highoff_difference = IAPS_highboost_all - IAPS_noboost_all;
Whiteboost_ERP_highmid_difference = IAPS_highboost_all - IAPS_midboost_all;
Whiteboost_ERP_midoff_difference = IAPS_midboost_all - IAPS_noboost_all;
save("3 Whiteboosting level difference_vividness.mat","Whiteboost_ERP_highoff_difference","Whiteboost_ERP_highmid_difference","Whiteboost_ERP_midoff_difference")

load("3 Whiteboosting level EEG - Valence.mat")
Whiteboost_ERP_highoff_difference = IAPS_highboost_all - IAPS_noboost_all;
Whiteboost_ERP_highmid_difference = IAPS_highboost_all - IAPS_midboost_all;
Whiteboost_ERP_midoff_difference = IAPS_midboost_all - IAPS_noboost_all;
save("3 Whiteboosting level difference_valence.mat","Whiteboost_ERP_highoff_difference","Whiteboost_ERP_highmid_difference","Whiteboost_ERP_midoff_difference")

load("3 Whiteboosting level EEG - Arousal.mat")
Whiteboost_ERP_highoff_difference = IAPS_highboost_all - IAPS_noboost_all;
Whiteboost_ERP_highmid_difference = IAPS_highboost_all - IAPS_midboost_all;
Whiteboost_ERP_midoff_difference = IAPS_midboost_all - IAPS_noboost_all;
save("3 Whiteboosting level difference_arousal.mat","Whiteboost_ERP_highoff_difference","Whiteboost_ERP_highmid_difference","Whiteboost_ERP_midoff_difference")


[R,P,ci,t] = ttest( IAPS_highboost_all - IAPS_noboost_all);

[R,P,ci,t] = ttest(zscore(IAPS_highboost_all - IAPS_noboost_all));

t_all=[];
for ch=1:31
    t_timepoint=[];
    for timepoint = 1:750
        [R,P,ci,t] = ttest(IAPS_highboost_all(ch,timepoint,:),IAPS_noboost_all(ch,timepoint,:));
        t_timepoint = [t_timepoint,t.tstat];
    end
    t_all = [t_all;t_timepoint];
end
 

t_all=[];
for ch = 1:31
    t_timepoint = [];
    for timepoint = 1:750
        [R,P,ci,t] = ttest(zscore(IAPS_highboost_all(ch,timepoint,:)),zscore(IAPS_noboost_all(ch,timepoint,:)));
        t_timepoint = [t_timepoint,t.tstat];
    end
    t_all = [t_all;t_timepoint];
end

t_all=[];
for ch = 1:31
    t_timepoint = [];
    for timepoint = 1:750
        [R,P,ci,t] = ttest(zscore(IAPS_highboost_all(ch,timepoint,:)),zscore(IAPS_noboost_all(ch,timepoint,:)));
        t_timepoint = [t_timepoint,t.tstat];
    end
    t_all = [t_all;t_timepoint];
end


a=zscore(zscore(IAPS_highboost_all - IAPS_noboost_all);