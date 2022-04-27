

% path to file and folder
path_to_file = 'C:\Users\aczeszumski\Documents\CurrentStudy\sub-P001\ses-S001\eeg\sub-P001_ses-S001_task-Default_run-001_eeg.xdf';
path_new_folder = 'C:\Users\aczeszumski\Documents\CurrentStudy\sub-P001\ses-S001\eeg\\MOBI';
% load streams and combine them in one struct
mobilab.allStreams = dataSourceXDF(path_to_file, path_new_folder);
all_mobilab_streams = [mobilab.allStreams().item];

% stream A - quick30




exported_EEG = mobilab.allStreams().export2eeglab(eeg_streams);
exported_EEG.data(:, any(isnan(exported_EEG.data),1)) = [];
exported_EEG.pnts = size(exported_EEG.data,2);
exported_EEG.times = exported_EEG.times(1:size(exported_EEG.data,2));
