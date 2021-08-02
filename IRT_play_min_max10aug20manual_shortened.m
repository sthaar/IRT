%5load('filename.mat')

clear all
[filename, filepath] = uigetfile('.mat'); % select datafile
%Z= load(filename
ds = fileDatastore(fullfile(filepath, filename),'ReadFcn',@load);
%t1 = tall(fds1.Files)
subds = partition(ds,10,1); %partitions datastore ds into the number of parts specified by N and returns the partition corresponding to the index index.
Z=read(subds);
fn=fieldnames(Z)
frame_array=Z.(fn{1})

HighestFrameNr=size(frame_array,3) %3rd dimension = nr of frames

minfa=min(min(min(frame_array,[],1),[],2),[],3); % get minimal temp value
maxfa=max(max(max(frame_array,[],1),[],2),[],3); % get maximal temp value
%animation
mfig = figure; % open figure window
set(mfig,'Position',[0 0 640 512]); % with predefined size and position
i=1; % framenr to cycle through
while ishghandle(mfig) && i<=HighestFrameNr %check if fig window and frame exist
   pause(0.02) % pause after every frame (determines play-rate
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