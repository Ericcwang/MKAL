function paramCell = buildParam_MKAL(tradeCandi)
n2 = length(tradeCandi);
nP = n2;
paramCell = cell(nP, 1);
idx = 0;
    for i4 = 1:n2
        param = [];
        param.trade_param = tradeCandi(i4);
        idx = idx + 1;
        paramCell{idx} = param;
    end
end