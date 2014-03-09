function [] = runLMNN(sampleIndex)
clc;
name = strcat('sampleData/sampleData',num2str(sampleIndex));
load(name);
trainNum = 485;
outdim = 60;
h = waitbar(0,'Running LMNN...');
for i = 1:3
	waitbar(i/33,h);
	training1 = sampleData{i}.training1;
    training2 = sampleData{i}.training2;
	label = [1:trainNum 1:trainNum];
    [metric, det] = lmnn2([training1 training2], label, 1, 'maxiter', 15000, 'checkup',0,'outdim',outdim);

	sampleData{i}.metric = metric;
end

name = strcat('sampleData/sampleMetric',num2str(sampleIndex));
save(name,'sampleData');
close(h);

end
