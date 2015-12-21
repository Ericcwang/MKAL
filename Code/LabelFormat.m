function Y1 = LabelFormat(Y,nClass)
% Y should be n*1 or n*c

[m n] = size(Y);
% if m == 1
%     Y = Y';
%     [m n] = size(Y);
% end;

if n == 1
    Y1 = zeros(m,nClass);
    Y1(:)=-1;
    for i=1:nClass
        Y1(Y==i,i) = 1;
    end;
else
    [temp Y1] = max(Y,[],2);
end
end
