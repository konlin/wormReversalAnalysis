function [bodyVectors,angles]=angleFinder(pos)
    index=1;
    for l=1:length(pos)
        if(l==1)
           posWithoutDuplicates(index,:)=pos(l,:);
           index=index+1;
        else if (pos(l,:)~=pos(l-1,:))
                posWithoutDuplicates(index,:)=pos(l,:);
                index=index+1;
            end
        end
    end
    posWithoutDuplicates
    for k=1:length(posWithoutDuplicates)-1
        bodyVectors(k,:)=posWithoutDuplicates(k+1,:)-posWithoutDuplicates(k,:);
    end
    for j=1:length(bodyVectors)-1
        angles(j)=calculateAngle(bodyVectors(j,:),bodyVectors(j+1,:));
    end
end

    
        
    
    