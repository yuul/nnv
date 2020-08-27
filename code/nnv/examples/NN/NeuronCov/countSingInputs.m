function results = countSingInputs(coverage)
    %%% This function counts the number of cells are covered
    %%% note that this is not the average but rather checks if a neuron has
    %%% been covered
    results = cell(size(coverage{1,1}));

    % generate the correct cells
    for i = 1:size(coverage{1,1},2)
        results{1,i} = zeros(size(coverage{1,1}{1,i}));
    end
    
    % iterate and sum up the coverage for all examples
    for i = 1:size(coverage,2)
        for j = 1:size(coverage{1,i},2)
            results{1,j} = results{1,j} + coverage{1,i}{1,j} > 0;
        end
    end
end

