function phase=calculatePhase(first,last,mcdf,options)
for k=first:last
    c=generateCurvature(mcdf(k));
    x=createSineFit2(c,options);
    phaseArray(k)=x(3);
end
unwrappedPhaseArray=unwrap(phaseArray);
phase=unwrappedPhaseArray(last)-unwrappedPhaseArray(first)
end