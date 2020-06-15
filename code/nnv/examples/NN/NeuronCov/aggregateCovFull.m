function results = aggregateCovFull(coverage)

    %%% Compute the neuron coverage for an entire network
    %%% Take in the individual coverage for all neurons
    %%% Return the coverage over the entire network
    results = 0;
    count = 0;
    for i = 1:size(coverage,2)
        
        count = count + size(coverage{1,i},1);
        for j = 1:size(coverage{1,i},1)
            
            % sum up the coverage
            if abs(coverage{1,i}(j,1)) <= 0.0001
            elseif abs(coverage{1,i}(j,1)-1) <= 0.0001
                results = results + 1;
            else
                results = results + coverage{1,i}(j,1);
            end
        end
    end
    
    results = results/count;
end

