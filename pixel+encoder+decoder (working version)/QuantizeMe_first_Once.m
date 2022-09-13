function y = QuantizeMe_first_Once(image,comp_level)
%its done on the whole image just once
%it takes the image and the compression either low quantization or high
%quantization
if comp_level ==0
    n=4;
else
    n=8;
end
[r c] = size (image);
    for i=1:r
        for j=1:c
            if (i < r/2) && (j < c/2)
                image(i,j)= floor(image(i,j)/n);
            else
            image (i,j) = floor(image(i,j)/(2*n));
            end
        end
    end
y=image;
end
    
