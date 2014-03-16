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
viper_hsvyuv_features = zeros(hsvyuv_dim,patch_num,total_img_num);
viper_lab_features = zeros(lab_dim,patch_num,total_img_num);

for i = 1:total_img_num/2
	temp_feature = cell(2*patch_num,1);
	for j = 1:patch_num
		hsv = hsv_feature_a{i}{j}.HSV;
		yuv = hsv_feature_a{i}{j}.YUV;
		%temp_feature{j} = [hsv;yuv];
		%temp_feature{j+patch_num} = (labfeatuer_a{i}{j})';
		viper_hsvyuv_features(:,j,i) = [hsv;yuv];
		viper_lab_features(:,j,i) = (labfeatuer_a{i}{j})';
	end		
end

for i = 1:total_img_num/2
	temp_feature = cell(2*patch_num,1);
	for j = 1:patch_num
		hsv = hsv_feature_b{i}{j}.HSV;
		yuv = hsv_feature_b{i}{j}.YUV;
		%temp_feature{j} = [hsv;yuv];
		%temp_feature{j+patch_num} = (labfeatuer_b{i}{j})';
		viper_hsvyuv_features(:,j,i+total_img_num/2) = [hsv;yuv];
		viper_lab_features(:,j,i+total_img_num/2) = (labfeatuer_b{i}{j})';
	end		
end


save('data/viper_features.mat','viper_lab_features','viper_hsvyuv_features','-v7.3');





