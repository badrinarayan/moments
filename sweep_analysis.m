zs   = [logspace(-0.5,0.5,8) 1];
ns   = [100,200,400,800];
ks   = [5,10,15];
nls  = [2 4 8 16];
L    = Linearize(ns,ks,nls);
zOpt = containers.Map()
for fileNo = 1:480
  data = load(sprintf('inputs/random/input%d.txt',fileNo));
  [n,k,nl] = L.values(fileNo);
  z_opt{[n,k,l]} = data.z_opt;
end 
