function [fdate] = datefromfileinfo(filen)
    names=fieldnames(Z)
%    framename=names(1)
    frameinfo=names((contains(names, 'DateTime'))==true)
   frameinfo(1)
   dt=Z.(frameinfo{1})
   d=dt([1:3])
    
%     for i = 1:length(names)
%         if contains(names{i}, 'DateTime')==true
%             bloep=names{i}
%         end
%     end
end
         
            
   
   
   
