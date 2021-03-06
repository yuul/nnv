function results = aggregateCoverage(coverage)

    results = zeros(4,size(coverage,2));
   
    for i = 1:size(coverage,2)
        
        count = 0;
        for j = 1:size(coverage{1,i},1)
            
            if abs(coverage{1,i}(j,1)) <= 0.0001
                results(1,i) = results(1,i)+1;
            elseif abs(coverage{1,i}(j,1)-1) <= 0.0001
                results(3,i) = results(3,i)+1;
                count = count + 1;
            else
                results(2,i) = results(2,i)+1;
                count = count + coverage{1,i}(j,1);
            end
        end
        
        results(4,i) = count/size(coverage{1,i},1);
    end
end