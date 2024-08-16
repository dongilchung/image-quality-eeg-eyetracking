clear
clc

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
for t = 1:length(tList)
for s = 1:length(sList)
    for i = 1:length(imgList)
        idx = metricTab.sub == sList(s) & metricTab.task == tList(t) & metricTab.IAPS_number == imgList(i);
        
        ratingTab = [ratingTab; sList(s) imgList(i) tList(t) mean(metricTab.rating(idx))];
        
    end
end
end

ratingTab = array2table(ratingTab);
ratingTab.Properties.VariableNames = {'sub', 'IAPS_number', 'task', 'rating'};

ratingTab.rating_class(:) = 2;
for t = 1:length(tList)
for s = 1:length(sList)
    idx = ratingTab.sub == sList(s) & ratingTab.task == tList(t);
    class_bnd = [quantile(ratingTab.rating(idx), 2/3) quantile(ratingTab.rating(idx), 1/3)];
     
    idx_tmp = ratingTab.rating >= class_bnd(1);
    ratingTab.rating_class(idx&idx_tmp) = 3;

    idx_tmp = ratingTab.rating < class_bnd(2);
    ratingTab.rating_class(idx&idx_tmp) = 1;
end
end

metricTab.rating_class = zeros(height(metricTab),1);
for s = 1:length(sList)
    for t = 1:length(tList)
    for i = 1:length(imgList)
        idx = metricTab.sub == sList(s) & metricTab.task == tList(t) & metricTab.IAPS_number == imgList(i);
        idx_rating = ratingTab.sub == sList(s) & ratingTab.task == tList(t) & ratingTab.IAPS_number == imgList(i);
        metricTab.rating_class(idx) = ratingTab.rating_class(idx_rating);
    end
    end
end



%% rating linear reg
regdatTab_vi = [];
regdatTab_ar = [];
regdatTab_va = [];


for s = 1:length(sList)
    for i = 1:length(imgList)
        idx_vi = metricTab.sub == sList(s) & metricTab.IAPS_number == imgList(i) & metricTab.task ==1;
        idx_ar = metricTab.sub == sList(s) & metricTab.IAPS_number == imgList(i) & metricTab.task ==2;
        idx_va = metricTab.sub == sList(s) & metricTab.IAPS_number == imgList(i) & metricTab.task ==3;

        rating_vi = mean(metricTab.rating(idx_vi));
        rating_ar = mean(metricTab.rating(idx_ar));
        rating_va = mean(metricTab.rating(idx_va));
        
        curr_dat_vi = nanmean(metricTab{idx_vi, [10:2:15 18 20 23:25]},1);
        curr_dat_ar = nanmean(metricTab{idx_ar, [10:2:15 18 20 23:25]},1);
        curr_dat_va = nanmean(metricTab{idx_va, [10:2:15 18 20 23:25]},1);

        regdatTab_vi = [regdatTab_vi; sList(s) rating_vi rating_ar rating_va curr_dat_vi];
        regdatTab_ar = [regdatTab_ar; sList(s) rating_vi rating_ar rating_va curr_dat_ar];
        regdatTab_va = [regdatTab_va; sList(s) rating_vi rating_ar rating_va curr_dat_va];
    end

end

regdatTab_vi = array2table(regdatTab_vi);
regdatTab_ar = array2table(regdatTab_ar);
regdatTab_va = array2table(regdatTab_va);

regdatTab_vi.Properties.VariableNames = {'sub', 'rating_vi', 'rating_ar', 'rating_va', ...
    'SaccFreq', 'SaccDur', 'SaccPvel', 'BlinkFreq', 'BlinkDur', 'MeanPupDiam', 'PeakPupDiam', 'VarPupDiam'};
regdatTab_ar.Properties.VariableNames = regdatTab_vi.Properties.VariableNames;
regdatTab_va.Properties.VariableNames = regdatTab_vi.Properties.VariableNames;


%% regression
regTab_vi = [];
regTab_ar = [];
regTab_va = [];

