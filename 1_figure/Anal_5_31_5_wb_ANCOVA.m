clear
clc


%%
load('metricTab3_4.mat');
tmp = load('pupilTab.mat');
pupilTab = tmp.metricTab;

metricTab = [metricTab pupilTab(:,2:end)];

sList = [1 3:9 11:19];

vList = unique(metricTab.valence)'; % valence
wList = unique(metricTab.white_boosting)'; % white boosting
cList = unique(metricTab.color_gamut)'; % color_gamut





%% evTab
evTab = [];
for s = 1:length(sList)
    
    for w = 1:length(wList)

        idx = metricTab.sub == sList(s) & metricTab.white_boosting == wList(w);
        if sum(idx) == 0, continue; end

        tmp = nanmean(metricTab{idx, [10:2:15 18 20 23:25]},1);

        evTab = [evTab; sList(s) wList(w) tmp];

    end

end

evTab = array2table(evTab);
evTab.Properties.VariableNames = {'sub','white_boost', ...
    'SaccRate', 'SaccDur', 'SaccPvel', 'BlinkRate', 'BlinkDur',...
    'MeanPupDiam', 'PeakPupDiam', 'VarPupDiam'};


%% evTab summary
evMeanTab = [];
for w = 1:length(wList)

    idx = evTab.white_boost == wList(w);
    if sum(idx) == 0, continue; end

    tmp = nanmean(evTab{idx, 3:end},1);

    evMeanTab = [evMeanTab; wList(w) tmp];

end

evMeanTab = array2table(evMeanTab);
evMeanTab.Properties.VariableNames = {'white_boost', ...
    'SaccRate', 'SaccDur', 'SaccPvel', 'BlinkRate', 'BlinkDur',...
    'MeanPupDiam', 'PeakPupDiam', 'VarPupDiam'};



evSteTab = [];
for w = 1:length(wList)

    idx = evTab.white_boost == wList(w);
    if sum(idx) == 0, continue; end

    tmp = nanstd(evTab{idx, 3:end},0,1)/sqrt(nansum(idx));

    evSteTab = [evSteTab; wList(w) tmp];

end

evSteTab = array2table(evSteTab);
evSteTab.Properties.VariableNames = {'white_boost', ...
    'SaccRate', 'SaccDur', 'SaccPvel', 'BlinkRate', 'BlinkDur',...
    'MeanPupDiam', 'PeakPupDiam', 'VarPupDiam'};


%% plot
varList = evTab.Properties.VariableNames(3:end);
var_ylabels = {'Saccade Frequency', 'Saccade Duration', 'Saccade Peak Velocity', ...
    'Blink Frequency', 'Blink Duration', ...
     'Mean Pupil Diameter', 'Peak Pupil Diameter', 'Var. of Pupil Diameter'};
var_units = {'(/s)','(ms)','(\circ/s)','(/s)','(ms)','(A.U.)', '(A.U.)', '(A.U.)'};
xpts = unique(evMeanTab.white_boost)';

var_ylims = {[1.3 1.8], [20 70], [90 150], [0.35 0.8], [140 220], [-0.3 0], [0.15 0.35], [0.05 0.18]};

color_grey = [.3 .3 .3];
color_grey_indiv = [.6 .6 .6];

color_full = [1 .3 .3];
color_srgb = [.5 .5 .5];

color_full_indiv = [1 .6 .6];
color_srgb_indiv = [.7 .7 .7];

color_positive = [.3 .7 .3];
color_neutral = [1 .8 .3];
color_negative = [1 .4 .3];

color_positive_indiv = [.5 .7 .5];
color_neutral_indiv = [1 .8 .5];
color_negative_indiv = [1 .4 .5];


for v = [1 2 3 4 5 6]
    figure('position',[0 0 200 200]);
    
%     for s = 1:length(sList)
%         idx_indiv = evTab.sub == sList(s);
%         plot(xpts, evTab.(varList{v})(idx_indiv), '.:', 'color', color_grey_indiv, 'MarkerSize', 10, 'LineWidth', 0.8); hold on;
%     end
%     
    errbar(xpts, evMeanTab.(varList{v}), evSteTab.(varList{v}), 'color', [0 0 0],'linewidth', 0.5); hold on;
    h_positive = plot(xpts, evMeanTab.(varList{v}), '.-', 'color', [0 0 0], 'MarkerSize', 15, 'LineWidth', 1.75); hold on;
    %plot(xpts, evMeanTab.(varList{v}), '.', 'color', [1 1 1], 'MarkerSize', 25); hold on;
    
    
    xlim([0.5 3.5]);
    xticks([1 2 3]);
    xticklabels({'Off', 'Low', 'High'});
    xlabel(['White Booste Mode'])
    ylabel([var_ylabels{v} ' ' var_units{v}])
    ylim(var_ylims{v})
    
    box off;
    
    saveas(gcf,[pwd filesep 'Fig_Main_effects' filesep 'wb_' num2str(v) '_' varList{v} '.pdf'])
    close
end
