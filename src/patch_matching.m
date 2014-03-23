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

for i = 1:size(files_in_a,1)
    imgpath = strcat(folder_name_a,files_in_a(i).name);
    image_in_a{i} = imread(imgpath);
    imgpath = strcat(folder_name_b,files_in_b(i).name);
    image_in_b{i} = imread(imgpath); 
end

most_similar_coordinates = cell(total_img_num/2,total_img_num/2,patch_num); 
progress_bar = waitbar('Processing...');

for i = 1:total_img_num/2
    waitbar(i*2/total_img_num,progress_bar);
    curr_image_a = image_in_a{i};
    for j = 1:total_img_num/2
        curr_image_b = image_in_b{j};
        data_in = [];
        int count = 0; 
        for height = 1:(par.height_stride):(par.imageheight+1-par.patchheight)
            for width = 1:(par.width_stride):(par.imagewidth+1-par.patchwidth) 
                template = curr_image_a(height:(height+par.patchheight-1), width:(width+par.patchwidth-1), :);
                if(count == 0)
                    [ssd,ncc,data_in] = template_matching(template,curr_image_b);
                else
                    [ssd,ncc,data_in] = template_matching(template,curr_image_b,data_in);
                end
                [x,y] = find(ssd == max(ssd(:)));
                count = count + 1;
                most_similar_coordinates(i,j,count).x = x;
                most_similar_coordinates(i,j,count).y = y;
            end
        end
    end
end

close(progress_bar);
save('./data/similar.mat','most_similar_coordinates');


