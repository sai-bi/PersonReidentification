function selected_patch_feature = get_selected_patch_feature(parameters,viper_features_hsvyuv,viper_features_lab)
	perm = randperm(parameters.part_patch_num-13);
	selected_patch_index = perm(1:parameters.selected_patch_num);
	perm1 = randi(2,1,parameters.selected_patch_num);
	index1 = find(perm1 == 1);
	index2 = find(perm1 == 2);
	index1 = selected_patch_index(index1);
	index2 = selected_patch_index(index2);
	index1 = [index1 index1+1 index1+2 index1+11 index1+12 index1+13];
	index2 = [index2 index2+1 index2+2 index2+11 index2+12 index2+13];
	index1 = index1(:);
	index2 = index2(:);
	selected_feature_hsvyuv = viper_features_hsvyuv(:,index1,:);
	selected_feature_lab = viper_features_lab(:,index2,:);
	selected_feature_hsvyuv = reshape(selected_feature_hsvyuv,[],parameters.total_img_num);
	selected_feature_lab = reshape(selected_feature_lab,[],parameters.total_img_num);

	selected_patch_feature = [selected_feature_hsvyuv;selected_feature_lab];
end

