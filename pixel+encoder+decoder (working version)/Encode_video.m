function [ coded_Dn_1,coded_Dn_2,coded_Dn_3,dict1,dict2,dict3, Fn_reconstructed, Mx_mat,My_mat,residual] = Encode_video(referenceframe,currentframe)
%Extract_Video_Frames(Video_path,Saving_path);
    
    [residual, Mx_mat, My_mat] = motion_Est_Total (referenceframe, currentframe);
    
    %Apply Jpeg    
    %get P-frame
    predicted = predict (referenceframe, residual, Mx_mat, My_mat);
    
    %finding Dn &Performing DCT &Quantization & Huffman Encoding
    Dn = minus(double(currentframe) , double(predicted));
    %DCT
    %disp(size(Dn));
    Dn_Dct_1 = dct2(Dn(:,:,1));
    Dn_Dct_2 = dct2(Dn(:,:,2));
    Dn_Dct_3 = dct2(Dn(:,:,3));
    %Quantization
    Dn_Quan_1 = QuantizeMe_first_Once(Dn_Dct_1,0);
    Dn_Quan_2 = QuantizeMe_first_Once(Dn_Dct_2,0);
    Dn_Quan_3 = QuantizeMe_first_Once(Dn_Dct_3,0);
    %from 2D to 1D
    Dn_Quan_arr_1 = reshape(Dn_Quan_1,1,numel(Dn_Quan_1));
    Dn_Quan_arr_2 = reshape(Dn_Quan_2,1,numel(Dn_Quan_2));
    Dn_Quan_arr_3 = reshape(Dn_Quan_3,1,numel(Dn_Quan_3));
    %find the symbols & counts & probabilities
    [symbols1,counts_1, probabilities1] = symbol_freq(Dn_Quan_arr_1);
    [symbols2,counts_2, probabilities2] = symbol_freq(Dn_Quan_arr_2);
    [symbols3,counts_3, probabilities3] = symbol_freq(Dn_Quan_arr_3);
    %Huffman Encode Dictionary
    %disp(symbols1);
    %disp(probabilities1);
    [dict1,avglen] = huffmandict(symbols1,probabilities1);
    [dict2,avglen] = huffmandict(symbols2,probabilities2);
    [dict3,avglen] = huffmandict(symbols3,probabilities3);
    %Huffman Encoding
    coded_Dn_1 = huffmanenco(Dn_Quan_arr_1,dict1);
    coded_Dn_2 = huffmanenco(Dn_Quan_arr_2,dict2);
    coded_Dn_3 = huffmanenco(Dn_Quan_arr_3,dict3);
    
    %Reconstruction Path
    %Inverse Huffman
%     dec_Dn_1 =  huffmandeco(coded_Dn_1,dict1);
%     dec_Dn_2 =  huffmandeco(coded_Dn_2,dict2);
%     dec_Dn_3 =  huffmandeco(coded_Dn_3,dict3);
%     %Reshape
%     Dn_sh_1 = reshape(dec_Dn_1,720,1280);
%     Dn_sh_2= reshape(dec_Dn_2,720,1280);
%     Dn_sh_3 = reshape(dec_Dn_3,720,1280);
%     %DeQuantize
%     Dn_deq_1 = DeQuantizeMe_first_Once(Dn_sh_1,0);
%     Dn_deq_2 = DeQuantizeMe_first_Once(Dn_sh_2,0);
%     Dn_deq_3 = DeQuantizeMe_first_Once(Dn_sh_3,0);
%     %IDCT
%     Dn_iDct_1 = idct2(Dn_deq_1);
%     Dn_iDct_2 = idct2(Dn_deq_2);
%     Dn_iDct_3 = idct2(Dn_deq_3);
%     
%     Dn_reconstructed = zeros(720,1280,3);
%     Dn_reconstructed(:,:,1) = Dn_iDct_1;
%     Dn_reconstructed(:,:,2) = Dn_iDct_2;
%     Dn_reconstructed(:,:,3) = Dn_iDct_3;
%     
%     Fn_reconstructed = plus(double(Dn_reconstructed),double(predicted));
 Fn_reconstructed =0;
end

