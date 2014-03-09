clc;
clear;
dir_e	= './VIPeRa/'; % dataset path
dir_e_list = dir(strcat(dir_e,'/*.bmp'));
n_img       =   size(dir_e_list,1);

hwait = waitbar(0,'Extract features..');
permit_inds = 1:n_img;
totalF = [];
mapping=getmapping(8,'u2'); 

lbpfea = {};
count = 1;
for i=1:length(permit_inds)
 
    img     =   imread(strcat(dir_e,'/',dir_e_list(permit_inds(i)).name));
    fea1 = labExtractFeature(img,[8,4],[4,4],[24,24,24],[8,4],[4,4],'mean', 1, 8, mapping);
    %fea = [fea, fea1];       
    lbpfea{count} = fea1;
    count = count + 1;
    waitbar(i/length(permit_inds),hwait)
    %totalF = [totalF,fea'];
end

save('lbpfeature.mat','lbpfea');

close(hwait);
