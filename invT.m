function x = invT(Tx,n)
% Inverts the Toeplitz operator for complex entries
% x = invT(Tx,n)
% Find x so that Tx = T(x)
% 
% The optional parameter n is the length of x.
% If n is even, recall that Tx = T(x(1:end-1)).
% In this case, invT(T(x)) would be x(1:end-1).
%
% But if rank(Tx)<n/2, invT uses Matrix Pencil
% Prony's technique to determine x.
% In this case invT(T(x,n)) would be x.
if nargin==1,n=size(Tx,1)*2-1;end
x = [Tx(end:-1:1,1); Tx(1,2:end).'];
if mod(n,2)==0
  [w,c] = poles_amps([Tx(end:-1:1,1); Tx(1,2:end).'],n/2-1);
  x = sum(diag(c)*exp(1i * w * (0:n-1)),1).';
end
end