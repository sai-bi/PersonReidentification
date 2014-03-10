%Select subset of features for training and testing
clear all;
clc;
close all;
load('../Feature/data/viper_features.mat');
parameters.total_patch_num = 704;
parameters.total_img_num = 1264;
parameters.selected_patch_num = 60;
parameters.sample_num = 30;
parameters.pca_out_dim = 600;

permutation = randperm(parameters.total_img_num/2);
train_index = permutation(1:length(permutation)/2);
test_index = permutation((length(permutation/2)+1) : length(permutation));

process_bar = waitbar(0,'Select features...');
got_feature = cell(1,parameters.sample_num);
got_feature{1} = get_selected_patch_feature(parameters,viper_features);
got_feature{1} = mypca(got_feature{1},parameters.pca_out_dim);
waitbar(1/parameters.sample_num,process_bar);
for i = 2:parameters.sample_num
	pre_selected_num = 10;
	pre_selected_feature = cell(pre_selected_num,1);
	correlation = zeros(pre_selected_num,1);
	for j = 1:pre_selected_num
		pre_selected_feature{j} = get_selected_patch_feature(parameters,viper_features);
		pre_selected_feature{j} = mypca(pre_selected_feature{j},parameters.pca_out_dim);
		correlation(j) = cal_correlation(got_feature,pre_selected_feature{j},i-1);
	end
	[~,min_index] = min(correlation);
	got_feature{i} = pre_selected_feature{min_index};
	waitbar(i/parameters.sample_num,process_bar);
end

for i = 1:parameters.sample_num
	temp1 = got_feature{i};
	train_part1 = temp1(:,train_index);
	train_part2 = temp1(:,train_index + 632);
	test_part1 = temp1(:,test_index);
	test_part2 = temp1(:,test_index+632);	
	file_name = strcat('./data/selected_viper_feature', num2str(i),'.mat');
	save(file_name, 'train_part1','train_part2','test_part1','test_part2');
end

























































