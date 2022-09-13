function predicted = predict (reference_frame, residual, Mx, My)
%input: residual matrix, motion vector matrix, ref_frame after being
%encoded/decoded with jpeg
%Residual : 3 dimensions
%Mx, My 1 dimension 
%output: the predicted frame from the reference frame
%reference_frame =rgb2ycbcr(reference_frame);
[m,n,z] = size(reference_frame);
predicted = zeros(m,n,z);
%loop on the blocks
m_blocks = m/16; n_blocks=n/16;
num_blocks = m_blocks*n_blocks; 
predicted = zeros(m,n,z);
index =[1 1];
%x=1;y=1;
blocksize =16;
%First loop on the row blocks
for i= 1 : num_blocks
    %fprintf('iteration no. %f \n',i);
    %fprintf('index of block %f and %f', index(1),index(2));
    %find the ref block in the ref frame    
    if (index(2) > 1265)
        %the row is finished
        index(1) = index(1)+16;
        index(2) = 1;
    end
    if (index(1) > 705)
       disp('All blocks are predicted');
            break;
    end
    ref_x= index(1)+ Mx(i);
    ref_y= index(2)+ My(i);
    
    predicted(index(1):index(1)+15,index(2):index(2)+15,:)= uint8(reference_frame(ref_x:ref_x+15,ref_y:ref_y+15,:)) + uint8(residual(index(1):index(1)+15,index(2):index(2)+15,:));    
    index(2)= index(2)+16;
   
end


end