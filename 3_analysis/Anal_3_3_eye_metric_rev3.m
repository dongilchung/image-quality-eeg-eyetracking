clear
clc

%% load rawdat file
load('LGE_pilot_rawdat.mat');
load('parseTab.mat');
% load(['edfDat_' num2str(idx_edf)]);

rawTab = RawDat.rawTab;
edfTab = RawDat.edfTab;
clear RawDat

edfList = unique(parseTab.idx_edf)';
nTrial = max(parseTab.trial);


%% saccade metric
saccTab = [];
disp('saccade')
for e = 1:length(edfList)
    disp([num2str(e) ' / ' num2str(length(edfList))]); tic;
    load(['edfDat_' num2str(edfList(e))]);
    sacc_tmp = edfDat.Events.Esacc;
    
    % preprocessing: filtering saccade only inside the screen
    if e <= 12, display_px = [3840 2160];
    else, display_px = [1920 1080]; end
    in_idx = sacc_tmp.posX > 0 & sacc_tmp.posX < display_px(1) ...
        & sacc_tmp.posXend > 0 & sacc_tmp.posXend < display_px(1) ...
        & sacc_tmp.posY > 0 & sacc_tmp.posY < display_px(2) ...
        & sacc_tmp.posYend > 0 & sacc_tmp.posYend < display_px(2);
    
    sacc_tmp.eye = sacc_tmp.eye(in_idx);
    sacc_tmp.start = sacc_tmp.start(in_idx);
    sacc_tmp.end = sacc_tmp.end(in_idx);
    sacc_tmp.duration = sacc_tmp.duration(in_idx);
    sacc_tmp.pvel = sacc_tmp.pvel(in_idx);
    sacc_tmp.posX = sacc_tmp.posX(in_idx);
    sacc_tmp.posY = sacc_tmp.posY(in_idx);
    sacc_tmp.posXend = sacc_tmp.posXend(in_idx);
    sacc_tmp.posYend = sacc_tmp.posYend(in_idx);
    
    [~,~,in_idx] = outlier_filter(sacc_tmp.duration, 3);
    sacc_tmp.eye = sacc_tmp.eye(in_idx);
    sacc_tmp.start = sacc_tmp.start(in_idx);
    sacc_tmp.end = sacc_tmp.end(in_idx);
    sacc_tmp.duration = sacc_tmp.duration(in_idx);
    sacc_tmp.pvel = sacc_tmp.pvel(in_idx);
    sacc_tmp.posX = sacc_tmp.posX(in_idx);
    sacc_tmp.posY = sacc_tmp.posY(in_idx);
    sacc_tmp.posXend = sacc_tmp.posXend(in_idx);
    sacc_tmp.posYend = sacc_tmp.posYend(in_idx);
    
    for t =1:nTrial
        idx = parseTab.idx_edf == edfList(e) & parseTab.trial == t;
        sttime = double(parseTab.sttime_onset(idx));
        idxtime = double(parseTab.idx_onset(idx));
        
        if t == nTrial
            m_flags = find(strcmp(edfDat.Events.Messages.info, ['stimOff_' num2str(nTrial)])==1);
            m_idx = double(m_flags(end));
            sttime_next = double(edfDat.Events.Messages.time(m_idx));
            idxtime_next = find(edfDat.Samples.time == sttime_next);
            
        else
            idx_next = parseTab.idx_edf == edfList(e) & parseTab.trial == t+1;
            sttime_next = double(parseTab.sttime_onset(idx_next));
            idxtime_next = double(parseTab.idx_onset(idx_next));
        end
        
        idx_sacc = sacc_tmp.start > sttime & sacc_tmp.start < sttime_next;
        curr_eye = sacc_tmp.eye(idx_sacc);
        curr_duration = double(sacc_tmp.duration(idx_sacc));
        curr_pvel = double(sacc_tmp.pvel(idx_sacc));

        
        curr_ampl = double(sqrt((sacc_tmp.posXend - sacc_tmp.posX).^2 + (sacc_tmp.posYend - sacc_tmp.posY).^2));
        if e <= 12 % ampl unit px to degree (screen resolution: [3840 2160])
            viewing_distance = 127.5;
            display_x_cm = 121;
            display_x_px = 3840;
            
            cm_per_px = display_x_cm/display_x_px;
            curr_ampl = curr_ampl * ( 2 * atand(cm_per_px/(2*viewing_distance)) );
            
        else % screen resolution: [1920 1080]
            viewing_distance = 127.5;
            display_x_cm = 121;
            display_x_px = 1920;
            
            cm_per_px = display_x_cm/display_x_px;
            curr_ampl = curr_ampl * ( 2 * atand(cm_per_px/(2*viewing_distance)) );
        end
        
        idx_left = strcmp(curr_eye,'LEFT');
        idx_right = strcmp(curr_eye,'RIGHT');
        
        SaccRate_left = nansum(idx_left)/((sttime_next - sttime)/1000);
        SaccRate_right = nansum(idx_right)/((sttime_next - sttime)/1000);

        SaccPvel_left = nanmean(curr_pvel(idx_left));
        SaccPvel_right = nanmean(curr_pvel(idx_right));
        
        SaccAmpl_left = nanmean(curr_ampl(idx_left));
        SaccAmpl_right = nanmean(curr_ampl(idx_right));
        
        
        % For Duration
        idx_left = strcmp(sacc_tmp.eye,'LEFT');
        idx_right = strcmp(sacc_tmp.eye,'RIGHT');

        sacc_L.start = sacc_tmp.start(idx_left);
        sacc_L.end = sacc_tmp.end(idx_left);
        sacc_L.duration = sacc_tmp.duration(idx_left);

        sacc_R.start = sacc_tmp.start(idx_right);
        sacc_R.end = sacc_tmp.end(idx_right);
        sacc_R.duration = sacc_tmp.duration(idx_right);
        
        % Left Eye
        idx_sacc_L = find(sacc_L.start > sttime & sacc_L.start < sttime_next);
        curr_dur_L = double(sacc_L.duration(idx_sacc_L));
        
            % consider prev sacc
            prev_sacc_L_idx = sacc_L.start < sttime & sacc_L.end > sttime;
            if sum(prev_sacc_L_idx) > 0
                if sacc_L.end(prev_sacc_L_idx) < sttime_next
                    prev_sacc_L_dur = sacc_L.end(prev_sacc_L_idx) - sttime;
                else
                    prev_sacc_L_dur = sttime_next-sttime;
                end
                curr_dur_L = [prev_sacc_L_dur curr_dur_L];
            end
            
            % consider last sacc
            if ~isempty(idx_sacc_L)
                last_sacc_L_start = double(sacc_L.start(idx_sacc_L(end)));
                last_sacc_L_end = double(sacc_L.end(idx_sacc_L(end)));
                if last_sacc_L_end > sttime_next
                    last_sacc_L_dur = sttime_next - last_sacc_L_start;
                    curr_dur_L(end) = last_sacc_L_dur;
                end
            end

         % Right Eye
         idx_sacc_R = find(sacc_R.start > sttime & sacc_R.start < sttime_next);
         curr_dur_R = double(sacc_R.duration(idx_sacc_R));
        
            % consider prev sacc
            prev_sacc_R_idx = sacc_R.start < sttime & sacc_R.end > sttime;
            if sum(prev_sacc_R_idx) > 0
                if sacc_R.end(prev_sacc_R_idx) < sttime_next
                    prev_sacc_R_dur = sacc_R.end(prev_sacc_R_idx) - sttime;
                else
                    prev_sacc_R_dur = sttime_next-sttime;
                end
                curr_dur_R = [prev_sacc_R_dur curr_dur_R];
            end
            
            % consider last sacc
            if ~isempty(idx_sacc_R)
                last_sacc_R_start = double(sacc_R.start(idx_sacc_R(end)));
                last_sacc_R_end = double(sacc_R.end(idx_sacc_R(end)));
                if last_sacc_R_end > sttime_next
                    last_sacc_R_dur = sttime_next - last_sacc_R_start;
                    curr_dur_R(end) = last_sacc_R_dur;
                end
            end
        
         SaccDur_left = nanmean(curr_dur_L);
         SaccDur_right = nanmean(curr_dur_R);
        
        idx_rawTab = rawTab.sub == edfTab.sub(edfList(e)) & rawTab.task == edfTab.task(edfList(e)) & rawTab.trial == t;
        saccTab = [saccTab; edfTab.sub(edfList(e)) edfTab.task(edfList(e)) double(t) ...
            rawTab.rating(idx_rawTab) rawTab.valence(idx_rawTab) rawTab.white_boosting(idx_rawTab) ...
            rawTab.color_gamut(idx_rawTab) rawTab.IAPS_number(idx_rawTab) ...
            SaccRate_left SaccRate_right SaccDur_left SaccDur_right SaccPvel_left SaccPvel_right  SaccAmpl_left  SaccAmpl_right ...
            ];
    end
    
    toc
