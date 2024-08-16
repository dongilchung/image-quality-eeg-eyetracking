%% Fig.4A
file_Path='/Volumes/samba/Office/Users/chlim/LG_task/EEG_preprocessed_data';
addpath '/Volumes/samba/Office/Users/chlim/LG_task/EEG_preprocessed_data'
addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation/Script

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

Sig_ch = [2,7,8];
grey = [0.7 0.7 0.7]; green_subjopt = [154,216,50]/256; blue_SV = [0.5 0.1 1];
pink = [1 0.4 0.9];
pink2 = [0.5 0.5 1];
color_rating_class{1} = [1 0 0]; % red
color_rating_class{2} = [255 192 0] / 255; % orange
color_rating_class{3} = [127 127 127] /255; % grey

load("White boosting condtion for all block.mat")
load("Significant cluster White boosting effect across block.mat")


Sig_pos_ch_time_info_all=[];
for i=1:size(Sig_clust_pos,2)
    Pos_ch_info = Sig_clust_pos(i).channel;
    Pos_time_info = Sig_clust_pos(i).time;
    Sig_pos_ch_time_info = [Pos_ch_info,Pos_time_info];
    Sig_pos_ch_time_info_all =[Sig_pos_ch_time_info_all;Sig_pos_ch_time_info];
    pos_channels = unique(Sig_pos_ch_time_info(:,1));
end
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
saveas(gcf,"Fig.4A: Significant Cluster to show whiteboosting effect Fz, FC1, C3 ERP across 3 blocks.tiff")

%% Fig.4B
file_Path='/Volumes/samba/Office/Users/chlim/LG_task/EEG_preprocessed_data';
addpath '/Volumes/samba/Office/Users/chlim/LG_task/EEG_preprocessed_data'
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

sig_ch = [2,7,8];

sig_timepoint = cell(1,3);
loc = 0;
for ch = sig_ch
    loc = loc +1;
    sig_timepoint{loc} = transpose(find(Ancova_Whiteboost_P(ch,:) <= 0.05));
end

custom_colormap = [0 1 0; 1 0 0];
Timepointindex = [100,256, 412];
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
    caxis([-10 10])
    if loc == 3
        c = colorbar;    
        caxis([-10 10]);
        c.Label.String = 'F-Statistic';
    end
    %saveas(gcf,"Fig.4B:topoplot, Ancova White boosting main effect - "+num2str(timepoint)+" ms.tiff")
    %saveas(gcf,"Fig.4B:topoplot, Multiple Arousal t stat"+ num2str(500-2*timepoint)+"ms.tiff")
end

