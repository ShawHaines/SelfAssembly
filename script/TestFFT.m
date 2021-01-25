slices=512;
range=2;
x=linspace(0,range,slices);
f=@(x) sin(2*pi*3*x)+0.2*sin(2*pi*10*x);
g=@(x) exp(-100*x.*x);
y=g(x);
ky=myFFT(y)/slices;
kyPrime=fft(y)/slices;
kx=(0:2^nextpow2(slices)-1)/range;
%% plot and compare.
figure;
hold on;
plot(kx,abs(ky),'DisplayName',"myFFT, abs");
plot(kx,abs(kyPrime),'DisplayName',"fft, abs");
plot(kx,imag(ky),'DisplayName',"myFFT, imag");
plot(kx,imag(kyPrime),'DisplayName',"fft, imag");
plot(kx,real(ky),'DisplayName',"myFFT, real");
plot(kx,real(kyPrime),'DisplayName',"fft, real");
legend;
% All is well.

%% Time test

repeats=500;
tic;
for i=1:repeats
    ky=myFFT(y);
end
toc
%%
tic;
for i=1:repeats
    ky=fft(y);
end
toc
% killer performance... can't compete at all!