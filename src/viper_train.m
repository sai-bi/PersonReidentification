clear all;
close all;
clc;
parameters.total_patch_num = 704;
parameters.total_img_num = 1264;
parameters.selected_patch_num = 60;
parameters.sample_num = 30;
parameters.pca_out_dim = 600;
parameters.outdim = 80;
lmnn_path = './../LMNN';
addpath(lmnn_path);
addpath([lmnn_path '/helperfunctions']);
addpath([lmnn_path '/mexfunctions/binaries']);
addpath([lmnn_path '/mexfunctions']);
addpath([lmnn_path '/mtrees/binaries']);
addpath([lmnn_path '/mtrees']);

viper_features = cell(parameters.sample_num,1);
for i = 1:parameters.sample_num
	load(strcat('./data/selected_viper_feature', num2str(i),'.mat'));
	viper_features{i}.train_part1 = train_part1;
	viper_features{i}.train_part2 = train_part2;
end

matlabpool open 4;
metrics = cell(parameters.sample_num,1);
parfor i = 1:parameters.sample_num
	label = [1:316 1:316];
	[metrics{i},~] = lmnn2([viper_features{i}.train_part1,viper_features{i}.train_part2],label,1, 'maxiter', 15000, 'checkup',0,'outdim',parameters.outdim,'quiet',1);
end

save('./data/metrics.mat','metrics');
matlabpool close;

