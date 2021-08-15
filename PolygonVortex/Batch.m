% clearvars;
folder="./Cropped/";
outputName="Combined.avi";
writer=VideoWriter(char(folder+outputName));
writer.FrameRate=25;
open(writer);
% boundaryList=cell([1,300]);
% scaledBoundaryList=cell([1,300]);
%%
loop=1;tic;
fileName=folder+loop+".jpg";
while exist(fileName,"file")
%     try
%         Process_Video;
%         boundaryList{loop}=outterBoundary;
%         scaledBoundaryList{loop}=deltaR;
%     catch e % Error Handling.
%         boundaryList{loop}=boundaryList{loop-1};
%         scaledBoundaryList{loop}=scaledBoundaryList{loop-1};
%     end
    image=imread(fileName);
    image=imresize(image,[NaN,1280]);
    imshow(image,'InitialMagnification','fit');
    if loop>1
        if ~isequal(boundaryList{loop},boundaryList{loop-1})
            hold on;
            temp=boundaryList{loop};
            plot(temp(:,1),temp(:,2),'Color','red','LineWidth',5.0);
            hold off;
            drawnow;
        end
    end
    writeVideo(writer,getframe(gca));
    loop=loop+1;
    fileName=folder+loop+".jpg";
end
close(writer);
toc
fprintf("video exported in %s\\%s.\n",folder,outputName);