function output=processFrame(input,uniformSize,rect,mask,desiredRange,gamma,binarize)
% Gross parameter passing strategy... Very stupid
resized=imresize(input,[1080,NaN]);
% image adjustment, enhance contrast.
gray=rgb2gray(resized);
gray=imadjust(gray,desiredRange,[]);  % the adjustment need to be done later, to ensure the success of circle detection
%     gray=imadjust(gray);
gray=imcrop(gray,rect);
cropped=imresize(gray,[uniformSize,uniformSize]);
cropped(mask)=255;
% nonlinear gamma correction is the KEY!
cropped=gammaCorrection(cropped,gamma);
if binarize
    cropped=imbinarize(cropped);
    
    % morphological process
    se=strel('disk',1);
    cropped=imopen(cropped,se);
    output=bwareaopen(cropped,6);
else
    output=cropped;
end
end

function output=gammaCorrection(input,gamma)
% output an image with gamma correction.
output=im2double(input).^gamma;
end
