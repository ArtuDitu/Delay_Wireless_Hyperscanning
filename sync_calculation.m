%% LOAD AND SYNC BOTH EEG SETS + ADD Markers
% add required libraries to the path
addpath(genpath('D:\Dropbox\MATLAB_Tools'))
%change the path to the folder with scripts and add the folder to the path
cd D:\Dropbox\Projects\BMK_Japan
addpath(genpath('D:\Dropbox\Projects\BMK_Japan'))

% path to file and folder
path_to_file = 'D:\Dropbox\Projects\BMK_Japan\Data\test10\test.xdf';
path_new_folder = 'D:\Dropbox\Projects\BMK_Japan\Data\test10\MOBI';

% load EEG streams and combine them in one struct
mobilab.allStreams = dataSourceXDF(path_to_file, path_new_folder);
all_mobilab_streams = [mobilab.allStreams().item];

% load triggers timing
cd D:\Dropbox\Projects\BMK_Japan\Data\test10\
d = readtable('results.csv');

%add triggers as channel 31 in CGX30quick system
triggers_EEG1 = zeros(length(all_mobilab_streams{1,1}.data(:,30)),1); % vector with zeros
all_mobilab_streams{1,1}.data(:,31) = all_mobilab_streams{1,1}.auxChannel.data(:,5); %temporary store triggers signal as channel 31
all_mobilab_streams{1,1}.label(31) = {'trigger_eeg1'}; % add label name for trigger channel
all_mobilab_streams{1,1}.channelSpace = NaN(31,3); % expand channelSpace - it's all empty now but size has to be consistent with data struct

%add triggers as channel 31 in CGX30quick system
triggers_EEG2 = zeros(length(all_mobilab_streams{1,2}.data(:,30)),1); % vector with zeros
all_mobilab_streams{1,2}.data(:,31) = all_mobilab_streams{1,2}.auxChannel.data(:,5); %temporary store triggers signal as channel 31
all_mobilab_streams{1,2}.label(31) = {'trigger_eeg2'}; % add label name for trigger channel
all_mobilab_streams{1,2}.channelSpace = NaN(31,3); % expand channelSpace - it's all empty now but size has to be consistent with data struct

%eeg1
ts_list_eeg1 = find(all_mobilab_streams{1,1}.data(:,31)~=0); %find all events
ts_list_unique_eeg1 = ts_list_eeg1; % empty list for unique events
% for loop to remove all triggers that are repeated over consecutive
% timestamps
for idx = 2:length(ts_list_eeg1)
     if (ts_list_eeg1(idx) - ts_list_eeg1(idx-1)) < 5
         ts_list_unique_eeg1(idx)=0;
     end
 end
ts_list_unique_eeg1 = unique(ts_list_unique_eeg1);
ts_list_unique_eeg1 = ts_list_unique_eeg1(2:end);

%eeg2
ts_list_eeg2 = find(all_mobilab_streams{1,2}.data(:,31)~=0); %find all events
ts_list_unique_eeg2 = ts_list_eeg2; % empty list for unique events
% for loop to remove all triggers that are repeated over consecutive
% timestamps
for idx = 2:length(ts_list_eeg2)
     if (ts_list_eeg2(idx) - ts_list_eeg2(idx-1)) < 5
         ts_list_unique_eeg2(idx)=0;
     end
 end
ts_list_unique_eeg2 = unique(ts_list_unique_eeg2);
ts_list_unique_eeg2 = ts_list_unique_eeg2(2:end);



% sync 2 eeg streams and markers
exported_EEG = mobilab.allStreams().export2eeglab([1,2]);

% make events from channel 31 CGX30
tmp_EEG_1 = pop_chanevent(exported_EEG, 31,'edge','leading','edgelen',1.1,'nbtype',1);
tmp_EEG_2 = pop_chanevent(exported_EEG, 62,'edge','leading','edgelen',1.1,'nbtype',1);




combine_triggers_2systems = [tmp_EEG_1.event tmp_EEG_2.event];
combine_triggers_2systems = rmfield(combine_triggers_2systems, 'urevent');
combine_triggers_2systems = sortrows(struct2table(combine_triggers_2systems),1);
exported_EEG.event = table2struct(combine_triggers_2systems); %add to event struct


exported_EEG = eeg_checkset(exported_EEG); % check set

%eegplot(exported_EEG.data,'srate',exported_EEG.srate,'eloc_file',exported_EEG.chanlocs,'events',exported_EEG.event);

%% Step 1 - look at triggers latency in CGX32 - data collected via LSL and wireless local network

% compare amount of events before synchronizing LSL streams
d = d(2:end,:);
d{:,1}=d{:,1}+1;
size(d,1)
% triggers sent == 595


epoch_CGX30 = pop_epoch(exported_EEG,{'chan62'},[0 ,2]);
size(epoch_CGX30.data,3)