%Figure_2_White boosting effect in vividness rating across 3 blocks
addpath /Volumes/samba/Office/Users/chlim/LG_task/Behavior_data

off_White_all=[];
mid_White_all=[];
high_White_all=[];
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
    
%     load("LG_"+num2str(subj)+"_valence_pilot_EEG.mat")
%     
%     off_White_val = confirm_data(find(confirm_data(:,4) == 1),2);
%     mid_White_val = confirm_data(find(confirm_data(:,4) == 2),2);
%     high_White_val = confirm_data(find(confirm_data(:,4) == 3),2);
%     
%     off_White_all=[off_White_all,off_White_val];
%     mid_White_all=[mid_White_all,mid_White_val];
%     high_White_all=[high_White_all,high_White_val];
%     
%     load("LG_"+num2str(subj)+"_arousal_pilot_EEG.mat")
%     
%     off_White_aro = confirm_data(find(confirm_data(:,4) == 1),2);
%     mid_White_aro = confirm_data(find(confirm_data(:,4) == 2),2);
%     high_White_aro = confirm_data(find(confirm_data(:,4) == 3),2);
%     
%     off_White_all=[off_White_all,off_White_aro];
%     mid_White_all=[mid_White_all,mid_White_aro];
%     high_White_all=[high_White_all,high_White_aro];
end

y11 = mean(mean(off_White_all));
y12 = mean(mean(mid_White_all));
y13 = mean(mean(high_White_all));
y11_s = std(std(off_White_all))/sqrt(size(off_White_all,2));
y12_s = std(std(mid_White_all))/sqrt(size(off_White_all,2));
y13_s = std(std(high_White_all))/sqrt(size(off_White_all,2));
y1 = [y11 y12 y13];
y1_std = [y11_s y12_s y13_s];


figure('Position',[500 700 800 500])
x=[1 2 3];
h1=plot(x,y1,'linewidth',3,'color','k'); % dull
hold on
%scatter(x,y1,50,'filled','k','LineWidth',2)
e1=errorbar(1:3,y1, y1_std, 'linestyle','none','color','k','linewidth',2,'Marker','o','Capsize',0,'Markersize',7)
e1.MarkerFaceColor = 'w';
e1.CapSize = 0;
ylim([1 5])
xlim([0 4])
xticks(1:1:3)
set(gca,'linewidth',1.5,'Fontsize',28),hold on;
xlabel('White boosting level')
xticklabels({'Off','Mid','High'})
%ylim([2 5.5])
yticks([1 3 5])
ylabel('Subjective rating')
%legend([h1],'vividness')
%saveas(gcf,"Behavior - White boosting effect in vividness block.tiff")
saveas(gcf,"Fig.2B:vividness rating - White boosting effect across three blocks.tiff")


%% Anova
t = table(transpose(mean(off_White_all)),transpose(mean(mid_White_all)),transpose(mean(high_White_all)),'VariableNames',{'b1','b2','b3'});
Whiteboosting = (table([1,2,3]','VariableNames',{'Whiteboost'}));
rm1 = fitrm(t, 'b1-b3~1', 'WithinDesign', Whiteboosting);
P1=ranova(rm1); % Whiteboosting effect, P = 0.21015, F(32) = 1.6385
