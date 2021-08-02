IRT

UNDER DEVELOPMENT
scripts for loading,viewing, calculating multiple images from multiple video's from FLIR Infrared thermography camera (IRT FLIR 430c ), exported as .mat files using researchIR. Developed for video's of birds, but should be applicable to other images/videos.
by Sita ter Haar
written in MATLAB 2017a Windows 7, adapted to Matlab 2019b in linux mint 19.2

For completely automatic analysis:
Run script IRT_multiplefiles_automatic.m (green 'play' button, or F5. Make sure that datefromfileinfo.m, IRT_plot_min_max_automatic_1.m and checkframe_excludeparts_automatic.m are in the same folder.
Make sure folder with all scripts is added to path (left sidebar with 'current folder' is not greyed out. if it is grey, right click and select 'add to path> selected folder and subfolders')

For semi-automatic (check inbetween to see if selected images are OK):
run IRT_multiple files. In the console, you are asked to enter y to continue (if you think images are OK), or r to redo (if you think images are not OK)
In the pop-up select the folders containing IRT video data in .mat format

Images of the frame with the max value is shown (where you see the animal), with asterix op de max value to verify that the max value is on the eye region. It automatically proceeds to the next video

It may take a while before it is done!

If you want to check a video, run the script 'IRT_play_min_max10aug20manual_shortened.m'. The red asterix will indicate the max value through the video.