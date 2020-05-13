function results = getResults(coverage)
    
    results = zeros(size(coverage,2), 3);
    
    for i = 1:size(coverage, 2)
        
        for j = 1:size(coverage{1,i}, 1)
            
            if abs(coverage{1,i}(j,1)) <= 0.000001
                results(i,1) = results(i,1) + 1;
            elseif abs(coverage{1,i}(j,1)-1) <= 0.000001
                results(i,3) = results(i,3) + 1;
            else
                %disp(coverage{1,i}(j,1));
                results(i,2) = results(i,2) + 1;
            end
        end
    end
end