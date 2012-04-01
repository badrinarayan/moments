function run_admm(fileNo,experiment)

infile = strcat('inputs/',experiment,'/input',int2str(fileNo),'.mat');
load(infile);

e  = @(x) norm(signal(:)-x(:))/norm(signal);

fprintf('Received MSE=%.4f\n',e(received)^2);

tic;
[sdp_output,sdp_debiased] = admm_ben_general(received,tau/sqrt(n));
sast_time = toc;
sast_mse    = e(sdp_debiased)^2;

disp(['Atomic Softthreshold (SDP) Time : ' num2str(sast_time)]);
fprintf('SDP MSE=%.4f\n',sast_mse);

end
