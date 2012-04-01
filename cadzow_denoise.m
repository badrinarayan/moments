function x = cadzow_denoise(y, r, varargin)
% Alternately project onto Rank-r Grasmmanian manifold
% and space of Toeplitz matrices.
x = y;
if nargin==2
  debias=0;
else
  debias = varargin{1};
end
max_iterations = 20;
tol = 1e-6;
ratio = tol;

n = length(x);
X = T(x);

for iter=1:max_iterations
  if (ratio<tol), break; end
  % Alternate Projection using SVD, toeplitz_approx
  [U,D,V] = svd(X);
  V((r+1):end,(r+1):end)=0;
	d = diag(D);
  X = toeplitz_approx(U(:,1:r)*diag(d(1:r))*V(:,1:r)');
  % Update convergence parameter
  ratio = D(r+1,r+1)/D(r,r);
end

x = invT(X,n);
if debias==1
  [w,ignore] = poles_amps(x,r);
  U = exp( 1i*(0:(n-1))'*w');
  x = U*(U\y);
end
end
