function res = winLoss( a,b )
win=0;
tie=0;
loss=0;
t1=a;
t2=b;
[~,p]=ttest2(t1,t2,'Alpha',0.95);
if (p>0.05)
    tie=1;
else
    if (mean(t1)>mean(t2))
        win=1;
    else
        loss=1;
    end
end

res=[win,tie,loss];
end

