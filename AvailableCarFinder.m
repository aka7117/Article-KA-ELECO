function [nVeh_t,AvailableCars] = AvailableCarFinder(t,Cars)

nVeh_t = 0;

AvailableCarIndex = [];

for i = 1:Cars.nVeh
    
    if Cars.Availability(i,t)==1
        
        nVeh_t = nVeh_t+1;
        AvailableCarIndex = [AvailableCarIndex i];
        
    end
    
end

if nVeh_t ~= 0
    
    AvailableCars.Tav = zeros(nVeh_t,1);
    AvailableCars.DSOC = zeros(nVeh_t,1);
    AvailableCars.CSOC = zeros(nVeh_t,1);
    AvailableCars.BatteryCap = zeros(nVeh_t,1);
    
    for i = 1:nVeh_t
        
        AvailableCars.Tav(i) = Cars.Tout(AvailableCarIndex(i)) - t;
        AvailableCars.DSOC(i) = Cars.DSOC(AvailableCarIndex(i));
        AvailableCars.CSOC(i) = Cars.CSOC(AvailableCarIndex(i));
        AvailableCars.BatteryCap(i) = Cars.BatteryCapacity(AvailableCarIndex(i));
        
    end
       
else
    
    AvailableCars.Tav = [];
    AvailableCars.DSOC = [];
    AvailableCars.CSOC = [];
    AvailableCars.BatteryCap = [];
    
end

AvailableCars.Index = AvailableCarIndex;
AvailableCars.SOCmin = Cars.SOCmin;
AvailableCars.SOCmax = Cars.SOCmax;
AvailableCars.Xub = Cars.Xub(AvailableCars.Index);
AvailableCars.Xlb = Cars.Xlb(AvailableCars.Index);

end