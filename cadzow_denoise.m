function x = cadzow_denoise(x, r, printlevel)
X = toeplitz(x);
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
    [ignore,D,V] = svd(X);
    ratio = D(r+1,r+1)/D(r,r);
    V((r+1):end,(r+1):end)=0;
    X = toeplitz_approx(V*D*V');
    X = (X+X')/2;
end
if printlevel==1
    fprintf('\n');
end
x = X(1,:);
end
