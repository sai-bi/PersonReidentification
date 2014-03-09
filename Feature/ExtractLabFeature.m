clc;
clear;
folder_a = './../viper/cam_a/';
folder_b = './../viper/cam_b/';

img_list_a = dir(strcat(folder_a,'*.bmp'));
img_list_b = dir(strcat(folder_b,'*.bmp'));
img_num = size(img_list_a,1);
process_bar = waitbar(0,'Extract lab feature...');
mapping = getmapping(8,'u2');
labfeatuer_a = cell(img_num,1);
labfeatuer_b = cell(img_num,1);

for i = 1:img_num
	img_name = strcat(folder_a,img_list_a(i).name);
	img = imread(img_name);
    feat = labExtractFeature(img,[8,4],[4,4],[24,24,24],[8,4],[4,4],'mean', 1, 8, mapping);
	labfeatuer_a{i} = feat;
		
	img_name = strcat(folder_b,img_list_b(i).name);
	img = imread(img_name);
    feat = labExtractFeature(img,[8,4],[4,4],[24,24,24],[8,4],[4,4],'mean', 1, 8, mapping);
	labfeatuer_b{i} = feat;

	waitbar(i/img_num,process_bar);
end

close(process_bar);
save('data/labfeature.mat','labfeatuer_a','labfeatuer_b');







