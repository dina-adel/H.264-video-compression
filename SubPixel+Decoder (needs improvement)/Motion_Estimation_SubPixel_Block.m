function [ residual MVy MVx] = Motion_Estimation_SubPixel_Block(Block_Matrix, reference_frame, xc, yc, SearchLimit,SubPixel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [MVy MVx] = Motion_Estimatio_Sub_Pixel(Block, reference_frame, xc, yc, SearchLimit)

% Helper Function to find the residual and Sub pixel motion vectors in only one block of
% the reference frame whose index = (xc , yc)

% Input:
% Block_Matrix          - the current block being searched
% reference_frame       - the reference image
% xc, yc                - (xc, yc) are the indices of Block
% SearchLimit           - Search range 
% SubPixel              -SubPixeling or not : 0=No , 0.5= Half SubPixeling
% 0.25= Quarter SubPixeling 
%
% Output:
% [MVy MVx]             -  motion vectors of the Block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
[M N C] = size(reference_frame);
BlockSize = size(Block_Matrix,1);
range= floor(BlockSize/2);
BlockRange = -range:range-1;
SearchRange = SearchLimit;
% Sum Absolute Error Criteria
SAEmin = 100000;
predicted_Block=zeros(BlockSize,BlockSize,3);
%% Compare Block to reference Blocks ( Normal Motion Estimation )
for i = -SearchRange:BlockSize:SearchRange
    for j = -SearchRange:BlockSize:SearchRange
        x_new = xc + j;
        y_new = yc + i;
        disp(x_new);
        disp(y_new);
        Block_ref  = reference_frame(y_new+BlockRange, x_new+BlockRange, :);
        SAE        = sum(abs(Block_Matrix(:) - Block_ref(:)))/(BlockSize^2);
        if SAE < SAEmin
            SAEmin  = SAE;
            x_min   = x_new;
            y_min   = y_new;
            predicted_Block=reference_frame(y_new+BlockRange, x_new+BlockRange, :);
        end
        
        % Find Motion Vectors
         MVx = xc - x_min;
         MVy = yc - y_min;
        end
       
    end 
% Comapre Block to reference Blocks ( Half Pixel Motion Estimation)
if SubPixel==0.5 || SubPixel==0.25
    % Resizing The predicted block in reference frame  ie .Replacing each Pixel
    % With 9 pixels but only in this block ( 8 more pixels with interpolated values)
    predicted_Block = imresize(predicted_Block,3);
    [Mnew Nnew C]=size(predicted_Block);
    for i = -BlockSize:BlockSize:BlockSize
        for j = -BlockSize:BlockSize:BlockSize
            % x_new=x_min+j , y_new=y_min+i
            x_new = xc-MVx + j; 
            y_new = yc-MVy + i;
            Block_ref =predicted_Block((1+BlockSize+j:2*BlockSize+j),(1+BlockSize+i:2*BlockSize+i),:);
        SAE_2   = sum(abs(Block_Matrix(:) - Block_ref(:)))/(BlockSize^2);
            if SAE_2 < SAEmin 
                SAEmin  = SAE_2;
                x_min   = x_new;
                y_min   = y_new;
            end
        MVx = xc - x_min;
        MVy = yc - y_min;
        end
    end
% Rescale Back to original size
if SubPixel==0.5
predicted_Block = imresize(predicted_Block,1/3);
end
end
% Comapre Block to reference Blocks ( Quarter Pixel Motion Estimation)
if SubPixel==0.25
    % Resizing The predicted block in the Half SubPixeled Predicted Block in  reference frame 
    %( Replacing each Pixel With 9 pixels ( 8 more pixels with interpolated values)
    % in total each original pixel ( only in this block ) was replaced by 81 Pixels ( 80 more
    % pixels with interpolated values)
    
predicted_Block = imresize(predicted_Block,3);
[Mnew Nnew C]=size(predicted_Block);
    for i = BlockSize:BlockSize:BlockSize
        for j = -BlockSize:BlockSize:BlockSize
        % x_new=x_min+j , y_new=y_min+i
        x_new = xc-MVx + j;  
        y_new = yc-MVy + i;
        Block_ref =predicted_Block((1+BlockSize+j:2*BlockSize+j),(1+BlockSize+i:2*BlockSize+i),:);
    SAE_3   = sum(abs(Block_Matrix(:) - Block_ref(:)))/(BlockSize^2);
            if SAE_2 < SAEmin 
                SAEmin  = SAE_3;
                x_min   = x_new;
                y_min   = y_new;
            end
    MVx = xc - x_min;
    MVy = yc - y_min;
        end
    end
% Rescale Back to original size
predicted_Block = imresize(predicted_Block,1/9);
end           
residual=Block_Matrix-predicted_Block;
end