end

saccTab = array2table(saccTab);
saccTab.Properties.VariableNames = {'sub', 'task', 'trial', ...
    'rating', 'valence', 'white_boosting', 'color_gamut', 'IAPS_number', ...
    'SaccFreq_L', 'SaccFreq_R', 'SaccDur_L', 'SaccDur_R', 'SaccPvel_L', 'SaccPvel_R', 'SaccAmpl_L', 'SaccAmpl_R'};


%% blink metric
blinkTab = [];
disp('blink')
for e = 1:length(edfList)
    disp([num2str(e) ' / ' num2str(length(edfList))]); tic;
    load(['edfDat_' num2str(edfList(e))]);
    blink_tmp = edfDat.Events.Eblink;
    
    % preprocessing: filtering blink
    [~,~,in_idx] = outlier_filter(blink_tmp.duration, 3);
    blink_tmp.eye = blink_tmp.eye(in_idx);
    blink_tmp.start = blink_tmp.start(in_idx);
    blink_tmp.end = blink_tmp.end(in_idx);
    blink_tmp.duration = blink_tmp.duration(in_idx);
    
    idx_left = strcmp(blink_tmp.eye,'LEFT');
    idx_right = strcmp(blink_tmp.eye,'RIGHT');
    
    blink_L.start = blink_tmp.start(idx_left);
    blink_L.end = blink_tmp.end(idx_left);
    blink_L.duration = blink_tmp.duration(idx_left);
    
    blink_R.start = blink_tmp.start(idx_right);
    blink_R.end = blink_tmp.end(idx_right);
    blink_R.duration = blink_tmp.duration(idx_right);
    
    for t =1:nTrial
        idx = parseTab.idx_edf == edfList(e) & parseTab.trial == t;
        sttime = double(parseTab.sttime_onset(idx));
        idxtime = double(parseTab.idx_onset(idx));
        
        if t == nTrial
            m_flags = find(strcmp(edfDat.Events.Messages.info, ['stimOff_' num2str(nTrial)])==1);
            m_idx = double(m_flags(end));
            sttime_next = double(edfDat.Events.Messages.time(m_idx));
            idxtime_next = find(edfDat.Samples.time == sttime_next);
        else
            idx_next = parseTab.idx_edf == edfList(e) & parseTab.trial == t+1;
            sttime_next = double(parseTab.sttime_onset(idx_next));
            idxtime_next = double(parseTab.idx_onset(idx_next));
        end
        
        
        % Left Eye
        idx_blink_L = find(blink_L.start > sttime & blink_L.start < sttime_next);
        curr_dur_L = double(blink_L.duration(idx_blink_L));
            
            % consider prev blink
            prev_blink_L_idx = blink_L.start < sttime & blink_L.end > sttime;
            if sum(prev_blink_L_idx) > 0
                if blink_L.end(prev_blink_L_idx) < sttime_next
                    prev_blink_L_dur = blink_L.end(prev_blink_L_idx) - sttime;
                else
                    prev_blink_L_dur = sttime_next-sttime;
                end
                curr_dur_L = [prev_blink_L_dur curr_dur_L];
            end
            
            % consider last blink
            if ~isempty(idx_blink_L)
                last_blink_L_start = double(blink_L.start(idx_blink_L(end)));
                last_blink_L_end = double(blink_L.end(idx_blink_L(end)));
                if last_blink_L_end > sttime_next
                    last_blink_L_dur = sttime_next - last_blink_L_start;
                    curr_dur_L(end) = last_blink_L_dur;
                end
            end
        
         BlinkRate_left = length(idx_blink_L)/((sttime_next - sttime)/1000);
         BlinkDur_left = nanmean(curr_dur_L);
         
         
        % Right Eye        
        idx_blink_R = find(blink_R.start > sttime & blink_R.start < sttime_next);
        curr_dur_R = double(blink_R.duration(idx_blink_R));
            
            % consider prev blink
            prev_blink_R_idx = blink_R.start < sttime & blink_R.end > sttime;
            if sum(prev_blink_R_idx) > 0
                if blink_R.end(prev_blink_R_idx) < sttime_next
                    prev_blink_R_dur = blink_R.end(prev_blink_R_idx) - sttime;
                else
                    prev_blink_R_dur = sttime_next-sttime;
                end
                curr_dur_R = [prev_blink_R_dur curr_dur_R];
            end
            
            % consider last blink
            if ~isempty(idx_blink_R)
                last_blink_R_start = double(blink_R.start(idx_blink_R(end)));
                last_blink_R_end = double(blink_R.end(idx_blink_R(end)));
                if last_blink_R_end > sttime_next
                    last_blink_R_dur = sttime_next - last_blink_R_start;
                    curr_dur_R(end) = last_blink_R_dur;
                end
            end
        
        BlinkRate_right = length(idx_blink_R)/((sttime_next - sttime)/1000);
        BlinkDur_right = nanmean(curr_dur_R);
         
        TrialDur = (sttime_next - sttime)/1000;

        idx_rawTab = rawTab.sub == edfTab.sub(edfList(e)) & rawTab.task == edfTab.task(edfList(e)) & rawTab.trial == t;
        blinkTab = [blinkTab; edfTab.sub(edfList(e)) edfTab.task(edfList(e)) double(t) ...
            rawTab.rating(idx_rawTab) rawTab.valence(idx_rawTab) rawTab.white_boosting(idx_rawTab) ...
            rawTab.color_gamut(idx_rawTab) rawTab.IAPS_number(idx_rawTab) ...
            BlinkRate_left BlinkRate_right BlinkDur_left BlinkDur_right TrialDur ...
            ];
    end
    
    toc;
end

blinkTab = array2table(blinkTab);
blinkTab.Properties.VariableNames = {'sub', 'task', 'trial', ...
    'rating', 'valence', 'white_boosting', 'color_gamut', 'IAPS_number', ...
    'BlinkFreq_L', 'BlinkFreq_R', 'BlinkDur_L', 'BlinkDur_R', 'TrialDur'};

%% adjust nan values
evTab.SaccDur(isnan(evTab.SaccDur)) = 0;
evTab.SaccPvel(isnan(evTab.SaccPvel)) = 0;
evTab.SaccDur(isnan(evTab.SaccDur)) = 0;

%% save
%metricTab = [parseTab(:,1) fixTab saccTab(:,9:end) blinkTab(:,9:end) ];
metricTab = [parseTab(:,1) saccTab blinkTab(:,9:end) ];
save('metricTab3_4.mat', 'metricTab');




