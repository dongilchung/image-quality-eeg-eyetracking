%Supple_6ab
%S6a: 31 channel Multiple linear regression beta1 (vividness rating) ~ EEG
addpath '/Volumes/samba/Office/Users/chlim/LG_task/LG_permutation'
load("MLR image based Vividness EEG ~ Vivid + Arousal + Valence subjective rating - 31 channel 18 individual_all block.mat")

Block_behavior = {'Vivid'};
Block = {'Vivid'};
rep =1;
repeat = 1;
Vivid_rating_beta_allsubj(:,:,4) = [];
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
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.5 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
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
     if ch ==1    
       xlabel('Time(s)')
     end
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
     end
 
box off;
end
saveas(gcf,"S6a. 31ch MLR in Vivid EEG ~ beta 1 width 0.5.tiff")



%% S6b: Multiple linear regression, EEG ~ beta1 (vividness rating), 17 individuals, thresh_p = 0.005
addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation/Supple_figure
addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation
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


block = {'Vivid','Valence','Arousal'};
color_txt{1} = 'k';
color_txt{2} = 'k';
color_txt{3} = 'k';
color_txt{4} = 'k';
subplot_loc = 0;
block_num = 1;
pos_channels = sortrows(pos_channels);
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.2 0.8], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
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
    ylabel(['\beta_',num2str(block_num)])
    xlabel('Time (s)')
    yline(0,'color','k','linestyle','--')
    xline(0,'linestyle','--')
    ylim([-0.25 0.25])
    yticks([-0.20 0 0.20])
    
end
saveas(gcf,"Fig.S6b:Multiple linear regression vividness representation in 3 significant channels width 0.2 hegiht 0.8.tiff")




%1 row, 3 columns
block = {'Vivid','Valence','Arousal'};
color_txt{1} = 'k';
color_txt{2} = 'k';
color_txt{3} = 'k';
color_txt{4} = 'k';
subplot_loc = 0;
block_num = 1;
pos_channels = sortrows(pos_channels);
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.6 0.4], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for ch = transpose(pos_channels)
    subplot_loc = subplot_loc + 1;
    
    subplot(1,3,subplot_loc)
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
    ylabel(['\beta_',num2str(block_num)])
    xlabel('Time (s)')
    yline(0,'color','k','linestyle','--')
    xline(0,'linestyle','--')
    ylim([-0.25 0.25])
    yticks([-0.20 0 0.20])
    
end
saveas(gcf,"Fig.S6b:Multiple linear regression vividness representation in 3 significant channels width 0.6 hegiht 0.4.tiff")

