function output = makeTable(coverage)

    names = cell(1,size(coverage,2));
    theMax = 0;
    for i = 1:size(coverage,2)
        names{1,i} = strcat('Layer ', num2str(i));
        
        theMax = max(theMax, size(coverage{1,i},1));
    end
    
    disp(names);
    disp(size(coverage));
    disp(size(names));
    T = table();
    
    for i = 1:size(coverage,2)
        row = zeros(theMax, 1);
        curSize = size(coverage{1,i},1);
        row(1:curSize,1) = coverage{1,i}(:,1);
        T = addvars(T, row);
    end
    T.Properties.VariableNames = names;
    output = T;
end

