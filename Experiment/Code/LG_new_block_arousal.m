%Behavior experiment code with EEG and Eye-tracking recording
sca;
close all;
clear;
%% pseudo randomize trial, 4 pseudo randomize trial mat files for each block (Vivid, Valence, Arousal)
%load("sequence_arousal1.mat") 
%sequence=1;

%load("sequence_arousal2.mat")
%sequence=2;

%%load("sequence_arousal3.mat") 
sequence=3;

%load("sequence_arousal4.mat")
%sequence=4;

%% Working path
current_path=pwd;
% data_path=[current_path,'/pilot_Data/'];
% data_path=[current_path,'/pilot_Data/old/'];
data_path=[current_path,'/data_arousal/'];
% dummymode = 1; % variable for EEG usage. (0 is using EEG recordiing; 1 for not using EEG)
prompt=input('EEG mode? (yes=1 or no=2) :');
if prompt==1
    dummymode = 0;
elseif prompt==2
    
    dummymode = 1;
end

if dummymode == 0
    %create an instance of the io64 object
    ioObj           = io64;
    %
    %initialize the hwinterface.sys kernel-level I/O driver
    status          = io64(ioObj);
    % status = 0 : ready to write and read to a hardware port
    
    address         = hex2dec('DCF8');          % LPT3 I/O port address
    data_ini        = 1;                        % for initialization
    io64(ioObj,address,data_ini);
end

%% Experiment input

task_id = 'Behavior_arousal';%newest_datafile(1:3);
subj_ID = 100;
temp = input(['Participant ID: ',task_id,num2str(subj_ID),'? (yes=1, no=2)']);
if temp==2
    while 1
        subj_ID = input('Participant ID:');
        if isempty(subj_ID)
            error('Participant ID is missing')
            break;
        end
        break;
    end
end

ExpName = input('Experimenter: ','s');
if isempty(ExpName)
    error('Experi menter is missing')
end



% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

AssertOpenGL;

Screen('Preference','SkipSyncTests',1)
oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
oldSupressAllWarning = Screen('Preference', 'SuppressAllWarnings', 1);
%% Keyboard settings
KbName('UnifyKeyNames');
left = KbName('LeftArrow');
right = KbName('RightArrow');
spacebar = KbName('Space');
escapeKey = KbName('ESCAPE');
scale_4=KbName(',<');
scale_5=KbName('.>');
scale_6=KbName('/?');
scale_1=KbName('z');
scale_2=KbName('x');
scale_3=KbName('c');

KEYS = [scale_1 scale_2 scale_3 scale_4 scale_5 scale_6 spacebar escapeKey];


% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen..
screenNumber = max(screens);

% Define black and white (white will be 1 and black 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. With our setup, values defined between 0 and 1.
white = 1;
black = 0;
grey = white / 5;
down_ratio = 3; up_ratio = 2;

% Open an on screen window using PsychImaging and color it grey.
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
baseRect = [0 0 windowRect(3)/down_ratio*up_ratio windowRect(4)/down_ratio*up_ratio]; % pixel scale
centeredRect = CenterRectOnPointd(baseRect, windowRect(3)/2, windowRect(4)/2);
randomsec=rand(1)*3+1;

%% eyelink start
prompt_eyelink =1;

if prompt_eyelink == 1
    eyelinkOn = 1; % 1 for ON / 0 for OFF
elseif prompt_eyelink == 2
    eyelinkOn = 0; % 1 for ON / 0 for OFF
end

if eyelinkOn
    
    dummymode_eyelink = 0;
    
    % Optional: Set IP address of eyelink tracker computer to connect to.
    % Call this before initializing an EyeLink connection if you want to use a non-default IP address for the Host PC.
    %Eyelink('SetAddress', '10.10.10.240');
    
    EyelinkInit(dummymode_eyelink); % Initialize EyeLink connection
    status = Eyelink('IsConnected');
    if status < 1 % If EyeLink not connected
        dummymode_eyelink = 1;
    end
    
    edf_file_name = 'ar19';%input('Set the file name of eye-tracking data: ');
    fprintf('EDFFile: %s\n', edf_file_name );
    
    el=EyelinkInitDefaults(window);
    
    % open file to record data
    res = Eyelink('Openfile', edf_file_name);
    if res~=0
        fprintf('Cannot create EDF file ''%s'' ', [edf_file_name '.edf']);
        Eyelink('ShutDown'); Screen('CloseAll');
        return;
    end
    
    % make sure we're still connected.
    if Eyelink('IsConnected')~=1
        Eyelink('ShutDown'); Screen('CloseAll');
        return;
    end
    
    % do calibration & validation
    EyelinkDoTrackerSetup(el);
    
    % start record
    WaitSecs(0.05);
    Eyelink('StartRecording');
end

%% image load
load("IAPS_image_name_replicated.mat")% row for loading the IAPS image with trial information
screenShot=load('arousal_rating.mat'); %load valence, arousal Rating images

%% data output

%fixation시작, image시작, image 끝, fixation시작, confidence시작, confidence끝, confidence rating num
nT=length(new_row_all); %nT=number of Trial
confirm_data_t = nan(nT, 4);
confirm_data = nan(nT, 6);
% confirm_data_t(i,1) = start;
% confirm_data_t(i,2) = image_start;
% confirm_data_t(i,3) = rating;
% confirm_data_t(i,4) = fixation;
% confirm_data(i,1) = trial;
% confirm_data(i,2) = rating_score;
% confirm_data(i,3:6) = trial_info; [valence, boosting, color_gamut,image_number]
%% Start
Screen('FillRect', window, grey, centeredRect);
ccPsychDrawImage(window,screenShot.images.ProbaText{1},20,1,10); % Start
Start=Screen('Flip', window);
WaitSecs(randomsec);
confirm_data_t(1,1)=Start;

if dummymode == 0
    %% use EEG trigger (Experiment start)
    data_out        = 1;
    io64(ioObj,address,data_out);   % output command
    pause(0.005);                 % 0.005s pause
    % io64(ioObj,address,data_ini);   % output command initiali
end
%% fixation
% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');%for smooth line, can be eliminat

Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, 36);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;


