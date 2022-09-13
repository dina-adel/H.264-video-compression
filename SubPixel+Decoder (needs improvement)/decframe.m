function fr = decframe(mpeg,pf,mvx,mvy,q)

mbsize = size(mpeg);
M = 16 * mbsize(1);
N = 16 * mbsize(2);

% Loop over macroblocks
fr = zeros(M,N,3);
for m = 1:mbsize(1)
    for n = 1:mbsize(2)
        
        % Construct frame
        x = 16*(m-1)+1 : 16*(m-1)+16;
        y = 16*(n-1)+1 : 16*(n-1)+16;
        fr(x,y,:) = decblock(mpeg(m,n),pf,x,y,mvx(m,n),mvy(m,n),q);
        
    end % macroblock loop
end % macroblock loop