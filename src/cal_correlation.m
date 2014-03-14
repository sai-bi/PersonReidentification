function corr = cal_correlation(got_feature,currfeature,num)
	corr_vec = zeros(num,1);
	for i = 1:num
		temp1 = got_feature{i};
		temp2 = zeros(size(temp1,2),1);
		for j = 1:size(temp1,2)
			result = corrcoef(temp1(:,j), currfeature(:,j));
			temp2(j) = abs(result(1,2));
		end
		corr_vec(i) = mean(temp2);
	end	
	corr = max(corr_vec);
end
