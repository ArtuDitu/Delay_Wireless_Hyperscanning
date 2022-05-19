disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'name','CGX Quick-30 30CH Q30-0071'); 
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
while t < 200
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_sample();
    chunks=[chunks chunk'];
    lsl_stamps = [lsl_stamps stamps];
    clock_stamps = [clock_stamps {clock}];
    t=toc;
end

cd D:\Dropbox\Projects\BMK_Japan\Data\testNTP_2

% improve saving to not save all variables - im stupid
dell_trigger = chunks(35,:);
dell_lsl = lsl_stamps;
dell_clock = clock_stamps;
save('dell', 'dell_trigger', 'dell_lsl', 'dell_clock')



load('SurfacePro')




SurfacePro_trigger_clock = SurfacePro_clock(SurfacePro_trigger == 32768);
dell_trigger_clock = dell_clock(dell_trigger == 32768);

dell_idx_trigger = find(dell_trigger == 32768);
dell_idx_trigger_unique = dell_idx_trigger;
for idx = 2:length(dell_idx_trigger)
    if (dell_idx_trigger(idx) - dell_idx_trigger(idx-1)) < 2
        dell_idx_trigger_unique(idx)=0;
    end
end

dell_events = unique(dell_idx_trigger_unique);
dell_events = dell_events(2:end);


Surface_idx_trigger = find(SurfacePro_trigger == 32768);
Surface_idx_trigger_unique = Surface_idx_trigger;
for idx = 2:length(Surface_idx_trigger)
    if (Surface_idx_trigger(idx) - Surface_idx_trigger(idx-1)) < 2
        Surface_idx_trigger_unique(idx)=0;
    end
end

Surface_events = unique(Surface_idx_trigger_unique);
Surface_events = Surface_events(2:end);

dell_clock_event = dell_clock(dell_events);
Surface_clock_event = SurfacePro_clock(Surface_events);




