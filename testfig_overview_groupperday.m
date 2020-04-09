count=0
for n = 3:(length(output))
    if output{n,11} == uniquedates{1}
        color=[1 0 0];
    elseif output{n,11} == uniquedates{2}
        color=[0 1 0];
    elseif output{n,11} == uniquedates{3}
        color=[0 0 1];
    else 
        color=[0 0 0];
    end
    x=str2num(cell2mat(output(n,10)))/10000;
    y=cell2mat(output(n,3));
    if contains(output(n,1), 'after')==0
        %x=str2num(cell2mat(output(n,9)))/10000;
        %y=cell2mat(output(n,3));
        %overview_plot=plot((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), '.', 'Color', color)
        overview_plot=plot(x,y, '.', 'Color', color);
        
        %plot((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), '.')
        %text((str2num(cell2mat(output(n,9)))/10000), cell2mat(output(n,3)), strcat('___', num2str(n-2)),'Fontsize', 7, 'Color', color)
        text((str2num(cell2mat(output(n,10)))/10000), cell2mat(output(n,3)), [' ' num2str(n-2)],'Fontsize', 7, 'Color', color);
    else
        overview_plot=plot((str2num(cell2mat(output(n,10)))/10000), cell2mat(output(n,3)), 'Color', color);
        text((str2num(cell2mat(output(n,10)))/10000), cell2mat(output(n,3)), [' ' num2str(n-2) 'a'],'Fontsize', 7, 'Color', 'r');
    end
    count=count+1;
    meanmx=cell2mat(output(n,5));
    minmx=cell2mat(output(n,4));
    if count == 3
        %errorbar(x,meanmx,(minmx-meanmx),(cell2mat(output((n-2),3))-meanmx),'o')
        %error bar with Avmax, minofmax and maxmax --> not good, when bird
        %out of view, value very low  --> better Standard Dev.
        errorbar(x,meanmx,StDmax, 'o')
        count=0;
    end
end
xlim([0 24])
ylim([25 45])
xlabel('time (h) from 0 to 24')
legend('Location', 'northeastoutside')


%
%%

%%%%%%%
f=figure
%for n = 3:(length(output))
x=str2num(cell2mat(output(3:end,10)))/10000;
y=cell2mat(output(3:end,3));
group=output(3:end,11);
%gscatter(Weight,MPG,Model_Year,'','xos')
gscatter(x,y,group,'','x.sd');

%errorbar(x,meanmx,(minmx-meanmx),(cell2mat(output((n-2),3))-meanmx),'o')
%error bar with Avmax, minofmax and maxmax --> not good, when bird
%out of view, value very low  --> better Standard Dev.
errorbar(x,meanmx,StDmax, 'o')


%end
xlim([0 24]);
ylim([25 45]);
xlabel('time (h) from 0 to 24');
legend('Location', 'northeastoutside');

%boxplot(x,g) 
f2=figure
boxplot(x,y,group) 

StDmax=cell2mat(output(3:end,6));
meanmx=cell2mat(output(3:end,5));
%minmx=cell2mat(output(n,4));Subscripting into a table using one subscript (as in t(i)) or three or more subscripts (as in t(i,j,k)) is not

%%
uniquedates = unique(output(3:length(output),11));
f3=figure

errorbar(x,meanmx,StDmax, 'o')

%grouped by cylinder
grpstats([Acceleration,Weight/1000],Cylinders,0.05)

%%
%%after reading table from csv
uniquedates=unique(NB184SDIRT1518okt18output.output11)
%f3=figure

for m =1:length(uniquedates)
    f=figure
    rows=find(NB184SDIRT1518okt18output.output11==uniquedates(m))
    %StDmax=cell2mat(output(3:end,6));
    %meanmx=cell2mat(output(3:end,5));
    means=NB184SDIRT1518okt18output.output5(rows(1):rows(end))
    StD=NB184SDIRT1518okt18output.output6(rows(1):rows(end))
    x=(NB184SDIRT1518okt18output.output10(rows(1):rows(end)))/10000
    %headers = {'filename', 'frameNumber', 'max', 'minOfMax', 'AvMax', 'StDma   x', 'vmin', 'bestImage', 'm', 'timestamp', 'date'}
    errorbar(x,means,StD, '-s')
    legend(uniquedates(m))
    %hold on
%end
%hold off
xlim([0 24]);
ylim([25 45]);
xlabel('time (h) from 0 to 24');
legend('Location', 'northeastoutside');
end
legend(uniquedates)
hold off

    