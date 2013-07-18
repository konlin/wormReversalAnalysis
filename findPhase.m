%find the phase of a worm by taking the curvature
%Konlin Shen
%6/10/13

function phaseArray=findPhase(cra)
craSize=length(cra);
filteredCurvatureArray=[];
phaseArray=[];
options=optimset('MaxFunEvals', 100000, 'MaxIter', 100000);


%first filter the CRA for unreasonably large curvatures
for index=1:craSize
    reverseFrame=cra(index).WormVid(1);
    c=generateCurvature(reverseFrame);
    
    maxCurv=max(abs(c));
    
    if maxCurv<2*pi
        filteredCurvatureArray=[filteredCurvatureArray,c];
    end
end

fcraSize=size(filteredCurvatureArray,2)

for i=1:fcraSize
    curvature=filteredCurvatureArray(:,i);
    
%     waveMatrix=NaN(100,200);
%     
%     for j=1:100
%         waveMatrix(j,j:j+99)=curvature;
%     end
%     
%     constructedWave=zeros(1,200);
%     
%     for col=1:200
%         count=0;
%         colTotal=0;
%         for row=1:100
%            if(~isnan(waveMatrix(row,col))) 
%                 colTotal=colTotal+waveMatrix(row,col);
%                 count=count+1;
%            end
%         end
%         constructedWave(col)=colTotal/count;
%     end
%     constructedWave(isnan(constructedWave))=[];

    constructedWave=curvature;
%     figure;
%     plot(constructedWave)
       
    Fs = 1; %sample rate is one sampe / percent body length
    D = 1/Fs; %1 percent body length
    L = length(constructedWave); %number of samples total
    l = (1:L)*D; % x axis of the input curve (units sample)
%     figure;
%     hold on;
%     ax2(1)=subplot(2,1,1);
%     plot(l/Fs,constructedWave);
%     xlabel('Percent Body Length')
%     ylabel('Curvature')

    NFFT = 2^nextpow2(L); % Next power of 2 from length of y - nyquist rate
    Y = fft(constructedWave,NFFT)/L; %fft(data, number of samples) n-point DFT
    f = Fs/2*linspace(0,1,NFFT/2+1);
%     ax2(2)=subplot(2,1,2);
%     stem(f,2*abs(Y(1:NFFT/2+1)), '-.');
%     xlabel('Angular Frequency (Cycles / Percent Body Length)')
    [maxVal, maxInd] = max(abs(Y));
    while(f(maxInd)==0)
        f(maxInd)=[];
        [maxVal, maxInd]=max(abs(Y));
    end
    freq = f(maxInd) * 100; %cycle per body length
%     
%     text(f(maxInd), 2*maxVal,['Max=',num2str(freq)],...
%         'VerticalAlignment','Bottom',...
%         'HorizontalAlignment','Left',...
%         'FontSize',8)
    
    %perform a best fit for a sine wave:
    bestFitCurve=createSineFit2(curvature, options);
    if numel(bestFitCurve)~=0
        phaseArray=[phaseArray,bestFitCurve(3)];
    end
end

figure;
hist(phaseArray,15);
title('Histogram of Phase');
end