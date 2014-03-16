clear all;
close all;
clc;

load('./data/hsvyuv_feature.mat');
load('./data/labfeature.mat');

total_img_num = 1264;
patch_num = 352;
viper_features = cell(total_img_num,1);
hsvyuv_dim = 66;
lab_dim = 38;
viper_hsvyuv_features = zeros(total_img_num,patch_num,hsvyuv_dim);
viper_lab_features = zeros(total_img_num,patch_num,lab_dim);

for i = 1:total_img_num/2
	temp_feature = cell(2*patch_num,1);
	for j = 1:patch_num
		hsv = hsv_feature_a{i}{j}.HSV;
		yuv = hsv_feature_a{i}{j}.YUV;
		%temp_feature{j} = [hsv;yuv];
		%temp_feature{j+patch_num} = (labfeatuer_a{i}{j})';
		viper_hsvyuv_features(i,patch_num,:) = [hsv;yuv];
		viper_lab_features(i,patch_num,:) = (labfeature_a{i}{j})';
	end		
end

for i = 1:total_img_num/2
	temp_feature = cell(2*patch_num,1);
	for j = 1:patch_num
		hsv = hsv_feature_b{i}{j}.HSV;
		yuv = hsv_feature_b{i}{j}.YUV;
		%temp_feature{j} = [hsv;yuv];
		%temp_feature{j+patch_num} = (labfeatuer_b{i}{j})';
		viper_hsvyuv_features(i+total_img_num/2,patch_num,:) = [hsv;yuv];
		viper_lab_features(i+total_img_num/2,patch_num,:) = (labfeature_b{i}{j})';
	end		
end


save('data/viper_features.mat','viper_lab_features','viper_hsvyuv_features',-v7.3');





