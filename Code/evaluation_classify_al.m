function res = evaluation_classify_al(X_tr,Y_tr,X_te,Y_te, labeledIdx,nClass)
% todo : add knn classifier and LR 
% todo : ensure each class has at least one training point.

res = [];
y_pre=svm_ova(X_tr(labeledIdx,:),Y_tr(labeledIdx),X_te,Y_te);
ACC = mean(y_pre == Y_te);
% disp('y_pre');
% disp(y_pre');
% disp('Y_te');
% disp(Y_te');
% Y_te = LabelFormat(Y_te,nClass);
% y_pre = LabelFormat(y_pre,nClass);
% res_2 =multilabel_accu(y_pre,Y_te);
% fns = fieldnames(res_2);
% for i1 = 1:length(fns)
%     if isvector(res_2.(fns{i1}))
%         res.([fns{i1}, '_svm']) = mean(res_2.(fns{i1}));
%     else
%         res.([fns{i1}, '_svm']) = res_2.(fns{i1});
%     end
% end
res.Accu_svm = ACC;
end

