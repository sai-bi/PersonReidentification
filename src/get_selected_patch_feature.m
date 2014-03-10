function selected_patch_feature = get_selected_patch_feature(parameters,viper_features)
	perm = randperm(parameters.total_patch_num-13);
	selected_patch_index = perm(1:parameters.selected_patch_num);
	selected_patch_feature = [];	
	for i = 1:parameters.total_img_num
		currfeature = viper_features{i};
		selected_feature = [];
		for j = 1:parameters.selected_patch_num
			index = selected_patch_index(j);
			selected_feature = [selected_feature;currfeature{index+1}];
			selected_feature = [selected_feature;currfeature{index+2}];
			selected_feature = [selected_feature;currfeature{index+11}];
			selected_feature = [selected_feature;currfeature{index+12}];
			selected_feature = [selected_feature;currfeature{index+13}];
		end	
		selected_patch_feature = [selected_patch_feature selected_feature];	
	end
end

