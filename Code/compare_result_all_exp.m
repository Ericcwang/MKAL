function compare_result_all_exp(dataset, exp_settings)
rng('default');
disp(['Processing ',dataset])
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

saveDir = fullfile('..','PDF');
if isfield(exp_settings, 'saveDir')
    saveDir = exp_settings.saveDir;
end

loadDir = fullfile('..','output');
if isfield(exp_settings, 'saveDir')
    loadDir = exp_settings.loadDir;
end

trainRatio=0.6;
if isfield(exp_settings, 'trainRatio')
    trainRatio = exp_settings.trainRatio;
end

kernelCandi = 10.^(-5:5);
if isfield(exp_settings, 'kernelCandi')
    kernelCandi = exp_settings.kernelCandi;
end

tradeParam=0.01;
if isfield(exp_settings, 'tradeParam')
    tradeParam = exp_settings.tradeParam;
end
%======================data setup===========================

[tr_idx_cell, te_idx_cell, ~] = random_split_cv_al(nSmp, nRepeat, trainRatio, nFoldCV, nBatch);
%eval_fns = {'Accu_svm', 'Prec_svm', 'Recl_svm', 'ROC_svm', 'F_macro_svm', 'F_micro_svm','Square_err_svm'};
eval_fns = {'Accu_svm'};
%======================algo setup===========================
numberKernel = length(kernelCandi);
RRSS_new_res = cell(numberKernel+1,nBatch);
for idx2=1:numberKernel+1
    for idx3 = 1:nBatch
        for idx1 = 1:length(eval_fns)
            RRSS_new_res{idx2,idx3}.(eval_fns{idx1}) = [];
        end
    end
end
KTED_new_res = cell(numberKernel+1,nBatch);
for idx2=1:numberKernel+1
    for idx3 = 1:nBatch
        for idx1 = 1:length(eval_fns)
            KTED_new_res{idx2,idx3}.(eval_fns{idx1}) = [];
        end
    end
end
MKAL_new_res = cell(1,nBatch);
for idx3 = 1:nBatch
    for idx1 = 1:length(eval_fns)
        MKAL_new_res{idx3}.(eval_fns{idx1}) = [];
    end
end
MKAG_new_res = cell(1,nBatch);
for idx3 = 1:nBatch
    for idx1 = 1:length(eval_fns)
        MKAG_new_res{idx3}.(eval_fns{idx1}) = [];
    end
end
Rand_new_res = cell(1,nBatch);
for idx3 = 1:nBatch
    for idx1 = 1:length(eval_fns)
        Rand_new_res{idx3}.(eval_fns{idx1}) = [];
    end
end
%Ks=zeros;

for i1 = 1:nRepeat
    tr_idx = tr_idx_cell{i1};
    te_idx = te_idx_cell{i1};
    X_tr = X(tr_idx,:);
    Y_tr = Y(tr_idx);
    X_te = X(te_idx,:);
    Y_te = Y(te_idx);
    Kavg=zeros(size(X_tr,1),size(X_tr,1));
    for kernel_param_idx=1:numberKernel
        kernel_param=kernelCandi(kernel_param_idx);
        K=myKernel(X_tr, kernel_param);
        Kavg=Kavg+K;
        disp([dataset,'repeat ', num2str(i1), ' of ', num2str(nRepeat), '...']);
        %KTED
        res_i9 = cell(nBatch,1);
        %---------------------------------------------------testing for KTED
        
        [selectedSmpIdx,~] = KTED(K,tradeParam,50);
        for i3 = 1:nBatch
            L=selectedSmpIdx(1:i3 * batchSize);
            res_i9{i3} = evaluation_classify_al(X_tr, Y_tr, X_te ,Y_te, L,nClass);
        end
        
        for i4 = 1:length(eval_fns)
            for i11 = 1:nBatch
                KTED_new_res{kernel_param_idx, i11}.(eval_fns{i4}) = [KTED_new_res{kernel_param_idx,i11}.(eval_fns{i4}); res_i9{i11}.(eval_fns{i4})];
            end
        end
        %RRSS
        res_i9 = cell(nBatch,1);
        %---------------------------------------------------testing for
        %RRSS
        selectedSmpIdx = RRSS(K,tradeParam,10);
        for i3 = 1:nBatch
            L=selectedSmpIdx(1:i3 * batchSize);
            res_i9{i3} = evaluation_classify_al(X_tr, Y_tr, X_te ,Y_te, L,nClass);
        end
        
        for i4 = 1:length(eval_fns)
            for i11 = 1:nBatch
                RRSS_new_res{kernel_param_idx, i11}.(eval_fns{i4}) = [RRSS_new_res{kernel_param_idx,i11}.(eval_fns{i4}); res_i9{i11}.(eval_fns{i4})];
            end
        end
    end

    Kavg=Kavg/numberKernel;
    %KTED
    res_i9 = cell(nBatch,1);
    %---------------------------------------------------testing for KTED
    
    [selectedSmpIdx,~] = KTED(Kavg,tradeParam,50);
    for i3 = 1:nBatch
        L=selectedSmpIdx(1:i3 * batchSize);
        res_i9{i3} = evaluation_classify_al(X_tr, Y_tr, X_te ,Y_te, L,nClass);
    end
    
    for i4 = 1:length(eval_fns)
        for i11 = 1:nBatch
            KTED_new_res{numberKernel+1, i11}.(eval_fns{i4}) = [KTED_new_res{numberKernel+1,i11}.(eval_fns{i4}); res_i9{i11}.(eval_fns{i4})];
        end
    end
    %RRSS
    res_i9 = cell(nBatch,1);
    %---------------------------------------------------testing for
    %RRSS
    selectedSmpIdx = RRSS(Kavg,tradeParam,1);
    for i3 = 1:nBatch
        L=selectedSmpIdx(1:i3 * batchSize);
        res_i9{i3} = evaluation_classify_al(X_tr, Y_tr, X_te ,Y_te, L,nClass);
    end
    
    for i4 = 1:length(eval_fns)
        for i11 = 1:nBatch
            RRSS_new_res{numberKernel+1, i11}.(eval_fns{i4}) = [RRSS_new_res{numberKernel+1,i11}.(eval_fns{i4}); res_i9{i11}.(eval_fns{i4})];
        end
    end
    
