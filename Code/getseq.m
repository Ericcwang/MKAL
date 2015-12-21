function idx = getseq( a , nSelect)
%[~, idx] = sort(sum(a,2),'descend');
b=sum(abs(a),2);
b=b./ max(b);
n=size(a,1);
% c=zeros(size(b));
% for i=1:n
%     for j=1:n
%         if j~=i
%             c(i)=sum(a(i,:).*a(j,:))/(norm(a(i,:))*norm(a(j,:)));
%         end
%     end
% end
% c=c./max(c);
% b=b+c;
% [~,idx]=sort(b,'descend');
used=zeros(n,1);
[~ ,idx]=max(b);
used(idx)=1;
L=idx;
dist=EuDist2(a,[],0);
dist=sqrt(dist);
dist=dist./max(dist(:));
for i=2:nSelect
    mm=-100000000;
    mmidx=-1;
    for j=1:n
        if used(j)==0
            tmp=0;
            for k=L
                tmp=tmp-dist(k,j);
            end
            tmp=tmp./length(L)+b(j);
            if (tmp>mm)
                mm=tmp;
                mmidx=j;
            end
        end
    end
    L=[L;mmidx];
    used(mmidx)=1;
end
  idx=L;      
end

