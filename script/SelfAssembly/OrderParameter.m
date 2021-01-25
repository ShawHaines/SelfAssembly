%数据处理程序——序参量：
for i1=1:a
    if (radii(i1)<10) && radii(i1)>0&& ((centers(i1,1)-shuiping/2)^2+(centers(i1,2)-shuzhi/2)^2)<380^2
        if j2==1 
           center(j2,1)=centers(i1,1);
           center(j2,2)=centers(i1,2); 
           j2=j2+1;
        end
        if j2>1
           for k=1:j2-1
               if ((centers(i1,1)-center(k,1))^2+( centers(i1,2)-center(k,2))^2<5^2)
                   k=k-1;
                  break
               end
           end
            if k==j2-1
               center(j2,1)=centers(i1,1);
               center(j2,2)=centers(i1,2);
               radi(j2)=radii(i1);
               j2=j2+1;
            end
        end
    end
end
[a,b]=size(radi);
TRI=delaunay(center(:,1),center(:,2));
[a1,b1]=size(TRI);
n=zeros(b,12);
for j2=1:a1
    for k=1:3
        if n(TRI(j2,k),1)==0
           for m=1:3
               if m~=k
                  n(TRI(j2,k),1)=n(TRI(j2,k),1)+1;
                  n(TRI(j2,k),n(TRI(j2,k),1)+1)=TRI(j2,m);
               end
           end
        end
        if n(TRI(j2,k),1)~=0
            for m=1:3
                if m~=k
                    for p=2:n(TRI(j2,k),1)+1
                        if TRI(j2,m)==n(TRI(j2,k),p)
                            p=p-1;
                            break
                        end
                    end
                if p==n(TRI(j2,k),1)+1
                       n(TRI(j2,k),1)=n(TRI(j2,k),1)+1;
                       n(TRI(j2,k),n(TRI(j2,k),1)+1)=TRI(j2,m);
                    end
                end
            end
        end
    end
end
theta=zeros(b,12);
q=6;op1(i)=0;
for i1=1:b
    j2=n(i1,1);
    for k=2:j2+1
        theta(i1,k)=atan2((center(n(i1,k),2)-center(i1,2)),(center(n(i1,k),1)-center(i1,1)));
theta(i1,1)=exp(1j*q*theta(i1,k))+theta(i1,1);
    end
    theta(i1,1)=theta(i1,1)/j2;
    op1(i)=op1(i)+abs(theta(i1,1));
end
op1(i)=op1(i)/b;
op=op+op1(i);
end
op=op/25
