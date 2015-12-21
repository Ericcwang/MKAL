function rank_idx = MKAG(Ks,c, nSelect)
[A, K, ~, ~]=MKAGobj(Ks, c);
 rank_idx= MAEDseq(K,nSelect,[],0);
 %a = sum(abs(A),2);
% 
% [~, rank_idx] = sort(a,'descend');
%rank_idx=getseq(A,nSelect);
end
function [A, K, Z, objHistory] = MKAGobj(Ks, c)
nIter = 50;
nSmp = size(Ks,1);
nKernel = size(Ks,3);
Z = ones(nKernel, 1)/nKernel;
K = calculate_localized_kernel_theta(Ks, Z);
objHistory =[];
tryNo = 0;
while tryNo < nIter
    tryNo = tryNo+1;
    % ===================== update A ========================
    [~, A] = KTED(K, c, 50);
    % ===================== update Z ========================
    AA = A * A';
    ident= diag(ones(size(A,1),1));
    e=zeros(nKernel,1);
    for ii=1:nKernel
        e(ii)=sum(diag( Ks(:,:,ii)*(ident + 2 * A + AA) ));
    end
    Z=1.0 ./ e;
    Z=Z/sum(Z);
    K = calculate_localized_kernel_theta(Ks, Z);
%     obj=sum(diag(K-2*K*A+A'*K*A));
%     tmp=0;
%     for ii=1:size(A,1)
%         tmp=tmp+norm(A(ii,:));
%     end
%     obj = obj + c*tmp;
%     objHistory=[objHistory;obj];
end
end
%==========================================================================
function K_Theta = calculate_localized_kernel_theta(K, Theta)
K_Theta = zeros(size(K(:, :, 1)));
newTheta = Theta .^2;
for m = 1:size(K, 3)
    K_Theta = K_Theta + K(:, :, m) .* newTheta(m);
end
end