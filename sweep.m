function sweep(fileNo,wd,experiment,algorithm)
  infile = strcat(wd,'/inputs/',experiment,'/input',int2str(fileNo),'.mat');
  load(infile);
  outfile = strcat(wd, '/sweep_',experiment,'/',algorithm,int2str(fileNo),'.mat');

  zs = [logspace(-0.5,0.5,8) 1];
  e  = @(x) norm(signal(:)-x(:))/norm(signal);
  
  mses = zeros(size(zs));
  function m = mse(z)
    if(strcmp('algorithm','dast'))
      [ignore,denoised] = moment_sparsa(received,z*tau,2^17);
    elseif(strcmp('algorithm','ast'))
      [ignore,denoised] = admm_ben_general(received,z*tau/sqrt(n));
    else
      error('Unknown algorithm');
    end
    m = e(denoised)^2;
  end
  
  for i=1:length(zs)
    fprintf('%d\n',i);
    mses(i) = mse(zs(i));
  end

  [min_mse, idx] = min(mses);
  z_opt = zs(idx);
  tau_opt = z_opt*tau;
  base_mse = mses(end);

  save(outfile,'mses','min_mse','z_opt','tau','tau_opt','base_mse');
end