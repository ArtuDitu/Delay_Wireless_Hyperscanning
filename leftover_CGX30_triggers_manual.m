% % change trigger channel from CGX30quick into markers
% % comment: mobilab change triggers in CGX30 to different numbers so it has
% % to be corrected. First out of the 1-3 numbers is chosen for precision 
% exported_EEG.data(61,find(exported_EEG.data(61,:) ~= 0)) = 1;
% 
% triggers_list = find(exported_EEG.data(61,:)~=0); %find all events
% triggers_list_unique = triggers_list; % empty list for unique events
% % for loop to remove all triggers that are repeated over consecutive
% % timestamps
% for idx = 2:length(triggers_list)
%     if (triggers_list(idx) - triggers_list(idx-1)) < 5
%         triggers_list_unique(idx)=0;
%     end
% end
% 
% triggers_list = unique(triggers_list_unique); % select unique time stamps for each trigger
% triggers_list = triggers_list(2:end); % remove trigger #0
% exported_EEG.data(61,:) =0; %make trigger channel empty
% exported_EEG.data(61,triggers_list) = 1; % add triggers 
% change triggers from channel to events field in tmp stuct

% % create a list of events to remove events really close to each other
% % (wrong collection of triggers by CGX, so each trigger was repeated over
% % consecutive timestamps (around 10))
% 
% ts_list = find(all_mobilab_streams{1,3}.data(:,31)~=0); %find all events
% ts_list_unique = ts_list; % empty list for unique events
% % for loop to remove all triggers that are repeated over consecutive
% % timestamps
% for idx = 2:length(ts_list)
%     if (ts_list(idx) - ts_list(idx-1)) < 5
%         ts_list_unique(idx)=0;
%     end
% end
% 
% ts_list = unique(ts_list_unique); % select unique time stamps for each trigger
% ts_list = ts_list(2:end); % remove trigger #0
% triggers_CGX30([ts_list]) = 1; % add triggers as '1' to the empty vector
% all_mobilab_streams{1,3}.data(:,31) = triggers_CGX30; % add triggers to the channel 31