%Encode and Decode the video frames
clc
clear
%%
%Extract Video Frames
Video_path= 'E:\Education\Zewail Stuff\Courses\Year 4 - First Semester\Information Theory\Project\Phase 2\test_video.mp4';
Saving_path= 'E:\Education\Zewail Stuff\Courses\Year 4 - First Semester\Information Theory\Project\Phase 2\Video_Images';
%Extract_Video_Frames(Video_path,Saving_path);
%%
ref_frame = 1; %the first reference frame
curr_frame = 2; %the first current frame
count = 0;
i=1;
%%
%Loop on the video frames and Encode
while (ref_frame < 133) && (curr_frame < 133) 
    ref_frame_indcies (i) = ref_frame; %save the image index of references
    i=i+1;
    referenceframe = imread([Saving_path '\' int2str(ref_frame), '.jpg']);
    referenceframe = rgb2ycbcr(referenceframe);
    %%
while (count<10) && (curr_frame < 133)
    currentframe = imread([Saving_path '\' int2str(curr_frame), '.jpg']);
    currentframe=rgb2ycbcr(currentframe);
    [coded_Dn_1,coded_Dn_2,coded_Dn_3,dict1,dict2,dict3, Fn_reconstructed, Mx_mat,My_mat,res] = Encode_video(referenceframe,currentframe);
    disp('Done Encode');
    %Save important values to be used in the decoder
    Dn_coded_1(curr_frame-1) = {coded_Dn_1};
    Dn_coded_2(curr_frame-1) = {coded_Dn_2};
    Dn_coded_3(curr_frame-1) = {coded_Dn_3};
    disp('Encoded Dn');
    %%
    Dn_dict_2(curr_frame-1) = {dict1};
    Dn_dict_2(curr_frame-1) = {dict2};
    Dn_dict_3(curr_frame-1) = {dict3};
    disp('Encoded dict');
    Residual(curr_frame-1)= {res};
    %%
    Mx(curr_frame-1)={Mx_mat};
    My(curr_frame-1)={My_mat};
    
    curr_frame = curr_frame +1; %increment the curr_frame
    count = count +1; %increment the current frame counters (should be 10 frames only)    
end
    count =0; %restart the counter
    ref_frame = ref_frame +10; %take the next ref frame
    curr_frame= ref_frame + 1;
end

%%
%Decoding
save_path = 'E:\Education\Zewail Stuff\Courses\Year 4 - First Semester\Information Theory\Project\Phase 2\Constructed frames';
for i = ref_frame_indcies
    %read the ref frame
    referenceframe = imread([Saving_path '\' int2str(i), '.jpg']);
    %save ref_frame in the file
    imwrite(referenceframe,[save_path '\' int2str(i), '.jpg']);
    %loop over current frame
    count = 0;
    %%
    while count<10
        res = Residual{i+count+1};
        
        coded_Dn_1 =Dn_coded_1(i+count+1);
        coded_Dn_2 =Dn_coded_2(i+count+1);
        coded_Dn_3 =Dn_coded_3(i+count+1);
        
        dict1 = Dn_dict_1 (i+count+1);
        dict2 = Dn_dict_2 (i+count+1);
        dict3 = Dn_dict_3 (i+count+1);
        
        Mx = Mx_mat(i+count+1);
        My = My_mat(i+count+1);
        %%
        Fn = Decode_video(referenceframe, Mx,My,res,coded_Dn_1,coded_Dn_2,coded_Dn_3,dict1,dict2,dict3,i+count+1);
        count=count+1;
    end
end