%%% EXPERIMENT 1: Manual Examples
%%% Take a manually constructed net and perform exact Neuron Cov estimation
%%% on it
%%% Also examine the coverage vs individual examples
%{
% ub is upper bound, lb is lower bound, F is network with Reachability
% computed, I is the input set, and newExamples is the grid of single
% inputs
load('ManualInputs.mat');

% run volume based Neuron Coverage computation
result = computeNeuronCoverage(F, 0);

% iterate over all the new examples and examine their single input coverage
cov = cell(1,size(newExamples,2));
st = tic;
for i = 1:size(newExamples, 2)
    cov{1,i} = singleInputCoverage(F, newExamples(:,i), 0);
end
fin = toc(st);
singleInput = combineSingInputs(cov);
fprintf('Ran Single Input Coverage on %d inputs in %.4f time\n', size(newExamples,2), fin);
%save('ManualOutputs.mat', 'result', 'cov','fin');
%}


%%% EXPERIMENT 2: Evaluate Neuron Coverage on MNIST Net
%%% Use exact neuron coverage measurement on the Small MNIST architecture
%%% Currently running into slow runtime problems
%{
load ('CNN/MNIST_NETS/Small/images.mat');
load('CNN/MNIST_NETS/Small/Small_ConvNet.mat');
nnvNet = CNN.parse(net, 'Small_ConvNet');

% Note: label = 1 --> digit 0
%       label = 2 --> digit 1
%       ...
%       label = 10 --> digit 9



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
%}
%[lb2, ub2] = outputSet_Zono.getRanges;
%[lb3, ub3] = outputSet_AbsDom.getRanges;


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

%%% EXPERIMENT 3: Neuron Coverage on ACAS XU network
%%% Generate reachable sets from ACASXU/Verify P1/On N1_1/verify_P1_star
%%% Results stored in the F.mat file in that directory
%%% Compute exact neuron coverage on those reachable sets
%load('../ACASXU/Verify P1/On N1_1/f.mat', 'F');
%net1 = F;
%vol = computeLayerVolumes(F);
%volCov = computeNeuronCoverage(F, 0);
%%% stored currently in coverage.mat
%{
lb = [0.634057002041121;-0.079577471545942;-0.079577471545942;0.472727272727273;-0.479166666666667];
ub = [0.634886726074908;0.079577471545942;0.079577471545942;0.477272727272727;-0.470833333333333]; % upper bound vector
n = 10;
[examples, input] = generateGrid(ub,lb,n);

cov = cell(1,size(examples,2));

for i = 1:size(examples,2)
    if (mod(i,10000) == 0) 
        disp(i)
    end
    cov{1,i} = singleInputCoverage(F, examples(:,i), 0);
    %fprintf('Input: %.1f, %.1f ', newExamples(i,1), newExamples(i,2));
    %fprintf('Layer 1: %d, %d, %d ', cov{1,1}(1,1), cov{1,1}(2,1), cov{1,1}(3,1));
    %fprintf('Layer 2: %d, %d ', cov{1,2}(1,1), cov{1,2}(2,1));
    %number = cov{1,1}(1,1)*16 + cov{1,1}(2,1)*8 + cov{1,1}(3,1)*4 + cov{1,2}(1,1)*2 + cov{1,2}(2,1)+1;
    %fprintf('Number: %d\n', number);
    %encoding(number,1) = encoding(number,1) + 1;
end
%}

%%% Experiment 4: ACAS Xu network again
%%% Generate reachable set from another network?
%load('../ACASXU/Verify P1/On N1_2/f.mat', 'F');
%net2 = F;
%vol = computeLayerVolumes(net2);
%volCov = computeNeuronCoverage(net2, 0);

%ub = [0.999135576907121;0.079577471545942;0.079577471545942;0.477272727272727;-0.470833333333333];
%lb = [0.916163173528484;-0.079577471545942;-0.079577471545942;0.472727272727273;-0.479166666666667];
%{
[examples, input] = generateGrid(ub,lb,10);
cov = cell(1,size(examples,2));
for i = 1:size(examples,2)
    cov{1,i} = singleInputCoverage(F, examples(:,i), 0);
end
%}
%singleInput = combineSingInputs(cov);

%%% Experiment 5: Batch run, make sure to do it on a large number
load('../ACASXU/Verify P1/On N1_2/f.mat', 'F');
load('../ACASXU/Verify P1/On N1_2/f.mat', 'F');
load('../ACASXU/Verify P1/On N1_2/f.mat', 'F');
load('../ACASXU/Verify P1/On N1_2/f.mat', 'F');
load('../ACASXU/Verify P1/On N1_2/f.mat', 'F');
