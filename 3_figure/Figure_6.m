%Figure_6_Vividness_effect_3ERP and topoplot
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

load("3 group divided by 14 paired stimuli different image between subject_vividness block_4,10 subj except.mat")

color_rating_class{1} = [203 207 246]/255;
color_rating_class{2} = [120 157 251]/255; %[150 110 160]/255;
color_rating_class{3} = [0 0 1]             %blue_SV %[208 67 76]/255;
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.3 0.5], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);

ch = 29;
hold on
plot(epoch_time,dull_ERP(ch,:),'linewidth',4,'color',color_rating_class{1})
hold on
%errorbar(epoch_time,dull_ERP(ch,:),dull_ERP_s(ch,:),'linewidth',2,'color',color_rating_class{1},'linestyle','none','Capsize',0)
plot(epoch_time,mid_ERP(ch,:),'linewidth',4,'color',color_rating_class{2})
%errorbar(epoch_time,mid_ERP(ch,:),mid_ERP_s(ch,:),'linewidth',2,'color',color_rating_class{2},'linestyle','none','Capsize',0)
plot(epoch_time,vivid_ERP(ch,:),'linewidth',4,'color',color_rating_class{3})
box off;
set(gca,'linewidth',1.5,'fontsize',28)

ylabel('Event related potential')
xlabel('Time(s)')
title(CHlist(ch))
ylim([-4 4])
yticks([-3 0 3])
xline(0,'linestyle','--')
line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')
xlim(x_lim_i)
xticks(x_ticks_i)
xticklabels(x_label_i)
ylim([-4 4])
yticks([-3 0 3])

%saveas(gcf,"Dull,mid,vivid 3 rating groups in arousal block FC2 3 ERP blue.tiff")
saveas(gcf,"Fig.6A: Dull,mid,vivid 3 rating groups in vividness block in F4 channel 3 ERP.tiff")

%% Fig 6B. Multiple Linear regression in F4, 3betas with cluster based result plot
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



%% Topoplot MLR betas, testing the average of beta is different with zero
load("MLR image based Vividness EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat")
load("Significant cluster image based in Multiple Vivid EEG ~ Vividness.mat")

Vivid_rating_beta_allsubj(:,:,4) = [];
t_all = [];
for ch = 1:31
    t_time = [];
    for time = 1:750
        [R,P,ci,t] = ttest(Vivid_rating_beta_allsubj(ch,time,:));
        t_time = [t_time , t.tstat];
    end
    t_all = [t_all ; t_time];
end
Sig_pos_ch_time_info_all=[];
for i=1:size(Sig_clust_pos,2)
    Pos_ch_info = Sig_clust_pos(i).channel;
    Pos_time_info = Sig_clust_pos(i).time;
    Sig_pos_ch_time_info = [Pos_ch_info,Pos_time_info];
    Sig_pos_ch_time_info_all =[Sig_pos_ch_time_info_all;Sig_pos_ch_time_info]; 
    pos_channels = unique(Sig_pos_ch_time_info(:,1));

end
%Arousal ~ Arousal timepoint 438~608,  462~737 399~750
%2*438-500=376, 2*608-500 = 716
Timepointindex = [236 536 836];
for timepoint = Timepointindex
    % topoplot 그리기
    figure;
    topoplot(t_all(:, 250+timepoint/2), EEG.chanlocs, 'style', 'map', 'electrodes', 'labels');
    %colormap(cmap); % colormap을 설정합니다.
    set(gca,'linewidth',1.5,'fontsize',20)
    %title(Block(repeat)+" EEG - Valence behavior paired t test- "+num2str(timepoint * 2 - 500)+"ms"); % 그래프 제목을 지정합니다.
    %title("T value from multiple linear regression beta- "+num2str(timepoint * 2 - 500)+"ms",'fontsize',16); % 그래프 제목을 지정합니다.
    caxis([-4, 4])
    % 범례 추가
    
    if timepoint ==836
        c = colorbar;
        c.Label.String = 'T-Statistic';       
        c.Ticks = [-4, 0, 4]
    end
    %saveas(gcf,"topoplot, White boosting t stat"+Block(repeat)+" - "+num2str(timepoint)+"ms.tiff")
    %saveas(gcf,"topoplot, Multiple Arousal t stat"+num2str(timepoint)+"ms.tiff")
    saveas(gcf,"Fig.6C: topoplot, MLR image based vividness ~ vivid rating "+num2str(timepoint)+"ms.tiff")
end
