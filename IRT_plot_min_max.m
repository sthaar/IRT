%% Script for loading,viewing, calculating data from FLIR Infrared thermography camera (IRT FLIR 430c )
% by Sita ter Haar
% with acknowledgments to Chirs Klink for heeps of help!

%edit since 15 apr: commented out tiff. not necessary for now
%9dec restriction that 3 max values are at least 10 (more?) pixels apart
%not anymore, now90,95 and 100%
%added buttons, not working yet

function [maxThree, MinofMax, minfa, AvMax, select] = IRT_plot_min_max(maxeye, mineye, myfilepath, filename)
%% set functions for buttons
%function button_call(varargin)
%        if figsubpb1.Value == true
%            select(1) = 1
%        elseif figsubpb2.Value == true
%            select(2) = 1
%        elseif figsubpb3.Value == true
%            select(3) = 1
%        elseif figsubpb4.Value == true
%            select(1:3) = 1
%        end
%end

%function pb_kpf(varargin)
%    if strcmp(varargin{1,2}.Key, '1'|'2'|'3'|'space')
%            pb_call(varargin{:})
%    end
%end

%% Load the data
%[filename, filepath] = uigetfile('.mat'); % select datafile
fprintf(['Loading data ' filename '...\n']);
Z=load([myfilepath '/' filename]); % load the data

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
if HighestFrameNr >1
    frame_array = zeros(size(Z.Frame1,1),...
        size(Z.Frame1,2),framenr-1); % pre-allocate a 3d array
    for f=1:HighestFrameNr
         frame_array(:,:,f) = eval(['Z.Frame' num2str(f)]); % put frames in
    end
end

usr = 'r';
rerun = 0;
while usr == 'r'
    %% animate in implay (needs to be in 0-255 range)%outcommented in version 23okt18
    % fa=frame_array; % duplicate array (think about memory: don't do this if you don't need it)
    % minfa=min(min(min(fa,[],1),[],2),[],3); % get minimal temp value
    % maxfa=max(max(max(fa,[],1),[],2),[],3); % get maximal temp value
    % fan = uint8(((fa-minfa)./(maxfa-minfa))*255); % normalize to 8-bit range
    
    %% exclude unnatural values above 50 degree celcius
    %testlamp=frame_array;
    %testlamp(find(testlamp>40))=NaN;
    frame_array(find(frame_array>50))=NaN;
    
    %% animate in figure window (in temp scale)
