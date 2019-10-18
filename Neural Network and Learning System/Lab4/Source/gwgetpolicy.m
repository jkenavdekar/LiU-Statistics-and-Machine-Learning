function P = gwgetpolicy(Q)
% GWGETPOLICY Get best policy from Q-matrix.
%
% You have to implement this function yourself. It is not necessary to loop
% in order to do this, and looping will be much slower than using matrix
% operations. It's possible to implement this in one line of code.

[~,P(:,:)] = max(Q,[],3);

end

