%% Ancova analysis
load("EEG plot variables","epoch_time","CHlist","x_lim_i","x_ticks_i","x_label_i","Ch_brain","ch","plot_index","epoch_name","chanlocation")
addpath '/Users/changhyunlim/Desktop/LG_display/EEG/eeglab2022.1_old'
file_Path='/Users/changhyunlim/Desktop/LG_display/EEG/eeglab2022.1_old/after_artifact';
subj = 1;
filename=['arousal',num2str(subj),'_artifactepochbaselinepeak_remove'];
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

Ancova_Whiteboost_P = Ancova_statistics.P_val_wb_all;
Ancova_Whiteboost_F = Ancova_statistics.F_val_wb_all;

Ancova_valence_P = Ancova_statistics.P_val_valence_all;
Ancova_arousal_P = Ancova_statistics.P_val_arousal_all;
Ancova_whiteboost_block_P = Ancova_statistics.P_val_wb_block_all;
Ancova_whiteboost_block_F = Ancova_statistics.F_val_wb_block_all;
Ancova_whiteboost_val_P = Ancova_statistics.P_val_wb_val_all;
Ancova_whiteboost_val_F = Ancova_statistics.F_val_wb_val_all;
Ancova_whiteboost_aro_P = Ancova_statistics.P_val_wb_aro_all;
Ancova_whiteboost_aro_F = Ancova_statistics.F_val_wb_aro_all;

coeff_wb_all = Ancova_statistics.coeff_wb_all;
coeff_valence_all = Ancova_statistics.coeff_valence_all;
coeff_arousal_all = Ancova_statistics.coeff_arousal_all;


% % Whiteboosting main effect
% for ch=1:31
%     randnum = rand(1,250)*2-rand(1,250)*2;
%     Ancova_Whiteboost_F_fill(ch,1:750) = [randnum,Ancova_Whiteboost_F(ch,:)];
%     
%     Ancova_whiteboost_block_F_fill(ch,1:750) = [randnum,Ancova_whiteboost_block_F(ch,:)];
%     Ancova_whiteboost_val_F_fill(ch,1:750) = [randnum,Ancova_whiteboost_val_F(ch,:)];
%     Ancova_whiteboost_aro_F_fill(ch,1:750) = [randnum,Ancova_whiteboost_aro_F(ch,:)];
%     %Ancova_Whiteboost_F_fill(ch,1:750) = [randnum,Ancova_Whiteboost_F(ch,:)];
%     
% end
% 
%% White boosting main effect in 31 EEG channels 
grey = [0.5 0.5 0.5];
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.9 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for locate = 1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))
    hold on;    
    set(gca,'linewidth',1.5,'fontsize',16)
    title(CHlist(ch));     
    plot(epoch_time,Ancova_Whiteboost_F(ch,:),'linewidth',1.5,'color',[0.8 0.1 0.7])
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
    if ch ==1
        ylabel('F value')
        xlabel('Time (s)')
    end
    for time=251:700
        P = Ancova_Whiteboost_P(ch,time);
        if P <= 0.001
           scatter(2*time-500,-1,30,'o','filled','r') 
        end
        if P <= 0.01
            scatter(2*time-500,-3,30,'o','filled','k')
        end
%         if  P <= 0.05
%             scatter(2*time-500,-3,20,'o','filled','markerFacecolor',grey)            
%         end
    end
    xticks([-400 0 400 800])
    xticklabels([-0.4 0 0.4 0.8])
    ylim([-4 15])
    xlim(x_lim_i)    
end
saveas(gcf,"31 ch Ancova whiteboost main effect_color change.tiff")

color_rating_class{1} = [53 134 187]/255;
color_rating_class{2} = [252 225 99]/255;
color_rating_class{3} = [208 67 76]/255;

addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation
load("White boosting condtion for all block.mat.")
Sig_ch = [2,7,8];

% Whiteboosting 3 channel plot, Fz, FC1, C3
grey = [0.7 0.7 0.7]; green_subjopt = [154,216,50]/256; blue_SV = [0.5 0.1 1];
pink = [1 0.4 0.9];
pink2 = [0.5 0.5 1];
color_rating_class{1} = [1 0 0]; % red
color_rating_class{2} = [255 192 0] / 255; % orange
color_rating_class{3} = [127 127 127] /255; % grey

loc = 0;
%figure('Position',[0 0 1400 400])
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 1.0 0.4], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);

for ch = Sig_ch 
    loc = loc+1;
    subplot(1,3,loc);    
    hold on
     xline(0,'linewidth',1,'linestyle','--','Color','k')
     
    line(xlim(),[0,0],'LineWidth', 1,'Color','k','LineStyle','--')       
    h3=plot(epoch_time,mean(IAPS_noboost_ERP_allsubj(ch,:,:),3,'omitnan'),'linewidth',3,'color',color_rating_class{3});
    
    
    h2=plot(epoch_time,mean(IAPS_lowboost_ERP_allsubj(ch,:,:),3,'omitnan'),'linewidth',3,'color',color_rating_class{2});
    h1 = plot(epoch_time,mean(IAPS_highboost_ERP_allsubj(ch,:,:),3,'omitnan'),'linewidth',3,'color',color_rating_class{1});
    hold on
    %h2.Color(4) = 0.7;    
    
    %h3.Color(4) = 0.7;
    
    %h2=plot(epoch_time,mean(IAPS_lowboost_ERP_allsubj(ch,:,:),3,'omitnan'),'linewidth',1.5,'color',blue_SV);
    %h3=plot(epoch_time,mean(IAPS_noboost_ERP_allsubj(ch,:,:),3,'omitnan'),'linewidth',1.5,'color','k')    
    box off;
    title(CHlist(ch));                 
    set(gca,'linewidth',1.5,'fontsize',28)
   
    if ch ==Sig_ch(1)      
        ylabel('Amplitude (µV)')        
        xlabel('Time (s)')
    end    

    
    Row = find(Sig_pos_ch_time_info(:,1) == ch);
    Time = Sig_pos_ch_time_info(Row,2);
    scatter(2*Time-500,-2.5,150,'o','filled','k')
   
