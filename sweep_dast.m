function sweep_dast(fileNo,wd,experiment)

infile = strcat(wd,'/inputs/',experiment,'/input',int2str(fileNo),'.mat');
load(infile);

outfile = strcat(wd,'/outputs/',experiment,'/sweep_dast',int2str(fileNo),'.mat');

e  = @(x) norm(signal(:)-x(:))/norm(signal);
s  = @(x) svd(toeplitz(x));

fprintf('Received MSE=%.4f\n',e(received)^2);

% Gridding Algorithm:
tic;
[grid,grid_c,grid_debiased12,grid_c_debiased] = moment_sparsa(received,tau,2^12);
ast_time12 = toc;
ast_mse12  = e(grid_debiased12)^2;

disp(['(2^12) Atomic Softthreshold Time : ' num2str(ast_time12)]);
fprintf('Gridding MSE=%.4f\n',ast_mse12);

tic;
[grid,grid_c,grid_debiased13,grid_c_debiased] = moment_sparsa(received,tau,2^13);
ast_time13 = toc;
ast_mse13  = e(grid_debiased13)^2;

disp(['(2^13) Atomic Softthreshold Time : ' num2str(ast_time13)]);
fprintf('Gridding MSE=%.4f\n',ast_mse13);

tic;
[grid,grid_c,grid_debiased14,grid_c_debiased] = moment_sparsa(received,tau,2^14);
ast_time14 = toc;
ast_mse14  = e(grid_debiased14)^2;

disp(['(2^14) Atomic Softthreshold Time : ' num2str(ast_time14)]);
fprintf('Gridding MSE=%.4f\n',ast_mse14);

% Save to file
if exist(outfile)
	save(outfile,'ast_mse12','ast_mse13','ast_mse14',...
	'ast_time12','ast_time13','ast_time14','-append')
end

end