end
for i1=1:nRepeat
    disp(['MKAL : repeat ', num2str(i1), ' of ', num2str(nRepeat), '...']);
    tr_idx = tr_idx_cell{i1};
    te_idx = te_idx_cell{i1};
    X_tr = X(tr_idx,:);
    Y_tr = Y(tr_idx);
    X_te = X(te_idx,:);
    Y_te = Y(te_idx);
    %Rand
    res_i9 = cell(nBatch,1);
    %------------------------------------------------testing for Rand
    n=length(Y_tr);
    L=[];
    U=1:n;
    for i3 = 1:nBatch
        selectedSmpIdx = Rand(U,batchSize);
        L=[L,selectedSmpIdx];
        U=setdiff(U,selectedSmpIdx);
        res_i9{i3} = evaluation_classify_al(X_tr, Y_tr, X_te ,Y_te, L,nClass);
    end
    for i4 = 1:length(eval_fns)
        for i11 = 1:nBatch
            Rand_new_res{i11}.(eval_fns{i4}) = [Rand_new_res{i11}.(eval_fns{i4}); res_i9{i11}.(eval_fns{i4})];
        end
    end
    %MKAL
    res_i9 = cell(nBatch,1);
    %---------------------------------------------------testing for MKAL
    n=size(X_tr,1);
    Ks=zeros(n,n,numberKernel);
    for idx=1:numberKernel
        Ks(:,:,idx) = myKernel(X_tr, kernelCandi(idx));
    end
    selectedSmpIdx = MKAL(Ks, tradeParam, nBatch*batchSize);
    for i3 = 1:nBatch
        L=selectedSmpIdx(1:i3*batchSize);
        res_i9{i3} = evaluation_classify_al(X_tr, Y_tr, X_te ,Y_te, L,nClass);
    end
    
    for i4 = 1:length(eval_fns)
        for i11 = 1:nBatch
            MKAL_new_res{i11}.(eval_fns{i4}) = [MKAL_new_res{i11}.(eval_fns{i4}); res_i9{i11}.(eval_fns{i4})];
        end
    end
   
    %MKAG
    res_i9 = cell(nBatch,1);
    %---------------------------------------------------testing for MKAL
    n=size(X_tr,1);
    Ks=zeros(n,n,numberKernel);
    for idx=1:numberKernel
        Ks(:,:,idx) = myKernel(X_tr, kernelCandi(idx));
    end
    selectedSmpIdx = MKAG(Ks, tradeParam, nBatch*batchSize);
    for i3 = 1:nBatch
        L=selectedSmpIdx(1:i3*batchSize);
        res_i9{i3} = evaluation_classify_al(X_tr, Y_tr, X_te ,Y_te, L,nClass);
    end
    
    for i4 = 1:length(eval_fns)
        %             if MKAG_param.res_i1_ps.(eval_fns{i4}) == res_i1_best_p(i2)
        for i11 = 1:nBatch
            MKAG_new_res{i11}.(eval_fns{i4}) = [MKAG_new_res{i11}.(eval_fns{i4}); res_i9{i11}.(eval_fns{i4})];
        end
        %             end
    end
