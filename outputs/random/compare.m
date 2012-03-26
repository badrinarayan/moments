function compare(fileNo)
infile = strcat('input',int2str(fileNo),'.mat');
load(infile);
outfile = strcat('output',int2str(fileNo),'.mat');

e  = @(x) norm(signal(:)-x(:))/norm(signal);
s  = @(x) svd(toeplitz(x));

fprintf('Received MSE=%.4f\n',e(received)^2);

% Gridding Algorithm:
tic;
[grid,grid_c,grid_debiased,grid_c_debiased] = moment_sparsa(received,tau,2^14);
ast_time = toc;
ast_mse    = e(grid_debiased)^2;

disp(['Atomic Softthreshold Time : ' num2str(ast_time)]);
fprintf('Gridding MSE=%.4f\n',ast_mse);

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
if n < 500
	[w2,c2] = poles_amps(cadzow,k);
end

if n < 500
	save(outfile,'w0','c0','w1','c1','w2','c2','cadzow','grid_debiased','cadzow_time','ast_time','k_est','cadzow_mse','ast_mse')
else
	save(outfile,'w0','c0','w1','c1','grid_debiased','ast_time','k_est','ast_mse')
end
