clear
clc

%% load rawdat file
load('LGE_pilot_rawdat.mat');

rawTab = RawDat.rawTab;
edfTab = RawDat.edfTab;
clear RawDat

%% parse trials
parseTab = [];

nTrials = max(rawTab.trial);

for e = 1:length(edfTab.idx_edf)
    disp(['e = ' num2str(e) '(/' num2str(length(edfTab.idx_edf)) ')'])
    tic;
    
    idx_edf = edfTab.idx_edf(e);
    load(['edfDat_' num2str(idx_edf)]);
    
    currTrial = 1;
    for t_event = 1: length(edfDat.RawEdf.FEVENT)
        if currTrial > nTrials, break; end
            
            if strcmp(edfDat.RawEdf.FEVENT(t_event).message, ['stimOn_' num2str(currTrial)]) || ...
                    strcmp(edfDat.RawEdf.FEVENT(t_event).message, ['stimOff_' num2str(currTrial)])
                
                onset_sttime = edfDat.RawEdf.FEVENT(t_event).sttime;
                onset_idx = find(edfDat.RawEdf.FSAMPLE.time == onset_sttime);
                
                parseTab = [parseTab; edfTab.idx_edf(e) currTrial onset_sttime onset_idx];
                currTrial = currTrial + 1;
            end

    end
    clear edfDat
    toc
end

parseTab = array2table(parseTab);
parseTab.Properties.VariableNames = {'idx_edf', 'trial', 'sttime_onset', 'idx_onset'};

save('parseTab.mat', 'parseTab');

