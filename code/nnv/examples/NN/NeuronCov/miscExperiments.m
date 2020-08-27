load ("..\MNIST\mnist_1_140\result.mat", "F");
load ("..\MNIST\digits\zeros.mat");
load ("..\MNIST\digits\ones.mat");
load ("..\MNIST\digits\twos.mat");
load ("..\MNIST\digits\threes.mat");
load ("..\MNIST\digits\fours.mat");
load ("..\MNIST\digits\fives.mat");
load ("..\MNIST\digits\sixes.mat");
load ("..\MNIST\digits\sevens.mat");
load ("..\MNIST\digits\eights.mat");
load ("..\MNIST\digits\nines.mat");
zeroes = zeros;
onesMatrix = ones;
clear zeros;
clear ones;
digits = [zeroes;onesMatrix;twos;threes;fours;fives;sixes;sevens;eights;nines];

% load the images necessary
%{
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
    'nndatasets','DigitDataset');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
%}

covs = cell(1,1000);
for i = 1:1000
    
    input_vec = digits(i, :)';
    %y = F.evaluate(input_vec);
    covs{1,i} = singleInputCoverage(F, input_vec, 0);
    %disp(combineSingInputs(coverage));
    %covs(1,i) = combineSingInputs(coverage);
end

aggCov = countSingInputs(covs);
final = aggregateCovFull(aggCov);

% try altering the delta values to see coverage
rng(1,'twister');
superComb = cell(1,5);
finalCovs = ones(1,5);

for i = 1:5 %5
    
    % generate ub and lb
    ub = i*ones(784,1);
    lb = -i*ones(784,1);
    
    % generate the random values and compute coverage
    combinedCovs = cell(1,1000);
    for j = 1:1000 %1000
        
        input_vec = digits(i, :)';
        newUb = input_vec + ub;
        newLb = input_vec + lb;

        randVals = generateUniformRand(newUb, newLb, 10);
        randCov = cell(1,10);
        for k = 1:10
            randCov{1,k} = singleInputCoverage(F, randVals(:,k),0);
        end
        % countSingInputs
        combinedCovs{1,j} = countSingInputs(randCov);
    end
    
    % aggregate again for each delta value
    superComb{1,i} = countSingInputs(combinedCovs);
    finalCovs(1,i) = aggregateCovFull(superComb{1,i});
end
















%%% EXPERIMENT 2: Evaluate Neuron Coverage on MNIST Net
%%% Use exact neuron coverage measurement on the Small MNIST architecture
%%% Currently running into slow runtime problems

%load ('CNN/MNIST_NETS/Small/images.mat');
%load('CNN/MNIST_NETS/Small/Small_ConvNet.mat');
%nnvNet = CNN.parse(net, 'Small_ConvNet');

%{
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
    'nndatasets','DigitDataset');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
img = readimage(imds,1);
y = nnvNet.evaluate(img);
coverage = singleInputCoverage(nnvNet, img, 0);
%}


% Note: label = 1 --> digit 0
%       label = 2 --> digit 1
%       ...
%       label = 10 --> digit 9


%{
% computing reachable set
IM = IM_data(:,:,1);
IM = reshape(IM, [784 1]);
label = IM_labels(1);
% Brightening attack
d = 250;
lb = IM;
ub = IM;
for i=1:784
    if  IM(i) >= d
        lb(i) = 0;
        ub(i) = 0.0005*IM(i);
    end
end

lb = reshape(lb, [28 28 1]);
ub = reshape(ub, [28 28 1]);
inputSet = ImageZono(lb, ub);   
inputSet1 = inputSet.toImageStar;

outputSet_Star = nnvNet.reach(inputSet1, 'approx-star');
reachTime_star = nnvNet.totalReachTime;


[lb1, ub1] = outputSet_Star.getRanges;
disp("done");
save("ImageReach.mat", "nnvNet");
%[lb2, ub2] = outputSet_Zono.getRanges;
%[lb3, ub3] = outputSet_AbsDom.getRanges;
%}

%{
lb1 = reshape(lb1, [10 1]);
ub1 = reshape(ub1, [10 1]);

im_center1 = (lb1 + ub1)/2;
err1 = (ub1 - lb1)/2;
x1 = 0:1:9;
y1 = im_center1;

% plot ranges of different approaches
figure;
subplot(1,3,1);
e = errorbar(x1,y1,err1);
e.LineStyle = 'none';
e.LineWidth = 1;
e.Color = 'red';
xlabel('Output', 'FontSize', 11);
ylabel('Ranges', 'FontSize', 11);
xlim([0 9]);
title('ImageStar', 'FontSize', 11);
xticks([0 5 9]);
xticklabels({'0', '5', '9'});
set(gca, 'FontSize', 10);
%}

