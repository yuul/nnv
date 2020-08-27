%%% A script for running the experiments on box coverage
%{
lb = [0;0;0;0];
ub = [6;6;6;5];
B = Box(lb,ub);
[hi, there] = B.getRange();
disp(boxSize(B));
newbie = intersectHalfSpace(B, 2, 0);
try
    newbie2 = intersectHalfSpace(B, 5, 0);
catch err
    disp(err);
end

try
    newbie3 = intersectHalfSpace(B, 2, 10);
catch otherErr
    disp(otherErr);
end
%}


% Create the networks
networks = cell(1,45);
for i = 1:5
    for j = 1:9
        filename = strcat('../ACASXU/nnet-mat-files/ACASXU_run2a_', num2str(i),'_', num2str(j), '_batch_2000.mat');
        networks{1,9*(i-1)+j} = createACASnet(filename);
    end
end

lb = [0;-pi; -pi; 100; 0];
ub = [62000; pi; pi; 1200; 1200];
means = [31000;0;0;650;600];
range = [60261;6.283185307180000;6.283185307180000;1100;1200];
ub = (ub-means)./range;
lb = (lb-means)./range;

% create smaller ub and lb ranges for the volume computation (1/25)^5 the
% original size - I did this for examples 1-10
% for examples 11-45, I used an input size (3/100)^5 the original size
delta = (ub-lb)/100;
newUb = ub - 48.5*delta;
newLb = lb + 48.5*delta;
B = Box(newLb, newUb);

bigUb = ub - 48*delta;
bigLb = lb + 48*delta;
bigB = Box(bigLb, bigUb);

singleCovTimes = zeros(45,1);
for i = 1:1
    
    if i <= 10
        % reachability analysis
        [R, t] = networks{1,i}.reach(bigB, 'exact', 4, []);
        filename = strcat('batchBoxRun/Batch', num2str(i), '.mat');
        output = networks{1,i};
        save(filename, 'output');

        % volume analysis
        volCov = computeNeuronCovBox(networks{1,i},0);
        save(filename, 'volCov', '-append');
    else
        
        % reachability analysis - this uses a smaller box
        [R, t] = networks{1,i}.reach(B, 'exact', 4, []);
        filename = strcat('batchBoxRun/Batch', num2str(i), '.mat');
        output = networks{1,i};
        save(filename, 'output');

        % volume analysis
        volCov = computeNeuronCovBox(networks{1,i},0);
        save(filename, 'volCov', '-append');
    end
    
   
end




%%% Takes in a box and finds the volume of the box
%%% Checks if the box produced has not volume because of dimension mismatch
function size = boxSize(B)
    diff = B.ub - B.lb;
    if all(diff >= 0 )
        size = prod(diff);
    else
        size = 0;
    end
end

%%% Takes in a box, index, and activation level
%%% Creates a new box with the lb of the index set to above the activation
%%% level
%%% Also checks that the new box has a volume
function newBox = intersectHalfSpace(B, index, activation)
    
    if index > size(B.ub,1)
        error("Index too large for given box size");
    end
    
    newLB = B.lb;
    newLB(index,1) = activation;
    
    % Checks if the box has valid dimensions
    if all((B.ub - newLB) >= 0 )
        newBox = Box(newLB, B.ub);
    else
        error("Cannot create a valid box");
    end
end