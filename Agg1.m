function [TotalLoad,XDec] = Agg1(BL,a1,a2,nV,nL,fac)

addpath('/data'); 

n = nV + nL; %Total Number of Agents

% BL = load('Load.mat');

BL = [BL BL BL];
Load = [BL BL BL];

Load = BL;
% n = 1000;
% nL = 10;

delta = 0.3;
% Cars = CreateCars(n);
% Cars = CreateCars(nE,nL);
Car = load('Ar2_Cars_0_1_20000.mat');
Cars = Car.Cars;

Xub = [Cars.Xub(1:nV) Cars.Xub(10001:10000+nL)];
Xlb =[Cars.Xlb(1:nV) Cars.Xlb(10001:10000+nL)];


Sigma = 1;

BBBat = [Cars.BatteryCapacity(1:nV) Cars.BatteryCapacity(10001:10000+nL)];
Tin = [Cars.Tin(1:nV) Cars.Tin(10001:10000+nL)];
ISOC = [Cars.ISOC(1:nV) Cars.ISOC(10001:10000+nL)];
DSOC = [Cars.DSOC(1:nV) Cars.DSOC(10001:10000+nL)];
Tout = [Cars.Tout(1:nV) Cars.Tout(10001:10000+nL)];
Tav = [Cars.Tav(1:nV) Cars.Tav(10001:10000+nL)];

T = max(Tout);

BL = BL(1:T);
E1 = DSOC-ISOC;
E = E1.*BBBat;
tt = 0;
Stop = 0;

N = numel(Tin);

k = zeros(1,N);


for i = 1:N
    
    k(i) = (abs(E(i))/Tav(i))/((sum(BL)/numel(BL)) + sum(abs(E)./Tav));
    
end

X0 = zeros(N,T);
Xhelp = X0;
Xold = X0;
Xnew = X0;
X = zeros(N,T);
XX = {};

% for i=1:N
%     
%     Lnoti =  BL + sum(Xnew)-Xnew(i,:);
%     [f,X(i,:)]= optimizer(Lnoti,BBBat(i),ISOC(i),DSOC(i),k(i),T,Sigma,Tin(i),Tout(i),Xub(i),Xlb(i),a1,a2,delta);
%     Xnew(i,:) = X(i,:);
%     
% end
% 
% Lnoti = zeros(numel(BL));

%% Decetralized

while norm(Xold-Xnew) > 1e-2 && tt<5*N
    
    tt = tt+1;
    
    for i = 1:N
        
        if Xold(i,:)~=Xnew(i,:)
            
            Lnoti =  BL + sum(Xnew)-Xnew(i,:);
            [f,X(i,:)] = optimizer(Lnoti,BBBat(i),ISOC(i),DSOC(i),k(i),T,Sigma,Tin(i),Tout(i),Xub(i),Xlb(i),a1,a2,delta);
            Xhelp(i,:) = X(i,:);
            
        else
            
            Xhelp(i,:) = Xnew(i,:);
            
        end
        
    end
    
    Xold = Xnew;
    Xnew = Xhelp;
    XX{tt} = Xnew;
    
    if tt > 2
        
        for kk = 1:tt-1
            
            if isequal(XX(kk),XX(tt))
                
                Stop = 1;
                Stopkk = kk;
                
            end
            
        end
        
    end
    
    if Stop == 1
        
        break;
        
    end
    
end

XDec = Xnew;

% %% Centralized
% QQ = [];
% for i = 1:N
%
%     QQ = [QQ eye(T)];
%
% end
%
% H = [];
%
% for i = 1:N
%
%     H = [H
%         QQ];
%
% end
%
%
% Aeq = zeros(N,T*N);
% for i = 1:N
%
%     Aeq(i,(i-1)*T+1:i*T)=ones(1,T);
%
% end
% Beq = E;
% lb = -4*ones(N*T,1);
% ub = 4*ones(N*T,1);
% f = 2*repmat((BL'-Avg),N,1);
% Y = quadprog(H,f,[],[],Aeq,Beq,lb,ub);
%
% QY = QQ*Y;
% QY = QY';
%
% LC = BL+QY;
% LD = BL+sum(X);
% LLL = [BL;LC;LD];
% bar(LLL');
% legend('BL','LC','LD');

TotalLoad = BL + sum(XDec);
TotalLoad = TotalLoad(24:48);
XDec = XDec(:,24:48);

Prc = [1.02 1.03 1.05].*[6.5 9.4 13.2];
Prd = [0.98 0.67 0.48].*[6.5 9.4 13.2];
pr = [Prc Prd]';
Pr = repmat(pr,T,1);

PPrc = [6.5 9.4 13.2];
PPrd = [6.5 9.4 13.2];
Ppr = [PPrc PPrd]';
PPr = repmat(Ppr,T,1);

end