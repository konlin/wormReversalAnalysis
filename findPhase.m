%find a bunch of phase shifts given a CRA
%Konlin Shen
%6/10/13

function [phaseArray,waveMatrix,constructedWave]=findPhase(cra)
craSize=length(cra);
phaseArray=[];

for i=1:craSize
    reverseFrame=cra(i).WormVid(1);
    curvature=generateCurvature(reverseFrame);
    
    waveMatrix=NaN(100,200);
    
    for j=1:100
        waveMatrix(j,j:j+99)=curvature;
    end
    
    constructedWave=zeros(1,200);
    
    for col=1:200
        count=0;
        colTotal=0;
        for row=1:100
           if(~isnan(waveMatrix(row,col))) 
                colTotal=colTotal+waveMatrix(row,col);
                count=count+1;
           end
        end
        constructedWave(col)=colTotal/count;
    end
    constructedWave(isnan(constructedWave))=[];
%     figure;
%     plot(constructedWave)

    Fs = 1; %sample rate is one sampe / percent body length
    D = 1/Fs; %1 percent body length
    L = length(constructedWave); %number of samples total
%     l = (1:L)*D; % x axis of the input curve (units sample)
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
    freq = f(maxInd) * 100 %cycle per body length
    
%     text(f(maxInd), 2*maxVal,['Max=',num2str(freq)],...
%         'VerticalAlignment','Bottom',...
%         'HorizontalAlignment','Left',...
%         'FontSize',8)
%     
    
    phaseArray=[phaseArray,freq];
end

end