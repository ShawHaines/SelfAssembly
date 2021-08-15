function [center]=GranuleRecognition(stats)
    % remove those beads that are marked more than 1 time.
    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii = diameters/2;
    j=0;
    [a,~]=size(radii);
    % the list of filtered center of beads.
    center=zeros(a,2);
    radi=zeros(a,1);
    for i1=1:a
        if (radii(i1)<10) && radii(i1)>0.5 % Won't need the restrictions that the beads should be inside the plate, now that the background has been erased.
           if j==0
              j=j+1;
              center(j,1)=centers(i1,1);
              center(j,2)=centers(i1,2); 
              radi(j)=radii(i1);
           elseif j>=1
              % checking the repetitions.
              for k=1:j
                  if ((centers(i1,1)-center(k,1))^2+( centers(i1,2)-center(k,2))^2<15^2)
                      k=k-1;
                      break
                  end
              end
              if k==j
                 j=j+1;
                 center(j,1)=centers(i1,1);
                 center(j,2)=centers(i1,2);
                 radi(j)=radii(i1);
              end
           end
        end
    end
end
