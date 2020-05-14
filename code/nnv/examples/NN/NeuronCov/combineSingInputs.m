function results = combineSingInputs(coverage)
    
    results = cell(size(coverage{1,1}));

    % generate the correct cells
    for i = 1:size(coverage{1,1},2)
        results{1,i} = zeros(size(coverage{1,1}{1,i}));
    end
    
    % iterate and sum up the coverage for all examples
    for i = 1:size(coverage,2)
        for j = 1:size(coverage{1,i},2)
            results{1,j} = results{1,j} + coverage{1,i}{1,j};
        end
    end
    
    % normalize and divide by the number of elements
    for i = 1:size(results, 2)
        results{1,i} = results{1,i}./size(coverage,2);
    end
end