for trial=1:length(new_row_all)
    
    confirm_data(trial,1)=trial;
    
    %% image 3s show
    %upload image without 3 continuous present with same valence or same boosting option
    
    %eval("positive_image = positive_image_"+num2str(i));
    image=IAPS_image_name_replicated{new_row_all(trial)};
    ccPsychDrawImage(window,image,3,1,[1:3]);
    
    
    image_start= Screen('Flip', window);
    confirm_data_t(trial,2)=image_start;
    
    if eyelinkOn
        eyelink_msg = ['stimOn_' num2str(trial)];
        Eyelink('Message', eyelink_msg);
    end
    
    
    if dummymode == 0
        %% use EEG trigger (Image watching)
        data_out        = 2;
        io64(ioObj,address,data_out);   % output command
        pause(0.005);                 % 0.005s pause
        % io64(ioObj,address,data_ini);   % output command initiali
    end
    
    
    
    
    
    while(1)
        [ keyIsDown, time, keyCode ] = KbCheck;    % Check the state of the keyboard.
        %WaitSecs(0.05);
        
        if keyCode(KbName('escape'))
            Screen('CloseAll');
            break;
        end
        
        
        if keyIsDown
            
            
            if keyCode(KbName('z'))
                
                if eyelinkOn
                    eyelink_msg = ['stimOff_' num2str(trial)];
                    Eyelink('Message', eyelink_msg);
                end
                if dummymode == 0
                    %% use EEG trigger (image rating)
                    data_out        = 3;
                    io64(ioObj,address,data_out);   % output command
                    pause(0.005);                 % 0.005s pause
                    %io64(ioObj,address,data_ini);   % output command initiali
                end
                confirm_data(trial,2)=1;
                confirm_data_t(trial,3)=time;
                %confirm_data
                
                break;
                
            elseif keyCode(KbName('x'))
                if eyelinkOn
                    eyelink_msg = ['stimOff_' num2str(trial)];
                    Eyelink('Message', eyelink_msg);
                end
                if dummymode == 0
                    %% use EEG trigger (image rating)
                    data_out        = 3;
                    io64(ioObj,address,data_out);   % output command
                    pause(0.005);                 % 0.005s pause
                    %io64(ioObj,address,data_ini);   % output command initiali
                end
                confirm_data(trial,2)=2;
                confirm_data_t(trial,3)=time;
                break;
            elseif keyCode(KbName('c'))
                if eyelinkOn
                    eyelink_msg = ['stimOff_' num2str(trial)];
                    Eyelink('Message', eyelink_msg);
                end
                if dummymode == 0
                    %% use EEG trigger (image rating)
                    data_out        = 3;
                    io64(ioObj,address,data_out);   % output command
                    pause(0.005);                 % 0.005s pause
                    %io64(ioObj,address,data_ini);   % output command initiali
                end
                confirm_data(trial,2)=3;
                confirm_data_t(trial,3)=time;
                break;
                
            elseif keyCode(scale_4)
                if eyelinkOn
                    eyelink_msg = ['stimOff_' num2str(trial)];
                    Eyelink('Message', eyelink_msg);
                end
                if dummymode == 0
                    %% use EEG trigger (image rating)
                    data_out        = 3;
                    io64(ioObj,address,data_out);   % output command
                    pause(0.005);                 % 0.005s pause
                    %io64(ioObj,address,data_ini);   % output command initiali
                end 
                confirm_data(trial,2)=4;
                confirm_data_t(trial,3)=time;
                break;
                
            elseif keyCode(scale_5)
                if eyelinkOn
                    eyelink_msg = ['stimOff_' num2str(trial)];
                    Eyelink('Message', eyelink_msg);
                end
                if dummymode == 0
                    %% use EEG trigger (image rating)
                    data_out        = 3;
                    io64(ioObj,address,data_out);   % output command
                    pause(0.005);                 % 0.005s pause
                    %io64(ioObj,address,data_ini);   % output command initiali
                end
                confirm_data(trial,2)=5;
                confirm_data_t(trial,3)=time;
                break;
                
            elseif keyCode(scale_6)
                %WaitSecs(0.02);
                if eyelinkOn
                    eyelink_msg = ['stimOff_' num2str(trial)];
                    Eyelink('Message', eyelink_msg);
                end
                if dummymode == 0
                    %% use EEG trigger (image rating)
                    data_out        = 3;
                    io64(ioObj,address,data_out);   % output command
                    pause(0.005);                 % 0.005s pause
                    %io64(ioObj,address,data_ini);   % output command initiali
                end
                confirm_data(trial,2)=6;
                confirm_data_t(trial,3)=time;
             
                break;
            end
        end
    end
    
    WaitSecs(0.2);
    %Screen('FillRect', window, grey, centeredRect)
    
    
    if eyelinkOn
        eyelink_msg = ['stimOff_' num2str(trial)];
        Eyelink('Message', eyelink_msg);
    end
    if dummymode == 0
        %% use EEG trigger (fixation pop up)
        data_out        = 4;
        io64(ioObj,address,data_out);   % output command
        pause(0.005);                 % 0.005s pause
        %io64(ioObj,address,data_ini);   % output command initiali
    end
    %DrawFormattedText(window, '+', 'center', 'center', white);
    
    % Setup the text type for the window
    
    
    % Draw the fixation cross in white, set it to the center of our screen and
    % set good quality antialiasing
    
    %DrawFormattedText(window, '+', 'center', 'center', white);
    ccPsychDrawImage(window,image,3,1,[1:3]);
    %Screen('FillRect', window, grey, centeredRect);
    Screen('DrawLines', window, allCoords,...
        lineWidthPix, grey, [xCenter yCenter],2 );
    fixation_t1= Screen('Flip', window);
     confirm_data_t(trial,4)=fixation_t1;
    
    WaitSecs(0.5);
    %fixation_t1=Screen('Flip', window);
   
    confirm_data(trial,3:6)=trial_info_all(trial,1:4);
