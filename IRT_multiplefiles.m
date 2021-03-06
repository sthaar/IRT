%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%UNDER DEVELOPMENT
%%script for loading,viewing, calculating multiple images from multiple video's 
%from FLIR Infrared thermography camera (IRT FLIR 430c ), exported as .mat files using researchIR 
%by Sita ter Haar
%written in MATLAB 2017a Windows 7, adjusted to matlab2019 in linux mint
%make sure script IRT_plot_min_max (line 23) and datefromFilename.m are in the same folder
%as this one.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TODO
        
clear
prompt = 'max eye value'
maxeye = input(prompt);

myfilepath = uigetdir() %gets directory);
filenames = dir(fullfile(myfilepath,'*.mat')); %gets all mat files in struct

%output = {};
%achteraf gezien waarschijnlijk beter struct dan cell
headers = {'filename', 'frameNumber', 'max', 'minOfMax', 'AvMax', 'vmin', 'bestImage', 'm', 'timestamp', 'date', 'select'};
output=cell(1, length(headers));
output(1,1) = {matlab.desktop.editor.getActiveFilename};
output(1,2) = {maxeye};
output(2,:) = headers;
run=1
for k = 1:length(filenames)
    %filename=strcat('\',filenames(k).name)
    %filename=strcat('/',filenames(k).name)   
    filename=strcat(filenames(k).name);
    %script 'IRT_play_min_max14okt19' gets frames with max three values and
    %plots it. In first plot also lines for min and max values over alle
    %frames are plotted (still have to split this into a seperate graph
    [maxThree, MinofMax, minfa, AvMax, select]=IRT_plot_min_max(maxeye, myfilepath, filename) ;       
    %if HighestFrameNr > 1
        filedate=datefromFilename(filename);
        %matrix kan niet character dus dit werkt niet: output = [filename maxfa vmax rmax cmax]
        timeindend=max(strfind(filename, '_'));
        timeindst=timeindend-8;
        %time38stampstr=replace(filename(timeindst:timeindend-1), '_', ':')
        timestampstr=erase(filename(timeindst:timeindend-1), '_');
        %timestamp=datetime(timestampstr, 'InputFormat', 'HH:mm:ss')
        for m = 1:3
            %maxThree is now 90, 95 and 100% values (15dec19)
          appendline = {filename, maxThree(m,1), maxThree(m,2), MinofMax, minfa, AvMax, 0, m, timestampstr, filedate, select(m)};
            output(end+1,:) = appendline;
        end
   % end
end
T = cell2table(output);
writetable(T,strcat(myfilepath, 'output.csv'))

%%%plot per day

%color=[0 0 0]
uniquedates = unique(output(3:size(output, 1),10));
nfig = figure; % open figure window
ishghandle(nfig);
hold on
%plot timestamp (x), by max values (y)
for n = 3:(size(output, 1));
    if output{n,10} == uniquedates{1};
        color=[1 0 0];
    elseif output{n,10} == uniquedates{2};
        color=[0 1 0];
    elseif output{n,10} == uniquedates{3};
        color=[0 0 1];
    else 
        color=[0 0 0];
    end
    if output{n,11}==0 ;%output(11)=select --> so plot if 1 (selected) but not if 0 (not selected)
        color(color==0)=0.5;
    end
    if contains(output(n,1), 'after')==0;
        plot((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), '.', 'Color', color);
        %plot((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), '.')
        %text((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), strcat('___', num2str(n-2)),'Fontsize', 7, 'Color', color)
        text((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), [' ' num2str(n-2)],'Fontsize', 7, 'Color', color);
    else
        plot((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), 'Color', color);
        text((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), [' ' num2str(n-2) 'a'],'Fontsize', 7, 'Color', 'r');
    end
end
xlim([0 24]);
ylim([35 40]);
xlabel('time (h) from 0 to 24');
