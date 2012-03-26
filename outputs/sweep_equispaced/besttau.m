% The optimal parameter for each noise level
prefix = 'sweep_equispaced';
tau_opts = zeros(480,1);
tau_s    = zeros(480,1);
for fileNo = 1:480
	filename = strcat(prefix,int2str(fileNo),'.mat');
	load(filename)
	tau_s(fileNo) = tau;
	tau_opts(fileNo) = tau_opt;
end
nl = [2;4;8;16];
T  = reshape(reshape(tau_opts./tau_s,40,12).',120,4);
r  = mean(T);
e  = std(T);
%h1 = bar(1:4,r,'r'); hold on;
%set(h1,'BarWidth',0.5);
h2 = errorbar(1:4,r,e,'color','k'); %hold off;
xlabel('Signal Amplitude'); ylabel('\tau');
%set(h2,'linestyle','none');
set(gca,'XTickLabel','2|4|8|16')
%k = repmat([5*ones(40,1);10*ones(40,1);15*ones(40,1)],4,1);
%n = [100*ones(120,1);200*ones(120,1);400*ones(120,1);800*ones(120,1)];
%nl = repmat([2*ones(10,1);4*ones(10,1);8*ones(10,1);16*ones(10,1)],12,1);
%hist(tau_opts./tau_s);
%plot(1:length(tau_s),tau_opts./tau_s,'k.');
%plot(k,tau_opts./tau_s,'kx'),xlabel('k'),ylabel('Ratio');
title('Ratio of the Best Regularization Parameter to \tau');
%refline(regress(tau_opts,tau_s),0);
saveas(gcf,'rpequiv.eps','eps2c');