end



if eyelinkOn
    eyelink_msg = ['rateOff_' num2str(trial)];
    Eyelink('Message', eyelink_msg);
end

if dummymode == 0
    FileName = ['Behavior_arousal',num2str(subj_ID),'.mat'];
elseif dummymode == 1
    FileName = ['Behavior_arousal',num2str(subj_ID),'.mat'];
end


save([data_path, FileName],'subj_ID','ExpName','confirm_data','confirm_data_t','sequence');%,'confirm_bonus','confirm_bonus_gamble');



% KbReleaseWait(currDeviceNum);
% waitKey(spacebar, currDeviceNum);

if dummymode == 0
    %% use EEG trigger (exp end key press)
    data_out        = 7;
    io64(ioObj,address,data_out);   % output command
    pause(0.005);                 % 0.005s pause
    %io64(ioObj,address,data_ini);   % output command initiali
end

%% Eyelink finalize
if eyelinkOn
    WaitSecs(0.5);
    Eyelink('StopRecording');
    
    WaitSecs(0.5);
    Eyelink('CloseFile');
    
    try
        fprintf('Receiving data file ''%s''\n', edf_file_name );
        status=Eyelink('ReceiveFile');
        if status > 0
            fprintf('ReceiveFile status %d\n', status);
        end
        if 2==exist(edf_file_name, 'file')
            fprintf('Data file ''%s'' can be found in ''%s''\n', edf_file_name, pwd );
        end
    catch %#ok<*CTCH>
        fprintf('Problem receiving data file ''%s''\n', edf_file_name );
    end
    
    Eyelink('ShutDown');
end


Screen('FillRect', window, grey, centeredRect);
Screen('Flip', window);

WaitSecs(0.5);




%% Close the screen
Screen('Close', window);

% Clear the screen.
sca;