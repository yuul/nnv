function results = combineSingInputs(coverage)
    
    results = cell(size(coverage{1,1}));
    disp(size(coverage{1,1},2));
    for i = 1:size(coverage{1,1},2)
        results{1,i} = zeros(size(coverage{1,1}{1,i}));
    end
    
    %size(singleInputcov,2)
    for i = 1:size(coverage,2)
        for j = 1:size(coverage{1,i},2)
            results{1,j} = results{1,j} + coverage{1,i}{1,j};
        end
    end
end