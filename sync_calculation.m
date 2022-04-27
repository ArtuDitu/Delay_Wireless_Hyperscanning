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

% create a list of events to remove events really close to each other
% (wrong collection of triggers by CGX, so each trigger was repeated over
% consecutive timestamps (around 10))

ts_list = find(all_mobilab_streams{1,3}.data(:,31)~=0); %find all events
ts_list_unique = ts_list; % empty list for unique events
% for loop to remove all triggers that are repeated over consecutive
% timestamps
for idx = 2:length(ts_list)
    if (ts_list(idx) - ts_list(idx-1)) < 5
        ts_list_unique(idx)=0;
    end
end

ts_list = unique(ts_list_unique); % select unique time stamps for each trigger
ts_list = ts_list(2:end); % remove trigger #0
triggers_CGX30([ts_list]) = 1; % add triggers as '1' to the empty vector
all_mobilab_streams{1,3}.data(:,31) = triggers_CGX30; % add triggers to the channel 31
all_mobilab_streams{1,3}.label(31) = {'trigger'}; % add label name for trigger channel
all_mobilab_streams{1,3}.channelSpace = NaN(31,3); % expand channelSpace - it's all empty now but size has to be consistent with data struct

% sync 2 eeg streams and markers
exported_EEG = mobilab.allStreams().export2eeglab([1,3],[2]);

