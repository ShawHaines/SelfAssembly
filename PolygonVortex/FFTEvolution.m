folder="./Cropped/";
outputName="FFTEvolution.avi";
showGraph=false;
if showGraph
writer=VideoWriter(char(folder+outputName));
writer.FrameRate=25;
open(writer);
handle=figure;
axis auto;
end
%%
tic;
c3=zeros([1,300]);
for i=1:300
    if isempty(boundaryList{i})
        break;
    end
    % Calculate r,theta
    deltaR=scaledBoundaryList{i};
    rho=vecnorm(deltaR,2,2);
    % y is upside-down
    theta=atan2(-deltaR(:,2),deltaR(:,1));
    % Express the countour as complex numbers.
    % again the y axis needs to flip.
    boundary=deltaR(:,1)-1i*deltaR(:,2);
    
    % Discrete Fourier Transformation
    
    y=abs(fft(rho))/length(rho); % divide by length,normalization.
    y=fftshift(y);
    [~,middle]=max(y);
    x=-20:20;
    % complex integration, c for complex
    yc=abs(fft(boundary))/length(boundary);
    yc=fftshift(yc);
    % The results are convincing.
    [~,middleC]=max(yc);
    c3(i)=y(middle+3);
    if showGraph
    subplot(2,1,1);
    stem(x,y(middle+x));
    ylim([0,0.045]);
    title("FFT");
    subplot(2,1,2);
    stem(x,yc(middleC+x-1));
    ylim([0,0.045]);
    title("Complex Integration");
    writeVideo(writer,getframe(handle));
    end
end
if showGraph
close(writer);
end
toc
fprintf("video exported in %s\\%s.\n",folder,outputName);