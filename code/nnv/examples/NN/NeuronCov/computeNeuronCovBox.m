function coverage = computeNeuronCovBox(net,activation)
    g = [activation];
    coverage = cell(1,net.nL);
    
    % Step 1: Iterate over every single layer
    for i = 1:net.nL
        
        lay = tic;
        % Step 2: Calculate the volume of the sets covered by a given layer
        volume = 0.0;
        numReachSet = size(net.reachSet{1,i}, 2);      
        for j = 1:numReachSet
            volume = volume + net.reachSet{i}(1,j).computeBoxSize();
        end
        
        layerResults = zeros(net.Layers(1,i).N,2);
        %{
        % Step 3: Iterate over every neuron in the layer
        for j = 1:net.Layers(1,i).N
            
            % Step 4: Create a half space with that neuron 
            st = tic;
            G = zeros(1, net.Layers(1,i).N);
            G(1, j) = 1;

            % Step 5: Use the half space to intersect with the Polytopes by
            % iterating over all of the neurons
            newVol = 0;
            emptySet = 0;
            for k = 1:numReachSet
                newSet = net.reachSet{i}(1,k).intersectHalfSpace(G,g);
                
                if(isempty(newSet))
                    emptySet = emptySet + 1;
                else
                    newVol = newVol + newSet.getStarCoverage();
                end
            end
            t1 = toc(st);

            layerResults(j,1) = (volume - newVol)/volume;
            layerResults(j,2) = t1;
            %fprintf('Percent coverage: %.5f for Layer %d, Neuron %d Time:%.5f Empty Sets: %d\n', layerResults(j,1), i,j, layerResults(j,2), emptySet);
        end
        %}
        
        t2 = toc(lay);
        fprintf('Done with layer: %d Time: %.4f\n', i, t2);
        coverage{1,i} = layerResults;
    end
end

