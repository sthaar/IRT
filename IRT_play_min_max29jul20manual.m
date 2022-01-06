%%under development
%%script for loading,viewing, calculating data from FLIR Infrared thermography camera (IRT FLIR 430c ) 
%%by Sita ter Haar
%%previous version version 15apr19
%% Load the data
clear all

[filename, filepath] = uigetfile('.mat'); % select datafile

%fprintf(['Loading data ' filename '...\n']);
%Z=load([filepath filename]); % load the data
%% Load large data
%fds = fileDatastore(fullfile(filepath),'ReadFcn',@load,'FileExtensions','.mat')

ds = fileDatastore(fullfile(filepath, filename),'ReadFcn',@load);
%t1 = tall(fds1.Files)
subds = partition(ds,10,1); %partitions datastore ds into the number of parts specified by N and returns the partition corresponding to the index index.
Z=read(subds);
%% find how many frames exist in this data-file
HighestFrameFound = false; % switch for loop below
framenr=1; % start looking at frame nr 1 and find the highest frame nr
fprintf('Highest framenr: ');
while ~HighestFrameFound
    fn=['Frame' num2str(framenr)]; % create a 'FrameX' label
    if isfield(Z,fn) % does it exist in Z?
        framenr=framenr+1; % if so check next number
    else
        HighestFrameFound = true; % previous number was the last exist
        HighestFrameNr=framenr-1; % so subtract one
        fprintf([num2str(HighestFrameNr) '\n']); % and print to cmd
    end
end

%% collecting frames in a single array

frame_array = zeros(size(Z.Frame1,1),...
    size(Z.Frame1,2),framenr-1); % pre-allocate a 3d array
for f=1:HighestFrameNr
    frame_array(:,:,f) = eval(['Z.Frame' num2str(f)]); % put frames in
end

%calculate %% calculate max value of each frame and determine min and max of that (i.e. range of max values)
% maxPFr = zeros(1,HighestFrameNr);
% indMinmx = zeros(1,HighestFrameNr);%create empty array
% for f=1:HighestFrameNr % for each frame, extract the max value and place in array maxPFr
%     mx = max(max(frame_array(:,:,f)));%absolute max of frame;
%     maxPFr(f) = mx(1);
%     [rmaxf, cmaxf] = find(frame_array(:,:,f)==maxPFr(f));
%     %minOfMaxPFr(f) = min(max(frame_array(:,:,f))); % minimum of max of each column per frame
% end  

%% animate in implay (needs to be in 0-255 range)%outcommented in version 23okt18
% fa=frame_array; % duplicate array (think about memory: don't do this if you don't need it)
% minfa=min(min(min(fa,[],1),[],2),[],3); % get minimal temp value
% maxfa=max(max(max(fa,[],1),[],2),[],3); % get maximal temp value
% fan = uint8(((fa-minfa)./(maxfa-minfa))*255); % normalize to 8-bit range

