L = Linearize([100,200,400,800],[5 10 15],[2 4 8,16]);
nsmps = 10;
for i=1:nsmps
	f = randsample(1,480,1);
	[n,k,sl] = L.values(f);
	fprintf('-----------------------\n');
	fprintf('n = %d, k = %d, sl = %d\n',n,k,sl);
	fprintf('-----------------------\n');
	sweep_dast(f,pwd,'random')
end
