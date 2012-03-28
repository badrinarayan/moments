function Tx = T(x)
% Applies the Toeplitz operator
% for complex entries
n = length(x);
M = floor(n/2);
Tx = toeplitz(x(M:-1:1),x(M:n));
end
