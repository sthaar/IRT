%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%UNDER DEVELOPMENT
%%script for automatically loading,viewing, calculating max (and other) values of multiple Infrared Thermography video's 
%from FLIR Infrared thermography camera (IRT FLIR 430c ), exported as .mat files using researchIR 
%by Sita ter Haar
%written in MATLAB 2019 linux mint 19.2
%(originally in 2017a Windows 7 adusted to matlab 2019)
%make sure script IRT_plot_min_max_automatic (line 35) and datefromFilename.m are in the same folder
%as this one.
%in progress:
%-fixing legend overview plot
%-semiautomatic analysis
%-multiplotfor more detail
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 6aug21


clear
%values over 43 excluded 
maxeye = 43
auto_semi = input('automatic? type a or semiautomatic? type s', 's')

myfilepath = uigetdir %gets directory
filenames = dir(fullfile(myfilepath,filesep,'**','*.mat')); %gets all mat files in struct
%output = {};
%achteraf gezien waarschijnlijk beter struct dan cell
headers = {'filename', 'frameNumber', 'max', 'minOfMax', 'AvMax', 'StDmax', 'minfa', 'm', 'timestamp', 'date', 'scriptname'}
vartypes={'string', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double','string', 'string'}
%output=cell(1, length(headers))
output=table;
sz=[length(filenames)*3,length(headers)];
output=table('Size',sz, 'VariableTypes', vartypes, 'VariableNames',headers);
%temp = output(column1, column2, 'VariableNames',{'c1','c2'});


%output(1,:) = headers;
output.scriptname(1) = {matlab.desktop.editor.getActiveFilename};
addrow=1; %in order to add three rows each filename. 
for k = 1:length(filenames)
    %filename=strcat('\',filenames(k).name)
    filename=strcat('/',filenames(k).name)
    %script 'IRT_play_min_max14okt19' gets frames with max three values and
    %plots it. In first plot also lines for min and max values over alle
    %frames are plotted (still have to split this into a seperate graph
    [maxThree, MinofMax, minfa, AvMax, StDmax]=IRT_plot_min_max_automatic_1(maxeye, myfilepath, filename, filenames, auto_semi);   
   % if HighestFrameNr > 1      
        try filedate=datefromfileinfo(filename);
        catch filedate=datefromFilename(filename);
        end        %matrix kan niet character dus dit werkt niet: output = [filename maxfa vmax rmax cmax]
        timeindend=max(strfind(filename, '_'));
        timeindst=timeindend-8;
        timestampstr=erase(filename(timeindst:timeindend-1), '_');
        %timestamp=datetime(timestampstr, 'InputFormat', 'HH:mm:ss')%H,MI,S)
        %timestamp=datetime(timestampstr, (H, MI, S))
       for m = 1:3;
          %appendline = (filename, maxThree(m,1), maxThree(m,2), MinofMax, AvMax, StDmax, minfa, 0, m, timestampstr, filedate);
          %output(end+1,:) = appendline;
          r=addrow;%in order to add three rows each filename. 
          headers = {'filename', 'frameNumber', 'max', 'minOfMax', 'AvMax', 'StDmax', 'minfa', 'm', 'timestampstr', 'date', 'scriptname'};
          output.filename(r) = filename;
          output.frameNumber(r) = maxThree(m,1);
          output.max(r)= maxThree(m,2);
          output.minOfMax(r)=MinofMax;
          output.AvMax(r)=AvMax;
          output.StDmax(r)=StDmax;
          output.minfa(r)=minfa;
          output.m(r)=m;
          try
              output.timestamp(r)=str2num(timestampstr);
          catch output.timestamp(r) =0
          end
          output.date(r)=filedate;
          addrow=addrow+1;
        end
    %end
end
%T = cell2table(output);
[filepath,name,ext] = fileparts(filename);
sep=strfind(myfilepath, filesep)
foldrname=myfilepath((sep(end)+1):end)
%foldrname=strsplit(myfilepath, filesep)%last in array
writetable(output,strcat(myfilepath, filesep, foldrname,'_output.csv'))
%writetable(output,strcat(myfilepath, '/', name,'output.csv'))

%color=[0 0 0]
%uniquedates = unique(output(3:length(output),11));


%%
%hold on
%plot timestamp (x), by max values (y)
% count=0
% for n = 3:(length(output))
%     if output{n,11} == uniquedates{1}
%         color=[1 0 0];
%     elseif output{n,11} == uniquedates{2}
%         color=[0 1 0];
%     elseif output{n,11} == uniquedates{3}
%         color=[0 0 1];
%     else 
%         color=[0 0 0];
%     end
%     x=str2num(cell2mat(output(n,10)))/10000;
%     y=cell2mat(output(n,3));
%     if contains(output(n,1), 'after')==0
%         %x=str2num(cell2mat(output(n,9)))/10000;
%         %y=cell2mat(output(n,3));
%         %overview_plot=plot((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), '.', 'Color', color)
%         overview_plot=plot(x,y, '.', 'Color', color);
%         
%         %plot((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), '.')
%         %text((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), strcat('___', num2str(n-2)),'Fontsize', 7, 'Color', color)
%         text((str2num(cell2mat(output(n,10)))/10000), cell2mat(output(n,3)), [' ' num2str(n-2)],'Fontsize', 7, 'Color', color);
%     else
%         overview_plot=plot((str2num(cell2mat(output(n,10)))/10000), cell2mat(output(n,3)), 'Color', color);
%         text((str2num(cell2mat(output(n,10)))/10000), cell2mat(output(n,3)), [' ' num2str(n-2) 'a'],'Fontsize', 7, 'Color', 'r');
%     end
%     count=count+1;
%     meanmx=cell2mat(output(n,5));
%     minmx=cell2mat(output(n,4));
%     StDmax=cell2mat(output(n,6));
%     if count == 3
%         %errorbar(x,meanmx,(minmx-meanmx),(cell2mat(output((n-2),3))-meanmx),'o')
%         %error bar with Avmax, minofmax and maxmax --> not good, when bird
%         %out of view, value very low  --> better Standard Dev.
%         errorbar(x,meanmx,StDmax, 'o')
%         count=0;
%     end
% end
% xlim([0 24])
% ylim([25 45])
% xlabel('time (h) from 0 to 24')
% legend('show', 'Location', 'northeastoutside')

%%
uniquedates = unique(output.date);
nfig = figure; % open figure window
ishghandle(nfig)
hold on

uniquedates=unique(output.date)
%f3=figure

for m =1:length(uniquedates)
   % f=figure;
    rows=find(output.date==uniquedates(m));
    %StDmax=cell2mat(output(3:end,6));
    %meanmx=cell2mat(output(3:end,5));
    %means=output.AvMax(rows(1):rows(end));
    %maxmax(rows)=output.max(rows(1):rows(end))
    maxmax(m,rows)=output.max(rows)
    StD(m,rows)=output.StDmax(rows);
    x(m,rows)=(output.timestamp(rows))/10000;
%end
%hold off


end

maxmax(maxmax==0) = NaN
for m =1:length(uniquedates)
    overview_plot=errorbar(x(m,:),maxmax(m,:),StD(m,:), '-s', 'MarkerSize',3)
    hold on
end

xlim([-5 24]);
ylim([30 45]);
xlabel('time (h) from 0 to 24');

legend(uniquedates)
legend('Location', 'northeastoutside');
hold off



%[filepath,name,ext] = fileparts(filename);
%saveas(overview_plot,strcat(myfilepath,'/overview_plot',name),'tiff')
nameplot=strcat(myfilepath,'/',foldrname, '_overview_plot.epsc')
saveas(gcf,nameplot)