%    minfa=min(min(min(frame_array,[],1),[],2),[],3); % get minimal temp value
%    maxfa=max(max(max(frame_array,[],1),[],2),[],3); % get maximal temp value
    %%animation
    %mfig = figure; % open figure window
    %set(mfig,'Position',[0 0 640 512]); % with predefined size and position
    %i=1; % framenr to cycle through
    %while ishghandle(mfig) && i<=HighestFrameNr %check if fig window and frame exist
    %    pause(0.02) % pause after every frame (determines play-rate
    %        imagesc(frame_array(:,:,i),[minfa maxfa]); % draw
    %        c=colorbar;title(c,'Temp (C)'); % temp scale bar
    %        title(['FrameNr: ' num2str(i)]); % title with frame nr
    %    i=i+1; % nest frame
    %end
    
    %% calculate max value of each frame and determine min and max of that (i.e. range of max values)
    maxPFr = zeros(1,HighestFrameNr);%create empty array
    for f=1:HighestFrameNr % for each frame, extract the max value and place in array maxPFr
        maxPFr(f) = max(max(frame_array(:,:,f)));%absolute max of frame
        %minOfMaxPFr(f) = min(max(frame_array(:,:,f))); % minimum of max of each column per frame, so not informative
        minPFr(f)= min(min(frame_array(:,:,f))); % minimum per frame, so background
    end
    
    maxsorted=sort(maxPFr, 'descend');
    maxThree = [] ;
%    outrow=0;
  
    %22jan20
    %extremesexcluded=maxsorted(maxsorted<maxeye);
    extremesexcluded=maxPFr(maxPFr<maxeye & maxPFr > mineye);
    if isempty(extremesexcluded)== true
        %delete(mfig)
        frame_array = checkframe_excludeparts(frame_array);    
         for f=1:HighestFrameNr % for each frame, extract the max value and place in array maxPFr
            maxPFr(f) = max(max(frame_array(:,:,f)));%absolute max of frame
            minPFr(f)= min(min(frame_array(:,:,f))); % minimum per frame, so background
         end
      %  maxsorted=sort(maxPFr, 'descend');
%3april20 something should be fixed?
%05jan21 outcommented line below becuase duplicate of line 102
%    extremesexcluded=maxPFr(maxPFr<maxeye);
    end
    
    maxsorted=sort(maxPFr, 'descend');
    threshold=maxsorted(int16(length(maxsorted))*0.1); %threshold max 10% 
 
mfig = figure('units','normalized','outerposition',[0 0 1 1]); % open figure window
    ishghandle(mfig)
    pos = get(gcf, 'Position'); %// gives x left, y bottom, width, height
    set(gcf, 'Position',  [pos(1), pos(2), pos(3)*2, pos(4)*2]) %this increases fig size, note that at end whole fig is mvoed to left
    %create panel and buttons
    %maxthreshold above which not natural eye temperature is expected. check
    %with testhighthresh
    
    minfa=min(min(min(frame_array,[],1),[],2),[],3); % get minimal temp value
    maxfa=max(max(max(frame_array,[],1),[],2),[],3); % get maximal temp value
    
    indMax10perc=find(extremesexcluded>threshold);
    max10perc=extremesexcluded(indMax10perc);
    indthresh=find(extremesexcluded==threshold); %index of threshold in maxsorted
    %%todo: check of bovenstaande regel maxsorted of extremesexcluded moet zijn    
    %9dec restriction that 3 max values are at least 10 (more?) pixels apart
    % for j = maxsorted(1:10:30)  %from 1 to 30 steps of (90%) and inbetween
    % (95%)
    % now max (100%) threshold (90
    %
    titlearray = {'100%', '95%', '90%'};
    outrow=1;
    for j = extremesexcluded(1:int16(indthresh(1)/3):(indthresh(1)-1))%plot maxthre (90,95&100% values) 
        %above threshold (10%), 
        %in steps of 1/3 of the 10% (rounded because of index) of with exteme values excluded
        
        [rmin,cmin,vmin] = ind2sub(size(frame_array),find(frame_array == minfa));
        [rmax,cmax,vmax] = ind2sub(size(frame_array),find(frame_array == j));
        % create variable maxThree for output, one row per frame (outrow), first column
        % vmax = frame nr, 2nd column j is max value of that frame
        %!!fix (1)
        maxThree(outrow,1) = vmax(1) ;%the (1) behind it is in case there are two frames with the same value. I shoudl fix this to store both
        maxThree(outrow,2) = j;
        
        subplot(1,3,outrow)
        im=frame_array(:,:,vmax(1));
        %!!fix (1)
        imagesc(im,[minfa j])% draw frame with maximum value.%the (1) behind it is in case there are two frames with the same value. I shoudl fix this to store both
        %place marker at max value
        hold on
        
        %maxframe=plot(cmax(1),rmax(1),'r*'); %(1) behind if multiple frames
        maxframe=plot(cmax(1),rmax(1),'r*','MarkerSize', 2); %(1) behind if multiple frames)
%        assignin('base', 'maxframe', maxframe)
        %
        % bla = uicontrol(gcf,...
        %button = uicontrol (mfig, 'style','pushbutton')
        %figsubp = uipanel('Parent',figp,'Title','Subpanel','FontSize',8,...
        %         %'Position',[.4 .1 .5 .5]);
        %        'Position',[outrow/10 .1 .5 .5]);
        %figsubpb = uicontrol('Parent',figsubp,'String','Push here',...
        %    figsubpb = uicontrol('Parent',figp,'String','Push here',...
        %              'Units', 'normalized','Position',[pos(1)*outrow pos(2) (pos(3)/3) (pos(4)/3)]); %'Position',[1.8*(outrow*5) 18 72 36])
        %text = uicontrol (mfig, 'style','pushbutton')
        %... Select eye with cursor and export to workspace as 'eye_min'. ...
        axis square
        %    title({[' max-' num2str(outrow)]})
        %title([titlearray(outrow) 'frame' vmax(1) 'max:' j])    
        title([titlearray{outrow} ' frame ' num2str(vmax(1)) ' max:' num2str(j)])
        outrow=outrow+1 
        movegui('west');
    end

    %sgtitle({filename(2:end)})
    sgtitle([{filename}, {[' rerun = ' num2str(rerun)]}])
%    hold off
    [filepath,name,ext] = fileparts(filename);
    saveas(maxframe,strcat(myfilepath,'/maxframe_',name),'tiff') %myfilepath refers to IRT_multiplefiles
    
    % max(maxPFr) is same as maxfa
    mmfig = figure; % open figure window
    MinofMax = min(maxPFr); % is minimum of all max values (max expected to correlate with eye). if bird is absent 23 or so in Rec-zebrafinch test-000381-179_09_31_16_737_original
%    AvMax = mean(maxPFr);
 AvMax = mean(extremesexcluded);
   
    %plots max and min of max values
    %and plots the max 10% of values between minofmax and max --> not really?
    %minofmax not used
    %SO NOT between min and max, because then you include background values
    
   ishghandle(mmfig)
    lineplot=plot(maxPFr, '.','DisplayName', 'max')
    hold on
    %plot(minOfMaxPFr, 'DisplayName', 'min of max')
    plot(minPFr, '.','DisplayName', 'min');
    %plot(xymax10p, 'DisplayName', 'max10p')
    %plot(indMax10perc,max10perc, '--', 'DisplayName', 'max10p')
    plot(indMax10perc,max10perc, 'g*', 'DisplayName', 'max10p')
    threeImgs=plot(maxThree(:,1),maxThree(:,2), 'r*', 'MarkerSize', 3, 'DisplayName', 'threeImgs'); % red dots for the three images plotted before
    
    line([1,length(maxPFr)],[threshold,threshold],'Color','yellow','LineStyle','--', 'DisplayName', 'max10pthresh')
    line([1,length(maxPFr)],[maxeye,maxeye],'Color','red','LineStyle','--', 'DisplayName', 'excludedabove')
    line([1,length(maxPFr)],[mineye,mineye],'Color','red','LineStyle','--', 'DisplayName', 'excludedbelow')
    line([1,length(maxPFr)],[AvMax,AvMax],'Color','black','LineStyle','--', 'DisplayName', 'average_max')
    xlabel('frame number')
    ylabel('temperature(C)')
    title({filename(2:end)})
    %ylim([minfa maxfa+2])
    ylim([20 45])
    hold off
    legend('show', 'Location', 'northeastoutside')
  %  movegui('east')
    %%
    %[filepath,name,ext] = fileparts(filenames(k).name)
    saveas(lineplot, strcat(filepath,'maxframe_',name),'tiff')
    
    figure(mfig)
    usr = input('next? y or redo? r', 's');
    if usr == 'r';
 %       if j==length(extremesexcluded);
 %           continue
  %      else
        frame_array(:,:,[maxThree(:,1)])=NaN; %exclude values that were just shown and not good enough
%        frame_array(maxThree(1,1))
        rerun =rerun+1;
        close all
   %     end
    elseif usr == 'y';
        continue
    else
        warning('wrong input, only y or r allowed')
        usr = input('next? y or redo? r', 's');
    end
end

%test=frame_array(:,:,[maxThree(:,1)]); for next step I should make
%maxThree NaN (what now is test)
%% buttons
%%oud:
%figp = uifigure('Title','Main Panel','FontSize',10,...
%             'BackgroundColor','white',...
%             'Position',[.05 .05 .9 .2]);
%bg = uibuttongroup(bfig,'Position',[5 5 123 100], 'ButtonDownFcn',
%@butnfunc); werkt niet
%bg = uibuttongroup(bfig,'Position',[5 5 123 100], 'Selection',@bselection); https://nl.mathworks.com/help/matlab/ref/uibuttongroup.html
%ButtonDownFcn?

%%uitproberen
%pos = getpixelposition(bg); %// gives x left, y bottom, width, height
%posshift = (pos(1) + (pos(3)-pos(1))/3);
%figsubpb1 = uitogglebutton('Parent',figp,...
%'Position',[pos(1) 18 72 36], 'call',@button_call); %'Position',[1.8*(outrow*5) 18 72 36])
%callback function in uitogglebutton? nee wel in buttongroup
%https://nl.mathworks.com/help/matlab/ref/uibuttongroup.html
%misschien betern zoals tb = uicontrol(gtfig, 'Style', 'togglebutton', 'String', 'Start/Stop', 'tag', 'togglebutton1', 'Position', [30 20 100 30])
%set(tb,'Callback',@fun1); %https://nl.mathworks.com/matlabcentral/answers/182628-how-can-i-get-the-value-of-toggle-button-uicontrol

