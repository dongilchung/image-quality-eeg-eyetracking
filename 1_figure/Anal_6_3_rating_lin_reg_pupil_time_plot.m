clc
clear

%% load
load('pupilTime_reg.mat')

%%
load('metricTab3_4.mat');
tmp = load('pupilTab.mat');
pupilTab = tmp.metricTab;

metricTab = [metricTab pupilTab(:,2:end)];

sList = [1 3:9 11:19];
tList = [1 2 3]; % vi ar val

vList = unique(metricTab.valence)'; % valence
wList = unique(metricTab.white_boosting)'; % white boosting
cList = unique(metricTab.color_gamut)';

target_varname = 'white_boosting';
target_list = vList;

%% add response class column
rList = [1 2 3];
imgList = unique(metricTab.IAPS_number)';

ratingTab = [];
metricTab.rating_class(:) = 2;
for s = 1:length(sList)
    for i = 1:length(imgList)
        idx = metricTab.sub == sList(s) & metricTab.task == tList(1) & metricTab.IAPS_number == imgList(i);
        
        ratingTab = [ratingTab; sList(s) imgList(i) mean(metricTab.rating(idx))];
        
    end
end

ratingTab = array2table(ratingTab);
ratingTab.Properties.VariableNames = {'sub', 'IAPS_number', 'rating'};

ratingTab.rating_class(:) = 2;
for s = 1:length(sList)
    idx = ratingTab.sub == sList(s);
    class_bnd = [quantile(ratingTab.rating(idx), 2/3) quantile(ratingTab.rating(idx), 1/3)];
     
    idx_tmp = ratingTab.rating >= class_bnd(1);
    ratingTab.rating_class(idx&idx_tmp) = 3;

    idx_tmp = ratingTab.rating < class_bnd(2);
    ratingTab.rating_class(idx&idx_tmp) = 1;
end

metricTab.rating_class = zeros(height(metricTab),1);
for s = 1:length(sList)
    for i = 1:length(imgList)
        idx = metricTab.sub == sList(s) & metricTab.IAPS_number == imgList(i);
        idx_rating = ratingTab.sub == sList(s) & ratingTab.IAPS_number == imgList(i);
        metricTab.rating_class(idx) = ratingTab.rating_class(idx_rating);
    end
end


%% subTab = subjective dull/mid/vivid stim
subTab = [];

ratingList = 1:3;
for s  = 1:length(sList)
for r = 1:length(ratingList)
    idx = ratingTab.sub == sList(s) & ratingTab.rating_class == ratingList(r);
    tmp = nanmean(regdatTab_vi{idx, 5:end},1);
    subTab = [subTab; sList(s) ratingList(r) tmp];
end
end

subTab = array2table(subTab);
subTab.Properties.VariableNames(1:2) = {'sub', 'class'};

%% sub mean tab
subMeanTab = [];
for r = 1:length(ratingList)
    idx = subTab.class == ratingList(r);
    tmp = nanmean(subTab{idx,3:end});
    subMeanTab = [subMeanTab; ratingList(r) tmp];
end

subMeanTab = array2table(subMeanTab);
subMeanTab.Properties.VariableNames(1) = {'sub'};

subSteTab = [];
for r = 1:length(ratingList)
    idx = subTab.class == ratingList(r);
    tmp = nanstd(subTab{idx,3:end})/sqrt(sum(idx));
    subSteTab = [subSteTab; ratingList(r) tmp];
end

subSteTab = array2table(subSteTab);
subSteTab.Properties.VariableNames(1) = {'sub'};

%% plot
figure('position', [0 0 300 200]);
xpts = 1:1501;

% color_rating_class{1} = [53 134 187]/255;
% color_rating_class{2} = [252 225 99]/255;
% color_rating_class{3} = [208 67 76]/255;

color_rating_class{1} = [203 207 246]/255;
color_rating_class{2} = [120 157 251]/255;
color_rating_class{3} = [0 0 255]/255;

color_txt{1} =  'k'; %'-b';
color_txt{2} =  'k'; %'-y';
color_txt{3} =  'k'; %'-r';

plot([min(xpts) max(xpts)]/1000, [0 0], ':', 'color', [.5 .5 .5]); hold on

