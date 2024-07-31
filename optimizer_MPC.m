function [F,X] = optimizer_MPC(Lnoti,Bat,ISOC,DSOC,k,T,Sigma,Tin,Tout,Xub,xlb,a1,a2,delta)
SOCmin = 0.1;
SOCmax = 1;
Prc = [1.1 1.15 1.2].*[6.5 9.4 13.2];
% Prd = [1,1,1].*[6.5 6.5 6.5];
% pr = [Prc Prd]';
Pr = repmat(Prc,1,T);
[lb,ub,A,b,Aeq,beq] = ConsFind_MPC(Tin,Tout,T,ISOC,DSOC,Bat,Sigma,Lnoti,Xub,xlb,SOCmin,SOCmax);

Q = zeros(3*T,3*T);

for i = 1:T
    
    Q(3*(i-1)+1:3*i,3*(i-1)+1:3*i) = ones(3,3);
    
end

Q = 2*k*delta*Q;

% f2 = 2*repelem(Lnoti,3);

% f2 = k*delta*f2;

f1 = Pr';
f = a1*f1;

[x1,FF] = linprog(f1,A,b,Aeq,beq,lb,ub);
% 
% cvx_begin;
% 
% cvx_solver Gurobi;
% 
% variable x(3*T);
% 
% minimize f1*x
% 
% subject to
% 
% A*x <= b;
% 
% Aeq*x == beq;
% 
% lb <= x <= ub;
% 
% cvx_end;
% 
% FF = cvx_optval;

Q2 = a2*Q;

% [x,F] = quadprog(Q2,f2,A,b,Aeq,beq,lb,ub);

if k ~= 0
    
    [~,FFF] = quadprog(Q2,[],A,b,Aeq,beq,lb,ub);
    
    if FFF == 0
        
        FFF = 1;
        
    end
    
%     f = a1*f1 + a2*(FF/FFF)*f2;
    
    Q2 = (FF/FFF)*Q2;
    
    [x,F] = quadprog(Q2,f,A,b,Aeq,beq,lb,ub);
    
else
    
    x = x1;
    F = FF;
    
end

X = zeros(T,1);

for i = 1:T
    
    X(i) = sum(x(3*(i-1)+1:3*i))-Lnoti(i);
    
end

end