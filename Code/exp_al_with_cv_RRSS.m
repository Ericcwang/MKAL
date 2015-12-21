function exp_al_with_cv_RRSS(dataset, exp_settings)
disp(dataset);
%======================extract X, Y===========================
[X, Y] = extractXY(fullfile('..','data',[dataset,'.mat']));
[nSmp, ~] = size(X);
nClass = length(unique(Y));

%======================exp setup===========================
batchSize = 5; % default
if isfield(exp_settings, 'batchSize')
    batchSize = exp_settings.batchSize;
end

nBatch = 10; % default
if isfield(exp_settings, 'nBatch')
    nBatch = exp_settings.nBatch;
end

nRepeat = 10; % default
if isfield(exp_settings, 'nRepeat')
    nRepeat = exp_settings.nRepeat;
end

nFoldCV = 5; % default
if isfield(exp_settings, 'nFoldCV')
    nFoldCV = exp_settings.nFoldCV;
end

saveDir = fullfile('..','output');
if isfield(exp_settings, 'saveDir')
    saveDir = exp_settings.saveDir;
end

trainRatio=0.6;
if isfield(exp_settings, 'trainRatio')
    trainRatio = exp_settings.trainRatio;
end

tradeCandi = 10.^(-5:5);
if isfield(exp_settings, 'tradeCandi')
    tradeCandi = exp_settings.tradeCandi;
end
%======================exp setup===========================

%======================data setup===========================
[~, ~, tr_cvp_cell] = random_split_cv_al(nSmp, nRepeat, trainRatio, nFoldCV, nBatch);

%======================data setup===========================

%======================algo setup===========================
paramCell = buildParam_RRSS(tradeCandi);
%======================algo setup===========================
% eval_fns = {'Accu_svm', 'Prec_svm', 'Recl_svm', 'ROC_svm', 'F_macro_svm', 'F_micro_svm','Square_err_svm'};
eval_fns = {'Accu_svm'};
for kernel_param = exp_settings.kernelCandi
parfor i1 = 1:nRepeat
    disp(['repeat ', num2str(i1), ' of ', num2str(nRepeat), ' with kernel parameter ',num2str(kernel_param)]);
    nParam = length(paramCell);
    res_i2_i3_i4 = cell(nParam, nBatch * nFoldCV);
    for i2 = 1:nParam
        param = paramCell{i2};
        disp(['        parameter search ', num2str(i2), ' of ', num2str(nParam), '...']);
        i34 = 0;
        for i3 = 1:nFoldCV
            tr_cv_idx = training(tr_cvp_cell{i1},i3);
            te_cv_idx = test(tr_cvp_cell{i1},i3);
            X_tr_cv = X(tr_cv_idx,:);
            Y_tr_cv = Y(tr_cv_idx);
            X_te_cv = X(te_cv_idx,:);
            Y_te_cv = Y(te_cv_idx);
            %------------------------------------cross validation for RRSS
            n=length(Y_tr_cv);
            K=myKernel(X_tr_cv, kernel_param);
			randIdx = RRSS(K,param.trade_param,1);
            %K=myKernel(X_tr_cv, param.kernel_param);
            for i4 = 1:nBatch
                L=randIdx(1:i4*batchSize); 
                i34 = i34 + 1;
                res_i2_i3_i4{i2, i34} = evaluation_classify_al(X_tr_cv, Y_tr_cv, X_te_cv, Y_te_cv, L,nClass);
            end
        end
    end
    % search the best parameter for currtent train_set over all folds and all batches
    res_i1_ps = []; %
    for i5 = 1:length(eval_fns) % different measures
        tmp = zeros(size(res_i2_i3_i4,1), 1);
        for i6 = 1:size(res_i2_i3_i4,1)
            for i7 = 1:size(res_i2_i3_i4,2)
                tmp(i6) = tmp(i6) + res_i2_i3_i4{i6,i7}.(eval_fns{i5});
            end
        end
        [~, res_i1_ps.(eval_fns{i5})] = max(tmp);
    end
    parsave(fullfile(saveDir,['RRSS_split',num2str(i1),'_',dataset,'_best_Para_',num2str(kernel_param),'.mat']),res_i1_ps);
end
end
end