%%%

%oud
% bfig = uifigure('Position',[140 140 140 140]);
% bg = uibuttongroup(bfig,'Position',[5 5 123 100]);
% figsubpb1 = uitogglebutton(bg, 'Position',[10 75 100 22]); %'Position',[1.8*(outrow*5) 18 72 36])
% figsubpb2 = uitogglebutton(bg, 'Position',[10 50 100 22]); %'Position',[1.8*(outrow*5) 18 72 36])
% figsubpb3 = uitogglebutton(bg, 'Position',[10 25 100 22]); %'Position',[1.8*(outrow*5) 18 72 36])
% figsubpb4 = uitogglebutton(bg, 'Position',[10 1 100 22]); %'Position',[1.8*(outrow*5) 18 72 36])
%
% figsubpb1.Text = 'n1';
% figsubpb2.Text = 'n2';
% figsubpb3.Text = 'n3';
% figsubpb4.Text = 'all';
%
% buttons = [figsubpb1 figsubpb2 figsubpb3 figsubpb4]
select=[0 0 0];
selectimages = 0;
while selectimages == 0
    %inputdlg({'Name','Telephone','Account'},.
    prompt = {'im1','im2','im3'};
    dlgtitle='which images do you want to save? enter 1 to save data, 0 for not. hit enter when done)';
    dims = [1 35];
    %n=inputdlg(prompt)
    definput = {'1','1','1'}
    n=inputdlg(prompt, dlgtitle, dims, definput)
    try
        for nn = 1:3
            select(nn)=eval(n{nn});
        end
        selectimages = 1;
        %       nn=eval(n{1})
        %      if isnumeric(nn)
        %         nn=eval(n{1})
        %        select(nn) = 1
        %       selectimages = 1
        %  else
        %      warning('wrong input, only 1,2,3 or combination allowed')
        %            selectimages = 0
        % end
    catch
        warning('wrong input, only 1,2,3 or combination allowed')
        selectimages = 0;
    end
end

end

%%oud
% for n = 1:4
%         if n<4 & buttons(n).Value == 1
%                 select(n) = 1
%         elseif buttons(4).Value == 1
%                 select(1:3) = 1
%         end
% end


%% dit kan ik aanzetten als ik geen semiauto wil. delete(bfig)
% end
%
% function butnfunc(varargin)
%
% end
%waitfor(bfig)

%... Select eye with cursor and export to workspace as 'eye_min'. ...
%%
%eye_min_value = frame_array(eye_min.Position(2),eye_min.Position(1),vmin)

%% same for max
%imagesc(frame_array(:,:,vmax),[minfa maxfa])% draw frame with maximum value

%...Select eye with cursor and export to workspace as 'eye_max'.
%%
%eye_max_value = frame_array(eye_max.Position(2),eye_max.Position(1),vmax)
%wing_max_value = frame_array(wing_max.Position(2),wing_max.Position(1),vmax)

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