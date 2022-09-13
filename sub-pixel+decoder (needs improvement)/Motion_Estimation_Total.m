function [ Residual MVx MVy] = Motion_Estimation_Total(current_frame, reference_frame,BlockSize,SearchLimit,SupPixel_Mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only for Testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Residual MVx MVy] = Motion_Estimation_Total(current_frame, reference_frame,BlockSize,SearchLimit)
% estimates motion of the Whole Reference frame by looping over all its blocks. 
%
% Input:
%        current_frame         - current   image
%        reference_frame       - reference image
%        BlockSize             - block size default= 8
%        SearchLimit      - search limit default= 16
%        SubPixel_Mode    - SubPixeling or not : 0=No , 0.5= Half SubPixeling  0.25= Quarter SubPixeling
%
% Output:
%         MVx - horizontal motion vectors
%         MVy - vertical motion vectors
%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SupPixel=SupPixel_Mode;
% convert RGB image to YCbCr image
     current_frame =rgb2ycbcr(current_frame);
     reference_frame =rgb2ycbcr(reference_frame);

% if BlockSize<=0
%     BlockSize = 8;
% end
% if SearchLimit<=0
%     SearchLimit = 16;
% end
% if(SubPixel_Mode==0.5)
%     current_frame=imresize(current_frame,2);
%     reference_frame=imresize(reference_frame,2);
% elseif(SubPixel_Mode==0.25)
%     current_frame=imresize(current_frame,4);
%     reference_frame=imresize(reference_frame,4);
% end

% Crop the images so that image size is a multiple of BlockSize
M        = floor(size(reference_frame, 1)/BlockSize)*BlockSize;
N        = floor(size(reference_frame, 2)/BlockSize)*BlockSize;
reference_frame  = reference_frame(1:M, 1:N, :);
current_frame = current_frame(1:M, 1:N, :);
% Enlarge the image boundaries by BlockSize/2 pixels
reference_frame  = padarray(reference_frame,  [BlockSize/2 BlockSize/2], 'replicate');
current_frame = padarray(current_frame, [BlockSize/2 BlockSize/2], 'replicate');
% Pad zeros to images to fit SearchLimit
reference_frame  = padarray(reference_frame,  [SearchLimit, SearchLimit]);
current_frame = padarray(current_frame, [SearchLimit, SearchLimit]);
% Set parameters
[M N C]     = size(reference_frame);
range           = floor(BlockSize/2);
BlockRange  = -range:range-1;
xc_range    = SearchLimit+range+1 : BlockSize : N-(SearchLimit+range);
yc_range    = SearchLimit+range+1 : BlockSize : M-(SearchLimit+range);

MVx = zeros(length(yc_range), length(xc_range));
MVy = zeros(length(yc_range), length(xc_range));
% Main Loop

% disp(xc_range);
% disp(yc_range);

for i = 1:length(yc_range)
    for j = 1:length(xc_range)
        xc = xc_range(j);
        yc = yc_range(i);
%         disp('fist');
%         disp('range x: ');
%         disp(xc+BlockRange);
%         disp('range y: ');
%         disp(yc + BlockRange);
        Block = current_frame(yc + BlockRange, xc + BlockRange, :);
        % Choose either one of the followings
%       [MVy1 MVx1]     = FullSearch(Block, img_ref, xc, yc, SearchLimit);
        [residual(yc + BlockRange , xc + BlockRange, :) MVy1 MVx1] = Motion_Estimation_SubPixel_Block(Block, reference_frame, xc, yc, SearchLimit,SupPixel);
        MVx(i,j) = MVx1;
        MVy(i,j) = MVy1;
    end
end
% Scaling residual to fit frame resolution
% if  (SubPixel_Mode==0.5)
%     Residual=zeros(1440,2560,3,"uint8");
%     Residual=residual(1:1440,1:2560,1:3);
%     Residual=imresize(Residual,0.5);
%     %Residual=imresize(Residual,0.5);
% elseif(SubPixel_Mode==0.25)
%     Residual=zeros(2880,5120,3,"uint8");
%     Residual=residual(1:2880,1:5120,1:3);
%     Residual=imresize(Residual,0.25);
% elseif(SubPixel_Mode==0)
     Residual=zeros(720,1280,3);
     Residual=residual(1:720,1:1280,1:3);
 end
 
