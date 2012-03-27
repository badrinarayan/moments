function compare(fileNo)
infile = strcat('input',int2str(fileNo),'.mat');
load(infile);
outfile = strcat('output',int2str(fileNo),'.mat');

e  = @(x) norm(signal(:)-x(:))/norm(signal);
s  = @(x) svd(toeplitz(x));

fprintf('Received MSE=%.4f\n',e(received)^2);

% Gridding Algorithm:
tic;
[grid,grid_c,grid_debiased,grid_c_debiased] = moment_sparsa(received,sqrt(n*c*tau),2^15);
ast_time = toc;
ast_mse    = e(grid_debiased)^2;

disp(['Atomic Softthreshold Time : ' num2str(ast_time)]);
fprintf('Gridding MSE=%.4f\n',ast_mse);
fprintf('Norm of Signal = %.4f\n',norm(signal));
fprintf('Norm of Denoised = %.4f\n',norm(grid_debiased));

tic;
[sdp_output,sdp_debiased] = admm_ben_general(received,sqrt(c*tau));
sast_time = toc;
sast_mse    = e(sdp_debiased)^2;

disp(['Atomic Softthreshold (SDP) Time : ' num2str(sast_time)]);
fprintf('SDP MSE=%.4f\n',sast_mse);
fprintf('Norm of Signal = %.4f\n',norm(signal));
fprintf('Norm of Denoised (SDP) = %.4f\n',norm(sdp_debiased));

% Model Order Determination
Tr    = toeplitz(received);
k_est = sum(eig((Tr+Tr')/2)>tau);
if k_est == 0, k_est = 1; end

disp(['Correct   Number of Frequencies: ' num2str(k)])
disp(['Estimated Number of Frequencies: ' num2str(k_est)])


% Cadzow:

if n < 500
	tic;
	cadzow=cadzow_denoise(received,k,0);
	cadzow_time = toc;
	cadzow_mse = e(cadzow)^2;

	disp(['Cadzow Denoising Time     : ' num2str(cadzow_time)]);
	fprintf('Cadzow   MSE=%.4f\n',cadzow_mse);
end
% Matrix Pencil
[w0,c0] = poles_amps(signal,k);
[w1,c1] = poles_amps(grid_debiased,k);
[w3,c3] = poles_amps(sdp_debiased,k);
if n < 500
	[w2,c2] = poles_amps(cadzow,k);
end

if n < 500
	save(outfile,'w0','c0','w1','c1','w2','c2','w3','c3','cadzow','grid_debiased','sdp_debiased','cadzow_time','ast_time','sast_time','k_est','cadzow_mse','ast_mse','sast_mse')
else
	save(outfile,'w0','c0','w1','c1','w3','c3','grid_debiased','sdp_debiased','ast_time','sast_time','k_est','ast_mse','sast_mse')
end
