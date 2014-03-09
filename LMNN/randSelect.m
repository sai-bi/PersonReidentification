function [] = randSelect(sampleIndex)
load('feature.mat');
lbpPatchNum = 352; % number of patches in lbp feature
hsvPatchNum = 352; % number of patches in hsv feature
totalPatchNum = lbpPatchNum + hsvPatchNum; 
selectPatchNum = 60; % number of patches to select
sampleNum = 32; % number of samples 
outdim = 600;
perm = randperm(632);  % split training & testing

sampleData = {};

h = waitbar(0, 'Ramdomly select features');
for i = 1:sampleNum
    waitbar(i/32,h);
	select = randsample(totalPatchNum-13,selectPatchNum);
	training1Index = perm(1:316);
	training2Index = perm(1:316)+632;
	test1Index = perm(317:632);
	test2Index = perm(317:632) + 632;
	training1 = [];
	training2 = [];
	test1 = [];
	test2 = [];
	
	selectFeature = [];
	for j = 1:1264
		temp = [];
		for k = 1:size(select,1)
			patchIndex = select(k);
			temp = [temp;feature{j}{patchIndex};feature{j}{patchIndex+1};feature{j}{patchIndex+2}];
			temp = [temp;feature{j}{patchIndex+11};feature{j}{patchIndex+12};feature{j}{patchIndex+13}];
		end
	    selectFeature = [selectFeature temp];
    end
    
    
    if(i == 31)
        selectFeature = [];
        select = 1:352;
        for j = 1:1264
            temp = [];
            for k = 1:352
                patchIndex = k;
                temp = [temp;feature{j}{patchIndex}];
            end
            selectFeature = [selectFeature temp];
        end
    end
    
    
    if(i == 32)
        selectFeature = [];
        select = [1:352] + 352;
        for j = 1:1264
            temp = [];
            for k = 1:352
                patchIndex = k+352;
                temp = [temp;feature{j}{patchIndex}];
            end
            selectFeature = [selectFeature temp];
        end
    end
    
            
            
        
    
    
	
	training1 = selectFeature(:,training1Index);
	training2 = selectFeature(:,training2Index);
	test1 = selectFeature(:,test1Index);
	test2 = selectFeature(:,test2Index);
   
	temp = [training1 training2 test1 test2];
	[eigenvector,eigenvalue] = PCA1(temp', outdim);
	eigenvector = eigenvector(:,1:outdim);
	
	sampleData{i}.select = select; 
	sampleData{i}.training1 = (training1' * eigenvector)';
	sampleData{i}.training2 = (training2' * eigenvector)';
	sampleData{i}.test1 = (test1' * eigenvector)';
	sampleData{i}.test2 = (test2' * eigenvector)';
end	

name = strcat('sampleData/sampleData',num2str(sampleIndex));
save(name,'sampleData');

close(h);
end
