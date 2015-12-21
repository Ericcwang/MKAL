function run_single_algo_exp(handle)
exp_setting.kernelCandi = [10.^(-3:3),2015,2016,2017];
exp_setting.tradeParam=0.1;
exp_setting.trainRatio=0.7;
exp_setting.nRepeat = 10;

% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('vote',exp_setting);
% 
% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('iono',exp_setting);
% % 
% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('wine',exp_setting);
% 
% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('iris',exp_setting);
% 
% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('arcene',exp_setting);
% 
% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('diabetes',exp_setting);
% 
% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('musk',exp_setting);
% 
exp_setting.batchSize=5;
exp_setting.nBatch=10;
handle('glass',exp_setting);
% % 
% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('yaleface',exp_setting);
% 
% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('jaffe',exp_setting);
% 
% %  large
% exp_setting.batchSize=5;
% exp_setting.nBatch=20;
% handle('COIL20',exp_setting);

exp_setting.batchSize=5;
exp_setting.nBatch=20;
handle('r',exp_setting);
% 
exp_setting.batchSize=5;
exp_setting.nBatch=15;
handle('ORL_32x32',exp_setting);
% % end large
% 
exp_setting.batchSize=5;
exp_setting.nBatch=10;
handle('segmentation',exp_setting);
% 
% exp_setting.batchSize=5;
% exp_setting.nBatch=10;
% handle('heart',exp_setting);
% 
exp_setting.batchSize=5;
exp_setting.nBatch=20;
handle('australian',exp_setting);
% 
exp_setting.batchSize=5;
exp_setting.nBatch=10;
handle('sonar',exp_setting);