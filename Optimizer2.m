function [F,X] = optimizer2(Lnoti,Bat,ISOC,DSOC,k,T,sigma,Tin,Tout,Xub,xlb,a1,a2,delta)
SOCmin = 0.1;
SOCmax = 1;
Prc = [1.1 1.15 1.2].*[13.2 13.2 13.2];
% Prd = [1,1,1].*[6.5 6.5 6.5];
% pr = [Prc Prd]';
Pr = repmat(Prc,1,T);
[lb,ub,A,b,Aeq,beq] = ConsFind(Tin,Tout,T,ISOC,DSOC,Bat,sigma,Lnoti,Xub,xlb,SOCmin,SOCmax);
    
f1 = Pr';
f = a1*f1;
    
[x,F] = linprog(f,A,b,Aeq,beq,lb,ub);
    
X = zeros(T,1);

for i = 1:T
    
    X(i) = sum(x(3*(i-1)+1:3*i))-Lnoti(i);
    
end

end