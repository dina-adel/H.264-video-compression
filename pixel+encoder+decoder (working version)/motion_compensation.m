function [res, Mx, My] = motion_compensation (block,frame,index_frame,index_block,res,k)
%Motion Compensation
%Input: the best match frame, the real block, the index of
%the best match block, and the residual matrix, the motion vector matrix
%Output : the residual between the best match and the block, the motion
%vector representing this prediction.
res(index_block(1):index_block(1)+15, index_block(2):index_block(2)+15,:) = block-frame;
Mx = index_frame(1)- index_block(1);
My = index_frame(2)- index_block(2);
end