for r = 1:length(ratingList)
    k = shadedErrorBar(xpts/1000, subMeanTab{r, xpts+1}, subSteTab{r, xpts+1},...
        'lineProps', {color_txt{r}}, 'patchSaturation', 0.08, 'transparent', true); hold on
    set(k.edge,'Color',[1 1 1])
    h{r} = plot(xpts/1000, subMeanTab{r, xpts+1}, 'color', color_rating_class{r}, 'LineWidth', 2); hold on
end


box off
xlabel('Time (s)')
xlim([min(xpts), max(xpts)]/1000)
ylabel('Pupil Diameter (A.U.)')
ylim([-0.6 0.3])

%legend([h{1},h{2},h{3}], {'Dim', 'Mid', 'Vivid'})

%% regMeanTab_vi
regMeanTab_vi = [];
varList = 5:1505;
for t = 1:length(varList)
    idx = regTab_vi.var == varList(t);
    tmp = nanmean(regTab_vi{idx, 4:6},1);
    regMeanTab_vi = [regMeanTab_vi; t tmp];
end

regMeanTab_vi = array2table(regMeanTab_vi);
regMeanTab_vi.Properties.VariableNames = {'t', 'beta_vi', 'beta_ar', 'beta_va'};

regSteTab_vi = [];
varList = 5:1505;
for t = 1:length(varList)
    idx = regTab_vi.var == varList(t);
    tmp = nanstd(regTab_vi{idx, 4:6},1)/sqrt(sum(idx));
    regSteTab_vi = [regSteTab_vi; t tmp];
end

regSteTab_vi = array2table(regSteTab_vi);
regSteTab_vi.Properties.VariableNames = {'t', 'beta_vi', 'beta_ar', 'beta_va'};

%% plot for betas - vividness pupil
% colors{1} = [0 0 0]/255;
% colors{2} = [14 31 87]/255;
% colors{3} = [122 0 11]/255;

colors{1} = [20 31 120]/255;
colors{2} = [13 70 40]/255;
colors{3} = [122 0 11]/255;

% vividness ratings
figure('position', [0 0 300 200]);

plot([min(xpts) max(xpts)]/1000, [0 0], '--', 'color', [.5 .5 .5]); hold on
k = shadedErrorBar(regMeanTab_vi.t/1000, regMeanTab_vi.beta_vi, regSteTab_vi.beta_vi, ...
    'lineProps', 'k',  'patchSaturation', 0.1, 'transparent', true);
set(k.edge,'Color',[1 1 1])
plot(regMeanTab_vi.t/1000, regMeanTab_vi.beta_vi, 'color', colors{1}, 'LineWidth', 2);

k = shadedErrorBar(regMeanTab_vi.t/1000, regMeanTab_vi.beta_ar, regSteTab_vi.beta_ar, ...
    'lineProps', 'k',  'patchSaturation', 0.1, 'transparent', true);
set(k.edge,'Color',[1 1 1])
plot(regMeanTab_vi.t/1000, regMeanTab_vi.beta_ar, 'color', colors{2}, 'LineWidth', 2);

k = shadedErrorBar(regMeanTab_vi.t/1000, regMeanTab_vi.beta_va, regSteTab_vi.beta_va, ...
    'lineProps', 'k',  'patchSaturation', 0.1, 'transparent', true);
set(k.edge,'Color',[1 1 1])
plot(regMeanTab_vi.t/1000, regMeanTab_vi.beta_va, 'color', colors{3}, 'LineWidth', 2);



p_idx1 = regSigTab_vi.p_vi<0.05;
p_idx2 = regSigTab_vi.p_va<0.05;
p_idx3 = regSigTab_vi.p_ar<0.05;

min_val = min(find(p_idx1==1));
max_val = max(find(p_idx1==1));

plot([min_val max_val]/1000, [-0.275 -0.275], 'Color', 'k', 'MarkerSize', 5, 'LineWidth', 2);
% if sum(p_idx2)>0, plot(xpts(p_idx2)/1000, -0.265, '.', 'Color', colors{2}, 'MarkerSize', 8); end
% if sum(p_idx3)>0, plot(xpts(p_idx3)/1000, -0.255, '.', 'Color', colors{3}, 'MarkerSize', 8); end

box off
xlabel('Time (s)')
xlim([min(xpts), max(xpts)]/1000)
ylabel('Estimated Coefficients')
ylim([-0.3 0.08])





