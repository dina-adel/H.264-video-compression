function Extract_Video_Frames(Video_path,Saving_path)
%%%%%%%%%%%%%%%%%%%%%%
% Extract_Video_Frames(Video_path,Saving_path)
% Input : 
% Video path    - Path of the folder of the video on computer followed by .mp4
% Save Path     - path on the computer for the folder to save images (frames) into
% Output: 
% The Saved indexed frames in the desired folder
%%%%%%%%%%%%%%%%%%%%%%
  vid=VideoReader(Video_path);
  numFrames = vid.NumberOfFrames;
  n=numFrames;
  
for i = 1:n
   frames = read(vid,i);
   baseFileName = sprintf('%d.jpg', i);
   fullFileName = fullfile(Saving_path, baseFileName);
   imwrite(frames, fullFileName);
   %imwrite(frames,[Saving_path int2str(i), '.jpg']);
end 
end

