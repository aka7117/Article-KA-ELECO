function FlexLoad = CreateFlexLoad(nL)

FlexLoad.nL = nL;

FlexLoad.Pmin = randi([1,3],1,nL);
FlexLoad.Pmax = randi([5,7],1,nL);

FlexLoad.Tin = ones(1,nL);
FlexLoad.Tout = 54*ones(1,nL);

FlexLoad.Pdes = (FlexLoad.Tout-FlexLoad.Tin).*(0.5*(FlexLoad.Pmax + FlexLoad.Pmin));

end