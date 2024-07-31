%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MPC-V2G %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Optimization using QP with receding horizon%%%%%%%%%%%%%
%%%%%%%%%% Arash Karimi %%%%% Email: arash.karimi@ee.sharif.edu%%%%%%%%
% Please make sure that essential matlab functions are included to the
% current directory. Required functions: CreateCars.m, CreatePowerGrid.m%%%%%%%

% clear all;
% close all;
% clc;
% 
% tic;
% 
%% Initializing
a1 = 1;
a2 = 1;

addpath('/data');
addpath('/results');

% Cars information
% Note that to have the best results, related to the paper, you may have 10000 EVs and %10000 flexible loads, So N might be 20000
nV = 20;
nL = 20;

N = nV + nL
Cars = CreateCars_MPC(N);
% Car = load('Ar2_Cars_0_1_20000.mat');

Cars.nVeh = 40;
Cars.ISOC = [Cars.ISOC(1:nV) Cars.ISOC(nV+1:nV+nL)];

Cars.DSOC = [Cars.DSOC(1:nV) Cars.DSOC(nV+1:nV+nL)];

Cars.Xub = [Cars.Xub(1:nV) Cars.Xub(nV+1:nV+nL)];

Cars.Xlb = [Cars.Xlb(1:nV) Cars.Xlb(nV+1:nV+nL)];

Cars.BatteryCapacity = [Cars.BatteryCapacity(1:nV) Cars.BatteryCapacity(nV+1:nV+nL)];

Cars.Tin = [Cars.Tin(1:nV) Cars.Tin(nV+1:nV+nL)];
Cars.Tav = [Cars.Tav(1:nV) Cars.Tav(nV+1:nV+nL)];
Cars.Tout = [Cars.Tout(1:nV) Cars.Tout(nV+1:nV+nL)];
Cars.CSOC = [Cars.CSOC(1:nV) Cars.CSOC(nV+1:nV+nL)];
Cars.Availability = [Cars.Availability(1:nV,:);Cars.Availability(nV+1:nV+nL,:)];


L_uncont = load('L_uncont.mat');
L_uncont = 0.02 * L_uncont.L_Uncont;

% Power Grid information

Load = load('Load.mat');
Load = Load.BL;
BL = 0.005*Load;
Load = BL;

%% Monte Carlo
TTTs = 1;
TTTf = 20;


L_MPC = cell(1,TTTf);
X_MPC = cell(1,TTTf);
Cars_MPC = cell(1,TTTf);

Var_MPC = zeros(1,TTTf);

% NN = Cars.nVeh + Cars.nL;

for ttt = 1:TTTf
    
    %% MPC
    
    % Initialization
    ts = 10;
    tf = 72;
    
    if ttt ~= 1
        
        Cars = CreateCars_MPC(N);
        
    end
    
    OptimalU = zeros(N,tf);
    
    Pveh = zeros(1,tf);
    
    for t = ts:tf
        
        [nVeh_t,AvailableCars] = AvailableCarFinder(t,Cars);
        
        
        if nVeh_t ~= 0
            
            U = zeros(N,1);
            [CCars,T] = ChangeAvaiCars(AvailableCars);
            BL = Load(t:end);
            AvailU = Agg1_MPC(BL,CCars,a1,a2);
            U(AvailableCars.Index) = AvailU';
            [Cars,Pveh] = Updater(Cars,U,t);
            
        else
            
            U = zeros(N,1);
            
        end
        
        OptimalU(:,t) = U;
        
    end
    
    
    
    % EVCosts = CostFinder(OptimalU,Load,k);
    %
    OptimalU = OptimalU(:,24:48);
    
    TotalLoad = Load(24:48) + sum(OptimalU);
    
    L_MPC{ttt} = TotalLoad;
    X_MPC{ttt} = OptimalU;
    Var_MPC(ttt) = var(TotalLoad);
    Cars_MPC{ttt} = Cars;
    
end

save('L_MPC','L_MPC');
save('X_MPC','X_MPC');
save('Var_MPC','Var_MPC');
save('Cars_MPC','Cars_MPC');

L_MPC = L_MPC{1};

[Fig5,Fig6] = Plot_Online(L_uncont,L_MPC,L_MPC);

savefig(Fig5,'Fig5.fig');
savefig(Fig6,'Fig6.fig');

figure(5);
openfig('Fig5.fig');
saveas(gcf, '../results/Fig5.png');

figure(6);
openfig('Fig6.fig');
saveas(gcf, '../results/Fig6.png')

