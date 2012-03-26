% Create input files for condor
idx = 1;
sigma    = 1;
for n = [100,200,400,800]
	for k =[5,10,15]
		for nl = [2,4,8,16]
			w  = 2*pi*rand(k,1); % Uniformly spaced frequencies
			tau = (1-1/log(n))*sqrt(n*log(n)+n*log(log(n))+n*log(2*pi))*sigma;
			c  = nl*tau/n; % nl - noise level
			c = c.*exp(1i*rand(size(c)));
			signal   = sum( diag(c)*exp(1i * w * (0:n-1)),1).';
			for i = 1:10 % iteration
				noise    = sigma*(randn(n,1) + 1i*randn(n,1) )/sqrt(2);
				received = signal+noise;
				filename = strcat('input',int2str(idx),'.mat');
				save(filename,'signal','received','w','k','n','tau','c','sigma','nl');
				idx = idx + 1;
			end
		end
	end
end

