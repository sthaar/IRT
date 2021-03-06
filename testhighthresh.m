%script to test the max values above which temperatures are not expected to
%be on eye anymore. (only on perch, on floor weird reflexions).
%Plots e absolutmax value, lowest above threshold and
%average of the two 
%if all have 'unreliable' images, try lowering threshold until 'good'
%images appear

close
%above_thresh=frame_array(frame_array>38)
%[r,c,Fr]=ind2sub(size(frame_array),find(frame_array>38))
prompt = 'max threshold' %usually around 38;
maxthr = input(prompt);

indabovethresh=find(maxPFr>maxthr);
valuesabovethresh=sort(maxPFr(indabovethresh), 'descend');

minfa=min(min(min(frame_array,[],1),[],2),[],3); % get minimal temp value
maxfa=max(max(max(frame_array,[],1),[],2),[],3); % get maximal temp value

count=0;
f=figure;
ishghandle(f);

titlearray = {'maxmax', 'avmax', 'minmax'};
%check pol in min max voor logica max range
%indabovethresh(1:int16((end+1)/2):end)
for j =  valuesabovethresh(1:int16((length(valuesabovethresh))/2-1):length(valuesabovethresh))
    % find which frame has min and which frames have the 3 highest values (top
    % 3) v in vmin and vmax means frame number 
    %[rmax,cmax,vmax] = ind2sub(size(frame_array),find(frame_array == indabovethresh(j)));
    % create variable maxThree for output, one row per frame (outrow), first column
    % vmax = frame nr, 2nd column j is max value of that frame
   %!!fix (1)
   %% maxThree(outrow,1) = vmax(1)%the (1) behind it is in case there are two frames with the same value. I shoudl fix this to store both
  %%  maxThree(outrow,2) = j
    count = count+1;
    subplot(1,3,count)
    plotframe=find(frame_array == j);
    [rmax,cmax,vmax] = ind2sub(size(frame_array),find(frame_array == j));
    %[rmax,cmax,vmax] = ind2sub(size(frame_array),plotframe(1));
%    [rmax,cmax,vmax]=find(frame_array == j);
    im=frame_array(:,:,vmax(1));
    %!!fix (1)
    imagesc(im,[minfa maxfa])% draw frame with maximum value.%the (1) behind it is in case there are two frames with the same value. I shoudl fix this to store both
    %place marker at max value
    hold on
    %ind2sub(size(frame_array),
    maxframe=plot(cmax(1),rmax(1),'r*');
    axis square
    %title({[' max-' num2str(count)]})
    title(titlearray(count))
end