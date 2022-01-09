%replace FILE filename incl path between quotation marks in line below 

%Z=load([FILE]); % load the data
Z=load(['/home/sitath/Dropbox/Utrecht/VENIproject/SLEEP/irt/FLIRmovies/DATA_IRT/ingekorte videos matlab/f_green_orange2_C_BrdU_9-12jun20_ingekort/short_Rec-f_gr-or2_10jun20_db_1030-162_10_52_16_623.mat']); % load the data

fZ=fieldnames(Z);
framenames=fZ((contains(fZ, 'Frame')) & (not(contains(fZ, 'DateTime'))));
if isempty(framenames)
    if exist ('Z.frame_array', 'var')
        HighestFrameNr=length(Z.frame_array);
    else 
        HighestFrameNr=length(Z.(fZ{(1)}))
    end
else
    HighestFrameName=framenames(length(framenames)); % get name of last frame in framenames (not necessarily same as length framenames, if starts with 0 or >1
    HighestFrameNr = cell2mat(regexp(HighestFrameName{1}, '\d+', 'match'));
end


%%
if HighestFrameNr >1
    if isempty(framenames)==0
            fr=['Frame' num2str(HighestFrameNr)];%to determine size of array;
            if isfield(Z,fr)
                frame_array = zeros(size(Z.(fr)));
                %size(Z.(fr),2),framenr-1); % pre-allocate a 3d array why -1??
               % if FirstFrameNr==0 % 0 can't be index in matlab
                %    FirstFrameNr=FirstFrameNr+1
                 %   HighestFrameNr=HighestFrameNr+1
                %end
                for f=1:length(framenames)
                        frame_array(:,:,f) = eval(['Z.' num2str(framenames{f})]); % put frames in array (
                        %fprintf([num2str(f) ' '])
                end
            end
    elseif exist ('Z.frame_array', 'var')
        frame_array=Z.frame_array;
    else
        frame_array=Z.(fZ{(1)}); %shortened files, wit X * Y * Z dimensions
    end
end
