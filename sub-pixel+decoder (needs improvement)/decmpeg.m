function mov = decmpeg(mpeg,mvx,mvy,q)

movsize = size(mpeg{1});
mov = repmat(uint8(0),[16*movsize(1:2), 3, length(mpeg)]);

% Loop over frames
pf = [];
for i = 1:length(mpeg)
    
    % Decode frame
    f = decframe(mpeg{i},pf,mvx,mvy,q);
    
    % Cache previous frame
    pf = f;
    
    % Convert frame to RGB
    f = ycbcr2rgb(f);
    
    % Make sure movie is in 8 bit range
    f = min( max(f,0), 255);
    
    % Store frame
    mov(:,:,:,i) = uint8(f);
    
end