%      for time=251:700
%         P = Ancova_Whiteboost_P(ch,time);
%         %P = Ancova_arousal_P(ch,time-250);
%         
% %         if P <= 0.001
% %             scatter(2*time-500,-2,50,'o','filled','k')
% %         end
% %       
%         if P <= 0.01
%             scatter(2*time-500,-2.5,50,'o','filled','k')
%         end
% %         
% %         if P <= 0.05
% %             s=scatter(2*time-500,-3,50,'o','filled');
% %             s.CData = [0.5 0.5 0.5];
% %         end
%  
%     end
%     for time=251:700
%         P = Ancova_Whiteboost_P(ch,time-250);
%         if P <= 0.01
%             scatter(2*time-500,-3,3,'*','r')
%         elseif P <= 0.05
%             scatter(2*time-500,-4,3,'*','k')
%         end
%     end
    ylim([-3 3])
    yticks([-2 0 2])
    xlim(x_lim_i)    
    xticks(x_ticks_i)
    xticklabels(x_label_i)
end
%saveas(gcf,"try5.png")
saveas(gcf,"Significant Cluster to show whiteboosting effect Fz, FC1, C3 ERP across 3 blocks.tiff")
saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - blue redpinkgrey.png")
saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - blue pinkpurplegrey.png")
    %saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - red pink blue.tiff")
    saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - blue bluepurple grey.png")
%saveas(gcf,"Fz, FC1, C3 ERP according to white boosting condition and ancova whiteboosting effect across 3 blocks - box off.tiff")
%saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - red pink grey.tiff")
%saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - red green grey.tiff")
%saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - red pink green.tiff")
%saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - black green red.tiff")
saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - black pink2 red.png")
%saveas(gcf,"Fz, FC1, C3 ERP according to WB condition and ancova whiteboosting effect across 3 blocks - red pink pinkgrey.tiff")
% EEG valence/arousal(covariate) effect
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);

for locate = 1:3
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))
    hold on;
    title(CHlist(ch),'fontsize',20);
    plot(epoch_time,Ancova_whiteboost_val_F(ch,:),'linewidth',1.5,'color',[0.5 0.5 0.5])
    %plot(epoch_time,Ancova_whiteboost_aro_F(ch,:),'linewidth',1.5,'color',[0.5 0.5 0.5])
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
    for time=251:700
        P = Ancova_valence_P(ch,time);
        %P = Ancova_arousal_P(ch,time-250);
        if P <= 0.01
            scatter(2*time-500,-3,3,'*','r')
        elseif P <= 0.05
            scatter(2*time-500,-4,3,'*','k')
        end
    end
    ylim([-4 15])
    xlim(x_lim_i)
    xticks(x_ticks_i)
    xticklabels(x_label_i)
end
saveas(gcf,"31 ch Ancova valence covariate effect.tiff")
%saveas(gcf,"31 ch Ancova arousal covariate effect.tiff")



% EEG Whiteboost x Block intr effect
col = [0.6 0.8 0.8];
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.9 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for locate = 1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))
    hold on;
    title(CHlist(ch),'fontsize',20);
    plot(epoch_time,Ancova_whiteboost_block_F(ch,:),'linewidth',2,'color',[0.6 0.6 0.7])
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
    for time=251:700
        P = Ancova_whiteboost_block_P(ch,time-250);
        if P <= 0.01
            scatter(2*time-500,-3,30,'o','filled','k')
        end
        if P <= 0.001
            scatter(2*time-500,-4,30,'o','filled','r')
            
        end
    end
    ylim([-4 15])
    xlim(x_lim_i)
    xticks(x_ticks_i)
    xticklabels(x_label_i)
end
saveas(gcf,"31 ch Ancova Block - Whiteboost intr effect.tiff")


% EEG Whiteboost x valence intr effect
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.9 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for locate = 1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))
    hold on;
    title(CHlist(ch),'fontsize',20);
    plot(epoch_time,Ancova_whiteboost_val_F(ch,:),'linewidth',1.5,'color',[0.5 0.5 0.5])
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
    for time=251:700
        P = Ancova_whiteboost_val_P(ch,time-250);
        if P <= 0.01
            scatter(2*time-500,-3,3,'*','r')
        elseif P <= 0.05
            scatter(2*time-500,-4,3,'*','k')
        end
    end
    ylim([-4 15])
    xlim(x_lim_i)
    xticks(x_ticks_i)
    xticklabels(x_label_i)
end
saveas(gcf,"31 ch Ancova valence - Whiteboost intr effect.tiff")


% EEG arousal effect
col = [0.6 0.1 0.3];
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.9 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for locate = 1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))
    hold on;
    title(CHlist(ch),'fontsize',16);
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
            scatter(2*time-500,-0.1,20,'o','filled','k')
        end
        
%         if P <= 0.05
%             scatter(2*time-500,-0.1,30,[0.5 0.5 0.5],'o','filled');
%             %s.CData = [0.5 0.5 0.5];
%         end
    end
    ylim([-0.6 0.6])
    xlim(x_lim_i)
    xticks(x_ticks_i)
    xticklabels(x_label_i)
