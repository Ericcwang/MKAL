function [ out ] = myKernel(x,lambda)
if lambda == 2015
    out = x * x';
else if lambda == 2016
    out = x * x';
    out = out .^ 2;
    else if lambda == 2017
        out = x*x';
        out = out .^4;
        else
            tmp=EuDist2(x,[],0);
            delta=lambda*max(tmp(:));
            out = exp(-tmp./delta);
        end
    end
end
     maximum=max(out(:));
     out = out ./maximum;
end

