input_dir = 'inputs/equispaced';
output_dir = 'outputs/equispaced_sqrtc';
for n = [100,200,400,800]
	for k = [5,10,15]
		for nl = [2,4,8,16]
			[ast_mse,cadzow_mse,~,~,ast_mses,k_est] = analyze(n,k,nl);
			if(ast_mse>0.16)
				its = find(ast_mses>0.16)';
				for i = its
					fileNo = 120*(log(n/100)/log(2)) + 8*(k-5) + 10*(log(nl)/log(2)-1) + i;
					fprintf('Correcting File #: %d (n = %d, k = %d, nl = %d)...\n',fileNo,n,k,nl);
					cd('../..')
					copyfile(strcat(input_dir,'/input',int2str(fileNo),'.mat'),'.')
					compare(fileNo)
					delete(strcat('input',int2str(fileNo),'.mat'))
					movefile(strcat('output',int2str(fileNo),'.mat'),output_dir);
					cd(output_dir)
				end
			end
		end
	end
end
