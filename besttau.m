function besttau(experiment)
	% The optimal parameter for each noise level
	prefix = strcat('sweep_',experiment);
	tau_opts = zeros(480,1);
	tau_s    = zeros(480,1);
	for fileNo = 1:480
		filename = strcat('outputs/',prefix,'/',prefix,int2str(fileNo),'.mat');
		load(filename)
		tau_s(fileNo) = tau;
		tau_opts(fileNo) = tau_opt;
	end
	nl = [2;4;8;16];
	T  = reshape(reshape(tau_opts./tau_s,40,12).',120,4);
	r  = mean(T);
	e  = std(T);
	h2 = errorbar(2.^(1:4),r,e,'color','k');
	axis square
	hx = xlabel('Signal Amplitude');
	hy = ylabel('\tau');
	legend(gca,'boxoff');
	set(hx,'FontSize',24,'FontName','Times')
	set(hy,'FontSize',24,'FontName','Times')
	set(gca,'FontSize',20,'FontName','Times')
	set(gca,'XTick',[2,4,8,16])
	saveas(gcf,strcat('figures/rp',experiment,'.pdf'),'pdf');
end
