function mb = decblock(mpeg,pf,x,y,mvx,mvy,q)
scale = 31;

mb = zeros(16,16,3);

% Predict with motion vectors

 mb = pf(x+mvx,y+mvy,:);

% Decode blocks
for i = 6:-1:1
    coef = mpeg(:,:,i) .* (scale * q) / 8;
    b(:,:,i) = idct2(coef);
end

% Construct macroblock
mb = mb + b;