clear all;
close all;
clc;

load('./data/hsvyuv_feature.mat');
load('./data/labfeature.mat');

total_img_num = 1264;
patch_num = 352;
viper_features = cell(total_img_num,1);


for i = 1:total_img_num/2
	temp_feature = cell(2*patch_num,1);
	for j = 1:patch_num
		hsv = hsv_feature_a{i}{j}.HSV;
		yuv = hsv_feature_a{i}{j}.YUV;
		temp_feature{j} = [hsv;yuv];
		temp_feature{j+patch_num} = (labfeatuer_a{i}{j})';
	end		
	viper_features{i} = temp_feature;
end

for i = 1:total_img_num/2
	temp_feature = cell(2*patch_num,1);
	for j = 1:patch_num
		hsv = hsv_feature_b{i}{j}.HSV;
		yuv = hsv_feature_b{i}{j}.YUV;
		temp_feature{j} = [hsv;yuv];
		temp_feature{j+patch_num} = (labfeatuer_b{i}{j})';
	end		
	viper_features{i+total_img_num/2} = temp_feature;
end


save('data/viper_features.mat','viper_features','-v7.3');





