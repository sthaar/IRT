%check one frame by it's number
function [nframe_array]=checkframe_excludeparts_automatic(frame_array)

test = frame_array(:,:,10); %select 1 frame to determine hot region
maxPfr = max(max(test));
minPfr = min(min(test));

%minfa=min(min(min(frame_array,[],1),[],2),[],3); % get minimal temp value
%maxfa=max(max(max(frame_array,[],1),[],2),[],3); % get maximal temp value
[rmin,cmin,vmin] = ind2sub(size(test),find(test == minPfr));
[rmax,cmax,vmax] = ind2sub(size(test),find(test == maxPfr));

%% calculate area where values are above unnatural (45degree celcius) + range of 5 pixels around
[rcheck_max,ccheck_max,~] = ind2sub(size(test),find(test > 45));
%[rcheck_max,ccheck_max,~] = ind2sub(size(test),find(test > 45));

minexr=min(rcheck_max)-5; %minimum index row
minexc=min(ccheck_max)-5; %minimum index col
maxexr=max(rcheck_max)+5; %maximum index row
maxexc=max(ccheck_max)+5; %maximum index col
if minexr <0
    minexr=1
end
if minexc<0
    minexc=1
end
if maxexr<0
    maxexr=1
end
if maxexc<0
    maxexc=1
end

frame_array(minexr:maxexr,minexc:maxexc,:)=NaN;
nframe_array=frame_array;
end
