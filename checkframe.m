%check one frame by it's number
prompt = 'Which frame do you want to check? ';
frametocheck = input(prompt)
test = frame_array(:,:,frametocheck);
maxx = max(max(test))
fig = figure; % open figure window
ishghandle(mfig)
imagesc(test,[minfa j]) %uses minfa and maxfa from IRT_multiplefile
%maxframe=plot(cmax(1),rmax(1),'r*')
hold on
plot(cmax(1),rmax(1),'r*')