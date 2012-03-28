function Tx = T(x)
% Applies the Toeplitz operator
% for complex entries
% 
% For a 2*d+1 long vector, there is a 
% corresponding d x d Toeplitz matrix
%
% This strategy eats last entry for even n
n = length(x);
if mod(n,2)==0
  Tx = T(x(1:end-1));
else
  Tx = toeplitz(x((n+1)/2:-1:1),x((n+1)/2:n));
end
end
