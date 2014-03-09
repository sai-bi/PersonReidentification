clear all;
close all;
clc;

total_img_num = 1264;
folder_name_a = './../viper/cam_a/';
folder_name_b = './../viper/cam_b/';


files_in_a = dir(strcat(folder_name_a,'*.bmp'));
files_in_b = dir(strcat(folder_name_b,'*.bmp'));


img_hsvyuv_a = cell(total_img_num/2,1);
img_hsvyuv_b = cell(total_img_num/2,1);

process_bar = waitbar(0,'Read images in...');

for i = 1:size(files_in_a,1)	
	waitbar(i/(size(files_in_a,1)), process_bar);
	imgpath = strcat(folder_name_a,files_in_a(i).name);
	imgrgb = imread(imgpath);
	[img_hsvyuv_a{i}.HSV, img_hsvyuv_a{i}.YUV] = imageConvert(imgrgb);

	imgpath = strcat(folder_name_b,files_in_b(i).name);
	imgrgb = imread(imgpath);
	[img_hsvyuv_b{i}.HSV, img_hsvyuv_b{i}.YUV] = imageConvert(imgrgb);
end

close(process_bar);

hsv_feature_a = cell(total_img_num/2,1);
hsv_feature_b = cell(total_img_num/2,1);


parameters.patchheight = 4;
parameters.patchwidth = 8;
parameters.width_stride = 4;
parameters.height_stride = 4;
parameters.imageheight = 128;
parameters.imagewidth = 48;

process_bar = waitbar(0,'Extract features...');
for i = 1:total_img_num/2	
	waitbar(i/(total_img_num/2),process_bar);
	hsv_feature_a{i} = getfeature(img_hsvyuv_a{i},parameters);
	hsv_feature_b{i} = getfeature(img_hsvyuv_b{i},parameters);
end

close(process_bar);

save('data/hsvyuv_feature.mat','hsv_feature_a','hsv_feature_b');
















