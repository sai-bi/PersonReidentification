function result = mypca(feature,outdim)
	[eigen_vector,~] = PCA1(feature', outdim);
	eigen_vector = eigen_vector(:,1:outdim);
	result = eigen_vector' * feature;	
end
