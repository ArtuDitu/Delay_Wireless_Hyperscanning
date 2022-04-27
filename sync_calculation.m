% add required libraries to the path
addpath(genpath('D:\Dropbox\MATLAB_Tools'))
%change the path to the folder with scripts and add the folder to the path
cd D:\Dropbox\Projects\BMK_Japan
addpath(genpath('D:\Dropbox\Projects\BMK_Japan'))

% path to file and folder
path_to_file = 'C:\Users\aczeszumski\Documents\CurrentStudy\sub-P001\ses-S001\eeg\test.xdf';
path_new_folder = 'C:\Users\aczeszumski\Documents\CurrentStudy\sub-P001\ses-S001\eeg\XXX';

% load EEG streams and combine them in one struct
mobilab.allStreams = dataSourceXDF(path_to_file, path_new_folder);
all_mobilab_streams = [mobilab.allStreams().item];

% load triggers timing
d = readtable('results.csv');

%add triggers as channel 31 in both systems

%CGX30quick
triggers_CGX30 = zeros(length(all_mobilab_streams{1,3}.data(:,30)),1);
all_mobilab_streams{1,3}.data(:,31) = all_mobilab_streams{1,3}.auxChannel.data(:,4);

% create a list of events to remove events really close to each other
% (wrong collection of triggers by CGX)
ts_list = find(all_mobilab_streams{1,3}.data(:,31)~=0);
ts_list_unique = ts_list;
for idx = 2:length(ts_list)
    if (ts_list(idx) - ts_list(idx-1)) < 5
        ts_list_unique(idx)=0;
    end
end
ts_list = unique(ts_list_unique);
ts_list = ts_list(2:end);
triggers_CGX30([ts_list]) = 1;

all_mobilab_streams{1,3}.data(:,31) = triggers_CGX30;

% CGX32
all_mobilab_streams{1,3}.data(:,31) = all_mobilab_streams{1,3}.auxChannel.data(:,4);


exported_EEG = mobilab.allStreams().export2eeglab([1,3]);
exported_EEG.data(:, any(isnan(exported_EEG.data),1)) = [];
exported_EEG.pnts = size(exported_EEG.data,2);
exported_EEG.times = exported_EEG.times(1:size(exported_EEG.data,2));
