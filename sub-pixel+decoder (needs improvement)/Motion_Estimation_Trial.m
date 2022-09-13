% Testing The Function to make Motion Estimation of a frame of the video
% Based on the reference frame
% Testing on Distant frames to analyze the effect of Motion Estimation
% Using SubPixel interpolation (Half , Quarter) or without Subpixel
% Interpolation
%%%%
% Only for Testing
%%%%
Video_path= 'E:\Education\Zewail Stuff\Courses\Year 4 - First Semester\Information Theory\Project\Phase 2\test_video.mp4';
Saving_path= 'E:\Education\Zewail Stuff\Courses\Year 4 - First Semester\Information Theory\Project\Phase 2\Video_Images';
referenceframe = imread([Saving_path '\' int2str(1), '.jpg']);
currentframe = imread([Saving_path '\' int2str(3), '.jpg']);
blocksize=16;
SearchRegion=48; 

[residual1 MVxh MVyh]=Motion_Estimation_Total(currentframe,referenceframe,blocksize,SearchRegion,0.5);
[residual2  MVyq]=Motion_Estimation_Total(currentframe,referenceframe,blocksize,SearchRegion,0.25)
[residual3 MVx MVy]=Motion_Estimation_Total(currentframe,referenceframe,blocksize,SearchRegion,0);
