function y=myFFT(x)
N=length(x);
m=log2(N);
if ceil(m)~=m % not an exponent of 2, add 0 at the tail
    m=ceil(m);
    N=2^m;
    x(N)=0; % A good method of resizing and adding 0s.
end
A1=x;
A2=zeros([1,N]);
omega=exp((0:(N/2-1))*-1i*2*pi/N);
for l=1:m
    if rem(l,2)~=0
        for k=0:(2^(m-l)-1)
            for j=0:(2^(l-1)-1)
                A2(k*2^l+j+1)=A1(k*2^(l-1)+j+1)+A1(k*2^(l-1)+j+1+N/2);
                A2(k*2^l+j+1+2^(l-1))=A1(k*2^(l-1)+j+1)-A1(k*2^(l-1)+j+1+N/2)*omega((k*2^(l-1))+1);
            end
        end
    else
        for k=0:(2^(m-l)-1)
            for j=0:(2^(l-1)-1)
                A1(k*2^l+j+1)=A2(k*2^(l-1)+j+1)+A2(k*2^(l-1)+j+1+N/2);
                A1(k*2^l+j+1+2^(l-1))=A2(k*2^(l-1)+j+1)-A2(k*2^(l-1)+j+1+N/2)*omega((k*2^(l-1))+1);
            end
        end
    end
end
if rem(m,2)==0
    y=A2;
else
    y=A1;
end
end