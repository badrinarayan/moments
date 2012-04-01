function pole_localize(n,k,sigma)
% n = 400;
% k = 5;
% sigma = 0.8;
close all;
[signal,c,w] = moment_vector(n,k);
received = signal + sigma/sqrt(2)*(randn(size(signal))+1i*randn(size(signal)));
tau = (1+1/log(n))*sqrt(n*log(n)+n*log(4*pi*log(n)))*sigma;
[ignore,ignore,w1,c1] = admm_ben_general(received,tau/sqrt(n));
cadzow = cadzow_denoise(received,k);
[w0,c0] = poles_amps(signal,k);
[w2,c2] = poles_amps(cadzow,k);
hold on;
stem(w0/2/pi,c0,'b-*');
stem(w1/2/pi,c1,'k-.^');
stem(w2/2/pi,c2,'r--+');
hold off;
legend('Original','AST','Cadzow');
end