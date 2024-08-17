clear
clc

%% load
pupTimeTab = readtable('pupilTimeTab_1_all_task.csv');
pTab = readtable('pupTimePtab.xlsx');

sList = [1 3:9 11:19];
wList = unique(pupTimeTab.white_boost)'; % white boosting


%% evTab - wb
evTab = [];

for s = 1:length(sList)
    for w = 1:length(wList)
        idx = pupTimeTab.sub == sList(s) & pupTimeTab.white_boost == wList(w);
        tmp = nanmean(pupTimeTab{idx, 6:end});
        
        evTab = [evTab; sList(s), wList(w), tmp];
    end
end

evTab = array2table(evTab);
evTab.Properties.VariableNames(1:2) = {'sub', 'white_boost'};

%% summary evTab
evMeanTab = [];
for w = 1:length(wList)
    idx = evTab.white_boost == wList(w);
    tmp = nanmean(evTab{idx,3:end});
    
    evMeanTab = [evMeanTab; wList(w) tmp];
end

evMeanTab = array2table(evMeanTab);
evMeanTab.Properties.VariableNames(1) = {'white_boost'};


evSeTab = [];
for w = 1:length(wList)
    idx = evTab.white_boost == wList(w);
    tmp = nanstd(evTab{idx,3:end})/sqrt(sum(idx));
    
    evSeTab = [evSeTab; wList(w) tmp];
end

evSeTab = array2table(evSeTab);
evSeTab.Properties.VariableNames(1) = {'white_boost'};


%% plot
figure('position', [0 0 600 300]);
xpts = 1:1501;

colors(1,:) = [.7 .7 .7];
colors(2,:) = [.4 .4 .4];
colors(3,:) = [0 0 0];

for w = 1:length(wList)
    %shadedErrorBar(xpts, evMeanTab{wList(w), xpts+1}, evSeTab{wList(w), xpts+1}); hold on
    h{w} = plot(xpts, evMeanTab{wList(w), xpts+1}, 'color', colors(wList(w),:)); hold on
end

p_idx = pTab.P_wb<0.05;
plot(xpts(p_idx), -0.4, '.', 'color', [0 0 1], 'MarkerSize', 1);

box off
xlabel('Time (ms)')
xlim([min(xpts), max(xpts)])
ylabel('Pupil Diameter (A.U.)')
ylim([-0.45 0.1])

legend([h{1},h{2},h{3}], {'Off', 'Midium', 'Strong'})
