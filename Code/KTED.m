function [rank_idx,A] = KTED(XX, r, nIter)
A=L12R21_reg_kernel(XX, r, nIter);
a = sum(abs(A),2);
[~, rank_idx] = sort(a,'descend');

function X=L12R21_reg_kernel(KK, r, nIter)
[n] = size(KK,2);
p = size(KK,2);
X=zeros(n,p);
d = ones(n,1);
for iter = 1:nIter
    D = spdiags(d,0,n,n);
    X=(KK+r*D)\KK;
    Xi = sqrt(sum(X.*X,2)+eps);
    d = 0.5./Xi;
end;
1;