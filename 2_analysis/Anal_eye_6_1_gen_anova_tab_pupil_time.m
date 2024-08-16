clear
clc

%%
load('pupilTimeTab.mat')
metricTab = pupilTimeTab;
clear puptilTimeTab
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

        tmp = nanmean(metricTab{idx, 9:end},1);
        
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
evTab.Properties.VariableNames(1:5) = {'sub', 'task', 'valence', 'arousal','white_boost'};



%% save
writetable(evTab, 'pupilTimeTab_1_all_task.csv')
