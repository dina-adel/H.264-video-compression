clc
clear
%Test Motion Estimation/Compensation/Prediction
Video_path= 'E:\Education\Zewail Stuff\Courses\Year 4 - First Semester\Information Theory\Project\Phase 2\test_video.mp4';
Saving_path= 'E:\Education\Zewail Stuff\Courses\Year 4 - First Semester\Information Theory\Project\Phase 2\Video_Images';
%Extract_Video_Frames(Video_path,Saving_path);

%read images and test
ref = imread([Saving_path '\' int2str(1), '.jpg']);
current = imread([Saving_path '\' int2str(2), '.jpg']);

current_frame =rgb2ycbcr(current(:,:,:));
reference_frame =rgb2ycbcr(ref);
disp('Encoding');
[coded_Dn_1,coded_Dn_2,coded_Dn_3,dict1,dict2,dict3, Fn_reconstructed, Mx_mat,My_mat,residual] = Encode_video(reference_frame,current_frame);
disp('Decoding');
Fn = Decode_video(reference_frame, Mx_mat,My_mat,residual,coded_Dn_1,coded_Dn_2,coded_Dn_3,dict1,dict2,dict3,1);
subplot(1,2,1)
imshow(current)
title('Original Frame');
subplot(1,2,2)
imshow(ycbcr2rgb(uint8(Fn)));
title('Reconstructed Frame');

%Check if it worked fine
%The reconstructed should have some error
result = isequal(current,ycbcr2rgb(uint8(Fn)));
fprintf('The two frames are exactely equal? %f ',result);
%How many bits are wrong
count_error = nnz(minus(current, ycbcr2rgb(uint8(Fn))));
fprintf('Number of error bits are %f ',count_error);
