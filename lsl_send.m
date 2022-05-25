cd D:\Dropbox\MATLAB_Tools
addpath(genpath('D:\Dropbox\MATLAB_Tools'))
addpath(genpath('D:\Dropbox\Projects\BMK_Japan'))


disp('Loading the library...');
lib = lsl_loadlib();

% make a new stream outlet
disp('Creating a new streaminfo...');
info = lsl_streaminfo(lib,'CGX','EEG',35,500,'cf_float32');

disp('Opening an outlet...');
outlet = lsl_outlet(info);

% send data into the outlet, sample by sample
disp('Now transmitting data...');
while true
    outlet.push_sample(randn(8,1));
    pause(0.01);
end