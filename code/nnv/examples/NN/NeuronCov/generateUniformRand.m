function [examples] = generateUniformRand(ub,lb,n)
    %GENERATEUNIFORMRAND 
    % generate n testing points between the upper bound and lower bound,
    % distributed randomly
    dim = size(ub,1);
    examples = rand(dim, n);
    for i = 1:n
        examples(:,i) = lb + (ub-lb).*examples(:,i);
    end
    %disp(examples);
end

