function []=save_result_all_exp(dataset, exp_settings)

dataName=dataset;
if strcmp(dataset,'ORL_32x32')
    dataName='ORL';
end;
if strcmp(dataset,'r')
    dataName='Reuters';
end;
deffontsize=20;
saveDir = fullfile('..','PDF');
if isfield(exp_settings, 'saveDir')
    saveDir = exp_settings.saveDir;
end
kernelCandi = 10.^(-5:5);
if isfield(exp_settings, 'kernelCandi')
    kernelCandi = exp_settings.kernelCandi;
end
numberKernel=length(kernelCandi);

eval_fns = {'Accu_svm'};

fileName=fullfile(saveDir,[eval_fns{1},'_',dataset,'_vsKTED.mat']);
load(fileName);

fileName=fullfile(saveDir,[eval_fns{1},'_',dataset,'_vsTED.mat']);
load(fileName);

fileName=fullfile(saveDir,[eval_fns{1},'_',dataset,'_vsRRSS.mat']);
load(fileName);

fileName=fullfile(saveDir,[eval_fns{1},'_',dataset,'_vsRand.mat']);
load(fileName);

fileName=fullfile(saveDir,[eval_fns{1},'_',dataset,'_self.mat']);
load(fileName);

NewsaveDir='';
nBatch = exp_settings.nBatch;
batchSize=exp_settings.batchSize;
baseLine=(1:nBatch)*batchSize;
tmp=zeros(numberKernel,1);
for ii=1:numberKernel+1
    tmp(ii) = sum(KTED_res{ii}.(eval_fns{1}));
end
[~ ,idx_f]=sort(tmp(1:numberKernel),'descend');
for idx1 = 1:length(eval_fns)
    fileName=fullfile(NewsaveDir,[eval_fns{idx1},'_',dataset,'_vsKTED.pdf']);
    hold on;
    set(gca,'defaulttextinterpreter','latex');
    %set(gca,'FontSize',deffontsize);
        plot(baseLine,Rand_res.(eval_fns{idx1}),'-ok',...
            baseLine,KTED_res{idx_f(1)}.(eval_fns{idx1}),'-ob',...
            baseLine,KTED_res{idx_f(2)}.(eval_fns{idx1}),'-oy',...
            baseLine,KTED_res{idx_f(3)}.(eval_fns{idx1}),'-oc',...
            baseLine,KTED_res{idx_f(5)}.(eval_fns{idx1}),'-og',...
            baseLine,KTED_res{numberKernel+1}.(eval_fns{idx1}),'-+b',...
            baseLine,MKAL_res.(eval_fns{idx1}),'-or',...
            baseLine,MKAG_res.(eval_fns{idx1}),'-sr','LineWidth',0.88);
        title(dataName,'FontSize',deffontsize);
        xlabel('Number of Selected Instances','FontSize',deffontsize);
        ylabel('Accuracy','FontSize',deffontsize);
        
    legend('Rand','CTED_1','CTED_2','CTED_3','CTED_m','CTED_a','LMKAL','GMKAL','location','southeast');
    hold off;
    save2pdf(fileName, gcf, 600);
    delete(gca);
end
%RRSS

tmp=zeros(numberKernel,1);
for ii=1:numberKernel+1
    tmp(ii) = sum(RRSS_res{ii}.(eval_fns{1}));
end
[~ ,idx_f]=sort(tmp(1:numberKernel),'descend');
for idx1 = 1:length(eval_fns)
    fileName=fullfile(NewsaveDir,[eval_fns{idx1},'_',dataset,'_vsRRSS.pdf']);
    hold on;
    set(gca,'defaulttextinterpreter','latex');
    %set(gca,'FontSize',deffontsize);
        plot(baseLine,RRSS_res{idx_f(1)}.(eval_fns{idx1}),'-ob',...
            baseLine,RRSS_res{idx_f(2)}.(eval_fns{idx1}),'-oy',...
            baseLine,RRSS_res{idx_f(3)}.(eval_fns{idx1}),'-oc',...
            baseLine,RRSS_res{idx_f(5)}.(eval_fns{idx1}),'-og',...
            baseLine,RRSS_res{numberKernel+1}.(eval_fns{idx1}),'-+b',...
            baseLine,MKAL_res.(eval_fns{idx1}),'-or',...
            baseLine,MKAG_res.(eval_fns{idx1}),'-sr','LineWidth',0.88);
                title(dataName,'FontSize',deffontsize);
        xlabel('Number of Selected Instances','FontSize',deffontsize);
        ylabel('Accuracy','FontSize',deffontsize);
    legend('RRSS_1','RRSS_2','RRSS_3','RRSS_m','RRSS_a','LMKAL','GMKAL','location','southeast');
    hold off;
    save2pdf(fileName, gcf, 600);
    delete(gca);
end
    disp(dataset);
    disp('MKAL');
    tmp = sum(MKAL_res.(eval_fns{1})>RRSS_res{idx_f(1)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs RRSS_1 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAL_res.(eval_fns{1})>RRSS_res{idx_f(2)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs RRSS_2 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAL_res.(eval_fns{1})>RRSS_res{idx_f(3)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs RRSS_3 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAL_res.(eval_fns{1})>RRSS_res{idx_f(5)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs RRSS_m in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAL_res.(eval_fns{1})>RRSS_res{numberKernel+1}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs RRSS_a in ',dataset,' ',num2str(tmp)]);
    
    
    
    
    
    
    
    
    
    disp(dataset);
    tmp = sum(MKAL_res.(eval_fns{1})>KTED_res{idx_f(1)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs KTED_1 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAL_res.(eval_fns{1})>KTED_res{idx_f(2)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs KTED_2 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAL_res.(eval_fns{1})>KTED_res{idx_f(3)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs KTED_3 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAL_res.(eval_fns{1})>KTED_res{idx_f(5)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs KTED_m in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAL_res.(eval_fns{1})>KTED_res{numberKernel+1}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAL vs KTED_a in ',dataset,' ',num2str(tmp)]);
    
    
    
    
    
    disp(dataset);
    tmp = sum(MKAG_res.(eval_fns{1})>KTED_res{idx_f(1)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs KTED_1 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAG_res.(eval_fns{1})>KTED_res{idx_f(2)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs KTED_2 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAG_res.(eval_fns{1})>KTED_res{idx_f(3)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs KTED_3 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAG_res.(eval_fns{1})>KTED_res{idx_f(5)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs KTED_m in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAG_res.(eval_fns{1})>KTED_res{numberKernel+1}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs KTED_a in ',dataset,' ',num2str(tmp)]);
    
    
    
    disp(dataset);
    disp('MKAG');
    tmp = sum(MKAG_res.(eval_fns{1})>RRSS_res{idx_f(1)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs RRSS_1 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAG_res.(eval_fns{1})>RRSS_res{idx_f(2)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs RRSS_2 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAG_res.(eval_fns{1})>RRSS_res{idx_f(3)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs RRSS_3 in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAG_res.(eval_fns{1})>RRSS_res{idx_f(5)}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs RRSS_m in ',dataset,' ',num2str(tmp)]);
    
    tmp = sum(MKAG_res.(eval_fns{1})>RRSS_res{numberKernel+1}.(eval_fns{1}));
    tmp = tmp/nBatch;
    disp(['MKAG vs RRSS_a in ',dataset,' ',num2str(tmp)]);
    
end