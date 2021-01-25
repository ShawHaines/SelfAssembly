oldPath=pwd;
cd(folder);
reader=VideoReader(fileName);
outputName=char(fileName+"_fft");
writer=VideoWriter(outputName); % You'd better use '(char) instead of ""(strings)
writer.FrameRate=reader.FrameRate;
open(writer);
%% read video and fft.
tic;
reader.CurrentTime=0;
viewPortSize=reader.Height*reader.Width;
climit=[0,0.1]; % colormap.
if hasFrame(reader)
    frame=rgb2gray(readFrame(reader));
    transformed=fftshift(fft2(frame)/viewPortSize);
    colormap jet;
    imagesc(abs(transformed),climit);
%     axis off;
    writeVideo(writer,getframe); % if you don't specify gcf, you won't need axis off to disble the axes.
end
close(writer);
fprintf("output in %s\\%s.\n",pwd,outputName);
cd(oldPath);
toc