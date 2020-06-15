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
%{
ub = [0.999135576907121;0.079577471545942;0.079577471545942;0.477272727272727;-0.470833333333333];
lb = [0.916163173528484;-0.079577471545942;-0.079577471545942;0.472727272727273;-0.479166666666667];

[examples] = generateGrid(ub,lb,10);
cov = cell(1,size(examples,2));
for i = 1:size(examples,2)
    cov{1,i} = singleInputCoverage(F, examples(:,i), 0);
end
%}
%singleInput = combineSingInputs(cov);


%%% Experiment 6 - Full Batch Runner
% Full Batch Run
% load all of the networks
%{
networks = cell(1,45);
for i = 1:5
    for j = 1:9
        filename = strcat('../ACASXU/nnet-mat-files/ACASXU_run2a_', num2str(i),'_', num2str(j), '_batch_2000.mat');
        networks{1,9*(i-1)+j} = createACASnet(filename);
    end
end

% generate random seed and grid
rng(1,'twister');
lb = [0;-pi; -pi; 100; 0];
ub = [62000; pi; pi; 1200; 1200];
means = [0;0;0;650;600];
range = [60261;6.283185307180000;6.283185307180000;1100;1200];
ub = (ub-means)./range;
lb = (lb-means)./range;
examples = generateUniformRand(ub, lb, 1000);

% run on all of the networks 
% should I be using different inputs at each iteration?
%{
singleInput = cell(1,45);
for i = 1:size(networks,2)
    
    % generate the examples for the input nets
    cov = cell(1,size(examples,2));
    for j = 1:size(examples,2)
        cov{1,j} = singleInputCoverage(networks{1,i}, examples(:,j), 0);
    end
    singleInput{1,i} = combineSingInputs(cov);
end
%}

% create smaller ub and lb ranges for the volume computation (1/25)^5 the
% original size - I did this for examples 1-10
% for examples 11-45, I used an input size (3/100)^5 the original size
delta = (ub-lb)/100;
newUb = ub - 48.5*delta;
newLb = lb + 48.5*delta;

B = Box(newLb, newUb);
I = B.toStar;
%save('Batch.mat', 'networks');

%size(networks,2)
for i = 1:size(networks,2)
    
    % reachability analysis
    [R, t] = networks{1,i}.reach(I, 'exact', 4, []);
    filename = strcat('batchRun/Batch', num2str(i), '.mat');
    output = networks{1,i};
    save(filename, 'output');
    
    % volume analysis
    volCov = computeNeuronCoverage(networks{1,i},0);
    save(filename, 'volCov', '-append');
    
    % testing example on the smaller set
    examples = generateUniformRand(newUb, newLb, 1000);
    cov = cell(1,size(examples,2));
    for j = 1:size(examples,2)
        cov{1,j} = singleInputCoverage(networks{1,i}, examples(:,j), 0);
    end
    singleInput = combineSingInputs(cov);
    save(filename, 'singleInput', '-append');
end


results = zeros(45,2,4,7);
for i = 1:45
    
    filename = strcat('batchRun/Batch',num2str(i),'.mat');
    load(filename, 'volCov', 'singleInput');
    results(i,1,:,:) = aggregateCoverage(volCov);
    results(i,2,:,:) = aggregateCoverage(singleInput);
end
save('batchRun/results.mat', 'results');

load('batchRun/results.mat','results');
aggVol = results(:,1,4,:);
aggVol = reshape(aggVol,45,7);
volTable = array2table(aggVol);
volTable.Properties.VariableNames = {'Layer1','Layer2','Layer3','Layer4','Layer5','Layer6','Layer7'};
writetable(volTable,'batchRun/volTable.csv');
aggTest = results(:,2,4,:);
aggTest = reshape(aggTest,45,7);
testTable = array2table(aggTest);
testTable.Properties.VariableNames = {'Layer1','Layer2','Layer3','Layer4','Layer5','Layer6','Layer7'};
writetable(testTable,'batchRun/testTable.csv');
%}


%%% Run on one ACAS Xu example with the whole input space
%%% Partition the input space into halves, so you have a combination of
%%% every half - 5 Dimensions means 2^5 = 32 total spaces
%{
lb = [0;-pi; -pi; 100; 0];
ub = [60261; pi; pi; 1200; 1200];
means = [0;0;0;650;600];
range = [60261;6.283185307180000;6.283185307180000;1100;1200];
ub = (ub-means)./range;
lb = (lb-means)./range;

% partitions is the number of partitions to split into?
partitions = 10;
space = cell(1,size(lb,1));
for i = 1:size(lb,1)
    fullSpace = linspace(lb(i,1),ub(i,1),partitions+1);
    space{1,i} = fullSpace(:,1:size(fullSpace,2)-1);
end
start = tic;
inputs = allcomb(space{1,1},space{1,2},space{1,3},space{1,4},space{1,5});
fin = toc(start);
fprintf("All Combos Computed, time:%.4f, size:%d\n", fin, size(inputs,1));

spacing = (ub-lb)./(partitions);
spacing = reshape(spacing, 1,5);

ACASfile = '../ACASXU/nnet-mat-files/ACASXU_run2a_1_1_batch_2000.mat';
network = createACASnet(ACASfile);

%size(inputs,1)
for i = 1:1
    
    start = tic;
    newLB = inputs(i,:);
    newUB = newLB + spacing;

    newLB = newLB.';
    newUB = newUB.';
    B = Box(newLB, newUB);
    I = B.toStar;
    network.reach(I, 'exact', 4, []);
    
    fin = toc(start);
    fprintf("Reachability done, time:%.4f/n", fin);
    
    start = tic;
    volCov = computeNeuronCoverage(network,0);
    fin = toc(start);
    fprintf("Reachability done, time:%.4f/n", fin);
end
%{
ACASfile = '../ACASXU/nnet-mat-files/ACASXU_run2a_1_1_batch_2000.mat';
network = createACASnet(ACASfile);
for i = 1:1
    
    % convert to binary representation
    b = dec2bin(i-1,5);

    % now use this binary representation to determine which half of the
    % input space to use for each dimension 
    % for example, 10000 means use the upper half for dim 1 and use the
    % lower half for the rest of the dimensions
    curLb = zeros(5,1);
    curUb = zeros(5,1);
    for j = 1:size(b,2)
        
        if(b(1,j) == 0)
            curLb(j,1) = lb(j,1);
            curUb(j,1) = middle(j,1);
        else
            curLb(j,1) = middle(j,1);
            curUb(j,1) = ub(j,1);
        end
    end
    
    % run reachability analysis
<<<<<<< HEAD
    %{
=======
>>>>>>> e8f30988fe662dd13c454d6177e400179d34d322
    B = Box(curLb, curUb);
    I = B.toStar;
    st = tic;
    network.reach(I, 'exact', 4, []);
    fin = toc(st);
    filename = strcat('partitionRun/Partition', num2str(i), '.mat');
    save(filename, 'B', 'fin', 'network');
<<<<<<< HEAD
    %}
=======
>>>>>>> e8f30988fe662dd13c454d6177e400179d34d322
end
%}