% This program implements metric learning algorithms put forward 
% in "Learning Weighted Metrics to Minimize Nearest-Neighbour Classification Error"
load('sampleData/sampleMetric2.mat');
% number of metrics
metricNum = 30;
% size of learning set
trainNum  = 316;
% initial weight is set to 1
weight = ones(1,metricNum);

% Initial arguments for gradient boosting
initStepsize = 1; % stepsize, or called learning rate
maxiter = 50; % maximum number of iterations
stepsizeGrowth = 1.01; % stepsize growth
betaValue = 7; % value for beta
derivative = zeros(1,metricNum); % initial value for derivatives
stepsize = initStepsize;
% record objective function value
obj = zeros(1,maxiter);

selectSet = sampleData;
training = sampleData;

% Calculate the distance between each two training instance
distance = {};
for i = 1:trainNum
	tempDist = zeros(trainNum,metricNum);
	for j = 1:metricNum
		metric = selectSet{j}.metric;
		training1 = training{j}.training1;
		training2 = training{j}.training2;
		temp = bsxfun(@minus, metric * training2, metric * training1(:,i)); 
		tempDist(:,j) = sum(temp.^2,1);
	end
	distance{i} = tempDist;
end

% Main Loop for Gradient Boosting
for iter = 1:maxiter
	% record old value
	oldWeight = weight;
	oldDerivative = derivative;

	% adjust weight according to derivatives
	if(iter > 1)
		for i = 1:metricNum
			weight(i) = weight(i) - stepsize * derivative(i);
            %display(weight);
		end
	end

	% calculate the new objective function value
	objValue = 0;
    derivative = zeros(1,metricNum);
    count = 0;
	for i = 1:trainNum
		% get the distance between same-class points
		tempDist = distance{i};
		tempDist = tempDist * (weight' .^2);
		sameClassDist = tempDist(i);
		[minimun, index] = sort(tempDist);

% 		if(index(1) == i)
% 			target = index(5);
% 		else
% 			target = index(1);
% 		end

        

		%diffClassDist = tempDist(index(2)) + tempDist(index(3)) +  tempDist(index(4)) + tempDist(index(5));
        %diffClassDist = diffClassDist/4;
        diffClassDist = tempDist(index(2));
		weightSum = sum(weight.^2);

		RX = sameClassDist/(diffClassDist * weightSum);
				
        %count = count  +  find(index == i) - 1;
		     
        %fprintf('RX: %f', RX);

		objValue = objValue + 1/(1 + exp(betaValue*(1-RX)));
		
		for j = 1:metricNum
            tempDist = distance{i};
            dis1 = tempDist(i,j);
            %dis2 = tempDist(index(2),j) + tempDist(index(3),j) + tempDist(index(4),j) + tempDist(index(5),j);
            %dis2 = dis2/4;
            dis2 = tempDist(index(2),j); 
            part1 = betaValue*exp(betaValue*(1-RX)) / (1 + exp(betaValue*(1-RX)))^2;
			part2 = 2 * weight(j) * dis1 * weightSum * diffClassDist;
			part3 = sameClassDist * (2 * weight(j) * diffClassDist + weightSum * 2 * weight(j) * dis2);
			derivative(j) = derivative(j) + part1 * (part2 - part3)/((diffClassDist * weightSum)^2);		
		end
    end
    
    fprintf('number of impostors: %d\n', count); 

	% record obj value
	obj(iter) = objValue;
	delta = obj(iter) - obj(max(iter-1,1));

	fprintf('Iter %d, obj: %f, delta: %f\n', iter, obj(iter), delta);

	if(iter > 1 && delta > 0)
        fprintf('hello \n');
		stepsize = stepsize * 0.5;
		weight = oldWeight;
		obj(iter) = obj(iter-1);
		derivative = oldDerivative;
	else
		stepsize = stepsize * stepsizeGrowth;
	end
end

save('ensemble.mat', 'weight');

  

