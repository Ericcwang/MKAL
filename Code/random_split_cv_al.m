function [tr_idx_cell, te_idx_cell, tr_cvp_cell] = random_split_cv_al( nSmp, nSplit, trainRatio, nFold, nBatch)
%
% usage: [tr_idx_cell, te_idx_cell, tr_cvp_cell] = random_split_cv_al( nSmp, nSplit, trainRatio, nFold , y, prefix)
%     i1 = 1;
%     tr_idx = tr_idx_cell{i1};
%     te_idx = te_idx_cell{i1};
%     cvo = tr_cvp_cell{i1};
%     for iFold = 1:cvo.NumTestSets
%         tr_cv_idx = tr_idx(cvo.training(iFold));
%         te_cv_idx = tr_idx(cvo.test(iFold));
% 
% Todo: add class even sampling to ensure at least one class having one example
% 
rng('default');

tr_idx_cell = cell(nSplit, 1);
te_idx_cell = cell(nSplit, 1);
tr_cvp_cell = cell(nSplit, 1);

trainSize = floor(nSmp * trainRatio);
for i=1:nSplit
    perm = randperm(nSmp);
    tr_idx_cell{i} = perm(1:trainSize)';
    te_idx_cell{i} = perm(trainSize+1:end)';
    
end
for i=1:nSplit
    tr_cvp_cell{i} = cvpartition(length(tr_idx_cell{i}), 'kfold', nFold);
end
for i=2:nSplit
    tr_cvp_cell{i} = tr_cvp_cell{1};
end
%save([prefix, '_split.mat'], 'tr_idx_cell','te_idx_cell','tr_cvp_cell');
end

