function sweep_dast(fileNo,wd,experiment)

infile = strcat(wd,'/inputs/',experiment,'/input',int2str(fileNo),'.mat');
load(infile);

outfile = strcat(wd,'/outputs/',experiment,'/sweep_dast',int2str(fileNo),'.mat');

e  = @(x) norm(signal(:)-x(:))/norm(signal);
s  = @(x) svd(toeplitz(x));

fprintf('Received MSE=%.4f\n',e(received)^2);

% Gridding Algorithm:
tic;
[grid,grid_c,grid_debiased15,grid_c_debiased] = moment_sparsa(received,tau,2^15);
ast_time15 = toc;
ast_mse15  = e(grid_debiased15)^2;

disp(['(2^15) Atomic Softthreshold Time : ' num2str(ast_time15)]);
fprintf('Gridding MSE=%.4f\n',ast_mse15);

tic;
[grid,grid_c,grid_debiased16,grid_c_debiased] = moment_sparsa(received,tau,2^16);
ast_time16 = toc;
ast_mse16  = e(grid_debiased16)^2;

disp(['(2^16) Atomic Softthreshold Time : ' num2str(ast_time16)]);
fprintf('Gridding MSE=%.4f\n',ast_mse16);

tic;
[grid,grid_c,grid_debiased17,grid_c_debiased] = moment_sparsa(received,tau,2^17);
ast_time17 = toc;
ast_mse17  = e(grid_debiased17)^2;

disp(['(2^17) Atomic Softthreshold Time : ' num2str(ast_time17)]);
fprintf('Gridding MSE=%.4f\n',ast_mse17);

% Save to file
save(outfile,'ast_mse15','ast_mse16','ast_mse17',...
'ast_time15','ast_time16','ast_time17')

end