end
saveas(gcf,"Fig.S3a, 31 ch Ancova arousal covariate effect_scatter size 20.tiff")

% EEG valence effect
gray = [0.5 0.5 0.5];
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for locate = 1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))
    hold on;
    title(CHlist(ch),'fontsize',16);
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
            scatter(2*time-500,-0.1,20,'o','filled','r')
        end
        
        if P <= 0.01
            scatter(2*time-500,0,1,'o','filled','k')
        end
        
%         if P <= 0.05
%            
%             s=scatter(2*time-500,-0.05,20,[0.5 0.5 0.5],'o','filled');
%         end
    end
    ylim([-0.3 0.3])
    xlim(x_lim_i)
    xticks(x_ticks_i)
    xticklabels(x_label_i)
end
saveas(gcf,"31 ch Ancova valence covariate effect.tiff")


%EEG Whiteboost x valence intr effect
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 1 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for locate = 1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))
    hold on;
    title(CHlist(ch),'fontsize',20);
    plot(epoch_time,Ancova_whiteboost_val_F(ch,:),'linewidth',1.5,'color',[0.5 0.5 0.5])
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
    for time=251:700
        if P <= 0.001
            scatter(2*time-500,-0.19,50,'o','filled','r')
        end
        
        if P <= 0.01
            scatter(2*time-500,-0.18,50,'o','filled','k')
        end
        
        if P <= 0.05
            s=scatter(2*time-500,-0.2,50,'o','filled')
            s.CData = [0.5 0.5 0.5];
        end
    end
    ylim([-4 15])
    xlim(x_lim_i)
    xticks(x_ticks_i)
    xticklabels(x_label_i)
end
saveas(gcf,"31 ch Ancova valence - Whiteboost intr effect.tiff")


%1. Valence covariate effect
ch = 13; %Fz:2, Pz:13
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.3 0.4], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
%plot(epoch_time,coeff_arousal_all(ch,:),'linewidth',2.5,'color',[0.3 0.7 0])
plot(epoch_time,coeff_valence_all(ch,:),'linewidth',2.5,'color','b')
hold on
title(CHlist(ch),'fontsize',28);
xline(0,'linestyle','--')
line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')
set(gca,'linewidth',1.5,'fontsize',28)
box off;
%     P_all=[];
%     for time=251:750
%         if P_rm_white(ch,time-250,1)<0.01
%             scatter(2*time-500,-3,3,'*','r')
%         elseif P_rm_white(ch,time-250,1)<0.05
%             scatter(2*time-500,-4,3,'*','k')
%         end
%     end
for time=1:750
    P = Ancova_valence_P(ch,time);
    if P <= 0.001
        scatter(2*time-500,-0.29,50,'o','filled','r')
    end
    
    if P <= 0.01
        scatter(2*time-500,-0.33,50,'o','filled','k')
    end
    
    if P <= 0.05
        scatter(2*time-500,-0.37,50,[0.5 0.5 0.5],'o','filled')
        
    end
end

    ylim([-0.4 0.2])
    %ylim([-0.2 0.5])
    %yticks([-0.2 0 0.2 0.4])
    xlim(x_lim_i)
    %x_ticks_i=[-400 -200 0 200 400 600 800 1000];
    %x_label_i=[-0.4 -0.2 -0.0 0.2 0.4 0.6 0.8 1.0];
    xticks([-400 0 400 800])
    xticklabels([-0.4 0 0.4 0.8])
    xlabel('Time (s)')
    ylabel('Valence slope')
    box off;
    %ylabel('Arousal slope')
 saveas(gcf,"Pz valence covariate effect.tiff")
 %saveas(gcf,"Pz arousal covariate effect.tiff")

%2. Pz arousal covariate effect
col = [0.6 0.1 0.3];
ch = 13; %Fz:2, Pz:13
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.3 0.4], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
%plot(epoch_time,coeff_arousal_all(ch,:),'linewidth',2.5,'color',[0.3 0.7 0])
plot(epoch_time,coeff_valence_all(ch,:),'linewidth',2.5,'color',col)
hold on
title(CHlist(ch),'fontsize',28);
xline(0,'linestyle','--')
line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')
set(gca,'linewidth',1.5,'fontsize',28)
box off;
%     P_all=[];
%     for time=251:750
%         if P_rm_white(ch,time-250,1)<0.01
%             scatter(2*time-500,-3,3,'*','r')
%         elseif P_rm_white(ch,time-250,1)<0.05
%             scatter(2*time-500,-4,3,'*','k')
%         end
%     end
for time=1:750
    P = Ancova_arousal_P(ch,time);
    if P <= 0.001
        scatter(2*time-500,-0.29,50,'o','filled','r')
    end
    
    if P <= 0.01
        scatter(2*time-500,-0.33,50,'o','filled','k')
    end
    
    if P <= 0.05
        scatter(2*time-500,-0.37,50,[0.5 0.5 0.5],'o','filled')
        
    end
end

    ylim([-0.4 0.2])
    %ylim([-0.2 0.5])
    %yticks([-0.2 0 0.2 0.4])
    xlim(x_lim_i)
    %x_ticks_i=[-400 -200 0 200 400 600 800 1000];
    %x_label_i=[-0.4 -0.2 -0.0 0.2 0.4 0.6 0.8 1.0];
    xticks([-400 0 400 800])
    xticklabels([-0.4 0 0.4 0.8])
    xlabel('Time (s)')
    ylabel('Arousal slope')
    box off;    
 saveas(gcf,"Pz arousal covariate effect.tiff")
 
 
