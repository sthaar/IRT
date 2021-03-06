%%script for loading,viewing, calculating data from FLIR Infrared thermography camera (IRT FLIR 430c ) 
%%by Sita ter Haar & Chirs Klink
%%previous version version 11okt19



function [maxThree, MinofMax, minfa, AvMax, StDmax] = IRT_plot_min_max_automatic(maxeye, myfilepath, filename, filenames)
%% Load the data
%[filename, filepath] = uigetfile('.mat'); % select datafile
fprintf(['Loading data ' filename '...\n']);
%Z=load([myfilepath filename]); % load the data
for x=1:length(filenames)
    if strcmp(['/', filenames(x).name],filename)
        folder=filenames(x).folder
    end
end
Z=load([folder filename]); % load the data
%% find how many frames exist in this data-file
HighestFrameFound = false; % switch for loop below
FirstFrameFound = false
framenr=1; % start looking at frame nr 1 and find the highest frame nr
fprintf('Highest framenr: ');
fld=fieldnames(Z);
while ~HighestFrameFound
    fn=['Frame' num2str(framenr)]; % create a 'FrameX' label
    %fprintf(['fn ' fn '...\n'])
    framenr=framenr+1; % if so check next number
    if isfield(Z,fn) % does it exist in Z?
        if FirstFrameFound == false;
            FirstFrameNr = framenr;
            FirstFrameFound = true;
        end
    else
        if FirstFrameFound == true
            HighestFrameFound = true; % previous number was the last exist
            HighestFrameNr=framenr-2; % so subtract one
            fprintf([num2str(HighestFrameNr) '\n']); % and print to cmd
        else
           HighestFrameFound = size(Z.fld{1},3); % previous number was the last exist

        end
    end
end

%% collecting frames in a single array
if HighestFrameNr >1
    fr=['Frame' num2str(HighestFrameNr)]
    frame_array = zeros(size(Z.(fr),1),...
    size(Z.(fr),2),framenr-1); % pre-allocate a 3d array
    for f=FirstFrameNr:HighestFrameNr
        frame_array(:,:,f) = eval(['Z.Frame' num2str(f)]); % put frames in
    end

%% get min and max value of whole frame
minfa=min(min(min(frame_array,[],1),[],2),[],3); % get minimal temp value
maxfa=max(max(max(frame_array,[],1),[],2),[],3); % get maximal temp value

%% animate in implay (needs to be in 0-255 range)%outcommented in version 23okt18
% fa=frame_array; % duplicate array (think about memory: don't do this if you don't need it)
% minfa=min(min(min(fa,[],1),[],2),[],3); % get minimal temp value
% maxfa=max(max(max(fa,[],1),[],2),[],3); % get maximal temp value
% fan = uint8(((fa-minfa)./(maxfa-minfa))*255); % normalize to 8-bit range

%% animate in figure window (in temp scale)

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
%% very extreme values like hot lamp (everythong above 45degree C) replaced with NaN by a block
if maxfa > 45
    frame_array=checkframe_excludeparts_automatic(frame_array);
end
%% calculate max value of each frame and determine min and max of that (i.e. range of max values)
maxPFr = zeros(1,HighestFrameNr);%create empty array
for f=1:HighestFrameNr % for each frame, extract the max value and place in array maxPFr
    mx = max(max(frame_array(:,:,f)));%absolute max of frame;
    maxPFr(f) = mx(1);
    %minOfMaxPFr(f) = min(max(frame_array(:,:,f))); % minimum of max of each column per frame
end  




%% extreme values above 'max eye' replaced by NaN per individual pixel

%maxsorted=sort(maxPFr, 'descend');
maxThree = [];
outrow=1;

 extremesexcluded=maxPFr(maxPFr<maxeye);