varList = [5:12];
for s = 1:length(sList)
    for vr = 1:length(varList)
        idx = regdatTab_vi.sub == sList(s);
        Xdat = [regdatTab_vi.rating_vi(idx) regdatTab_vi.rating_ar(idx) regdatTab_vi.rating_va(idx)];
        
        curr_m = fitlm(Xdat, regdatTab_vi{idx, varList(vr)});
        estimates = curr_m.Coefficients.Estimate(1:4);
        p = curr_m.Coefficients.pValue(2:4);
        t = curr_m.Coefficients.tStat(2:4);
        regTab_vi = [regTab_vi; sList(s) varList(vr) estimates' p' t'];
        
        curr_m = fitlm(Xdat, regdatTab_ar{idx, varList(vr)});
        estimates = curr_m.Coefficients.Estimate(1:4);
        p = curr_m.Coefficients.pValue(2:4);
        t = curr_m.Coefficients.tStat(2:4);
        regTab_ar = [regTab_ar; sList(s) varList(vr) estimates' p' t'];
        
        curr_m = fitlm(Xdat, regdatTab_va{idx, varList(vr)});
        estimates = curr_m.Coefficients.Estimate(1:4);
        p = curr_m.Coefficients.pValue(2:4);
        t = curr_m.Coefficients.tStat(2:4);
        regTab_va = [regTab_va; sList(s) varList(vr) estimates' p' t'];
    end
end

regTab_vi = array2table(regTab_vi);
regTab_ar = array2table(regTab_ar);
regTab_va = array2table(regTab_va);

regTab_vi.Properties.VariableNames = {'sub', 'var', 'estimate', ...
    'beta_vi', 'beta_ar', 'beta_va', 'beta_vi_p', 'beta_ar_p', 'beta_va_p',...
    'beta_vi_t', 'beta_ar_t', 'beta_va_t'};
regTab_ar.Properties.VariableNames = regTab_vi.Properties.VariableNames;
regTab_va.Properties.VariableNames = regTab_vi.Properties.VariableNames;

%% significance test for slope
regSigTab_vi = [];
regSigTab_ar = [];
regSigTab_va = [];


for vr = 1:length(varList)
    idx = regTab_vi.var == varList(vr);
    
    % vividness eye data
    [~,p_vi,~,stats_vi] = ttest(regTab_vi.beta_vi(idx));
    [~,p_ar,~,stats_ar] = ttest(regTab_vi.beta_ar(idx));
    [~,p_va,~,stats_va] = ttest(regTab_vi.beta_va(idx));
    
    t_vi = stats_vi.tstat; t_ar = stats_ar.tstat; t_va = stats_va.tstat;
    df_vi = stats_vi.df; df_ar = stats_ar.df; df_va = stats_va.df;
    regSigTab_vi = [regSigTab_vi; varList(vr) p_vi p_ar p_va t_vi t_ar t_va df_vi df_ar df_va];
    
    % arousal eye data
    [~,p_vi,~,stats_vi] = ttest(regTab_ar.beta_vi(idx));
    [~,p_ar,~,stats_ar] = ttest(regTab_ar.beta_ar(idx));
    [~,p_va,~,stats_va] = ttest(regTab_ar.beta_va(idx));
    
    t_vi = stats_vi.tstat; t_ar = stats_ar.tstat; t_va = stats_va.tstat;
    df_vi = stats_vi.df; df_ar = stats_ar.df; df_va = stats_va.df;
    regSigTab_ar = [regSigTab_ar; varList(vr) p_vi p_ar p_va t_vi t_ar t_va df_vi df_ar df_va];
    
    % valence eye data
    [~,p_vi,~,stats_vi] = ttest(regTab_va.beta_vi(idx));
    [~,p_ar,~,stats_ar] = ttest(regTab_va.beta_ar(idx));
    [~,p_va,~,stats_va] = ttest(regTab_va.beta_va(idx));
    
    t_vi = stats_vi.tstat; t_ar = stats_ar.tstat; t_va = stats_va.tstat;
    df_vi = stats_vi.df; df_ar = stats_ar.df; df_va = stats_va.df;
    regSigTab_va = [regSigTab_va; varList(vr) p_vi p_ar p_va t_vi t_ar t_va df_vi df_ar df_va];
end

regSigTab_vi = array2table(regSigTab_vi);
regSigTab_ar = array2table(regSigTab_ar);
regSigTab_va = array2table(regSigTab_va);

regSigTab_vi.Properties.VariableNames = {'var', 'p_vi', 'p_ar', 'p_va', ...
    't_vi', 't_ar', 't_va', 'df_vi', 'df_ar', 'df_va'};
regSigTab_ar.Properties.VariableNames = regSigTab_vi.Properties.VariableNames;
regSigTab_va.Properties.VariableNames = regSigTab_vi.Properties.VariableNames;


%% save
tabs = [];

tabs.regdatTab_vi = regdatTab_vi;
tabs.regdatTab_ar = regdatTab_ar;
tabs.regdatTab_va = regdatTab_va;

tabs.regTab_vi = regTab_vi;
tabs.regTab_ar = regTab_ar;
tabs.regTab_va = regTab_va;

tabs.regSigTab_vi = regSigTab_vi;
tabs.regSigTab_ar = regSigTab_ar;
tabs.regSigTab_va = regSigTab_va;

save('eyemetric_reg.mat','-struct','tabs')

