% Plot the performance profile
clear;
ast_mses = [];
cadzow_mses = [];
for fileNo = 1:360
	fileName = strcat('output',int2str(fileNo),'.mat');
	load(fileName);
	ast_mses = [ast_mses; ast_mse];
	cadzow_mses = [cadzow_mses; cadzow_mse];
end
r_min = min([ast_mses; cadzow_mses]);
r_ast = ast_mses/r_min;
r_cadzow = cadzow_mses/r_min;
t_max = ceil(max([r_ast;r_cadzow]));
t = linspace(1,t_max);
semilogx(t,arrayfun(@(x)sum(r_ast<x)/360,t),t,arrayfun(@(x)sum(r_cadzow<x)/360,t));
legend('DAST','Cadzow','Location','SouthEast');
xlabel('\tau')
ylabel('P')
title('Performance Profile')
saveas(gcf,'pp.eps','eps2c');
