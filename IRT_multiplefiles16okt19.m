%%script for loading,viewing, calculating multiple images from multiple video's 
%from FLIR Infrared thermography camera (IRT FLIR 430c ) 
%by Sita ter Haar
%written in MATLAB 2017a
%make sure script IRT_plot_min_max14okt19 (line 23) is in the same folder
%as this one.

clear
myfilepath = uigetdir %gets directory
filenames = dir(fullfile(myfilepath,'*.mat')); %gets all mat files in struct
%output = {};
%achteraf gezien waarschijnlijk beter struct dan cell
headers = {'filename', 'frameNumber', 'max', 'minOfMax', 'AvMax', 'vmin', 'bestImage', 'm', 'timestamp'}
output=cell(1, length(headers))
output(1,1) = {matlab.desktop.editor.getActiveFilename};
output(2,:) = headers;
for k = 1:length(filenames)
    filename=strcat('\',filenames(k).name)
    %filename=strcat('/',filenames(k).name)
    %script 'IRT_play_min_max14okt19' gets frames with max three values and
    %plots it. In first plot also lines for min and max values over alle
    %frames are plotted (still have to split this into a seperate graph
    IRT_plot_min_max15okt19
    %matrix kan niet character dus dit werkt niet: output = [filename maxfa vmax rmax cmax]
    timeindend=max(strfind(filename, '_'))
    timeindst=timeindend-8
    %timestampstr=replace(filename(timeindst:timeindend-1), '_', ':')
    timestampstr=erase(filename(timeindst:timeindend-1), '_')
    %timestamp=datetime(timestampstr, 'InputFormat', 'HH:mm:ss')
    for m = 1:3
        appendline = {filename, maxThree(m,1), maxThree(m,2), MinofMax, minfa, AvMax, 0, m, timestampstr};
        output(end+1,:) = appendline
    end
    
end
T = cell2table(output)
writetable(T,strcat(myfilepath, 'output.csv'))

nfig = figure; % open figure window
ishghandle(nfig)
hold on
%plot timestamp (x), by max values (y)
plot((str2num(cell2mat(output(3:end,9)))/10000), cell2mat(output(3:end,3)), 'o')
%plot(output(3:end,9), cell2mat(output(3:end,3)), 'o')
%plot(str2double(cell2mat(output(end-2:end,9))), cell2mat(output(end-2:end,3)), 'o')
%%xlim([datetick(min(str2num(cell2mat(output(end-2:end,9))) datetick(max(str2num(cell2mat(output(end-2:end,9)))])
xlim([0 24])
ylim([35 45])