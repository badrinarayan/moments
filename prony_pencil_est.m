function z = prony_pencil_est(x,N)
X0 = hankel(x(1:N),x(N:2*N-1));
X1 = hankel(x(2:N+1),x(N+1:2*N));
[V,D] = eig(X1,X0);
z = diag(D).';
