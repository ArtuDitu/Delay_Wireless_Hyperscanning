disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); 
end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});

disp('Now receiving chunked data...');
chunks=[];
lsl_stamps = [];
clock_stamps = [];
tic;
t=toc;
while t < 60
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_sample();
    chunks=[chunks chunk'];
    lsl_stamps = [lsl_stamps stamps];
    clock_stamps = [clock_stamps {clock}];
    t=toc;
end