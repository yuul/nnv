function time = sumTimes(coverage)
    % Returns the sum of all the time needed to compute the volume coverage
    time = 0;
    for i = 1:size(coverage,2)
        for j = 1:size(coverage{1,i},1)
            
           time = time + coverage{1,i}(j,2);
        end
    end
end