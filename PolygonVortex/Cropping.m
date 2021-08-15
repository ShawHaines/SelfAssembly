fileName="./Video1/1.jpg";
img=imread(fileName);
img=imresize(img,[NaN,1280]);
img=imbinarize(rgb2gray(img),0.6);
imshow(img);

[centers, radii, metric] = imfindcircles(img,[300,360],'Sensitivity',0.99,'ObjectPolarity','bright');
viscircles(centers, radii,'EdgeColor','b');
rect=zeros(1,4);
rect(3)=radii(1)*2;%Height.
rect(4)=rect(3);
rect(2)=centers(1,2)-rect(3)/2;
rect(1)=centers(1,1)-rect(3)/2;

