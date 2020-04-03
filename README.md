IRT

%UNDER DEVELOPMENT
%%scripts for loading,viewing, calculating multiple images from multiple video's 
%from FLIR Infrared thermography camera (IRT FLIR 430c ), exported as .mat files using researchIR 
%by Sita ter Haar
%written in MATLAB 2017a Windows 7


Run script IRT_multiplefiles17okt19.m make sure that datefromFilename.m en IRT_plot_min_max17okt19.m are in the same folder.

In line 57 t/m 65 in IRT_multiplefiles17okt19.m maximum values per frame are plotted. 
(If you want to change font size for example, you can change the value where it now sais 7 to whatever you like)

In line 70 t/73 in IRT_plot_min_max17okt19 an image of the frame with the max value is shown (where you see the animal), with asterix op de max value

If there is a part you want to exclude, type a % before the line. That part will turn green and will be excluded. Sometimes this results in errors, if a variable is created that is needed elsewhere for example.

