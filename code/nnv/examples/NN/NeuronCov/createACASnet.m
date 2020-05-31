function [network] = createACASnet(filename)
    %CREATEACASNET Takes the file name for an ACASXu network stored in .mat
    %file and returns a FFNN object created from the file
    load(filename, 'W', 'b', 'means_for_scaling', 'range_for_scaling');
    Layers = [];
    n = length(b);
    for i=1:n - 1
        bi = cell2mat(b(i));
        Wi = cell2mat(W(i));
        Li = Layer(Wi, bi, 'ReLU');
        Layers = [Layers Li];
    end
    bn = cell2mat(b(n));
    Wn = cell2mat(W(n));
    Ln = Layer(Wn, bn, 'Linear');

    Layers = [Layers Ln];
    network = FFNN(Layers);
end

