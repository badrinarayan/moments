function [mmse_ast, mmse_cadzow,mse_var_ast,mse_var_cadzow,mean_k_est] = analyze(n,k,nl)
	fileNo = 120*(log(n/100)/log(2)) + 8*(k-5) + 10*(log(nl)/log(2)-1);
	ast_mses    = [];
	cadzow_mses = [];
	k_ests      = [];
	%fprintf('fileNos = %d to %d\n',(fileNo+1),(fileNo+10));
	for idx=fileNo+1:fileNo+10
		load(strcat('output',int2str(idx),'.mat'))
		ast_mses = [ast_mses;ast_mse];
		if n > 500
			cadzow_mse = Inf;
		end
		cadzow_mses = [cadzow_mses;cadzow_mse];
		k_ests = [k_ests;k_est];
		load(strcat('../../inputs/equispaced/input',int2str(idx),'.mat'))
		%fprintf('n = %3d, k = %2d, nl = %d\n',n,k,n*c/tau);
		%fprintf('ast_mse = %.4f\n',ast_mse);
	end
	mmse_ast = mean(ast_mses);
	mmse_cadzow = mean(cadzow_mses);
	mse_var_ast = var(ast_mses);
	mse_var_cadzow = var(cadzow_mses);
	mean_k_est = mean(k_ests);
	fprintf('mse(ast) = %.4f, mse(cadzow)= %.4f, mean k_est = %.2f\n',mmse_ast, mmse_cadzow,mean_k_est);
end