maxsorted=sort(maxPFr, 'descend');

 threshold=maxsorted(int16(length(maxsorted))*0.1); %threshold max 10%    
    %changed maxPFr to extremesexcluded
    %23jan20:
    %indMax10perc=find(maxPFr>threshold); 
    %max10perc=maxPFr(indMax10perc);
    
    indMax10perc=find(extremesexcluded>threshold);
    max10perc=extremesexcluded(indMax10perc);
    indthresh=find(extremesexcluded==threshold); %index of threshold in maxsorted
    
mfig = figure('units','normalized','outerposition',[0 0 1 1]); % open figure window
ishghandle(mfig)

for j = maxsorted(1:3)  
    % find which frame has min and which frames have the 3 highest values (top
    % 3) v in vmin and vmax means frame number 
    [rmin,cmin,vmin] = ind2sub(size(frame_array),find(frame_array == minfa));
    [rmax,cmax,vmax] = ind2sub(size(frame_array),find(frame_array == j));
    % create variable maxThree for output, one row per frame (outrow), first column
    % vmax = frame nr, 2nd column j is max value of that frame
   %!!fix (1)
    maxThree(outrow,1) = vmax(1);%the (1) behind it is in case there are two frames with the same value. I shoudl fix this to store both
    maxThree(outrow,2) = j;
   
    subplot(1,3,outrow)
    im=frame_array(:,:,vmax(1));
    %!!fix (1)
    imagesc(im,[minfa maxfa]);% draw frame with maximum value.%the (1) behind it is in case there are two frames with the same value. I shoudl fix this to store both
    %place marker at max value
    hold on
    
    maxframe=plot(cmax,rmax,'r*', 'MarkerSize', 2);
    axis square;
    title({filename(2:end), [' max-' num2str(outrow), ', frame= ' num2str(maxThree(outrow,1)), ', max value= ' num2str(maxThree(outrow,2))]});
    %title({filename, strcat('\ max\-', num2str(outrow))})
    outrow=outrow+1;
    movegui('west');  
end

    sgtitle([{filename}])

    [filepath,name,ext] = fileparts(filename);
    saveas(maxframe,strcat(myfilepath,'/maxframe_',name),'tiff') %myfilepath refers to IRT_multiplefiles_automatic
    
    mmfig = figure; % open figure window
    MinofMax = min(maxPFr); % is minimum of all max values (max expected to correlate with eye). if bird is absent 23 or so in Rec-zebrafinch test-000381-179_09_31_16_737_original
    indMinmx=find(maxPFr==MinofMax);
    %AvMax = mean(maxPFr);
    AvMax = mean(extremesexcluded);
    StDmax=std(extremesexcluded);
    
    %plots max and min of max values (latter is probably lowest animal value)
    %and plots the max 10% of values between minofmax and max
    %SO NOT between min and max, because then you include background values
    ishghandle(mmfig)
    lineplot=plot(maxPFr, '.','DisplayName', 'max');
    hold on
    plot(indMax10perc,max10perc, 'g*', 'MarkerSize', 2, 'DisplayName', 'max10p');
    threeImgs=plot(maxThree(:,1),maxThree(:,2), 'r*', 'MarkerSize', 2, 'DisplayName', 'threeImgs'); % red dots for the three images plotted before
    minofmax=plot(indMinmx, MinofMax, 'b*', 'MarkerSize', 2, 'DisplayName', 'MinofMax');
    line([1,length(maxPFr)],[threshold,threshold],'Color','yellow','LineStyle','--', 'DisplayName', 'max10pthresh');
    line([1,length(maxPFr)],[maxeye,maxeye],'Color','red','LineStyle','--', 'DisplayName', 'excludedabove');
    line([1,length(maxPFr)],[AvMax,AvMax],'Color','black','LineStyle','--', 'DisplayName', 'average_max');
    xlabel('frame number');
    ylabel('temperature(C)');
    title({filename(2:end)});
    %ylim([minfa maxfa+2])
    ylim([20 45])
    hold off
    legend('show', 'Location', 'northeastoutside')
 
    saveas(lineplot,strcat(myfilepath,'/lineplot_max_',name),'tiff')


end
close all

end
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