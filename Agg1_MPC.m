function OptU = Agg1_MPC(BL,Cars,a1,a2)

% BL = load('Load.mat');
% BL = 4*BL.BL;
% BL = [BL BL BL];
% Load = [BL BL BL];

% n = 1000;
% nL = 10;

delta = 0.3;
% Cars = CreateCars(n);
% Cars = CreateCars(nE,nL);
% Car = load('Ar2_Cars_0_1_20000.mat');
% Cars = Car.Cars;

Xub = Cars.Xub;
Xlb = Cars.Xlb;

% N = 5000;
% N = nE;

Sigma = 1;
BBBat = Cars.BatteryCapacity;
Tin = Cars.Tin;
ISOC = Cars.ISOC;
DSOC = Cars.DSOC;
Tout = Cars.Tout;
Tav = Cars.Tav;
T = max(Tout);

% N = numel(Tin);

BL = BL(1:T);
E1 = DSOC-ISOC;
E = E1.*BBBat;
tt = 0;
Stop = 0;

% CHV = [];
% DHV = [];

N = numel(Tin);

k = zeros(1,N);

% for i = 1:N
%
%    if E(i)<=0
%
%        DHV = [DHV i];
%
%    else
%
%        CHV = [CHV i];
%
%    end
%
% end
%
% for i = 1:numel(DHV)
%
%     k(DHV(i)) = E(DHV(i))*Tav(DHV(i))/(24*sum(BL)+sum(E(CHV)./Tav(CHV))+sum(E(DHV).*Tav(DHV)));
%
% end

%
%
% for i = 1:numel(CHV)
%
%     k(CHV(i)) = E(CHV(i))*Tav(CHV(i))/(24*sum(BL)+sum(E(CHV)./Tav(CHV))+sum(E(DHV).*Tav(DHV)));
%
% end
%

for i = 1:N
    
    k(i) = (abs(E(i))/Tav(i))/((sum(BL)/numel(BL)) + sum(abs(E)./Tav));
    
end

X0 = zeros(N,T);
Xold = X0;
Xnew = X0;
X = zeros(N,T);
XX = {};

for i=1:N
    
    Lnoti =  BL + sum(Xnew)-Xnew(i,:);
    [f,X(i,:)]= optimizer_MPC(Lnoti,BBBat(i),ISOC(i),DSOC(i),k(i),T,Sigma,...
        Tin(i),Tout(i),Xub(i),Xlb(i),a1,a2,delta);
    Xnew(i,:) = X(i,:);
    
end

Lnoti = zeros(numel(BL));
%% Decetralized


while norm(Xold-Xnew) > 1e-3 && tt<5*N
    
    tt = tt+1;
    
    for i = 1:N
        
        if Xold(i,:)~=Xnew(i,:)
            
            Lnoti =  BL + sum(Xnew)-Xnew(i,:);
            [f,X(i,:)] = optimizer_MPC(Lnoti,BBBat(i),ISOC(i),DSOC(i),k(i),T,...
                Sigma,Tin(i),Tout(i),Xub(i),Xlb(i),a1,a2,delta);
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

% Prc = [1.02 1.03 1.05].*[6.5 9.4 13.2];
% Prd = [0.98 0.67 0.48].*[6.5 9.4 13.2];
% pr = [Prc Prd]';
% Pr = repmat(pr,T,1);
% 
% PPrc = [6.5 9.4 13.2];
% PPrd = [6.5 9.4 13.2];
% Ppr = [PPrc PPrd]';
% PPr = repmat(Ppr,T,1);

OptU = XDec(:,1);
end