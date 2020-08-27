%%% EXPERIMENT 1: Manual Examples
%%% Take a manually constructed net and perform exact Neuron Cov estimation
%%% on it
%%% Also examine the coverage vs individual examples

% ub is upper bound, lb is lower bound, F is network with Reachability
% computed, I is the input set, and newExamples is the grid of single
% inputs
load('ManualInputs.mat');

% run volume based Neuron Coverage computation
result = computeNeuronCoverage(F, 0);

% iterate over all the new examples and examine their single input coverage
%{
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
center = [0;-1];
centerCov = singleInputCoverage(F, center, 0);

% run on 1000 randomly generated examples
st = tic;
rng(1,'twister');
examples = generateUniformRand(ub, lb, 1000);
rngCov = cell(1,size(examples,2));
for i = 1:1000
    rngCov{1,i} = singleInputCoverage(F, examples(:,i), 0);
end
rngFin = toc(st);
singleInput = combineSingInputs(rngCov);
save('ManualOutputs.mat', '-append', 'singleInput', 'rngCov', 'rngFin');

error = zeros(1,5);
counter = 1;
for i = 1:size(result,2)
    for j = 1:size(result{1,i},1)
        error(1,counter) = result{1,i}(j,1) - singleInput{1,i}(j,1);
        counter = counter + 1;
    end
end
MSE = sum(error.^2)/size(error,2);