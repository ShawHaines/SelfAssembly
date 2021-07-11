frame=imread(fileName);
frame=rgb2gray(frame);
imshow(frame);

%% fft
climit=[0,1];
viewPortSize=size(frame,1)*size(frame,2);
transformed=fftshift(fft2(frame)/viewPortSize);
figure;
colormap jet;
imagesc(abs(transformed),climit);
