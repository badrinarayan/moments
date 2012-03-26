function performance_profiling(experiment)
% Plot the performance profile
	ast_mses = [];
	cadzow_mses = [];
	for fileNo = 1:360
		fileName = strcat('outputs/',experiment,'/output',int2str(fileNo),'.mat');
		load(fileName);
		ast_mses = [ast_mses; ast_mse];
		cadzow_mses = [cadzow_mses; cadzow_mse];
	end
	r_min = min([ast_mses'; cadzow_mses']);
	r_ast = ast_mses./r_min';
	r_cadzow = cadzow_mses./r_min';
	t_max = ceil(max([r_ast;r_cadzow]));
	t_max = 10;
	t = linspace(1,t_max);
	plot(t,arrayfun(@(x)sum(r_ast<x)/360,t),'k-',t,arrayfun(@(x)sum(r_cadzow<x)/360,t),'k--','LineWidth',1.5);
	axis([1 t_max 0 1])
	%[h,childObjs] = legend('DAST','Cadzow','Location','SouthEast');
	[h,childObjs] = legend('      DAST','      Cadzow');
	hx = xlabel('\beta');
	hy = ylabel('P(\beta)');
	legend(gca,'boxoff');
	set(h,'FontSize',18,'FontName','Times')
	set(hx,'FontSize',24,'FontName','Times')
	set(hy,'FontSize',24,'FontName','Times')
	set(gca,'FontSize',18,'FontName','Times')
	lineObjs = findobj(childObjs, 'Type', 'line');
	xCoords = get(lineObjs, 'XData') ;
	for lineIdx = 1:length(xCoords),
		if length(xCoords{lineIdx}) == 1,
			set( lineObjs(lineIdx), 'XData', xCoords{lineIdx} + [0.06]) ;
		elseif length(xCoords{lineIdx}) == 2,
			set( lineObjs(lineIdx), 'XData', xCoords{lineIdx} + [0 0.15]) ;
		end
	end
	% title('Performance Profile')
	saveas(gcf,strcat('figures/',experiment,'_pp.pdf'),'pdf');
end
