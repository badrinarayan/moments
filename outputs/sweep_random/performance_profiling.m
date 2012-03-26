% Plot the performance profile
clear;
prefix = 'sweep_random';
ast_mse_s = [];
min_mse_s = [];
for fileNo = 1:480
	fileName = strcat(prefix,int2str(fileNo),'.mat');
	load(fileName);
	ast_mse_s = [ast_mse_s; ast_mse];
	min_mse_s = [min_mse_s; min_mse];
end
r_min = min([ast_mse_s; min_mse_s]);
r_ast   = ast_mse_s/r_min;
r_sweep = min_mse_s/r_min;
t_max = ceil(max([r_ast;r_sweep]));
t_max = 10000;
t = linspace(1,t_max);
semilogx(t,arrayfun(@(x)sum(r_ast<x)/480,t),t,arrayfun(@(x)sum(r_sweep<x)/480,t));
legend('DAST Auto','AST Sweep','Location','SouthEast');
xlabel('\tau')
ylabel('P')
title('Performance Profile')
saveas(gcf,'sweep_random_pp.eps','eps2c');