%coverage = computeNeuronCoverageCNN(nnvNet, 0);

%%% Experiment 5: Batch run, make sure to do it on a large number of nets
%{
nets = cell(1,7);
load('../ACASXU/Verify P1/On N1_9/result.mat', 'F');
nets{1,1} = F;
load('../ACASXU/Verify P2/On N2_1/f.mat', 'F');
nets{1,2} = F;
load('../ACASXU/Verify P2/On N2_2/result.mat', 'F');
nets{1,3} = F;
load('../ACASXU/Verify P2/On N2_3/result.mat', 'F');
nets{1,4} = F;
load('../ACASXU/Verify P2/On N2_4/result.mat', 'F');
nets{1,5} = F;
load('../ACASXU/Verify P3/On N2_7/result.mat', 'F');
nets{1,6} = F;
load('../ACASXU/Verify P3/On N2_9/result.mat', 'F');
nets{1,7} = F;

UBsets = cell(1,7);
load('../ACASXU/Verify P1/On N1_9/result.mat', 'ub');
UBsets{1,1} = ub;
%load('../ACASXU/Verify P2/On N2_1/result.mat', 'ub');
ub = [0.6291; 0.0796; 0.0796; 0.4773; -0.4708];
UBsets{1,2} = ub;
load('../ACASXU/Verify P2/On N2_2/result.mat', 'ub');
UBsets{1,3} = ub;
load('../ACASXU/Verify P2/On N2_3/result.mat', 'ub');
UBsets{1,4} = ub;
load('../ACASXU/Verify P2/On N2_4/result.mat', 'ub');
UBsets{1,5} = ub;
load('../ACASXU/Verify P3/On N2_7/result.mat', 'ub');
UBsets{1,6} = ub;
load('../ACASXU/Verify P3/On N2_9/result.mat', 'ub');
UBsets{1,7} = ub;

lbsets = cell(1,7);
load('../ACASXU/Verify P1/On N1_9/result.mat', 'lb');
lbsets{1,1} = lb;
%load('../ACASXU/Verify P2/On N2_1/result.mat', 'lb');
lb = [0.6224; -0.07961; -0.0796; 0.4727; -0.4792];
lbsets{1,2} = lb;
load('../ACASXU/Verify P2/On N2_2/result.mat', 'lb');
lbsets{1,3} = lb;
load('../ACASXU/Verify P2/On N2_3/result.mat', 'lb');
lbsets{1,4} = lb;
load('../ACASXU/Verify P2/On N2_4/result.mat', 'lb');
lbsets{1,5} = lb;
load('../ACASXU/Verify P3/On N2_7/result.mat', 'lb');
lbsets{1,6} = lb;
load('../ACASXU/Verify P3/On N2_9/result.mat', 'lb');
lbsets{1,7} = lb;
%}

%%% once the info is saved, can be easily loaded from BatchInput.mat
%load BatchInput.mat

%{
for i = 1:1
    try
        st = tic;
        filename = strcat('BatchOutput', num2str(i));
        volCov = computeNeuronCoverage(nets{1,i},0);
        save(filename, 'volCov');
        [examples, input] = generateGrid(ubsets{1,i},lbsets{1,i},10);
        cov = cell(1,size(examples,2));
        for j = 1:size(examples,2)
            cov{1,j} = singleInputCoverage(nets{1,i}, examples(:,j), 0);
        end
        singleInput = combineSingInputs(cov);
        
        filename = strcat('BatchOutput', num2str(i));
        fin = toc(st);
        save(filename, 'singleInput', 'fin', '-append');
        fprintf('Done with set %d Time: %.4f\n', i, fin);
    catch err
        disp(err);
    end
end
%}

%{
tables = cell(7,2);
for i = 1:1
    filename = strcat('batchOutputs/BatchOutput', num2str(i));
    load(filename);
    
    % round the values!
    for j = 1:size(volCov,2)
        %A(A>10) = 10
        volCov{1,i}(abs(volCov{1,i})<.001) = 0;
        %volCov{1,i} = round(volCov{1,i},2);
    end
    disp(class(volCov{1,5}));
    tables{i,1} = makeTable(volCov);
    tables{i,2} = makeTable(singleInput);
    
    output1 = strcat('batchOutputs/VolOutput', num2str(i), '.csv');
    output2 = strcat('batchOutputs/TestOutput', num2str(i), '.csv');
    writetable(tables{i,1},output1); 
    writetable(tables{i,2},output2); 
end
%}