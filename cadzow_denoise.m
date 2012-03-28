function x = cadzow_denoise(x, r, printlevel)
n = length(x);
X = toeplitz(x(n/2:-1:1),x(n/2:n-1));
tol = 1e-6;
ratio = tol;
if printlevel==1
    fprintf('Cadzow Scheme:\n');
end
k = 0;
while (ratio >= tol) && (k < 20)
    k = k + 1;
    if printlevel==1
        fprintf('.');
        if(~mod(k,10))
            fprintf(' %d\n',k);
        end
    end
    [U,D,V] = svd(X);
    ratio = D(r+1,r+1)/D(r,r);
    V((r+1):end,(r+1):end)=0;
    X = toeplitz_approx(U*D*V');
    %X = (X+X')/2;
end
if printlevel==1
    fprintf('\n');
end

%x = [X(end:-1:1,1); X(1,2:end).'; x(end)];
% Debias using Prony + reconstruct x
[w,c] = poles_amps([X(end:-1:1,1); X(1,2:end).'; x(end)],r);
x = sum( diag(c)*exp(1i * w * (0:n-1)),1).';
end
