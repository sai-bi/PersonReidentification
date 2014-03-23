function selected_patch_feature = get_selected_patch_feature(parameters,viper_features_hsvyuv,viper_features_lab)
    load('./data/matching_result.mat');
    viper_hsvyuv_a = viper_features_hsvyuv(:,1:parameters.total_img_num/2);	
    viper_hsvyuv_b = viper_features_hsvyuv(:,parameters.total_img_num/2+1:end);
    viper_lab_a = viper_features_lab(:,1:parameters.total_img_num/2);
    viper_lab_b = viper_features_lab(:,parameters.total_img_num/2+1:end);
    
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
    
    selected_feature_hsvyuv_a = viper_hsvyuv_a(:,index1,:);
    selected_feature_lab_a = viper_lab_a(:,index2,:);
	selected_feature_hsvyuv_a = reshape(selected_feature_hsvyuv_a,[],parameters.total_img_num/2);
	selected_feature_lab_a = reshape(selected_feature_lab_a,[],parameters.total_img_num/2);
    
    selected_feature_hsvyuv_b = [];
    selected_feature_lab_b = [];
    for i = 1:parameters.total_img_num/2
        similarity = matching_result{i}{i};
        index3 = similarity(index1);
        index4 = similarity(index2);
        temp1 = viper_hsvyuv_b(:,index3,i);
        temp1 = temp1(:);
        selected_feature_hsvyuv_b = [selected_feature_hsvyuv_b temp1];
        temp1 = viper_lab_b(:,index4,i);
        temp1 = temp1(:);
        selected_feature_lab_a = [selected_feature_lab_b temp1];    
    end

    selected_patch_feature = [[selected_feature_hsvyuv_a;selected_feature_lab_a] [selected_feature_hsvyuv_b;selected_feature_lab_b]];
end

