%Fig. S7
addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation/Supple_figure
load("Significant cluster image based residual regression Vivid EEG ~ Vividness - 17 subjects - thresh_p_0.005.mat")
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
addpath /Volumes/samba/Office/Users/chlim/LG_task/LG_permutation
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
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.2 0.8], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
for ch = transpose(pos_channels)
    subplot_loc = subplot_loc + 1;
    
    subplot(3,1,subplot_loc)
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
    ylabel(['\beta_',num2str(block_num)])
    xlabel('Time (s)')
    yline(0,'color','k','linestyle','--')
    xline(0,'linestyle','--')
    ylim([-0.25 0.25])
    yticks([-0.20 0 0.20])
    
end
saveas(gcf,"Fig.S7.Residual linear regression vividness representation in 4 significant channels.tiff")



%3 Columns, 1 row

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
    ylabel(['\beta_',num2str(block_num)])
    xlabel('Time (s)')
    yline(0,'color','k','linestyle','--')
    xline(0,'linestyle','--')
    ylim([-0.25 0.25])
    yticks([-0.20 0 0.20])
    
end
saveas(gcf,"Fig.S7.Residual linear regression vividness representation in 3 significant channels width 0.6 height 0.4.tiff")
