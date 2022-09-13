function Fn = Decode_video(referenceframe, Mx,My,res,coded_Dn_1,coded_Dn_2,coded_Dn_3,dict1,dict2,dict3,imgNum)
%first decode the input stream of Dn (current - predicted) found in decoder
%Inverse Huffman
    dec_Dn_1 =  huffmandeco(coded_Dn_1,dict1);
    dec_Dn_2 =  huffmandeco(coded_Dn_2,dict2);
    dec_Dn_3 =  huffmandeco(coded_Dn_3,dict3);
    %Reshape
    Dn_sh_1 = reshape(dec_Dn_1,720,1280);
    Dn_sh_2= reshape(dec_Dn_2,720,1280);
    Dn_sh_3 = reshape(dec_Dn_3,720,1280);
    %DeQuantize
    Dn_deq_1 = DeQuantizeMe_first_Once(Dn_sh_1,0);
    Dn_deq_2 = DeQuantizeMe_first_Once(Dn_sh_2,0);
    Dn_deq_3 = DeQuantizeMe_first_Once(Dn_sh_3,0);
    %IDCT
    Dn_iDct_1 = idct2(Dn_deq_1);
    Dn_iDct_2 = idct2(Dn_deq_2);
    Dn_iDct_3 = idct2(Dn_deq_3);
    
    Dn_reconstructed = zeros(720,1280,3);
    Dn_reconstructed(:,:,1) = Dn_iDct_1;
    Dn_reconstructed(:,:,2) = Dn_iDct_2;
    Dn_reconstructed(:,:,3) = Dn_iDct_3;
    
    %find the P frame
    predicted = predict (referenceframe, res, Mx, My);
    
    %construct the current frame
    Fn= plus(predicted,Dn_reconstructed);
    save_path = 'E:\Education\Zewail Stuff\Courses\Year 4 - First Semester\Information Theory\Project\Phase 2\Constructed frames';
    %save the image to a path
    imwrite(ycbcr2rgb(uint8(Fn)),[save_path '\' int2str(imgNum), '.jpg']);
end