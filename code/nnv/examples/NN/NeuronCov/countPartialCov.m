function [count] = countPartialCov(coverage)
%COUNTPARTIALCOV Given a network, count the number of neurons in it that
%are partially covered
    count = 0;
    for i = 1:size(coverage,2)
        for j = 1:size(coverage{1,i},1)
            
            if abs(coverage{1,i}(j,1)) >= .0001 && abs(coverage{1,i}(j,1)-1) >= .0001
                count = count+1;
            end
        end
    end
end

