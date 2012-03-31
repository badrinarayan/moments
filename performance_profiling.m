function performance_profiling(experiment)
% Plot the performance profile
	ast_mses = [];
	ast_mses15 = [];
	ast_mses16 = [];
	ast_mses17 = [];
	sast_mses = [];
	cadzow_mses = [];
	for fileNo = 1:480
		fileName = strcat('outputs/',experiment,'/output',int2str(fileNo),'.mat');
		load(fileName);
		fileName = strcat('outputs/',experiment,'/sweep_dast',int2str(fileNo),'.mat');
		load(fileName);
		ast_mses = [ast_mses; ast_mse];
		ast_mses15 = [ast_mses15; ast_mse15];
		ast_mses16 = [ast_mses16; ast_mse16];
		ast_mses17 = [ast_mses17; ast_mse17];
		sast_mses = [sast_mses; sast_mse];
		cadzow_mses = [cadzow_mses; cadzow_mse];
	end
	r_min = min([ast_mses'; cadzow_mses'; sast_mses']);
	r_ast = ast_mses./r_min';
	r_ast15 = ast_mses15./r_min';
	r_ast16 = ast_mses16./r_min';
	r_ast17 = ast_mses17./r_min';
	r_sast = sast_mses./r_min';
	r_cadzow = cadzow_mses./r_min';
	t_max = ceil(max([r_ast;r_cadzow;r_sast]));
	t_max = 4;
	t = linspace(1,t_max);
	plot(...
				t,arrayfun(@(x)sum(r_sast<x)/480,t),...
				t,arrayfun(@(x)sum(r_ast15<x)/480,t),...
				t,arrayfun(@(x)sum(r_ast16<x)/480,t),...
				t,arrayfun(@(x)sum(r_ast17<x)/480,t),...
				t,arrayfun(@(x)sum(r_cadzow<x)/480,t)...
	);
	%t,arrayfun(@(x)sum(r_ast<x)/480,t),...
	axis([1 t_max 0 1])
	[h,childObjs] = legend('        AST','        DAST 2^{15}','        DAST 2^{16}','        DAST 2^{17}','        Cadzow');
	hx = xlabel('\beta');
	hy = ylabel('P(\beta)');
	legend(gca,'boxoff');
	set(h,'FontSize',16,'FontName','Times')
	set(hx,'FontSize',20,'FontName','Times')
	set(hy,'FontSize',20,'FontName','Times')
	set(gca,'FontSize',16,'FontName','Times')
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
