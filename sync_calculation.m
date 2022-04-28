%% LOAD AND SYNC BOTH EEG SETS + ADD Markers
% add required libraries to the path
addpath(genpath('D:\Dropbox\MATLAB_Tools'))
%change the path to the folder with scripts and add the folder to the path
cd D:\Dropbox\Projects\BMK_Japan
addpath(genpath('D:\Dropbox\Projects\BMK_Japan'))

% path to file and folder
path_to_file = 'D:\Dropbox\Projects\BMK_Japan\Data\test.xdf';
path_new_folder = 'D:\Dropbox\Projects\BMK_Japan\Data\MOBI';

% load EEG streams and combine them in one struct
mobilab.allStreams = dataSourceXDF(path_to_file, path_new_folder);
all_mobilab_streams = [mobilab.allStreams().item];

% load triggers timing
d = readtable('results.csv');

%add triggers as channel 31 in CGX30quick system
triggers_CGX30 = zeros(length(all_mobilab_streams{1,3}.data(:,30)),1); % vector with zeros
all_mobilab_streams{1,3}.data(:,31) = all_mobilab_streams{1,3}.auxChannel.data(:,4); %temporary store triggers signal as channel 31
all_mobilab_streams{1,3}.label(31) = {'trigger'}; % add label name for trigger channel
all_mobilab_streams{1,3}.channelSpace = NaN(31,3); % expand channelSpace - it's all empty now but size has to be consistent with data struct

% sync 2 eeg streams and markers
exported_EEG = mobilab.allStreams().export2eeglab([1,3],[2]);

% make events from channel 31 CGX30
tmp_EEG = pop_chanevent(exported_EEG, 61,'edge','leading','edgelen',1.1,'nbtype',1); 

% remove fields that overlap between two events streams
tmp_EEG.event = rmfield(tmp_EEG.event, 'urevent');
exported_EEG.event = rmfield(exported_EEG.event, 'urevent');
exported_EEG.event = rmfield(exported_EEG.event, 'hedTag');
exported_EEG.event = rmfield(exported_EEG.event, 'duration');
% combine triggers
combine_triggers_2systems = [exported_EEG.event tmp_EEG.event]; % combined array
[~,index] = sortrows([combine_triggers_2systems.latency].'); % sort by latency
combine_triggers_2systems = combine_triggers_2systems(index); clear index %sort by latency
exported_EEG.event = combine_triggers_2systems; %add to event struct
exported_EEG.urevent = []; % remove urvent field

exported_EEG = eeg_checkset(exported_EEG); % check set

% remove obsolete triggers and rename existing once
events_delete_list = [];

for event =1:length(exported_EEG.event)
    if strcmp('chan61',exported_EEG.event(event).type)
        exported_EEG.event(event).type = 'CGX30';
    elseif strcmp('<Marker><Type>Comment</Type><Description>M 32768<', exported_EEG.event(event).type)
        exported_EEG.event(event).type = 'CGX32';
    else
        events_delete_list = [events_delete_list event];
    end
end
exported_EEG.event(events_delete_list) = []; % remove 

%eegplot(exported_EEG.data,'srate',exported_EEG.srate,'eloc_file',exported_EEG.chanlocs,'events',exported_EEG.event);

%% Step 1 - look at triggers latency in CGX32 - data collected via LSL and wireless local network

% compare amount of events before synchronizing LSL streams
d = d(2:end,:);
d{:,1}=d{:,1}+1;
size(d,1)
% triggers sent == 595

% triggers before LSL sync
CGX32_count= 0;
CGXX32_markers = all_mobilab_streams{1,2};
for event =1:length(CGXX32_markers.event.label)
    if strcmp('<Marker><Type>Comment</Type><Description>M 32768<', CGXX32_markers.event.label{event,1})
        CGX32_count = CGX32_count + 1;
    end
end

% triggers received == 551

% triggers after LSL sync
epoch_CGX32 = pop_epoch(exported_EEG,{'CGX32'},[0 ,2]);
size(epoch_CGX32.data,3)

% triggers received == 551

%% Step 2 - look at triggers latency in CGX30 - data collected via LSL + cloud

% triggers sent == 595

%triggers_before LSL sync


% triggers received == 595

%triggers_after LSL sync
epoch_CGX30 = pop_epoch(exported_EEG,{'CGX30'},[0 ,2]);
size(epoch_CGX30.data,3)
% triggers received == 587




