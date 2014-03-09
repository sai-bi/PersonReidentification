%%% Select subset of features for training and testing
load('../Feature/data/viper_features.mat');
total_patch_num = 704;
total_img_num = 1264;
selected_patch_num = 60;
sample_num = 30;
permutation = randperm(total_img_num/2);
train_index = permutation(1:length(permutation)/2);
test_index = permutation((length(permutation/2)+1) : end);
pca_out_dim = 600;

got_feature = cell(1,sample_num);
got_feature{1} = get_selected_patch_feature();
got_feature{1} = mypca(got_feature{1}, outdim);


for i = 2:sample_num
	pre_selected_num = 10;
	pre_selected_feature = cell(pre_selected_num,1);
	correlation = zeros(pre_selected_num,1);
	for j = 1:pre_selected_num
		pre_selected_feature{j} = get_selected_patch_feature();
		pre_selected_feature{j} = mypca(pre_selected_feature{j},outdim);
		correlation(j) = cal_correlation(got_feature,pre_selected_feature,i-1);
	end
	[~,min_index] = min(correlation);
	got_feature{i} = pre_selected_feature{min_index};
end


for i = 1:sample_num
	temp1 = got_feature{i};
	train_part1 = temp1(:,train_index);
	train_part2 = temp1(:,train_index + 632);
	test_part1 = temp1(:,test_index);
	test_part2 = temp1(:,test_index+632);	
	file_name = strcat('./data/selected_viper_feature', num2str(i),'.mat');
	save(file_name, 'train_part1','train_part2','test_part1','test_part2');
end

function selected_patch_feature = get_selected_patch_feature()
	perm = randperm(total_patch_num-13);
	selected_patch_index = perm(1:selected_patch_num);
	selected_patch_feature = [];	
	for i = 1:total_img_num
		currfeature = viper_features{i};
		selected_feature = [];
		for j = 1:selected_patch_num
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

function corr = cal_correlation(got_feature,currfeature,num)
	corr_vec = zeros(num,1);
	for i = 1:num
		temp1 = got_feature{i};
		temp2 = zeros(size(temp1,2),1);
		for j = 1:size(temp1,2)
			temp2(j) = corrcoef(temp1(:,j), currfeature);
		end
		corr_vec(i) = mean(temp2);
	end	
	corr = max(corr_vec);
end

function result = mypca(feature,outdim)
	[eigen_vector,~] = PCA1(feature', outdim);
	eigen_vector = eigen_vector(:,1:outdim);
	result = eigen_vector' * feature;	
end





















































