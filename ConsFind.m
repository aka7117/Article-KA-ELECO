function [lb,ub,A,b,Aeq,beq] = ConsFind(Tin,Tout,T,ISOC,DSOC,Bat,Sigma,Lnoti,Xub,Xlb,SOCmin,SOCmax)

lb = repmat([0;0;0],T,1);
ub = repmat([900;600;500],T,1);

E0 = ISOC*Bat;
Emin = SOCmin*Bat;
Emax = SOCmax*Bat;
Ed = (Emin-E0)/Sigma;
Eu = (Emax-E0)/Sigma;
En = (DSOC-ISOC)*Bat/Sigma;

A11 = zeros(T,3*T);

for i = 1:T
    
   A11(i,3*(i-1)+1:3*i) = 1;
   
end

A12 = -A11;

A1 = [A11;A12];

b11 = Xub*ones(T,1) + Lnoti';
b12 = -Xlb*ones(T,1) - Lnoti';

b1 = [b11;b12];

A21 = ones(T,3*T);

for i = 1:T-1
    
   A21(i,3*i+1:end) = 0; 
    
end

A22 = -A21;

A2 = [A21;A22];

SLnoti = [];

for i = 1:T
    
    SLnoti = [SLnoti;sum(Lnoti(1:i))];
    
end

b21 = Eu*ones(T,1) + SLnoti;
b22 = -1*(Ed*ones(T,1) + SLnoti);

b2 = [b21;b22];

A = [A1;A2];

b = [b1;b2];

Aeq1 = ones(1,3*T);
beq1 = En + SLnoti(end);

Aeq21 = zeros(Tin-1,3*T);

for i = 1:Tin-1
    
   Aeq21(i,3*(i-1)+1:3*i) = 1; 
    
end

beq21 = Lnoti(1:Tin-1)';

Tnot = T - Tout +1;

Aeq22 = zeros(Tnot,3*T);

for i = Tout:T
    
   Aeq22(i-Tout+1,3*(i-1)+1:3*i) = 1; 
    
end

beq22 = Lnoti(Tout:T)';

Aeq2 = [Aeq21;Aeq22];
beq2 = [beq21;beq22];

Aeq = [Aeq1;Aeq2];
beq = [beq1;beq2];

end