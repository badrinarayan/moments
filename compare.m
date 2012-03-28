function compare(fileNo,wd,experiment,sqrtc,ben)
infile = strcat(wd,'/inputs/',experiment,'/input',int2str(fileNo),'.mat');
load(infile);
if sqrtc==1
	factor = sqrt(c*n);
	odir = strcat(experiment,'_sqrtc');
	factor_DAST = factor;
	factor_SAST = factor;
	if ben==1
		factor_DAST = 3.5*factor;
		factor_SAST = 0.75*factor;
		odir = strcat(experiment,'_ben');
	end
else
	factor = sqrt(tau);
	odir = experiment;
	factor_DAST = factor;
	factor_SAST = factor;
end
outfile = strcat(wd,'/outputs/',odir,'/output',int2str(fileNo),'.mat');

e  = @(x) norm(signal(:)-x(:))/norm(signal);
s  = @(x) svd(toeplitz(x));

fprintf('Received MSE=%.4f\n',e(received)^2);

% Gridding Algorithm:
tic;
[grid,grid_c,grid_debiased,grid_c_debiased] = moment_sparsa(received,factor_DAST*sqrt(tau),2^nextpow2(length(received)^1.6));
ast_time = toc;
ast_mse  = e(grid_debiased)^2;

disp(['Atomic Softthreshold Time : ' num2str(ast_time)]);
fprintf('Gridding MSE=%.4f\n',ast_mse);

tic;
[sdp_output,sdp_debiased] = admm_ben_general(received,factor_SAST*sqrt(tau/n));
sast_time = toc;
sast_mse    = e(sdp_debiased)^2;

disp(['Atomic Softthreshold (SDP) Time : ' num2str(sast_time)]);
fprintf('SDP MSE=%.4f\n',sast_mse);

% Model Order Determination
Tr    = toeplitz(received);
k_est = sum(eig((Tr+Tr')/2)>tau);
if k_est == 0, k_est = 1; end

disp(['Correct   Number of Frequencies: ' num2str(k)])
disp(['Estimated Number of Frequencies: ' num2str(k_est)])

% Cadzow:
tic;
cadzow=cadzow_denoise(received,k,0);
cadzow_time = toc;
cadzow_mse = e(cadzow)^2;

disp(['Cadzow Denoising Time     : ' num2str(cadzow_time)]);
fprintf('Cadzow   MSE=%.4f\n',cadzow_mse);

% Matrix Pencil
[w0,c0] = poles_amps(signal,k);
[w1,c1] = poles_amps(grid_debiased,k);
[w2,c2] = poles_amps(cadzow,k);
[w3,c3] = poles_amps(sdp_debiased,k);

save(outfile,'w0','c0','w1','c1','w2','c2','w3','c3','cadzow','grid_debiased','sdp_debiased','cadzow_time','ast_time','sast_time','k_est','cadzow_mse','ast_mse','sast_mse')
end