end
% end

Rand_res=[];
for idx= 1:length(eval_fns)
    Rand_res.(eval_fns{idx})=[];
end

RRSS_res=cell(1,numberKernel+1);
for idx1=1:numberKernel+1
    for idx= 1:length(eval_fns)
        RRSS_res{idx1}.(eval_fns{idx})=[];
    end
end

KTED_res=cell(1,numberKernel+1);
for idx1=1:numberKernel+1
    for idx= 1:length(eval_fns)
        KTED_res{idx1}.(eval_fns{idx})=[];
    end
end

MKAL_res=[];
for idx= 1:length(eval_fns)
    MKAL_res.(eval_fns{idx})=[];
end

MKAG_res=[];
for idx= 1:length(eval_fns)
    MKAG_res.(eval_fns{idx})=[];
end

for idx1 = 1:length(eval_fns)
    for idx2 = 1:nBatch
        for idx3 = 1:numberKernel+1
            RRSS_line = RRSS_new_res{idx3, idx2}.(eval_fns{idx1});
            KTED_line = KTED_new_res{idx3, idx2}.(eval_fns{idx1});
            %TED_line = TED_new_res{idx3, idx2}.(eval_fns{idx1});
            RRSS_res{idx3}.(eval_fns{idx1}) = [RRSS_res{idx3}.(eval_fns{idx1}), mean(RRSS_line)];
            KTED_res{idx3}.(eval_fns{idx1}) = [KTED_res{idx3}.(eval_fns{idx1}), mean(KTED_line)];
            %TED_res{idx3}.(eval_fns{idx1}) = [TED_res{idx3}.(eval_fns{idx1}), mean(TED_line)];
        end
        Rand_line = Rand_new_res{idx2}.(eval_fns{idx1});
        Rand_res.(eval_fns{idx1}) = [Rand_res.(eval_fns{idx1}), mean(Rand_line)];
        MKAL_line = MKAL_new_res{idx2}.(eval_fns{idx1});
        MKAL_res.(eval_fns{idx1}) = [MKAL_res.(eval_fns{idx1}), mean(MKAL_line)];
        MKAG_line = MKAG_new_res{idx2}.(eval_fns{idx1});
        MKAG_res.(eval_fns{idx1}) = [MKAG_res.(eval_fns{idx1}), mean(MKAG_line)];
    end
end

fileName=fullfile(saveDir,[eval_fns{idx1},'_',dataset,'_vsKTED.mat']);
save(fileName,'KTED_res');

fileName=fullfile(saveDir,[eval_fns{idx1},'_',dataset,'_vsRRSS.mat']);
save(fileName,'RRSS_res');

fileName=fullfile(saveDir,[eval_fns{idx1},'_',dataset,'_vsRand.mat']);
save(fileName,'Rand_res');

fileName=fullfile(saveDir,[eval_fns{idx1},'_',dataset,'_self.mat']);
save(fileName,'MKAL_res','MKAG_res');
% tmp=zeros(numberKernel,1);
% for ii=1:numberKernel
%     tmp(ii) = sum(KTED_res{ii}.(eval_fns{1}));
% end
% [~ ,idx_f]=sort(tmp,'descend');
% for idx1 = 1:length(eval_fns)
%     fileName=fullfile(saveDir,[eval_fns{idx1},'_',dataset,'_vsKTED.pdf']);
%     hold on;
%     set(gca,'defaulttextinterpreter','latex');
%         plot(1:nBatch,Rand_res.(eval_fns{idx1}),'-ok',...
%             1:nBatch,KTED_res{idx_f(1)}.(eval_fns{idx1}),'-ob',...
%             1:nBatch,KTED_res{idx_f(2)}.(eval_fns{idx1}),'-oy',...
%             1:nBatch,KTED_res{idx_f(3)}.(eval_fns{idx1}),'-oc',...
%             1:nBatch,KTED_res{idx_f(5)}.(eval_fns{idx1}),'-og',...
%             1:nBatch,MKAL_res.(eval_fns{idx1}),'-or',...
%             1:nBatch,MKAG_res.(eval_fns{idx1}),'-sr');
%     legend('Rand','CTED_1','CTED_2','CTED_3','CTED_m','Local','Global','location','southeast');
%     hold off;
%     save2pdf(fileName, gcf, 600);
%     %delete(gca);
% end
end