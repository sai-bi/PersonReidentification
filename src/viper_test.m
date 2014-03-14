clear all;
close all;
clc;
parameters.total_patch_num = 704;
parameters.total_img_num = 1264;
parameters.selected_patch_num = 60;
parameters.sample_num = 31;
parameters.pca_out_dim = 600;
parameters.outdim = 80;
parameters.testnum = 316;
load('./data/metrics.mat');
distance = zeros(1,parameters.testnum * parameters.testnum);
for j = 1:20
	load(strcat('./data/selected_viper_feature',num2str(j),'.mat'));
	test_part1_pca = metrics{j} * test_part1;
	test_part2_pca = metrics{j} * test_part2;
	test_part2_pca = repmat(test_part2_pca,[1,parameters.testnum]);
	test_part1_pca = repmat(test_part1_pca,[parameters.testnum,1]);
	test_part1_pca = reshape(test_part1_pca,parameters.outdim,[]);	
	temp1 = test_part1_pca - test_part2_pca;
	temp1 = sum(temp1.^2,1);	
	distance = distance + temp1;
end
distance = reshape(distance,parameters.testnum,[]);
[~,index] = sort(distance,1);
ratio = zeros(1,parameters.testnum);
for i = 1:parameters.testnum
	temp = index(:,i);
	index1 = find(temp == i);
	ratio = ratio + [zeros(1,index1-1), ones(1,parameters.testnum - index1 + 1)];		
end
x = 1:parameters.testnum;
ratio = ratio / parameters.testnum * 100;
figure;
plot(x,ratio);









