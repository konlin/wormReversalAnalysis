function [d3,d4,d5,s3curvature,s4curvature,s5curvature]=plotkvdk3(mcdf,varargin)

%maxs1curvature=[];
s2curvature=[];
s3curvature=[];
s4curvature=[];
s5curvature=[];

seg3freq=0;
seg4freq=0;
seg5freq=0;

d2=[];
d3=[];
d4=[];
d5=[];
if(nargin==2 && strcmp(class(varargin{1}),'WormReverse'))
    for k=1:length(varargin{1})
        %s1array=[];
        s2array=[];
        s3array=[];
        s4array=[];
        s5array=[];

        firstframe=find([mcdf.FrameNumber]==cleanedReversalArray(k).WormVid(1).FrameNumber); %finds a reversal
        if firstframe > 30 %pads beginning of reversal with 30 frames (unless it cannot)
            startframe=firstframe-30;
        else
            startframe=firstframe;
        end

        if firstframe+60 < length(mcdf) %takes the next 60 frames as the end
            endframe=firstframe+60;
        else
            endframe=length(mcdf);
        end

        frames=mcdf(startframe:endframe); 
        for m=1:length(frames)
            curvature=generateCurvature(frames(m));
            s1=curvature(1:20); %divides the curvature into 5 segments
            s2=curvature(21:40);
            s3=curvature(41:60);
            s4=curvature(61:80);
            s5=curvature(81:100);

            %s1array=[s1array,mean(s1)];
            s2array=[s2array,mean(s2)]; %for each time point, takes the mean curvature of each segment
            s3array=[s3array,mean(s3)];
            s4array=[s4array,mean(s4)];
            s5array=[s5array,mean(s5)];
        end

        %s1array=smooth(s1array);
        s2array=smooth(s2array);
        s3array=smooth(s3array);
        s4array=smooth(s4array);
        s5array=smooth(s5array);

        %diffSeg1=smooth(diff(s1array));
        diffSeg2=smooth(diff(s2array),3); %take the derivative
        diffSeg3=smooth(diff(s3array),3);
        diffSeg4=smooth(diff(s4array),3);
        diffSeg5=smooth(diff(s5array),3);
        try
            [d3start,d3end]=findNegativeBoundaries(diffSeg3(30:90));
            [d4start,d4end]=findNegativeBoundaries(diffSeg4(30:90));
            [d5start,d5end]=findNegativeBoundaries(diffSeg5(30:90));

            d3=[d3,mean(diffSeg3(d3start+30:d3end+30))];%s3array(maxd3index + 30)-s3array(30)]; %average the derivative
            d4=[d4,mean(diffSeg4(d4start+30:d4end+30))];%s4array(maxd4index + 30)-s4array(30)];
            d5=[d5,mean(diffSeg5(d5start+30:d5end+30))];%s5array(maxd5index + 30)-s5array(30)];

            s3curvature=[s3curvature,s3array(30)]; %save the segment curvature at the point of reversal
            s4curvature=[s4curvature,s4array(30)];
            s5curvature=[s5curvature,s5array(30)];
        catch
        end
    end
else
    frames=varargin{1}; 
    %s1array=[];
    s2array=[];
    s3array=[];
    s4array=[];
    s5array=[];
    for m=1:length(frames)
        curvature=generateCurvature(frames(m));
        s1=curvature(1:20); %divides the curvature into 5 segments
        s2=curvature(21:40);
        s3=curvature(41:60);
        s4=curvature(61:80);
        s5=curvature(81:100);

        %s1array=[s1array,mean(s1)];
        s2array=[s2array,mean(s2)]; %for each time point, takes the mean curvature of each segment
        s3array=[s3array,mean(s3)];
        s4array=[s4array,mean(s4)];
        s5array=[s5array,mean(s5)];
    end

    %s1array=smooth(s1array);
    s2array=smooth(s2array);
    s3array=smooth(s3array);
    s4array=smooth(s4array);
    s5array=smooth(s5array);

    %diffSeg1=smooth(diff(s1array));
    diffSeg2=smooth(diff(s2array),3); %take the derivative
    diffSeg3=smooth(diff(s3array),3);
    diffSeg4=smooth(diff(s4array),3);
    diffSeg5=smooth(diff(s5array),3);

   
    d3=[d3,mean(diffSeg3)];
    d4=[d4,mean(diffSeg4)];
    d5=[d5,mean(diffSeg5)];

    s3curvature=[s3curvature,s3array(1)];
    s4curvature=[s4curvature,s4array(1)];
    s5curvature=[s5curvature,s5array(1)];
    try
        [d3start,d3end]=findNegativeBoundaries(diffSeg3);
        [d4start,d4end]=findNegativeBoundaries(diffSeg4);
        [d5start,d5end]=findNegativeBoundaries(diffSeg5);

        d3=[d3,mean(diffSeg3)];
        d4=[d4,mean(diffSeg4)];
        d5=[d5,mean(diffSeg5)];

        s3curvature=[s3curvature,s3array(1)]; %save the segment curvature at the point of reversal
        s4curvature=[s4curvature,s4array(1)];
        s5curvature=[s5curvature,s5array(1)];
    catch
    end
end

% figure;
% hold on;
% %plot(abs(s2curvature),d2,'.b');
% plot(s3curvature,d3,'dg');  %plot and calculate correlation
% plot(s4curvature,d4,'dc');
% plot(s5curvature,d5,'dm');
% [~,pval3]=corrcoef(s3curvature',d3')
% [~,pval4]=corrcoef(s4curvature',d4')
% [~,pval5]=corrcoef(s5curvature',d5')
% xlabel('curvature');
% ylabel('change in curvature');
% legend('seg 3','seg 4', 'seg 5');

end
