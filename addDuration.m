function newList=addDuration(reversalList)
len=length(reversalList);
for i=1:len
  if(reversalList(i).getTimeDuration==0)
      newList(i)=reversalList(i).setTimeDuration...
          (length(reversalList(i).WormVid));
  end
end
end