%% Topoplot
%T stat and cluster plot

 sig_ch = [2,7,8];

 sig_timepoint = cell(1,3);
 loc = 0;
 for ch = sig_ch     
     loc = loc +1;
        sig_timepoint{loc} = transpose(find(Ancova_Whiteboost_P(ch,:) <= 0.05));
 end
 
custom_colormap = [0 1 0; 1 0 0];
Timepointindex = [100,230, 400];
%figure('units','normalized','outerposition',[0 0 0.8 0.6])
loc = 0;
for timepoint = Timepointindex
    % topoplot 그리기
    figure
    loc = loc +1;
    %subplot(1,3,loc)
    topoplot(Ancova_Whiteboost_F(:, 250 + timepoint/2), EEG.chanlocs, 'style', 'map', 'electrodes', 'labels');
    %colormap(cmap); % colormap을 설정합니다.
    %colorbar; % 색상 막대를 추가합니다.
    %title("Ancova F value- "+num2str(timepoint)+"ms"); % 그래프 제목을 지정합니다.
    %title("Multiple regression Arousal EEG - Arousal behavior paired t test- "+num2str(timepoint * 2 - 500)+"ms"); % 그래프 제목을 지정합니다.
    set(gca,'linewidth',1.5,'fontsize',22)
    %caxis([0,10])
    % 범례 추가
    c = colorbar;
    colormap(custom_colormap);
    caxis([0 10]);
    if loc == 3        
 
        c.Label.String = 'F-Statistic';        
    end
    %saveas(gcf,"topoplot, Ancova White boosting main effect - "+num2str(timepoint)+" ms.tiff")
    %saveas(gcf,"topoplot, Multiple Arousal t stat"+ num2str(500-2*timepoint)+"ms.tiff")
end 
 

%% Behavior plot, Only consider white boosting level
addpath /Users/changhyunlim/Desktop/LG_display/EEG/EEG_data/EEG_realpilot/Behavior_data
subj=1; % use IAPS_number order for subj1, to calculate rating of same IAPS number at IAPS_off_rating

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

White_vivid_allsubj = [mean(off_White_all);mean(mid_White_all);mean(high_White_all)];
White_valence_allsubj = [mean(off_White_val_all);mean(mid_White_val_all);mean(high_White_val_all)];
White_arousal_allsubj = [mean(off_White_aro_all);mean(mid_White_aro_all);mean(high_White_aro_all)];

grey = [0.5 0.5 0.5];
figure('Position',[500 700 800 500])
x=[1 2 3];
hold on 
for subj = 1:17
    h2 = plot(1:3, White_vivid_allsubj(:,subj),'color','k','linewidth',1.5);
    h2.Color(4) = 0.2;
    scatter(1:3, White_vivid_allsubj,10,'o','filled','markerFacecolor','k')
end
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
saveas(gcf,"Behavior - White boosting effect in vividness block - individual plot.jpg")