%% animate in figure window (in temp scale)
minfa=min(min(min(frame_array,[],1),[],2),[],3); % get minimal temp value
maxfa=max(max(max(frame_array,[],1),[],2),[],3); % get maximal temp value
%animation
mfig = figure; % open figure window
set(mfig,'Position',[0 0 640 512]); % with predefined size and position
i=1; % framenr to cycle through
while ishghandle(mfig) && i<=HighestFrameNr %check if fig window and frame exist
   pause(0.12) % pause after every frame (determines play-rate
   mx = max(max(frame_array(:,:,i)));%absolute max of frame;
   [cmaxf, rmaxf] = find(frame_array(:,:,i)==mx);
   im=frame_array(:,:,i);
   imagesc(im,[minfa maxfa]);% draw frame with maximum value.
   %cRange = caxis; % save the current color range
   hold on
   plot(rmaxf, cmaxf ,'r*', 'MarkerSize', 2);
   hold off
   %caxis(cRange);
   c=colorbar;title(c,'Temp (C)'); % temp scale bar
   title(['FrameNr: ' num2str(i)]); % title with frame nr
   i=i+1; % nest frame
end


% %% find which frame has min and which has max
% [rmin,cmin,vmin] = ind2sub(size(frame_array),find(frame_array == minfa));
% [rmax,cmax,vmax] = ind2sub(size(frame_array),find(frame_array == maxfa));
% mfig = figure; % open figure window
% ishghandle(mfig)
% im=frame_array(:,:,vmax(1));
% imagesc(im,[minfa maxfa]);% draw frame with maximum value.
% %place marker at max value
%  hold on
%  maxframe=plot(cmax,rmax,'r*', 'MarkerSize', 2);
 %%
% bla = uicontrol(gcf,...
%                     'style','pushbutton')
%  [filepath,name,ext] = fileparts(filename);
% saveas(maxframe,strcat(filepath,'maxframe_',name),'tiff');

%... Select eye with cursor and export to workspace as 'eye_min'. ...
%%
%eye_min_value = frame_array(eye_min.Position(2),eye_min.Position(1),vmin)

%% same for max
%imagesc(frame_array(:,:,vmax),[minfa maxfa])% draw frame with maximum value

%...Select eye with cursor and export to workspace as 'eye_max'.    
%%
%eye_max_value = frame_array(eye_max.Position(2),eye_max.Position(1),vmax)
%wing_max_value = frame_array(wing_max.Position(2),wing_max.Position(1),vmax)


%% calculate max value of each frame and determine min and max of that (i.e. range of max values)
% maxPFr = zeros(1,HighestFrameNr);%create empty array
% for f=1:HighestFrameNr % for each frame, extract the max value and place in array maxPFr
%     maxPFr(f) = max(max(frame_array(:,:,f)));
% end
% % max(maxPFr) is same as maxfa
% MinofMax = min(maxPFr); % is minimum of all max values (max expected to correlate with eye). if bird is absent 23 or so in Rec-zebrafinch test-000381-179_09_31_16_737_original
% AvMax = mean(maxPFr)
% plot(maxPFr)


%% check specific frame

%checkframe = 148 %framenumer to check
%imagesc(frame_array(:,:,checkframe), [minfa maxfa])% draw frame with framenumer to check)
%max_check_frame = max(max(frame_array(:,:,checkframe)))
% %% next step determine threshold
% minthresh = 30 % below 32, eye not visible, bird flying or out of view
% maxthresh = maxfa
% maxPFrthreshY=maxPFr(maxPFr< maxthresh & maxPFr>minthresh);
% maxPFrthreshX=find((maxPFr< maxthresh & maxPFr>minthresh));
% plot(maxPFrthreshX,maxPFrthreshY)
% hold on
% plot(maxPFr)
% %%
%save max value
%save plots

%%
%manual options below

%% get frames with max above certain value
 
%[rcheck_max,ccheck_max,vcheck_max] = ind2sub(size(frame_array),find(frame_array > 38));
%%check lenght
%frames_vcheck_max=unique(vcheck_max);
%length(frames_vcheck_max)

%% or frames with minofmax of certain value
%%check lenght
%frames_vcheck_min=find(maxPFr < 35 & maxPFr > 34);
%length(frames_vcheck_min)
%frames_vcheck_min(1:10)

%%
%
%for i=100:110
 %for i=1:length(frames_vcheck_min)
%    mfig = figure(i)
    %imagesc(frame_array(:,:,frames_vcheck_max(i)),[minfa maxfa])% draw frame with maximum value
%    imagesc(frame_array(:,:,frames_vcheck_min(i)),[minfa maxfa])% draw frame with min of maximum value
%end

%%
%%new eye-min and max

%eye_min_value = frame_array(eye_min.Position(2),eye_min.Position(1),vmin)
%eye_max_value = frame_array(eye_max.Position(2),eye_max.Position(1),vmax)