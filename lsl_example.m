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
tic;
t=toc;
chunks=[];
lslStamps = [];
clockStamps = [];
while t < 60
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    chunks=[chunks chunk];
    lslStamps = [lslStamps stamps];
    clockStamps =[clockStamps clock];
    t=toc;
end


c = clock;