function T = toeplitz_approx(A)
% TOEPLITZ_APPROX(A)
% For a square matrix A, find the Toeplitz approximation
% by averaging along the diagonals.
N = length(A);
T = zeros(size(A));
for n = -(N-1):(N-1)
    d = diag(A,n);
    d(:) = mean(d);
    T = T + diag(d,n);
end
end