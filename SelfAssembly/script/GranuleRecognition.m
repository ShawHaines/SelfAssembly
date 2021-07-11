function [center]=GranuleRecognition(stats,shuiping,shuzhi)
    % remove those beads that are marked more than 1 time.
    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii = diameters/2;
    j=1;
    [a,b]=size(radii);
    center=zeros(a,b);
    radi=zeros(a,1);
    for i1=1:a
        if (radii(i1)<10) && radii(i1)>0.5 && ((centers(i1,1)-shuiping/2)^2+(centers(i1,2)-shuzhi/2)^2)<490^2 %500是为了限制在盘内，是个需要修改的参量
           if j==1 
              center(j,1)=centers(i1,1);
              center(j,2)=centers(i1,2); 
              radi(j)=radii(i1);
              j=j+1;
           end
           if j>1
              for k=1:j-1
                  if ((centers(i1,1)-center(k,1))^2+( centers(i1,2)-center(k,2))^2<15^2)
                      k=k-1;
                      break
                  end
              end
              if k==j-1
                 center(j,1)=centers(i1,1);
                 center(j,2)=centers(i1,2);
                 radi(j)=radii(i1);
                 j=j+1;
              end
           end
        end
    end
    center=center(1:j-1,:);
end
