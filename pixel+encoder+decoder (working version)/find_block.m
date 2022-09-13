function [frame, index_frame] = find_block (block ,block_index, ref_frame, neighbours)
%This function finds the matching block in the reference frame
% Input: the block in the current frame, the reference frame
%Output: the best_matching frame and the values to find its index
[r,c,n] = size(block);
[x,y,m] = size(ref_frame);
min_energy = 10000000000000000;
%then start taking blocks from the ref_frame to compare with the block
%we will check the nearest blocks
start_row = block_index(1);
start_col = block_index(2);

%Having no of neighbours choosen, then at each side of the given block, we
%search for neighbours/2 blocks as a candidate to be the best match
%To find them:

%  start_rows(1) = start_row; end_rows(1)=end_row;
%  start_cols(1) = start_col; end_cols(1)=end_col;
r=16; c=16;
%for the same row move along the cols
start_rows = [ start_row, start_row,start_row,start_row, start_row+16, start_row+32, start_row-16, start_row-32];
start_cols = [start_col+16, start_col+32,start_col, start_col-16,start_col,start_col, start_col,start_col];
end_rows = [start_row+15,start_row+15,start_row+15,start_row+15,start_row+16+15, start_row+32+15,start_row-16-15, start_row-32-15];
end_cols = [start_col+16+15, start_col+32+15, start_col-15, start_col-16-15,start_col+15, start_col+15, start_col,start_col];
%  disp('rows')
%  disp(start_rows);
%  disp('cols')
%  disp(start_cols);
loop =1;
while (loop<(2*neighbours))
    res_energy = 0;
    i_block=1; j_block=1;
    start_row = start_rows(loop); start_col = start_cols(loop);
    end_row = end_rows(loop); end_col = end_cols(loop);

    if (start_row < 1 || start_row >= x || end_row<0 || end_row>x || start_col<1 || start_col >y || end_col < 1 || end_col > y )
        %this should be an error and should not be executed
        %disp(loop);
        loop = loop+1;
        %disp('found a problem');
        continue;
    end
    
    for i= start_row : end_row
        for j= start_col : end_col
            value_x = ref_frame(i,j,1) - block(i_block,j_block,1);
            value_y= ref_frame(i,j,2) - block(i_block,j_block,2);
            value_z=ref_frame(i,j,3) - block(i_block,j_block,3);
            %value_y=0; value_z =0;
            res_energy = res_energy + (value_x+value_y+value_z)^2 ;
            j_block = j_block+1;
        end
        if (j_block >= 16)
            j_block =1;
        end
        i_block=i_block+1;
    end
    if res_energy < min_energy
            %disp(min_energy);
            %disp(res_energy);
            %disp('frame is assigned');
            min_energy = res_energy;
            frame = ref_frame(start_row:start_row+15, start_col : start_col+15,:);
            index_frame = [start_row,start_col]; %stores the 1st & last row or column
            %disp([start_row end_row start_col end_col]);
    end
    
    loop = loop+1;
end
end