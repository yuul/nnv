%%% Generate a grid of examples
function [examples] = generateGrid(ub,lb, n)

    input = cell(size(ub,1),1);
    for i = 1:size(ub,1)
        input{i,1} = linspace(lb(i,1),ub(i,1),n);
    end
    
    examples = combvec(input{:});
end