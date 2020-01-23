%check one frame by it's number
function [nframe_array]=checkframe_excludeparts(frame_array)
prompt = 'Which frame do you want to check? ';
frametocheck = input(prompt);

test = frame_array(:,:,frametocheck);
maxPfr = max(max(test))
minPfr = min(min(test))

%minfa=min(min(min(frame_array,[],1),[],2),[],3); % get minimal temp value
%maxfa=max(max(max(frame_array,[],1),[],2),[],3); % get maximal temp value
[rmin,cmin,vmin] = ind2sub(size(test),find(test == minPfr));
[rmax,cmax,vmax] = ind2sub(size(test),find(test == maxPfr));

%% calculate area where values are above unnatural (45degree celcius)
[rcheck_max,ccheck_max,~] = ind2sub(size(test),find(test > 39));
minexr=min(rcheck_max); %minimum index row
minexc=min(ccheck_max); %minimum index col
maxexr=max(rcheck_max); %maximum index row
maxexc=max(ccheck_max); %maximum index col

w=1;
while w==1
    %plot frame and are to exclude with red asterixes
    fig = figure; % open figure window
    ishghandle(fig)
    imagesc(test,[minPfr maxPfr]) 
    %maxframe=plot(cmax(1),rmax(1),'r*')
    hold on
    plot(minexc, minexr, 'r*')
    plot(maxexc, minexr, 'r*')
    plot(minexc, maxexr, 'r*')
    plot(maxexc, maxexr, 'r*')

    %ask user if exclusion area is ok, if yes proceed if not go back
    inp =input('exclude part? (y/n/) or change dimensions? (c)','s');
    if inp =='y'
        test(minexr:maxexr,minexc:maxexc, 1)=NaN;
        delete(fig)
        %plot figure with exluded area
        fig = figure; % open figure window
        ishghandle(fig)
        imagesc(test,[minPfr maxPfr]) 
        %maxframe=plot(cmax(1),rmax(1),'r*')
        hold on
        input2 = input('ok? y/n','s')
        %ask again if ok and proceed
        if input2 == 'y'
            nframe_array=frame_array;
            nframe_array(minexr:maxexr,minexc:maxexc, :)=NaN;
            w=0;
        elseif input2 == 'n'
            warning('no new frame_array requested, exit')
            w=0;
        elseif input2 ~= 'y' | 'n'
            warning('wrong input, no new frame_array')
            w=1;
        end
    elseif inp == 'n'
        warning('no new frame_array requested, exit')
        w=0;
    elseif inp == 'c'
        prompt = {'min x:','min y:','max x:','max y:'};
        dlgtitle = 'new dimensions';
        %existing values default with window to change values
        minx=num2str(minexc);
        miny=num2str(minexr);
        maxx=num2str(maxexc);
        maxy=num2str(maxexr);
        definput = {minx,miny, maxx,maxy};
        dims = [1 35];
        answer = inputdlg(prompt,dlgtitle,dims,definput);
         minexc = eval(answer{1});
         minexr = eval(answer{2});
         maxexc = eval(answer{3})
         maxexr = eval(answer{4});
         w=1;
    elseif inp ~= 'y' | 'n'|'c'
        warning('wrong input, no new frame_array')
        w=1;
    end
end

