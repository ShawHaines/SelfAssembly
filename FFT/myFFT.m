function y=myFFT(x)
N=length(x);
m=log2(N);
if N==1
    y=[x];
    return;
end
if ceil(m)~=m % not an exponent of 2, add 0 at the tail
    m=ceil(m);
    N=2^m;
    x(N)=0; % A good method of resizing and adding 0s.
end
indices=2:2:N;
yo=myFFT(x(indices)); % odd, note that this is because the index starts from 0
ye=myFFT(x(indices-1)); % even
y=zeros([1,N]);
omega=exp((0:N/2-1)*(-1i)*2*pi/N);
indices=1:N/2;
y(indices)=ye+omega.*yo;
y(indices+N/2)=ye-omega.*yo;
end