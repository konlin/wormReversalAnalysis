function showFit(startframe, endframe, mcdf, options)
startframe = find([mcdf.FrameNumber]==startframe)
endframe = find([mcdf.FrameNumber]==endframe)
for k=startframe:endframe
    c=generateCurvature(mcdf(k));
    x=createSineFit2(c,options);
    x(3)
    j = waitforbuttonpress;
    close;
end
unwrappedPhaseArray=unwrap(phaseArray)
end