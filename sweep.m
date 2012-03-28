function sweep(fileNo,prefix)
infile = strcat('input',int2str(fileNo),'.mat');
load(infile);
outfile = strcat(prefix,int2str(fileNo),'.mat');

e  = @(x) norm(signal(:)-x(:))/norm(signal);

ast_mses = [];

% Gridding Algorithm:
taus=logspace(log10(tau)-1,log10(tau)+1,20);
for tau0=taus
  fprintf('.');
  [grid,grid_c,grid_debiased,grid_c_debiased] = moment_sparsa(received,tau0,2^14);
  mse = e(grid_debiased)^2;
  ast_mses = [ast_mses; mse];
end
fprintf('\n');
[grid,grid_c,grid_debiased,grid_c_debiased] = moment_sparsa(received,tau,2^14);
ast_mse    = e(grid_debiased)^2;

[min_mse, tau_opt_idx] = min(ast_mses);
tau_opt = taus(tau_opt_idx);

save(outfile,'ast_mses','ast_mse','taus','tau','tau_opt', 'min_mse')
end