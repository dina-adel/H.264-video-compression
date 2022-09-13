function [res, Mx_mat, My_mat] = motion_Est_Total (reference_frame, current_frame)
%Test Motion Estimation/Compensation/Prediction

%read images and test
current_frame =current_frame(:,:,:);
reference_frame =reference_frame (:,:,:);


num_blocks = 45*80;

start=1; start_col=1;

res = zeros(size(reference_frame));
[x,y,z] = size(reference_frame);

for k=1:num_blocks
            %disp(start_col);
            if (start_col >= y)
                start=start+16; start_col=1;
%             else if (start>=x)
%                     disp('end of frame found');
%                 end
            end
            block_current = current_frame( start:start+16-1 , start_col:start_col+16-1 ,:);
            %disp(block_current);
            %disp('____________');
            index_block = [start, start_col];
%             disp(index_block);
%             disp(block_current);
%             disp(size(reference_frame));
            %disp(k);
            [frame, index_frame] = find_block (block_current,index_block, reference_frame, 4);
            [res, Mx, My] = motion_compensation (block_current,frame,index_frame,index_block,res,k);
%             if (uint8(block_current) + uint8(res(index_block(1):index_block(1)+15,index_block(2):index_block(2)+15,:))) == frame
%                 disp('hoooraaaaaaaaaaay');
%             else 
%                 disp('saaaaaaad');
%             end
            Mx_mat(k) = Mx;
            My_mat(k) = My;
            start_col = start_col+16;
            %disp(index_block);
end
%predicted = predict (reference_frame, res, Mx_mat, My_mat);

%imshow(uint8(res))
%imshow(uint8(predicted))

end
