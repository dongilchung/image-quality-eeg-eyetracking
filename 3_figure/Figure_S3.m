%Supple3a_3b_3c
file_Path='/Volumes/samba/Office/Users/chlim/LG_task/EEG_preprocessed_data';
addpath '/Volumes/samba/Office/Users/chlim/LG_task/EEG_preprocessed_data'

subj = 1;
filename=['arousal',num2str(subj),'_artifactepoch_baselinepeak_remove'];
EEG = pop_loadset('filename',[filename,'.set'],'filepath',file_Path);
epoch_time=EEG.times;
subplot_index=[1:1:31];
chanlocation=EEG.chanlocs;
CHlist=cell(31,1);
for i=1:size(chanlocation,2)
    CHlist(i)=cellstr(chanlocation(i).labels);
end
epoch_name='onset';
x_lim_i=[-400 1000];
x_ticks_i=[-400 -200 0 200 400 600 800 1000];
x_label_i=[-0.4 -0.2 -0.0 0.2 0.4 0.6 0.8 1.0];
load("Ch_brain.mat")
plot_index=find(Ch_brain~=0);
yel=[0.9 0.7 0];
ch=Ch_brain(plot_index(1));

addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation
load("Ancova_750_datas.mat")


Ancova_valence_P = Ancova_statistics.P_val_valence_all;
Ancova_arousal_P = Ancova_statistics.P_val_arousal_all;

coeff_valence_all = Ancova_statistics.coeff_valence_all;
coeff_arousal_all = Ancova_statistics.coeff_arousal_all;
% EEG arousal effect, 3a
col = [0.6 0.1 0.3];
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.45 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for locate = 1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))
    hold on;
    title(CHlist(ch),'fontsize',12);
    set(gca,'linewidth',1.5,'fontsize',12)
    plot(epoch_time,coeff_arousal_all(ch,:),'linewidth',1.5,'color',col)
    hold on                
    xline(0,'linestyle','--')
    line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')
    
    for time=251:750
        P = Ancova_arousal_P(ch,time);
        if P <= 0.001
            scatter(2*time-500,0.1,20,'o','filled','r')
        end
        
        if P <= 0.01
            scatter(2*time-500,-0.05,20,'o','filled','k')
        end
        
%         if P <= 0.05
%             scatter(2*time-500,-0.1,30,[0.5 0.5 0.5],'o','filled');
%             %s.CData = [0.5 0.5 0.5];
%         end
    end
    
    if locate == 1
        ylabel('Arousal slope')
        xlabel('Time (s)')
    end
    ylim([-0.6 0.6])
    xlim(x_lim_i)    
    xticks([-400 0 400 800])
    xticklabels([-0.4 0 0.4 0.8])      
end
saveas(gcf,"Fig.S3a, 31 ch Ancova arousal covariate effect width 0.45 font 12.tiff")

% EEG valence effect, 3b
gray = [0.5 0.5 0.5];
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.45 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for locate = 1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))
    hold on;
    title(CHlist(ch),'fontsize',16);
    set(gca,'linewidth',1.5,'fontsize',16) 
    plot(epoch_time,coeff_valence_all(ch,:),'linewidth',1.5,'color','b')
    hold on                
    xline(0,'linestyle','--')
    line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')
    
    %     P_all=[];
    %     for time=251:750
    %         if P_rm_white(ch,time-250,1)<0.01
    %             scatter(2*time-500,-3,3,'*','r')
    %         elseif P_rm_white(ch,time-250,1)<0.05
    %             scatter(2*time-500,-4,3,'*','k')
    %         end
    %     end
    for time=251:750
        P = Ancova_valence_P(ch,time);
        if P <= 0.001
            scatter(2*time-500,0.05,20,'o','filled','r')
        end
        
        if P <= 0.01
            scatter(2*time-500,0,20,'o','filled','k')
        end
        
%         if P <= 0.05
%            
%             s=scatter(2*time-500,-0.05,20,[0.5 0.5 0.5],'o','filled');
%         end
    end
    
       
    if locate == 1
        ylabel('Valence slope')
        xlabel('Time (s)')
    end
    
    ylim([-0.3 0.3])
    xlim(x_lim_i)    
    xticks([-400 0 400 800])
    xticklabels([-0.4 0 0.4 0.8])      
end
saveas(gcf,"Fig.S3b. 31 ch Ancova valence covariate effect width 0.45 font 16.tiff")


%3c, Pz channel covariate effect
%1. Valence covariate effect
ch = 13; %Fz:2, Pz:13
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.3 0.4], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
plot(epoch_time,coeff_valence_all(ch,:),'linewidth',2.5,'color','b')
hold on
title(CHlist(ch),'fontsize',28);
xline(0,'linestyle','--')
line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')
set(gca,'linewidth',1.5,'fontsize',28)
box off;
for time=1:750
    P = Ancova_valence_P(ch,time);
    if P <= 0.001
        scatter(2*time-500,-0.29,50,'o','filled','r')
    end
    
    if P <= 0.01
        scatter(2*time-500,-0.33,50,'o','filled','k')
    end
    
end
    ylim([-0.4 0.5])
    yticks([-0.4 0 0.4])
    yticks
    xlim(x_lim_i)
    xticks([0 400 800])
    xticklabels([-0.4 0 0.4 0.8])
    xlabel('Time (s)')
    ylabel('Valence slope')
    box off;
    %ylabel('Arousal slope')
 saveas(gcf,"Fig.S3c. Pz valence covariate effect.tiff")
 %saveas(gcf,"Pz arousal covariate effect.tiff")

%2. Pz arousal covariate effect
col = [0.6 0.1 0.3];
ch = 13; %Fz:2, Pz:13
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.3 0.4], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
%plot(epoch_time,coeff_arousal_all(ch,:),'linewidth',2.5,'color',[0.3 0.7 0])
plot(epoch_time,coeff_arousal_all(ch,:),'linewidth',2.5,'color',col)
hold on
title(CHlist(ch),'fontsize',28);
xline(0,'linestyle','--')
line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')
set(gca,'linewidth',1.5,'fontsize',28)
box off;
for time=1:750
    P = Ancova_arousal_P(ch,time);
    if P <= 0.001
        scatter(2*time-500,-0.29,50,'o','filled','r')
    end
    
    if P <= 0.01
        scatter(2*time-500,-0.33,50,'o','filled','k')
    end
    
end
    ylim([-0.4 0.5])
    yticks([-0.4 0 0.4])
    yticks
    xlim(x_lim_i)
    xticks([0 400 800])
    xlabel('Time (s)')
    ylabel('Arousal slope')
    box off;

 saveas(gcf,"Fig.S3c. Pz arousal covariate effect.tiff")
