function coverage = singleInputCoverage(net, x, activation)

    % first perform the layer by layer analysis
    results = cell(1,net.nL);
    y = x; 
    for i=1:net.nL
        %disp(y)
        y = net.Layers(i).evaluate(y);
        results{1,i} = y;
    end

    % analyze the coverage
    coverage = cell(size(results));
    for i = 1:size(results,2)
        %disp(results{1,i})
        coverage{1,i} = results{1,i}>activation;
    end
end