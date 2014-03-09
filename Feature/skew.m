% calculate the skewness of a vectors
function skewness = skew(x)
	meanValue = sum(x)/size(x,1);

	temp = 0;
	for i = 1:size(x,1)
		temp = temp + (x(i) - meanValue)^3;
	end

	temp = temp/size(x,1);
	temp = nthroot(temp,3);
	skewness = temp;
end

	
