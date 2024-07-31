function Cars = CreateCars_MPC(n)

nL = n/2;
nE = nL;
Sigma = 1;
Cars.Sigma = Sigma;
Cars.nVeh = nE;                                    % Number of vehicles
Cars.nL = nL;
Cars.ISOC = [0.11*randi([2,9],1,Cars.nVeh) 0.15*ones(1,nL)];     % Initial SOC
Cars.DSOC = [0.11*randi([5,8],1,Cars.nVeh) 0.95*ones(1,nL)];      % Desired SOC at departure time
Cars.SOCmin = 0.1;
Cars.SOCmax = 1.0;
Cars.HistorySOC = [];
Caps = [17 19 25];
LCaps = [30 40 50];

Cars.Xub = [4*ones(1,nE) 6*ones(1,nL)];
Cars.Xlb = [-4*ones(1,nE) zeros(1,nL)];


Cars.BatteryCapacity = [Caps(randi([1,3],1,Cars.nVeh)) LCaps(randi([1,3],1,nL))];
Cars.Tin = [randi([20,50],1,nE) randi([20,40],1,nE)];               % Arrival time
Cars.Tout = zeros(1,n);
Cars.Tav = zeros(1,n);
Tav = zeros(1,n);
% Cars.Sigma = 0.92;
NeedSOC = Cars.DSOC - Cars.ISOC;
NE = (NeedSOC.*Cars.BatteryCapacity)/Sigma;
Cars.CSOC = Cars.ISOC;

for i = 1:nE
    
    if NE(i) > 0
        
        Tav(i) = ceil(0.5*NE(i));
        
        Cars.Tav(i) = randi([Tav(i)+1,Tav(i)+6],1,1);
        
        Cars.Tout(i) = Cars.Tin(i)+Cars.Tav(i);
        
    else
        
        Tav(i) = floor(0.5*NE(i));
        Cars.Tav(i) = randi([abs(Tav(i))+1,abs(Tav(i))+8],1,1);
        Cars.Tout(i) = Cars.Tin(i)+Cars.Tav(i);
        
    end
    
end


for i = nE+1:nE+nL
    
        Tav(i) = ceil(0.25*NE(i));
        
        Cars.Tav(i) = randi([Tav(i)+1,Tav(i)+6],1,1);
        
        Cars.Tout(i) = Cars.Tin(i) + Cars.Tav(i)+1;
    
end

Cars.Availability = zeros(n,72);

for i = 1:n
    
    for t = 1:72
        
        if Cars.Tin(i)<=t && t<Cars.Tout(i)
            
            Cars.Availability(i,t) = 1;
            
        end
        
    end
    
end

Cars.nVeh = n;

end