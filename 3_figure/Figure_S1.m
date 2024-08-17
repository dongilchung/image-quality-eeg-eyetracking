%Supple1: White-boosting effects on valence and arousal block

addpath /Volumes/samba/Office/Users/chlim/LG_task/Behavior_data

off_White_all=[];
mid_White_all=[];
high_White_all=[];
off_White_val_all=[];
mid_White_val_all=[];
high_White_val_all=[];
off_White_aro_all=[];
mid_White_aro_all=[];
high_White_aro_all=[];
for subj=1:19
    if subj==2 || subj==10
        continue
    end
    load("LG_"+num2str(subj)+"_vivid_pilot_EEG.mat")
    
    off_White = confirm_data(find(confirm_data(:,4) == 1),2);
    mid_White = confirm_data(find(confirm_data(:,4) == 2),2);
    high_White = confirm_data(find(confirm_data(:,4) == 3),2);
    
    off_White_all=[off_White_all,off_White];
    mid_White_all=[mid_White_all,mid_White];
    high_White_all=[high_White_all,high_White];
    
    load("LG_"+num2str(subj)+"_valence_pilot_EEG.mat")
    
    off_White_val = confirm_data(find(confirm_data(:,4) == 1),2);
    mid_White_val = confirm_data(find(confirm_data(:,4) == 2),2);
    high_White_val = confirm_data(find(confirm_data(:,4) == 3),2);
    
    off_White_val_all=[off_White_val_all,off_White_val];
    mid_White_val_all=[mid_White_val_all,mid_White_val];
    high_White_val_all=[high_White_val_all,high_White_val];
    
    load("LG_"+num2str(subj)+"_arousal_pilot_EEG.mat")
    
    off_White_aro = confirm_data(find(confirm_data(:,4) == 1),2);
    mid_White_aro = confirm_data(find(confirm_data(:,4) == 2),2);
    high_White_aro = confirm_data(find(confirm_data(:,4) == 3),2);
    
    off_White_aro_all=[off_White_aro_all,off_White_aro];
    mid_White_aro_all=[mid_White_aro_all,mid_White_aro];
    high_White_aro_all=[high_White_aro_all,high_White_aro];
end

y11 = mean(mean(off_White_all));
y12 = mean(mean(mid_White_all));
y13 = mean(mean(high_White_all));
y11_s = std(std(off_White_all))/sqrt(size(off_White_all,2));
y12_s = std(std(mid_White_all))/sqrt(size(off_White_all,2));
y13_s = std(std(high_White_all))/sqrt(size(off_White_all,2));
y1 = [y11 y12 y13];
y1_std = [y11_s y12_s y13_s];

y21 = mean(mean(off_White_val_all));
y22 = mean(mean(mid_White_val_all));
y23 = mean(mean(high_White_val_all));
y21_s = std(std(off_White_val_all))/sqrt(size(off_White_val_all,2));
y22_s = std(std(mid_White_val_all))/sqrt(size(off_White_val_all,2));
y23_s = std(std(high_White_val_all))/sqrt(size(off_White_val_all,2));
y2 = [y21 y22 y23];
y2_std = [y21_s y22_s y23_s];


y31 = mean(mean(off_White_aro_all));
y32 = mean(mean(mid_White_aro_all));
y33 = mean(mean(high_White_aro_all));
y31_s = std(std(off_White_aro_all))/sqrt(size(off_White_aro_all,2));
y32_s = std(std(mid_White_aro_all))/sqrt(size(off_White_aro_all,2));
y33_s = std(std(high_White_aro_all))/sqrt(size(off_White_aro_all,2));
y3 = [y31 y32 y33];
y3_std = [y31_s y32_s y33_s];



col = [0.6 0.1 0.3];

figure('Position',[500 700 800 500])
x=[1 2 3];
yel=[0.9 0.7 0];
h2=plot(x,y2,'linewidth',3,'color','b')% mid
hold on
a=scatter(x,y2,50,'filled','Linewidth',2)
a.CData=[0.9 0.7 0]
e2=errorbar(1:3,y2, y2_std, 'linestyle','none','color','b','linewidth',2,'Marker','o','Capsize',0,'Markersize',7);
h3=plot(x,y3,'linewidth',3,'color',col)% vivid
e3=errorbar(1:3,y3, y3_std, 'linestyle','none','color',col,'linewidth',2,'Marker','o','Capsize',0,'Markersize',7)
e2.MarkerFaceColor = 'w';
e3.MarkerFaceColor = 'w';
e2.CapSize = 0;
e3.CapSize = 0;
ylim([1 5])
xlim([0 4])
yticks([1 3 5])
xticks(1:1:3)
set(gca,'linewidth',1.5,'Fontsize',28),hold on;
xlabel('White boosting level')
xticklabels({'Off','Mid','High'})
ylabel('Subjective rating')
box off;
%legend([h2 h3],'Valence','Arousal')
saveas(gcf,"Fig.S1: Behavior - White boosting effect in Valence and Arousal block.tiff")

%Anova
t = table(transpose(mean(off_White_val_all)),transpose(mean(mid_White_val_all)),transpose(mean(high_White_val_all)),'VariableNames',{'b1','b2','b3'});
Whiteboosting = (table([1,2,3]','VariableNames',{'Whiteboost'}));
rm1 = fitrm(t, 'b1-b3~1', 'WithinDesign', Whiteboosting);
P2=ranova(rm1); % Whiteboosting effect, P = 0.49979, F(2,32) = 0.71

t = table(transpose(mean(off_White_aro_all)),transpose(mean(mid_White_aro_all)),transpose(mean(high_White_aro_all)),'VariableNames',{'b1','b2','b3'});
Whiteboosting = (table([1,2,3]','VariableNames',{'Whiteboost'}));
rm2 = fitrm(t, 'b1-b3~1', 'WithinDesign', Whiteboosting);
P3=ranova(rm1); % Whiteboosting effect, F(2,32) = 0.59, F(2,32) = 0.59138, P=0.5595
