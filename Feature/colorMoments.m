%this function is used to calculate the three color moments 
function moment = colorMoments(value)
	%first moment, that is 'Mean', the average color value in the image
	moment1 = sum(value)/size(value,1);

	%second moment, that is 'standard deviation'
	moment2 = std(value,1);

	%third moment, that is 'skewness'
	moment3 = skew(value);

	moment = [moment1;moment2;moment3];
end



