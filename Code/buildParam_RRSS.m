function paramCell = buildParam_RRSS(tradeCandi)
n = length(tradeCandi);
nP = n;
paramCell = cell(nP, 1);
idx = 0;
for i3 = 1:n
    param = [];
    param.trade_param = tradeCandi(i3);
    idx = idx + 1;
    paramCell{idx} = param;
end
end