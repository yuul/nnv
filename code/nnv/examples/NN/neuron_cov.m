%%% EXPERIMENT 1: Manual Examples
%%% Take a manually constructed net and perform exact Neuron Cov estimation
%%% on it
%%% Also examine the coverage vs individual examples
%/* construct an NNV network
%{
W1 = [1 -1; 0.5 2; -1 1]; 
b1 = [-1; 0.5; 0];        
W2 = [-2 1 1; 0.5 1 1];   
b2 = [-0.5; -0.5];        
L1 = LayerS(W1, b1, 'poslin'); 
L2 = LayerS(W2, b2, 'purelin');   
F = FFNNS([L1 L2]); % construct an NNV FFNN

%/* construct input set
lb = [-1; -2]; % lower bound vector
ub = [1; 0]; % upper bound vector
I = Star(lb, ub); % star input set

MNIST = load('CNN/mnist/net.mat');
newNet = MNIST.net;

%/* reachability analysis
nC = 1; % number of cores
[Reach, t1] = F.reach(I,'exact-star', nC);
disp(newline);

%result = computeNeuronCoverage(F, 0);

% generate more examples
n = 20;
newExamples = zeros((n+1)^2,2);
delta_1 = (ub(1,1) - lb(1,1)) / n;
delta_2 = (ub(2,1) - lb(2,1)) / n;
encoding = zeros(32, 1);

for i = 1:n+1
    for j = 1:n+1
        newExamples((i-1)*(n+1)+j, 1) = lb(1,1) + delta_1*(i-1);
        newExamples((i-1)*(n+1)+j, 2) = lb(2,1) + delta_2*(j-1);
    end
end

% iterate over all the new examples and examine their single input coverage
for i = 1:size(newExamples, 1)
    cov = singleInputCoverage(F, [newExamples(i,1); newExamples(i,2)], 0);
    %fprintf('Input: %.1f, %.1f ', newExamples(i,1), newExamples(i,2));
    %fprintf('Layer 1: %d, %d, %d ', cov{1,1}(1,1), cov{1,1}(2,1), cov{1,1}(3,1));
    %fprintf('Layer 2: %d, %d ', cov{1,2}(1,1), cov{1,2}(2,1));
    number = cov{1,1}(1,1)*16 + cov{1,1}(2,1)*8 + cov{1,1}(3,1)*4 + cov{1,2}(1,1)*2 + cov{1,2}(2,1)+1;
    %fprintf('Number: %d\n', number);
    encoding(number,1) = encoding(number,1) + 1;
end
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
load('ACASXU/Verify P1/On N1_1/f.mat', 'F');
%vol = computeLayerVolumes(F);
volCov = computeNeuronCoverage(F, 0);
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
% Function to compute Neuron Coverage using polytope volume
function coverage = computeNeuronCoverage(net, activation)

    %disp(net)
    g = [activation];
    coverage = cell(1,net.nL);
    
    % Step 1: Iterate over every single layer
    % net.nL
    for i = 1:1
        
        % Step 1.5: Get values for each layer (can be useful for
        % standardization)
        %set_array = net.reachSet{i};
        %set_length = net.numReachSet(i);
        %cur_layer = Layers(1,i);
        
        % Step 2: Calculate the volume of the sets covered by a given layer
        volume = 0.0;
        numReachSet = size(net.reachSet{1,i}, 2);
        
        for j = 1:numReachSet
            %disp(net.reachSet{i}(1,j))
            volume = volume + net.reachSet{i}(1,j).getStarCoverage();
        end
        %disp(volume);
        layerResults = zeros(net.Layers(1,i).N,1);
        
        % Step 2: Iterate over every neuron in the layer
        % net.Layers(1,i).N
        for j = 1:2
            
            % Step 3: Create a half space with that neuron 
            st = tic;
            G = zeros(1, net.Layers(1,i).N);
            G(1, j) = 1;
            disp(G);
            % Step 4: Use the half space to intersect with the Polytopes by
            % iterating over all of the neurons
            newVol = 0;
            emptySet = 0;
            for k = 1:numReachSet
                newSet = net.reachSet{i}(1,k).intersectHalfSpace(G,g);
                %disp(newSet);
                
                if(isempty(newSet))
                    emptySet = emptySet +1;
                    %disp("Empty set produced by intersection");
                else
                    newVol = newVol + newSet.getStarCoverage();
                end
            end
            t1 = toc(st);
            
            newSet = net.reachSet{i}(1,1).intersectHalfSpace(G,g);
            disp(newSet);
            %disp(newSet.d);
            
            layerResults(j,1) = newVol/volume;
            fprintf('Percent coverage: %.5f for Layer %d, Neuron %d Time:%.5f Empty Sets: %d\n', layerResults(j,1), i,j, t1, emptySet);
        end
        coverage{1,i} = layerResults;
    end
end

% Function to compute Neuron Coverage for CNN
function coverage = computeNeuronCoverageCNN(net, activation)

    %disp(net)
    g = [activation];
    coverage = cell(1,net.numLayers);
    
    % Step 1: Iterate over every single layer
    for i = 1:net.numLayers
        
        % Step 1.5: Get values for each layer (can be useful for
        % standardization)
        %set_array = net.reachSet{i};
        %set_length = net.numReachSet(i);
        %cur_layer = Layers(1,i);
        
        % Step 2: Calculate the volume of the sets covered by a given layer
        %volume = net.reachSet{i+1}.getStarCoverage();
        %{
        for j = 1:net.reachSet{1}
            %disp(net.reachSet{i}(1,j))
            volume = volume + net.reachSet{i}(1,j).getStarCoverage();
        end
        %}
        %disp(volume);
        layerResults = zeros(net.Layers(1,i).N,1);
        
        % Step 2: Iterate over every neuron in the layer
        %{
        for j = 1:net.Layers(1,i).N
            
            % Step 3: Create a half space with that neuron 
            G = zeros(1, net.Layers(1,i).N);
            G(1, j) = 0;
            
            % Step 4: Use the half space to intersect with the Polytopes by
            % iterating over all of the neurons
            newVol = 0;
            for k = 1:net.numReachSet(i)
                newSet = net.reachSet{i}(1,k).intersectHalfSpace(G,g);
                newVol = newVol + newSet.getStarCoverage();
            end
            
            fprintf('Percent coverage: %.5f for Layer %d, Neuron %d \n', newVol/volume, i,j);
            layerResults(j,1) = newVol/volume;
        end
        %}
        coverage{1,i} = layerResults;
    end
end

function coverage = singleInputCoverage(net, x, activation)

    % first perform the layer by layer analysis
    results = cell(1,net.nL);
    y = x; 
    for i=1:net.nL
        %disp(y)
        y = net.Layers(i).evaluate(y);
        results{1,i} = y;
    end

    % analyze the coverage
    coverage = cell(size(results));
    for i = 1:size(results,2)
        %disp(results{1,i})
        coverage{1,i} = results{1,i}>activation;
    end
end

%%% A function that will iterate over every computed reachable layer and
%%% compute their volumes
function volumes = computeLayerVolumes(net)

    volumes = zeros(1,net.nL);
    % Step 1: Iterate over every single layer
    for i = 1:net.nL
        
        % Step 2: Calculate the volume of the sets covered by a given layer
        volume = 0.0; 
        numReachSet = size(net.reachSet{1,i}, 2);
   
        for j = 1:numReachSet
            %disp(net.reachSet{i}(1,j))
            newAdd = net.reachSet{i}(1,j).getStarCoverage();
            volume = volume + newAdd;
        end

        fprintf('Final Volume: %f.5\n', volume);     
        volumes(1,i) = volume;
    end
end

%%% Generate a grid of examples
function [examples,input] = generateGrid(ub,lb, n)

    %examples = zeros((n+1)^size(ub,1),size(ub,1));
    input = cell(size(ub,1),1);
    for i = 1:size(ub,1)
        input{i,1} = linspace(lb(i,1),ub(i,1),n);
    end
    
    examples = combvec(input{:});
end