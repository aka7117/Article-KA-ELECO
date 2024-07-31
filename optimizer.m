function [F,X] = optimizer(Lnoti,Bat,ISOC,DSOC,k,T,sigma,Tin,Tout,Xub,xlb,a1,a2,delta)
SOCmin = 0.1;
SOCmax = 1;
Prc = [1.1 1.15 1.2].*[6.5 9.4 13.2];
% Prd = [1,1,1].*[6.5 6.5 6.5];
% pr = [Prc Prd]';
Pr = repmat(Prc,1,T);
[lb,ub,A,b,Aeq,beq] = ConsFind(Tin,Tout,T,ISOC,DSOC,Bat,sigma,Lnoti,Xub,xlb,SOCmin,SOCmax);

if a1 > 0 && a2 > 0
    
    Q = zeros(3*T,3*T);
    
    for i = 1:T
        
        Q(3*(i-1)+1:3*i,3*(i-1)+1:3*i) = ones(3,3);
        
    end
    
    Q = 2*k*delta*Q;
    
    f1 = Pr';
    f = a1*f1;
    
    [x1,FF] = linprog(f1,A,b,Aeq,beq,lb,ub);
    
    % CVX Optimizer
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
    
    f2 = zeros(3*T,1);
    
    if k ~= 0
        
        [~,FFF] = quadprog(Q2,f2,A,b,Aeq,beq,lb,ub);
        
        if FFF == 0
            
            FFF = 1;
            
        end
        
        
        Q2 = (FF/FFF)*Q2;
        
        [x,F] = quadprog(Q2,f,A,b,Aeq,beq,lb,ub);
        
    else
        
        x = x1;
        F = FF;
        
    end
    
elseif a1 == 0
    
    Q = zeros(3*T,3*T);
    
    for i = 1:T
        
        Q(3*(i-1)+1:3*i,3*(i-1)+1:3*i) = ones(3,3);
        
    end
    
    Q = 2*k*delta*Q;
    
    Q2 = a2*Q;
    
    f2 = zeros(3*T,1);
    [x,F] = quadprog(Q2,f2,A,b,Aeq,beq,lb,ub);
    
elseif a2 == 0
    
    f1 = Pr';
    f = a1*f1;
    
    [x,F] = linprog(f,A,b,Aeq,beq,lb,ub);
    
end


X = zeros(T,1);

for i = 1:T
    
    X(i) = sum(x(3*(i-1)+1:3*i))-Lnoti(i);
    
end

end