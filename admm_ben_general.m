function [x,x_debias] = admm_ben(y,mu)
T0=clock;
y = y(:);
n = length(y);

%%%% ALGORITHM PARAMETERS:
nesterov_momentum = 1; % set to 1 to use Nesterov schedule for overrelaxation.
verbose = 0; % set to 1 for printing, 0 for no output
momentum = 1.0; % (constant momentum.  Only used if Nesterov is off.)
maxIter = 5000; % maximum number of ADMM steps
rho = 2; % penalty parameter in augmented Lagrangian
tol_abs = 1e-3; %absolute tolerance
tol_rel = 1e-4; % iteration level relative tolerance
debias_tol = 1e-1; % cutoff for the eigenvalues in the debias step
%%%%

ZOld = zeros(n+1);
Lambda = zeros(n+1);
converged = 0;

normalizer = 1./[n; 2*((n-1):-1:1)'];
e1 = zeros(n,1); e1(1)=mu*n/rho;
theta = 1;

if verbose
    fprintf('                                                      time (s)\n')
    fprintf('iter | pri_res   target    | dual_res  target    | iter     total\n')
    for k=1:68, fprintf('-'); end
    fprintf('\n');
end

for count = 1:maxIter  
    T1=clock;
    
    % update the variables x,q, and t by a least-squares solve
    x = ((2*rho)/(2+rho))*(y/rho ...
        + ZOld(1:n,n+1)/2 +ZOld(n+1,1:n)'/2 ...
        - Lambda(1:n,n+1)/2-Lambda(n+1,1:n)'/2);
    q = normalizer.*(toeplitz_adjoint(ZOld(1:n,1:n) - Lambda(1:n,1:n)) - e1);
    t = ZOld(n+1,n+1)-Lambda(n+1,n+1)-mu/rho;
   
    % W is the matrix that should be psd.
    W = [toeplitz(q),x/2;x'/2,t];
    
    % update momentum using nesterov rule
    if nesterov_momentum, 
        momentum = 1+theta*(1/theta -1);
        theta = (sqrt(theta^4+4*theta^2)-theta^2)/2; 
    end
    
    % Z = projection of Q onto the semidefinite cone:
    Q = (momentum*W+Lambda+(1-momentum)*ZOld);
    [V,E] = eig((Q+Q')/2);   
    e = diag(E);
    idx = (e>0);
    Z = V(:,idx)*diag(e(idx))*V(:,idx)';
    Z = (Z+Z')/2;   
    
    % compute residuals to decide if we should stop.  Boyd's criteria.
    pri_res = W-Z;

    dual_res = rho*[(Z(1:n,n+1)-ZOld(1:n,n+1));
        toeplitz_adjoint(Z(1:n,1:n)-ZOld(1:n,1:n));
        Z(n+1,n+1)-ZOld(n+1,n+1)];
    
    dual_var_adj = rho*[(Lambda(1:n,n+1)+Lambda(n+1,1:n)')/2;
        toeplitz_adjoint(Lambda(1:n,1:n));
        Lambda(n+1,n+1)];
    
    pri_tol = (n+1)*tol_abs + tol_rel*max(norm(W,'fro'),norm(Z,'fro'));
    dual_tol = sqrt(2*n+1)*tol_abs + tol_rel*norm(dual_var_adj);
    
    % record errors for plots (this is really unecessary)
    err_rec_primal=norm(pri_res,'fro');
    err_rec_dual=norm(dual_res);
    
    if verbose,
        fprintf('%4g | %.3d %.3d | %.3d %.3d | %.2d %.2d\n',...
            count, err_rec_primal,pri_tol,err_rec_dual,dual_tol,...
        etime(clock,T1),etime(clock,T0));
    end
    
    % check stopping criteria
    converged = and(err_rec_primal<pri_tol,err_rec_dual<dual_tol);
    if converged, break; end
   
    % update the dual multiplier and record the last value of Z for
    % momentum
    Lambda = Lambda + momentum*W+(1-momentum)*ZOld-Z;
    ZOld=Z;    
end

if verbose,
    if count==maxIter, 
        fprintf('no solution found to specifed tolerance after %d iterations\n',maxIter);
        fprintf('current solution has relative feasibility %.4e\n',norm(pri_res,'fro'));
    end

    fprintf('total time %.2f s\n',etime(clock,T0));
end

% DEBIAS
[U,E] = eig(0.5*toeplitz(q)+0.5*toeplitz(q)');
e = diag(E);
idx = (e>debias_tol*max(e)); 
c = U(:,idx)\y;
x_debias = U(:,idx)*c;


function T = toeplitz_adjoint(A)
% TOEPLITZ_APPROX(A)
% For a square matrix A, find the Toeplitz approximation
% by averaging along the diagonals.
N = size(A,1);
T = zeros(N,1);
T(1) = sum(diag(A));
for n = 1:(N-1)
    T(n+1) = 2*sum(diag(A,n));
end