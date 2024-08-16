clear;
clc;

%% data load
dat_C = [0.0125 0.0217 0.00534 -0.0102 0.00564 0.00705];
dat_C_modi = [0.0217 0.0125 -0.0102 0.00534 0.00705 0.00564];

cTab = readtable('pupTimeCtab.xlsx');
pTab = readtable('pupTimePtab.xlsx');

%% plot
for var = 1:3
    figure('position', [0 0 180 200]); 
    datY = dat_C_modi(var*2-1:var*2);

    h = bar([1 2], datY, 0.35); hold on
    set(h,'FaceColor', 'k');

    xticks([1 2])
    xticklabels({'Arousal', 'Valence'})
    xlabel('Coeff. of Covariate')
    xlim([0.25 2.75])
    
    ylabel('Slope')
    box off;
end

%% time plot
xpts = 1:1501;
figure('position', [0 0 300 200]);

datY = cTab.C_va;
plot([min(xpts) max(xpts)]/1000, [0 0], '--', 'color', [.5 .5 .5]); hold on
plot(xpts/1000, datY, 'color', 'k', 'LineWidth', 2);

p_idx1 = pTab.P_va<0.05;
min_val = min(find(p_idx1==1));
max_val = max(find(p_idx1==1));

plot([min_val max_val]/1000, [-0.001 -0.001], 'Color', 'r', 'MarkerSize', 5, 'LineWidth', 2);

box off
xlabel('Time (s)')
xlim([min(xpts), max(xpts)]/1000)
ylabel('Valence Slope')
ylim([-0.002 0.013])



figure('position', [0 0 300 200]);

datY = cTab.C_ar;
plot([min(xpts) max(xpts)]/1000, [0 0], '--', 'color', [.5 .5 .5]); hold on
plot(xpts/1000, datY, 'color', 'k', 'LineWidth', 2);

p_idx1 = pTab.P_ar<0.05;
min_val = min(find(p_idx1==1));
max_val = max(find(p_idx1==1));

plot([min_val max_val]/1000, [-0.001 -0.001], 'Color', 'r', 'MarkerSize', 5, 'LineWidth', 2);

box off
xlabel('Time (s)')
xlim([min(xpts), max(xpts)]/1000)
ylabel('Arousal Slope')
ylim([-0.002 0.02])
