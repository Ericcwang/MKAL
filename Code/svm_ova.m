function y_pred = svm_ova(trainfeature, trainlabel, testfeature, testlabel)

model = train(trainlabel, sparse(trainfeature), '-s 1 -q');
[y_pred, ~, ~] = predict(testlabel * 0, sparse(testfeature), model, '-q');


% model = svmtrain(trainlabel, trainfeature,'-t 2 -q');
% [y_pred,~,~]= svmpredict(testlabel * 0, testfeature, model, '-q');
