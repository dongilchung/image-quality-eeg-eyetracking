clear
clc

%%
load('metricTab3_4.mat');
tmp = load('pupilTab.mat');
pupilTab = tmp.metricTab;

metricTab = [metricTab pupilTab(:,2:end)];

imgScoreTab = readtable('image_score.xlsx');

sList = [1 3:9 11:19];
tList = [1 2 3];

imgList = unique(metricTab.IAPS_number)'; % valence
wList = unique(metricTab.white_boosting)'; % white boosting
gList = unique(metricTab.color_gamut)'; % color gamut

%% evtab
evTab = [];
for s = 1:length(sList)
    
    for t = 1:length(tList)
    for i = 1:length(imgList)
    for w = 1:length(wList)

        idx = metricTab.sub == sList(s) & metricTab.task == tList(t) & metricTab.IAPS_number == imgList(i) & metricTab.white_boosting == wList(w);
        if sum(idx) == 0, continue; end

        tmp = nanmean(metricTab{idx, [10:2:15 18 20 23:25]},1);
        
%         for l = 1:length(tmp)
%             if isnan(tmp(l))
%                 tmp(l) = nanmean(metricTab{idx,(2*l-1)+10});
%             end
%         end
        
        score_idx = imgScoreTab.IAPSNumber == imgList(i);
        curr_valence = imgScoreTab.Valence(score_idx);
        curr_arousal = imgScoreTab.Arousal(score_idx);
        evTab = [evTab; sList(s) tList(t) curr_valence curr_arousal wList(w) tmp];

    end
    end
    end

end

evTab = array2table(evTab);
evTab.Properties.VariableNames = {'sub', 'task', 'valence', 'arousal','white_boost', ...
    'SaccRate', 'SaccDur', 'SaccPvel', 'BlinkRate', 'BlinkDur',...
    'MeanPupDiam', 'PeakPupDiam', 'VarPupDiam'};


%% adjust nan values
evTab.SaccDur(isnan(evTab.SaccDur)) = 0;
evTab.SaccPvel(isnan(evTab.SaccPvel)) = 0;
evTab.BlinkDur(isnan(evTab.BlinkDur)) = 0;

%% save
writetable(evTab, 'evTab_4_all_tasks.csv')

% evTab_vivid = evTab(evTab.task == 1,:);
% writetable(evTab_vivid, 'evTab_2_vivid_task.csv')
% 
% evTab_arousal = evTab(evTab.task == 2,:);
% writetable(evTab_arousal, 'evTab_2_arousal_task.csv')
% 
% evTab_valence = evTab(evTab.task == 3,:);
% writetable(evTab_valence, 'evTab_2_valence_task.csv')