t = table(transpose(mean(off_White_all)),transpose(mean(mid_White_all)),transpose(mean(high_White_all)),'VariableNames',{'b1','b2','b3'});
Whiteboosting = (table([1,2,3]','VariableNames',{'Whiteboost'}));
rm1 = fitrm(t, 'b1-b3~1', 'WithinDesign', Whiteboosting);
P1=ranova(rm1); % Whiteboosting effect, P = 0.21015, F(32) = 1.6385

col = [0.6 0.1 0.3];

figure('Position',[500 700 800 500])
x=[1 2 3];
yel=[0.9 0.7 0];
hold on 
for subj = 1:17
    h2 = plot(1:3, White_valence_allsubj(:,subj),'color','b','linewidth',1.5);
    h2.Color(4) = 0.2;
    scatter(1:3, White_valence_allsubj,10,'o','filled','markerFacecolor','b')
    h3 = plot(1:3, White_arousal_allsubj(:,subj),'color',col,'linewidth',1.5);
    h3.Color(4) = 0.2;
    scatter(1:3, White_valence_allsubj,10,'o','filled','markerFacecolor',col)
end
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
saveas(gcf,"Behavior - White boosting effect in Valence and Arousal block.tiff")
t = table(transpose(mean(off_White_val_all)),transpose(mean(mid_White_val_all)),transpose(mean(high_White_val_all)),'VariableNames',{'b1','b2','b3'});
Whiteboosting = (table([1,2,3]','VariableNames',{'Whiteboost'}));
rm1 = fitrm(t, 'b1-b3~1', 'WithinDesign', Whiteboosting);
P2=ranova(rm1); % Whiteboosting effect, P = 0.49979, F(2,32) = 0.71

t = table(transpose(mean(off_White_aro_all)),transpose(mean(mid_White_aro_all)),transpose(mean(high_White_aro_all)),'VariableNames',{'b1','b2','b3'});
Whiteboosting = (table([1,2,3]','VariableNames',{'Whiteboost'}));
rm2 = fitrm(t, 'b1-b3~1', 'WithinDesign', Whiteboosting);
P3=ranova(rm1); % Whiteboosting effect, F(2,32) = 0.59, F(2,32) = 0.59138, P=0.5595



ylim([1 6])
xlim([0 4])
xticks(1:1:3)
set(gca,'linewidth',1.5,'Fontsize',28),hold on;
xlabel('White boosting level')
xticklabels({'Off','Mid','High'})
%ylim([2 5.5])
yticks(2:1:5)
ylabel('Subjective rating')
%ylabel('Mean rating - arousal')
%ylabel('Mean rating - valence')
%legend([h1 h2 h3],'low','mid','high')
%legend([h1 h2 h3],'Negative','Neutral','Positive')
legend([h1 h2 h3],'vividness','valence','arousal')
%title('3 group divided by 14 paired image')
%saveas(gcf,"Behavior - Valence rating is different according to the vividness rating group.tiff")
saveas(gcf,"Behavior - Arousal rating is different according to the vividness rating group.tiff")



% only arousal plot
figure('Position',[500 700 800 500])
x=[1 2 3];
yel=[0.9 0.7 0];
hold on 
for subj = 1:17
    h3 = plot(1:3, White_arousal_allsubj(:,subj),'color',col,'linewidth',1.5);
    h3.Color(4) = 0.2;
    scatter(1:3, White_arousal_allsubj,10,'o','filled','markerFacecolor',col)
end
h3=plot(x,y3,'linewidth',3,'color',col)% vivid
e3=errorbar(1:3,y3, y3_std, 'linestyle','none','color',col,'linewidth',2,'Marker','o','Capsize',0,'Markersize',7)
e3.MarkerFaceColor = 'w';
e3.CapSize = 0;
ylim([1 6])
xlim([0 4])
xticks(1:1:3)
set(gca,'linewidth',1.5,'Fontsize',28),hold on;
xlabel('White boosting level')
xticklabels({'Off','Mid','High'})
%ylim([2 5.5])
yticks(2:1:5)
ylabel('Subjective rating')


%% Multiple linear regression
load("MLR image based Vividness EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat")
addpath '/Volumes/samba/Office/Users/chlim/LG_task/LG_permutation'
Block_behavior = {'Vivid'};
Block = {'Vivid'};
rep =1;
repeat = 1;
Vivid_rating_beta_allsubj(:,:,2) = [];
Vivid_rating_beta_m = mean(Vivid_rating_beta_allsubj,3);
P_all = [];
for ch = 1:31
    P_time = [];
    for time = 1:750
        %[R,P,ci,t] = ttest(Vivid_rating_beta_allsubj(ch,time,:));
        [R,P,ci,t] = eval("ttest("+Block_behavior(rep)+"_rating_beta_allsubj(ch,time,:))");
        P_time = [P_time , P];
    end
    P_all =[P_all ; P_time];
end


%col = [0.7 0.6 0.7]; %흐린 자주색
loc = 0;
grey = [0.5 0.5 0.5];
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.9 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for locate=1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))              
    hold on
    box on;
    title(CHlist(ch))
    eval("plot(epoch_time,"+Block_behavior(rep)+"_rating_beta_m(ch,:),'color','k','linewidth',1.5)");
    %plot(epoch_time,Vivid_rating_beta(1,:,ch),'color',col,'linewidth',2) 
    set(gca,'linewidth',1.5,'fontsize',16)
        
    xline(0)
    line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')
    xlim(x_lim_i)
    xticks([-400 0 400 800])
    xticklabels([-0.4 0 0.4 0.8])
    %xticks(x_ticks_i)
    %xticklabels(x_label_i)
    if ch ==1    
       %ylabel('\beta_1')
       %ylabel("Beta ("+Block_behavior(rep)+")")
       xlabel('Time(s)')
       %title(CHlist(ch)+"-"+Block{repeat}+" block EEG")
    end
%     end
    yline(0,'color','k','linestyle','--')
    xline(0)
    ylim([-0.30 0.20])
    yticks([-0.20 0 0.20])
    
    % for individual beta
     for time = 251:750
         if P_all(ch,time) < 0.001
             scatter(2*time - 500, -0.23,30,'o','filled','r')
         end
         
         if P_all(ch,time) < 0.01
             scatter(2*time - 500, -0.27,30,'o','filled','k')         
         end
%          if P_all(ch,time) < 0.05
%              scatter(2*time - 500, -0.27,30,'o','filled','markerFacecolor',grey)                 
%          end
     end
    % across subject beta
%     for time = 1:750
%         if Vivid_rating_P(1,time,ch) < 0.01
%             scatter(2*time - 500, -0.08,3,'*','r')
%         elseif Vivid_rating_P(1,time,ch) < 0.05
%             scatter(2*time - 500, -0.10,3,'*','k')
%         end
%     end
box off;
end
%saveas(gcf,"Multiple regression "+Block{repeat}+" EEG ~ "+Block_behavior(rep)+" individual beta and P value.tiff")
saveas(gcf,"31ch MLR "+Block{repeat}+" EEG ~ "+Block_behavior(rep)+" individual beta and P value box off2.tiff")
%saveas(gcf,"Multiple regression "+Block{repeat}+" EEG ~ 3 block ratings beta and P value.tiff")

%% Multiple linear regression, 3 betas plot
% plot 3 betas together
% colors{1} = [0 0 0]/255;
% colors{2} = [14 31 87]/255;
% colors{3} = [122 0 11]/255;
colors{1} = [20 31 120]/255;
colors{2} = [13 70 40]/255;
colors{3} = [122 0 11]/255;
load("MLR image based Vividness EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat")
Vivid_rating_beta_allsubj(:,:,4)= [];
Valence_rating_beta_allsubj(:,:,4)= [];
Arousal_rating_beta_allsubj(:,:,4)= [];

Vivid_rating_beta_m = mean(Vivid_rating_beta_allsubj,3,'omitnan');
Arousal_rating_beta_m = mean(Arousal_rating_beta_allsubj,3,'omitnan');
Valence_rating_beta_m = mean(Valence_rating_beta_allsubj,3,'omitnan');

Vivid_rating_beta_s = std(permute(Vivid_rating_beta_allsubj,[3 1 2]))/sqrt(17);
Vivid_rating_beta_s=permute(Vivid_rating_beta_s,[2 3 1]);

Arousal_rating_beta_s = std(permute(Arousal_rating_beta_allsubj,[3 1 2]))/sqrt(17);
Arousal_rating_beta_s=permute(Arousal_rating_beta_s,[2 3 1]);

Valence_rating_beta_s = std(permute(Valence_rating_beta_allsubj,[3 1 2]))/sqrt(17);
Valence_rating_beta_s=permute(Valence_rating_beta_s,[2 3 1]);

block = {'Vivid','Valence','Arousal'};
ch = 29;
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.9 0.5], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for block_num = 1:3
    subplot(1,3,block_num)
    %subplot(3,1,block_num)
       hold on
        box off;
        title(CHlist(ch))
        %eval("plot(epoch_time,"+block{block_num}+"_rating_beta_m(ch,:),'color',colors{"+num2str(block_num)+"},'linewidth',3)")
        eval("plot(epoch_time,"+block{block_num}+"_rating_beta_m(ch,:),'color','k','linewidth',3)")
        set(gca,'linewidth',1.5,'fontsize',28)       
     
    if block_num ==1

        sig_timepoint = [667:721];
        scatter(2*sig_timepoint-500,-0.1,150,'o','filled','k')
    end
    if block_num ==1
            k = shadedErrorBar(epoch_time,Vivid_rating_beta_m(ch,:),Vivid_rating_beta_s(ch,:), ...
                'lineProps', color_txt{block_num}, 'patchSaturation', 0.2, 'transparent', true); hold on
            set(k.edge,'Color',[1 1 1])
        end
        
        if block_num ==2
            k = shadedErrorBar(epoch_time,Valence_rating_beta_m(ch,:),Valence_rating_beta_s(ch,:), ...
                'lineProps', color_txt{block_num}, 'patchSaturation', 0.2, 'transparent', true); hold on
            set(k.edge,'Color',[1 1 1])
        end
        
        if block_num ==3
            k = shadedErrorBar(epoch_time,Arousal_rating_beta_m(ch,:),Arousal_rating_beta_s(ch,:), ...
                'lineProps', color_txt{block_num}, 'patchSaturation', 0.2, 'transparent', true); hold on
            set(k.edge,'Color',[1 1 1])
        end
    
     xlim(x_lim_i)
        xticks(x_ticks_i)
        xticklabels(x_label_i)
        %ylabel(['\beta_',num2str(block_num)])
        xlabel('Time (s)')
        yline(0,'color','k','linestyle','--')
        xline(0,'linestyle','--')
        ylim([-0.25 0.25])
        yticks([-0.20 0 0.20])
        
end
saveas(gcf,"three betas for multiple linear regression in vividness block only cluster p_figure - 17 subjects, Thresh_p 0.005.tiff")


%% Residual linear regression, 3 betas plot
col = [0.6 0.1 0.3];%붉은갈색
col = [0.9 0.7 0]; %붉은노란색
col = [0.7 0.6 0.7];%흐린자주
load("Residual image based MLR Valence EEG - Vivid subjective rating.- 31 channel individual beta.mat")
Valence_rating_beta_resi_allsubj = Vivid_rating_beta_resi_allsubj;
Valence_rating_beta_resi_allsubj(:,:,4) = [];
load("Residual image based MLR Arousal EEG - Vivid subjective rating.- 31 channel individual beta.mat")
Arousal_rating_beta_resi_allsubj = Vivid_rating_beta_resi_allsubj;
Arousal_rating_beta_resi_allsubj(:,:,4) = [];
load("Residual image based MLR Vivid EEG - Vivid subjective rating.- 31 channel individual beta.mat")
Vivid_rating_beta_resi_allsubj(:,:,4) = [];


% P_all = [];
% P_val_all=[];
% P_aro_all=[];
% for ch = 1:31
%     P_time = [];
%     P_time_val = [];
%     P_time_aro = [];
%     for time = 1:750
%         %[R,P,ci,t] = ttest(Vivid_rating_beta_allsubj(ch,time,:));
%         [R,P,ci,t] = ttest(Vivid_rating_beta_resi_allsubj(ch,time,:));
%         [R,P2,ci,t2] = ttest(Valence_rating_beta_resi_allsubj(ch,time,:));
%         [R,P3,ci,t3] = ttest(Arousal_rating_beta_resi_allsubj(ch,time,:));
%         %[R,P,ci,t] = eval("ttest("+Block_behavior(rep)+"_rating_beta_allsubj(ch,time,:))");
%         P_time = [P_time , P];
%         P_time_val = [P_time_val , P2];
%         P_time_aro = [P_time_aro , P3];
%     end
%     P_all =[P_all ; P_time];
%     P_val_all =[P_val_all ; P_time_val];
%     P_aro_all =[P_aro_all ; P_time_aro];
% end

% plot 3 betas together
% colors{1} = [0 0 0]/255;
% colors{2} = [14 31 87]/255;
% colors{3} = [122 0 11]/255;
% colors{1} = [20 31 120]/255;
% colors{2} = [13 70 40]/255;
% colors{3} = [122 0 11]/255;

colors{1} = [0 0 0];
colors{2} = [0 0 1];
colors{3} = [0.6 0.1 0.3];
Vivid_rating_beta_m = mean(Vivid_rating_beta_resi_allsubj,3,'omitnan');
Vivid_rating_beta_s = std(permute(Vivid_rating_beta_resi_allsubj,[3 1 2]))/sqrt(17);
Vivid_rating_beta_s=permute(Vivid_rating_beta_s,[2 3 1]);

Arousal_rating_beta_m = mean(Arousal_rating_beta_resi_allsubj,3,'omitnan');
Arousal_rating_beta_s = std(permute(Arousal_rating_beta_resi_allsubj,[3 1 2]))/sqrt(17);
Arousal_rating_beta_s=permute(Arousal_rating_beta_s,[2 3 1]);

Valence_rating_beta_m = mean(Valence_rating_beta_resi_allsubj,3,'omitnan');
Valence_rating_beta_s = std(permute(Valence_rating_beta_resi_allsubj,[3 1 2]))/sqrt(17);
Valence_rating_beta_s=permute(Valence_rating_beta_s,[2 3 1]);
color_txt{1} = 'k';
color_txt{2} = 'k';
color_txt{3} = 'k';
block = {'Vivid','Valence','Arousal'};
ch = 29;
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.9 0.5], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for block_num = 1:3
    subplot(1,3,block_num)
    %subplot(3,1,block_num)
       hold on
        box off;
        title(CHlist(ch))
        eval("plot(epoch_time,"+block{block_num}+"_rating_beta_m(ch,:),'color',colors{"+num2str(block_num)+"},'linewidth',3)")
        if block_num ==1
            k = shadedErrorBar(epoch_time,Vivid_rating_beta_m(ch,:),Vivid_rating_beta_s(ch,:), ...
                'lineProps', color_txt{block_num}, 'patchSaturation', 0.2, 'transparent', true); hold on
            set(k.edge,'Color',[1 1 1])
        end
        
        if block_num ==2
            k = shadedErrorBar(epoch_time,Valence_rating_beta_m(ch,:),Valence_rating_beta_s(ch,:), ...
                'lineProps', color_txt{block_num}, 'patchSaturation', 0.2, 'transparent', true); hold on
            set(k.edge,'Color',[1 1 1])
        end
        
        if block_num ==3
            k = shadedErrorBar(epoch_time,Arousal_rating_beta_m(ch,:),Arousal_rating_beta_s(ch,:), ...
                'lineProps', color_txt{block_num}, 'patchSaturation', 0.2, 'transparent', true); hold on
            set(k.edge,'Color',[1 1 1])
        end
        

        %eval("plot(epoch_time,"+block{block_num}+"_rating_beta_m(ch,:),'color','k','linewidth',3)")
        set(gca,'linewidth',1.5,'fontsize',28)       
     
    if block_num ==1
        sig_timepoint = [668:689];
        scatter(2*sig_timepoint-500,-0.1,150,'o','filled','k')
    end
    
    
     xlim(x_lim_i)
        xticks(x_ticks_i)
        xticklabels(x_label_i)
        %ylabel(['\beta_',num2str(block_num)])
        xlabel('Time (s)')
        ylabel('Residual beta')
        yline(0,'color','k','linestyle','--')
        xline(0,'linestyle','--')
        ylim([-0.25 0.25])
        yticks([-0.20 0 0.20])
        
end
saveas(gcf,"Residual three betas for multiple linear regression in vividness block only cluster p_figure.tiff")


%% Multiple linear regression, 3 betas plot, 17 individuals, thresh_p = 0.005
load("Significant cluster image based linear regression Vivid EEG ~ Vividness - 17 subjects - thresh_p_0.005.mat")
Sig_pos_ch_time_info_all = [];
for i=1:size(Sig_clust_pos,2)
    Pos_ch_info = Sig_clust_pos(i).channel;
    Pos_time_info = Sig_clust_pos(i).time;
    Sig_pos_ch_time_info = [Pos_ch_info,Pos_time_info];
    Sig_pos_ch_time_info_all =[Sig_pos_ch_time_info_all;Sig_pos_ch_time_info]; 
    pos_channels = unique(Sig_pos_ch_time_info_all(:,1));
end
Sorted_ch_time_info = sortrows(Sig_pos_ch_time_info_all);

block_num = 0;

colors{1} = [20 31 120]/255;
colors{2} = [13 70 40]/255;
colors{3} = [122 0 11]/255;
load("MLR image based Vividness EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat")
Vivid_rating_beta_allsubj(:,:,4)= [];
Valence_rating_beta_allsubj(:,:,4)= [];
Arousal_rating_beta_allsubj(:,:,4)= [];

Vivid_rating_beta_m = mean(Vivid_rating_beta_allsubj,3,'omitnan');
Arousal_rating_beta_m = mean(Arousal_rating_beta_allsubj,3,'omitnan');
Valence_rating_beta_m = mean(Valence_rating_beta_allsubj,3,'omitnan');

Vivid_rating_beta_s = std(permute(Vivid_rating_beta_allsubj,[3 1 2]))/sqrt(17);
Vivid_rating_beta_s=permute(Vivid_rating_beta_s,[2 3 1]);

Arousal_rating_beta_s = std(permute(Arousal_rating_beta_allsubj,[3 1 2]))/sqrt(17);
Arousal_rating_beta_s=permute(Arousal_rating_beta_s,[2 3 1]);

Valence_rating_beta_s = std(permute(Valence_rating_beta_allsubj,[3 1 2]))/sqrt(17);
Valence_rating_beta_s=permute(Valence_rating_beta_s,[2 3 1]);

block = {'Vivid','Valence','Arousal'};
color_txt{1} = 'k';
color_txt{2} = 'k';
color_txt{3} = 'k';
color_txt{4} = 'k';
subplot_loc = 0;
block_num = 1;
pos_channels = sortrows(pos_channels);
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.4 0.8], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for ch = transpose(pos_channels)
    subplot_loc = subplot_loc + 1;
    
    subplot(3,1,subplot_loc)
    %subplot(3,1,block_num)
    hold on
    box off;
    title(CHlist(ch))
    %eval("plot(epoch_time,"+block{block_num}+"_rating_beta_m(ch,:),'color',colors{"+num2str(block_num)+"},'linewidth',3)")
    eval("plot(epoch_time,"+block{block_num}+"_rating_beta_m(ch,:),'color','k','linewidth',3)")
    set(gca,'linewidth',1.5,'fontsize',28)
    
    %plot significant cluster
    loc = find(ch == Sorted_ch_time_info(:,1));
    sig_timepoint = Sorted_ch_time_info(loc,2);
    scatter(2*sig_timepoint-500,-0.1,150,'o','filled','k')
    
    %shaded s.e.m
    k = shadedErrorBar(epoch_time,Vivid_rating_beta_m(ch,:),Vivid_rating_beta_s(ch,:), ...
        'lineProps', color_txt{1}, 'patchSaturation', 0.2, 'transparent', true); hold on
    set(k.edge,'Color',[1 1 1])    
    
    
    xlim(x_lim_i)
    x_ticks = [-400 0 400 800];       
    x_label = [-0.4000 0 0.4000 0.8000];
    xticks(x_ticks)
    xticklabels(x_label)
    %ylabel(['\beta_',num2str(block_num)])
    xlabel('Time (s)')
    yline(0,'color','k','linestyle','--')
    xline(0,'linestyle','--')
    ylim([-0.25 0.25])
    yticks([-0.20 0 0.20])
    
end
saveas(gcf,"S6b.Multiple linear regression vividness representation in 3 significant channels.tiff")




%% Residual regression, 4 betas plot, 17 individuals, thresh_p = 0.005
load("Significant cluster image based linear regression Vivid EEG ~ Vividness - 17 subjects - thresh_p_0.005.mat")
Sig_pos_ch_time_info_all = [];
for i=1:size(Sig_clust_pos,2)
    Pos_ch_info = Sig_clust_pos(i).channel;
    Pos_time_info = Sig_clust_pos(i).time;
    Sig_pos_ch_time_info = [Pos_ch_info,Pos_time_info];
    Sig_pos_ch_time_info_all =[Sig_pos_ch_time_info_all;Sig_pos_ch_time_info]; 
    pos_channels = unique(Sig_pos_ch_time_info_all(:,1));
end
Sorted_ch_time_info = sortrows(Sig_pos_ch_time_info_all);

colors{1} = [20 31 120]/255;
colors{2} = [13 70 40]/255;
colors{3} = [122 0 11]/255;
load("Residual image based MLR Vivid EEG - Vivid subjective rating.- 31 channel individual beta.mat.")
Vivid_rating_beta_resi_allsubj(:,:,4)= [];
Vivid_rating_beta_resi_m = mean(Vivid_rating_beta_resi_allsubj,3,'omitnan');
Vivid_rating_beta_resi_s = std(permute(Vivid_rating_beta_resi_allsubj,[3 1 2]))/sqrt(17);
Vivid_rating_beta_resi_s=permute(Vivid_rating_beta_resi_s,[2 3 1]);

block = {'Vivid','Valence','Arousal'};
color_txt{1} = 'k';
color_txt{2} = 'k';
color_txt{3} = 'k';
color_txt{4} = 'k';
subplot_loc = 0;
block_num = 1;
pos_channels = sortrows(pos_channels);
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.9 0.8], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for ch = transpose(pos_channels)
    subplot_loc = subplot_loc + 1;
    
    subplot(2,2,subplot_loc)
    %subplot(3,1,block_num)
    hold on
    box off;
    title(CHlist(ch))
    %eval("plot(epoch_time,"+block{block_num}+"_rating_beta_m(ch,:),'color',colors{"+num2str(block_num)+"},'linewidth',3)")
    eval("plot(epoch_time,"+block{block_num}+"_rating_beta_resi_m(ch,:),'color','k','linewidth',3)")
    set(gca,'linewidth',1.5,'fontsize',28)
    
    %plot significant cluster
    loc = find(ch == Sorted_ch_time_info(:,1));
    sig_timepoint = Sorted_ch_time_info(loc,2);
    scatter(2*sig_timepoint-500,-0.1,150,'o','filled','k')
    
    %shaded s.e.m
    k = shadedErrorBar(epoch_time,Vivid_rating_beta_resi_m(ch,:),Vivid_rating_beta_resi_s(ch,:), ...
        'lineProps', color_txt{1}, 'patchSaturation', 0.2, 'transparent', true); hold on
    set(k.edge,'Color',[1 1 1])    
    
    
    xlim(x_lim_i)
    x_ticks = [-400 0 400 800];       
    x_label = [-0.4000 0 0.4000 0.8000];
    xticks(x_ticks)
    xticklabels(x_label)
    %ylabel(['\beta_',num2str(block_num)])
    xlabel('Time (s)')
    yline(0,'color','k','linestyle','--')
    xline(0,'linestyle','--')
    ylim([-0.25 0.25])
    yticks([-0.20 0 0.20])
    
end
saveas(gcf,"Fig.S7.Residual linear regression vividness representation in 4 significant channels.tiff")











