%check one frame by it's number
prompt = 'Which frame do you want to check? ';
frametocheck = input(prompt)
test = frame_array(:,:,frametocheck);
max(max(test))
fig = figure; % open figure window
ishghandle(mfig)
imagesc(test,[minfa j]) %uses minfa and maxfa from IRT_multiplefile
