function [CCars,T] = ChangeAvaiCars(AvailableCars)

CCars.ISOC = AvailableCars.CSOC;
CCars.Tin = ones(size(CCars.ISOC));
CCars.Tav = AvailableCars.Tav;
CCars.Tout = CCars.Tin + CCars.Tav;
CCars.DSOC = AvailableCars.DSOC;
CCars.BatteryCapacity = AvailableCars.BatteryCap;
CCars.Xub = AvailableCars.Xub;
CCars.Xlb = AvailableCars.Xlb;
T = max(CCars.Tout);

end