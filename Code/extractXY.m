function [X, Y] = extractXY(dataset)
load (dataset);
%===========================================
[nSmp,nFea] = size(fea);
for i = 1:nSmp
     fea(i,:) = fea(i,:) ./ max(1e-12,norm(fea(i,:)));
end
%===========================================
%===========================================
maxValue = max(max(fea));
fea = fea/maxValue;
%===========================================
X=fea;
Y=gnd;
if (length(unique(Y)) == 2)
    Y(Y == 1) = 2;
    Y(Y == 0) = 1;
end
end
  