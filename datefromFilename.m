function [fdate] = datefromFilename(filen)
    Num = regexp(filen,'\d\d...\d\d');%two numbers in a row
    Y=(17:20);
    fdate=0;
    try any(Y == str2num(filen((Num+5):(Num+6))));
        fdate = filen(Num:(Num+6));
    catch
        fdate = 'no date found';
    end
%     for i = 1:(length(Num)-6)
%         if any(years == str2num(filen(Num(i+5):Num(i+6))));
%             %if any(A < 0.5)
%             fdate = filen(Num(i):(Num(i)+6));
%         else
%             if fdate == ~0
%                 fdate = 'no date found';
%             end
%         end
%     end
end
