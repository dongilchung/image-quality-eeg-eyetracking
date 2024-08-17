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

% Supple 2a, White-boosting 3 ERP across three blocks, 31 channels, rmanova plot
%rmanova
load("White boosting condtion for all block.mat")
Whiteboosting = (table([1,2,3]','VariableNames',{'Whiteboost'}));
P_rm_white=[]; 
for ch = 1:31       
    for time=251:750
        y1 = permute(IAPS_noboost_ERP_allsubj(ch,time,:),[3,1,2]);
        y2 = permute(IAPS_lowboost_ERP_allsubj(ch,time,:),[3,1,2]);
        y3 = permute(IAPS_highboost_ERP_allsubj(ch,time,:),[3,1,2]);
        t = table(y1,y2,y3,'VariableNames',{'b1','b2','b3'});
        rm1 = fitrm(t, 'b1-b3~1', 'WithinDesign', Whiteboosting);
        P1=ranova(rm1);
        P_rm_white(ch,time-250) = table2array(P1(1,5));
                     
    end
end
save("Rmanova p value for White-boosting effect across 3 blocks.mat","P_rm_white")

grey = [0.7 0.7 0.7]; green_subjopt = [154,216,50]/256; blue_SV = [0.5 0.1 1];
pink = [1 0.4 0.9];
pink2 = [0.5 0.5 1];
color_rating_class{1} = [1 0 0]; % red
color_rating_class{2} = [255 192 0] / 255; % orange
color_rating_class{3} = [127 127 127] /255; % grey

load("Significant cluster White boosting effect across block.mat")

%Draw 31 channels of White-boosting 3 condition ERPS
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.45 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);

for locate = 1:31
    ch=Ch_brain(plot_index(locate));
    subplot(7,7,plot_index(locate))               
    hold on
    xline(0,'linestyle','--')    
    line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')

    %xline(0,'linewidth',1,'linestyle','--','Color','k')
    %line(xlim(),[0,0],'LineWidth', 1,'Color','k','LineStyle','--')       
    
    h3=plot(epoch_time,mean(IAPS_noboost_ERP_allsubj(ch,:,:),3,'omitnan'),'linewidth',1.5,'color',color_rating_class{3});        
    h2=plot(epoch_time,mean(IAPS_lowboost_ERP_allsubj(ch,:,:),3,'omitnan'),'linewidth',1.5,'color',color_rating_class{2});
    h1 = plot(epoch_time,mean(IAPS_highboost_ERP_allsubj(ch,:,:),3,'omitnan'),'linewidth',1.5,'color',color_rating_class{1});  
    %h2.Color(4) = 0.7;    
    set(gca,'linewidth',1.5,'fontsize',16)
    title(CHlist(ch));     
  
%     xline(0,'linestyle','--')    
%     line(xlim(),[0,0],'LineWidth', 1,'Color','black','LineStyle','--')
    box off;               
 
    if locate == 1     
        ylabel('Amplitude (µV)')        
        xlabel('Time (s)')
    end    

%     %need anova
%     Row = find(Sig_pos_ch_time_info(:,1) == ch);
%     Time = Sig_pos_ch_time_info(Row,2);
%     scatter(2*Time-500,-2.5,150,'o','filled','k')
   
     for time=1:500
        P = P_rm_white(ch,time);
          if P <= 0.001
             scatter(2*time,-2.8,30,'o','filled','r')
         end
%       
        if P <= 0.01
            scatter(2*time,-3.8,30,'o','filled','k')
        end
%         
%         if P <= 0.05
%             s=scatter(2*time-500,-3,50,'o','filled');
%             s.CData = [0.5 0.5 0.5];
%         end
 
    end
%     for time=251:700
%         P = Ancova_Whiteboost_P(ch,time-250);
%         if P <= 0.01
%             scatter(2*time-500,-3,3,'*','r')
%         elseif P <= 0.05
%             scatter(2*time-500,-4,3,'*','k')
%         end
%     end
    ylim([-4.2 4.2])
    yticks([-3 0 3])
    xlim(x_lim_i)    
    xticks([-400 0 400 800])
    xticklabels([-0.4 0 0.4 0.8])      
end
%saveas(gcf,"try5.png")
saveas(gcf,"Fig.S2a:White-boosting 3 ERPs across three blocks with rmanova width 0.45 height 1.tiff")


%S2b. 31 channels Whiteboost Ancova F value 
grey = [0.5 0.5 0.5];
figure('NumberTitle', 'off','units','normalized','outerposition',[0 0 0.45 1], 'Name', [epoch_name,' ERP_vivid_3 image rating levels']);
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
saveas(gcf,"Fig.S2b: 31 ch Ancova whiteboost main effect_color change width 0.45 height 1.tiff")
