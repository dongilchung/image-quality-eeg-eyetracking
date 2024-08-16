clc
clear

%% load
load('eyemetric_reg.mat')
load('metricTab3_4.mat');

sList = [1 3:9 11:19];
tList = [1 2 3]; % vi ar val


%% add response class column
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
subMeanTab.Properties.VariableNames(1) = {'rating'};

subSteTab = [];
for r = 1:length(ratingList)
    idx = subTab.class == ratingList(r);
    tmp = nanstd(subTab{idx,3:end})/sqrt(sum(idx));
    subSteTab = [subSteTab; ratingList(r) tmp];
end

subSteTab = array2table(subSteTab);
subSteTab.Properties.VariableNames(1) = {'rating'};

%% plot
varListPlot = [7 10];
yLabelNames = {'Saccade Peak Velocity (\circ/s)', 'Mean Pupil Diameter (A.U.)'};

color_rating_class{1} = [53 134 187]/255;
color_rating_class{2} = [252 225 99]/255;
color_rating_class{3} = [208 67 76]/255;

for v = 1:length(varListPlot)
    figure('position', [0 0 200 200]);
    errbar(subMeanTab.rating, subMeanTab{:,varListPlot(v)-3}, subSteTab{:,varListPlot(v)-3}, ...
        'color', [0 0 0], 'linewidth', 0.5); hold on
    plot(subMeanTab.rating, subMeanTab{:,varListPlot(v)-3}, ...
        '.-', 'MarkerSize', 20, 'LineWidth', 1.75, 'Color', 'k');
    
    for x = 1:3
        plot(subMeanTab.rating(x), subMeanTab{x,varListPlot(v)-3}, ...
            '.', 'MarkerSize', 19, 'Color', 'k');
    end
    
    ylabel(yLabelNames{v})
    xticks([1 2 3])
    xticklabels({'Dull', 'Mid', 'Vivid'});
    xlabel('Subjective Vividness')
    xlim([0.5 3.5])
    box off
end

%% plot of beta
varListPlot = [7 10];
yLabelNames = {'Estimated b'};

colors{1} = [0 0 0]/255;
colors{2} = [14 31 87]/255;
colors{3} = [122 0 11]/255;

for v = 1:length(varListPlot)
    figure('position', [0 0 180 200]); 
    idx = regTab_vi.var == varListPlot(v);
    meanDat = [mean(regTab_vi.beta_vi(idx)), mean(regTab_vi.beta_ar(idx)), mean(regTab_vi.beta_va(idx))];
    steDat  = [std(regTab_vi.beta_vi(idx))/sqrt(length(sList)), std(regTab_vi.beta_ar(idx))/sqrt(length(sList)), ...
        std(regTab_vi.beta_va(idx))/sqrt(length(sList))];
    
    xpts = [1 2 3];
    for x = 1:length(xpts)
        h = bar(xpts(x), meanDat(x), 0.35); hold on
        set(h,'FaceColor', 'k');
    end
    
    
    errbar([1 2 3], meanDat, steDat , 'Color', 'k', 'LineWidth', 0.5); hold on
    
    
    ylabel('Estimated coefficients')
    xticks([1 2 3])
    xticklabels({'\beta_1', '\beta_2', '\beta_3'})
    xlabel('Type of coefficients')
    xlim([0.5 3.5])
    box off;
    
end
    
    
