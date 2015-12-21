% min_{A,1'*A=1'}  ||(X - X*A)'||_2,1 + r*||A||_2,1
% min_{A,1'*A=1'}  ||(X - X*A)'||_2,1 + r*||A||_2,1
% min_{A,1'*A=1'}  ||(X - X*A)'||_2,1 + r*||A||_2,1
function rank_idx = RRSS(XX, r, iskernel)
% XX: if iskernel = 0, XX is a d*n data matrix, each column is a data point
%     if iskernel ~= 0, XX is a n*n kernel matrix
% r: parameter, larger to select fewer data points
% iskernel: kernel version if iskernel ~= 0, and XX should be kernel matrix
% rank_idx: the ranking values of data points
% rank_value: the ranking index of data points
% A: n*n representation matrix
% obj: objective values in the iterations

% Ref:
% Feiping Nie, Hua Wang, Heng Huang, Chris Ding. 
% Early Active Learning via Robust Representation and Structured Sparsity. 
% The 23rd International Joint Conference on Artificial Intelligence (IJCAI), 2013.


if iskernel == 0
    [A, ~]=L12R21(XX, XX, r);
else
    [A, ~]=L12R21_reg_kernel(XX, XX, XX, r);
end;

a = sum(abs(A),2);
[~, rank_idx] = sort(a,'descend');



% min_X  ||(A X - Y)'||_2,1 + r * ||X||_2,1
function [X, obj]=L12R21(A, Y, r, X0)

NIter = 50;
n = size(A,2);
p = size(Y,2);
if nargin < 4
    d = ones(n,1);
    d1 = ones(p,1);
else
    Xi = sqrt(sum(X0.*X0,2)+eps);
    d = 0.5./(Xi);
    AX = A*X0-Y;
    Xi1 = sqrt(sum(AX.*AX,1)+eps);
    d1 = 0.5./Xi1;
end;

AA = A'*A;
AY = A'*Y;
for iter = 1:NIter
    D = spdiags(d,0,n,n);
    for i = 1:p
        X(:,i) = (d1(i)*AA+r*D)\(d1(i)*AY(:,i));
    end;

    Xi = sqrt(sum(X.*X,2)+eps);
    d = 0.5./Xi;
    AX = A*X-Y;
    Xi1 = sqrt(sum(AX.*AX,1)+eps);
    d1 = 0.5./Xi1;

    obj(iter) = sum(Xi1) + r*sum(Xi);
end;
1;




% min_X  ||(A X - Y)'||_2,1 + r * ||X||_2,1
% AA = A'*A;
% AY = A'*Y;
% YY = Y'*Y;
function [X, obj]=L12R21_reg_kernel(AA, AY, YY, r, X0)

NIter = 50;
[n] = size(AA,2);
p = size(AY,2);
if nargin < 5
    d = ones(n,1);
    d1 = ones(p,1);
else
    Xi = sqrt(sum(X0.*X0,2)+eps);
    d = 0.5./(Xi);
    AX = A*X0-Y;
    Xi1 = sqrt(sum(AX.*AX,1)+eps);
    d1 = 0.5./Xi1;
end;

for iter = 1:NIter
    D = spdiags(d,0,n,n);
    for i = 1:p
        X(:,i) = (d1(i)*AA+r*D)\(d1(i)*AY(:,i));
    end;

    Xi = sqrt(sum(X.*X,2)+eps);
    d = 0.5./Xi;

%     for i = 1:p
%         xi = X(:,i);
%         Xi1(i) = sqrt(abs(xi'*AA*xi-2*xi'*AY(:,i)+YY(i,i))+eps);
%     end;
    Xi1 = sqrt(sum(X.*(AA*X),1) + diag(YY)' - 2*sum(X.*AY,1)+eps);   % faster
    d1 = 0.5./Xi1;

    obj(iter) = sum(Xi1) + r*sum(Xi);
end;
1;