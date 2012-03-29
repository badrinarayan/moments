function sweep(fileNo,wd,experiment,algorithm)
  infile = strcat(wd,'/inputs/',experiment,'/input',int2str(fileNo),'.mat');
  data = load(infile);
  outfile = strcat(wd, '/outputs/sweep_',experiment,'/',algorithm,int2str(fileNo),'.mat');

  zs = [logspace(-0.5,0.5,8) 1];
  e  = @(x) norm(data.signal(:)-x(:))/norm(data.signal);
  
  mses = zeros(size(zs));
  function m = mse(z)
    if(strcmp(algorithm,'dast'))
      [ignore,ignore,denoised] = moment_sparsa(data.received,z*data.tau,2^15);
    elseif(strcmp(algorithm,'ast'))
      [ignore,denoised] = admm_ben_general(data.received,z*data.tau/sqrt(data.n));
    else
      error('Unknown algorithm');
    end
    m = e(denoised)^2;
  end
  
  fprintf('Received: %f\n',e(data.received)^2);
  for i=1:length(zs)
    mses(i) = mse(zs(i));
    fprintf('%d: %f\n',i,mses(i));
  end

  [min_mse, idx] = min(mses);
  z_opt = zs(idx);
  tau_opt = z_opt*data.tau;
  base_mse = mses(end);
  fprintf('Base: %f\n',base_mse);
  fprintf('Min: %f\n',min_mse);
  tau = data.tau;

  save(outfile,'mses','min_mse','z_opt','tau','tau_opt','base_mse');
end