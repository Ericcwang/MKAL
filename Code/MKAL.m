function rank_idx = MKAL(Ks,c, nSelect)
[A, K, ~, ~]=MKALobj(Ks, c);
rank_idx= MAEDseq(K,nSelect,[],0);
end

function [A, K, Z, objHistory] = MKALobj(Ks, c)
nIter = 50;
nSmp = size(Ks,1);
nKernel = size(Ks,3);
Z = ones(nSmp, nKernel)/nKernel;
K = calculate_localized_kernel_theta(Ks, Z);
objHistory =[];
tryNo = 0;
while tryNo < nIter
    tryNo = tryNo+1;
    % ===================== update A ========================
    [~, A] = KTED(K, c, 50);
    % ===================== update Z ========================
    AA = A * A';
    n=size(A,1);
    M = diag(ones(n,1))+AA-A-A';
    M=M+M';
    M=M/2;
    Km = zeros(nSmp, nSmp, nKernel);
    for iKernel = 1:nKernel
        Km(:,:,iKernel) = M .* Ks(:,:,iKernel);
    end
    Z = QP_APG( Km, Z);
    K = calculate_localized_kernel_theta(Ks, Z);
end
end
%==========================================================================
function K_Theta = calculate_localized_kernel_theta(K, Theta)
K_Theta = zeros(size(K(:, :, 1)));
for m = 1:size(K, 3)
    K_Theta = K_Theta + (Theta(:, m) * Theta(:, m)') .* K(:, :, m);
end
end