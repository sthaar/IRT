function [fdate] = datefromFilename(filen)
    Num = regexp(filen,'\d');
    years=(17:19);
    fdate=0;
    for i = 1:(length(Num)-6)
        if (Num(i+1) == (Num(i) +1)) && (any(years == str2num(filen(Num(i+2:i+3)))));
            %if any(A < 0.5)
            fdate = filen(Num(i):(Num(i)+6));
        else
            if fdate == ~0
                fdate = 'no date found';
            end
        end
    end
end
