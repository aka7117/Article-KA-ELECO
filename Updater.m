function [Cars,Pveh] = Updater(Cars,U,t)

Cars.CSOC = Cars.CSOC +U'./(Cars.BatteryCapacity);

Pveh(t) = sum(U);

end