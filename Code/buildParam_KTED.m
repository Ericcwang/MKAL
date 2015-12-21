function paramCell = buildParam_KTED(tradeCandi)
n2 = length(tradeCandi);
paramCell = cell(n2, 1);
idx = 0;
    for i4 = 1:n2
        param = [];
        param.trade_param = tradeCandi(i4);
        idx = idx + 1;
        paramCell{idx} = param;
    end
end