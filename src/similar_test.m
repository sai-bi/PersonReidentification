clear all;
close all;
clc;

total_img_num = 1264;
folder_name_a = './../viper/cam_a/';
folder_name_b = './../viper/cam_b/';

files_in_a = dir(strcat(folder_name_a,'*.bmp'));
files_in_b = dir(strcat(folder_name_b,'*.bmp'));

image_in_a = cell(total_img_num/2,1);
image_in_b = cell(total_img_num/2,1);

par.patchheight = 4;
par.patchwidth = 8;
par.width_stride = 4;
par.height_stride = 4;
par.imageheight = 128;
par.imagewidth = 48;
patch_num = 352;

gray_scale_a = zeros(32,patch_num,total_img_num/2);
gray_scale_b = zeros(32,patch_num,total_img_num/2);

for i = 1:size(files_in_a,1)
    imgpath = strcat(folder_name_a,files_in_a(i).name);
    temp1 = imread(imgpath);
    temp1 = rgb2gray(temp1);
    imgpath = strcat(folder_name_b,files_in_b(i).name);
    temp2 = imread(imgpath);
    temp2 = rgb2gray(temp2);
    count = 1;
    for height = 1:(par.height_stride):(par.imageheight+1-par.patchheight)
            for width = 1:(par.width_stride):(par.imagewidth+1-par.patchwidth) 
                temp3 = temp1(height:(height+par.patchheight-1), width:(width+par.patchwidth-1));
                gray_scale_a(:,count,i) = temp3(:);
                temp3 = temp2(height:(height+par.patchheight-1), width:(width+par.patchwidth-1));
                gray_scale_b(:,count,i) = temp3(:);
                count = count + 1;
            end
    end 
end

save('./data/gray_scale.mat','gray_scale_a','gray_scale_b');
% load('./data/gray_scale.mat');

matching_result = cell(total_img_num/2,total_img_num/2);
%bar = waitbar(0,'Processing...');
parfor i = 1:total_img_num/2
    %waitbar(2*i/total_img_num,bar);
    patch_gray_1 = gray_scale_a(:,:,i); 
    patch_gray_1 = reshape(patch_gray_1,32,[]);
    patch_gray_1 = repmat(patch_gray_1,patch_num,1);
    patch_gray_1 = reshape(patch_gray_1,32,[]);

    for j = 1:total_img_num/2
        %clock
        patch_gray_2 = gray_scale_b(:,:,j);
        patch_gray_2 = reshape(patch_gray_2,32,[]);
        patch_gray_2 = repmat(patch_gray_2,1,patch_num); 
        temp1 = patch_gray_1 - patch_gray_2;
        temp1 = temp1.^2;
        temp1 = sum(temp1,1);  
        temp1 = reshape(temp1,patch_num,[]); 
        [~, index] = min(temp1,[],1);
        matching_result{i}{j} = index;  
        %clock
    end
end
%close(bar);
save('./data/matching_result.mat','matching_result');










































