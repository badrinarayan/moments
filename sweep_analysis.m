zs   = [logspace(-0.5,0.5,8) 1];
ns   = [100,200,400,800];
ks   = [5,10,15];
nls  = [2,4,8,16];
L    = Linearize(ns,ks,nls);
for algorithm={'ast','dast'}
	for experiment={'random','equispaced'}
		% Read in z_opt's
		fprintf('%s\n',algorithm{1});
		fprintf('%s\n',experiment{1});
		z_opt = containers.Map();
		ratio = containers.Map();
		for fileNo = 1:480
			filename = sprintf('outputs/sweep_%s/%s%d.mat',experiment{1},algorithm{1},fileNo);
			if ~exist(filename)
				fprintf('%s does not exist\n');
				continue
			end
			data = load(filename);
			[n,k,nl] = L.values(fileNo);
			key = sprintf('%d_%d_%d',n,k,nl);
			if isKey(z_opt,key)
				z_opt(key) = [z_opt(key);data.z_opt];
				ratio(key) = [ratio(key);data.min_mse/data.base_mse];
			else
				z_opt(key) = [data.z_opt];
				ratio(key) = [data.min_mse/data.base_mse];
			end
		end 
		% Display the means in a table
		for n=ns,for k=ks,for nl=nls
			key = sprintf('%d_%d_%d',n,k,nl);
			%fprintf('n = %d, k = %d, nl = %d, z_opt = %f\n',n,k,nl,mean(z_opt(key)));
			fprintf('n = %d, k = %d, nl = %d, ratio = %f\n',n,k,nl,mean(ratio(key)));
		end; end; end
	end
end

