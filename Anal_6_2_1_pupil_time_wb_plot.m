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
figure('position', [0 0 300 200]);
xpts = 1:1501;

colors(1,:) = [127 127 127]/255;
colors(2,:) = [255 192 0]/255;
colors(3,:) = [1 0 0];

color_txt{1} =  'k'; %'-k';
color_txt{2} =  'k'; %'-b';
color_txt{3} =  'k'; %'-m';

plot([min(xpts) max(xpts)]/1000, [0 0], '--', 'color', [.5 .5 .5]); hold on

for w = 1:length(wList)
    k = shadedErrorBar(xpts/1000, evMeanTab{wList(w), xpts+1}, evSeTab{wList(w), xpts+1},...
        'lineProps', color_txt{wList(w)}, 'patchSaturation', 0.08, 'transparent', true); hold on
    set(k.edge,'Color',[1 1 1])
    h{w} = plot(xpts/1000, evMeanTab{wList(w), xpts+1}, 'color', colors(wList(w),:), 'LineWidth', 2); hold on
end

p_idx1 = pTab.P_wb<0.05;
p_idx2 = pTab.P_wb<0.01;
p_idx3 = pTab.P_wb<0.001;

min_val = min(find(p_idx1==1));
max_val = max(find(p_idx1==1));

plot([min_val max_val]/1000,[-0.47  -0.47], 'color', [0 0 0], 'MarkerSize', 5, 'LineWidth', 2);
%plot(xpts(p_idx2)/1000, -0.47, '.', 'color', [.5 .5 .5], 'MarkerSize', 5);
%plot(xpts(p_idx3)/1000, -0.47, '.', 'color', [1 0 0], 'MarkerSize', 5);

box off
xlabel('Time (s)')
xlim([min(xpts), max(xpts)]/1000)
ylabel('Pupil Diameter (A.U.)')
ylim([-0.52 0.1])

%legend([h{1},h{2},h{3}], {'Off', 'Midium', 'Strong'})