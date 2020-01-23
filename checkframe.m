%check one frame by it's number
prompt = 'Which frame do you want to check? ';
frametocheck = input(prompt);

test = frame_array(:,:,frametocheck);
maxPfr = max(max(test))
minPfr = min(min(test))

%minfa=min(min(min(frame_array,[],1),[],2),[],3); % get minimal temp value
%maxfa=max(max(max(frame_array,[],1),[],2),[],3); % get maximal temp value
[rmin,cmin,vmin] = ind2sub(size(test),find(test == minPfr));
[rmax,cmax,vmax] = ind2sub(size(test),find(test == maxPfr));

fig = figure; % open figure window
ishghandle(fig)
imagesc(test,[minPfr maxPfr]) 
%maxframe=plot(cmax(1),rmax(1),'r*')
hold on
plot(cmax(1),rmax(1),'r*')

