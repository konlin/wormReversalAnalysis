%double checking the phase finding algorithm...
%6/24/13
%Konlin Shen

function phaseArray=suspiciousPhase(frameArray)
len=size(frameArray,2);
phaseArray=[];
options=optimset('MaxFunEvals', 100000, 'MaxIter', 100000);

for i=1:len
    curvature=generateCurvature(frameArray(i));
    constructedWave=curvature;

    Fs = 1; %sample rate is one sampe / percent body length
    D = 1/Fs; %1 percent body length
    L = length(constructedWave); %number of samples total
    l = (1:L)*D; % x axis of the input curve (units sample)

    NFFT = 2^nextpow2(L); % Next power of 2 from length of y - nyquist rate
    Y = fft(constructedWave,NFFT)/L; %fft(data, number of samples) n-point DFT
    f = Fs/2*linspace(0,1,NFFT/2+1);

    [maxVal, maxInd] = max(abs(Y));
    while(f(maxInd)==0)
        f(maxInd)=[];
        [maxVal, maxInd]=max(abs(Y));
    end
    freq = f(maxInd) * 100; %cycle per body length

    %perform a best fit for a sine wave:
    bestFitCurve=createSineFit2(curvature, options);
    
    if numel(bestFitCurve)~=0
        phaseArray=[phaseArray,bestFitCurve(3)];
    end
end

figure;
plot(phaseArray)
end