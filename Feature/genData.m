load('HSVYUVFeature.mat');
load('lbpfeature.mat');

feature = {};
h = waitbar(0,'Gen data...');
for i = 1:1264
    waitbar(i/1264,h);
    temp = {};
    for j = 1:352
        temp{j} = lbpfea{i}{j}';
    end
    
    if i < 633
        for j = 1:352
            temp{j+352} =  [HSVYUVFeatureA{i}{j}.HSV; HSVYUVFeatureA{i}{j}.YUV];
        end
    else
        for j = 1:352
            temp{j+352} =  [HSVYUVFeatureB{i-632}{j}.HSV; HSVYUVFeatureB{i-632}{j}.YUV];
        end
    end
    
    
    
    feature{i} = temp; 
    clear temp;
end

save('feature.mat','feature','-v7.3');

close(h);