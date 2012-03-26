for n = [100,200,400,800]
	for k = [5,10,15]
		if k==5
			fprintf('\\multirow{3}{*}{n=%d}',n);
		end
		fprintf('& k = %d',k);
		for nl = [2,4,8,16]
			[ast_mse,cadzow_mse,~,~,~,k_est] = analyze(n,k,nl);
			fprintf(' & %.4f &  %.4f  & %3.1f',ast_mse,cadzow_mse,k_est);
		end
		fprintf('\\\\\n');
	end
end


			
