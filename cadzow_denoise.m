function x = cadzow_denoise(x, r)
% Alternately project onto Rank-r Grasmmanian manifold
% and space of Toeplitz matrices.

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
  X = toeplitz_approx(U*D*V');
  % Update convergence parameter
  ratio = D(r+1,r+1)/D(r,r);
end

x = invT(X,n);
end
