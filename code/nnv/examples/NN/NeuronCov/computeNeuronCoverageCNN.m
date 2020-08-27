% Function to compute Neuron Coverage for CNN
function coverage = computeNeuronCoverageCNN(net, activation)

    %disp(net)
    g = [activation];
    coverage = cell(1,net.numLayers);
    
    % Step 1: Iterate over every single layer
    for i = 1:net.numLayers
        
        % Step 1.5: Get values for each layer (can be useful for
        % standardization)
        %set_array = net.reachSet{i};
        %set_length = net.numReachSet(i);
        %cur_layer = Layers(1,i);
        
        % Step 2: Calculate the volume of the sets covered by a given layer
        volume = net.reachSet{i+1}.getStarCoverage();
        
        for j = 1:net.reachSet{1}
            %disp(net.reachSet{i}(1,j))
            volume = volume + net.reachSet{i}(1,j).getStarCoverage();
        end
        
        %disp(volume);
        layerResults = zeros(net.Layers(1,i).N,1);
        
        % Step 2: Iterate over every neuron in the layer
        
        for j = 1:net.Layers(1,i).N
            
            % Step 3: Create a half space with that neuron 
            G = zeros(1, net.Layers(1,i).N);
            G(1, j) = 0;
            
            % Step 4: Use the half space to intersect with the Polytopes by
            % iterating over all of the neurons
            newVol = 0;
            for k = 1:net.numReachSet(i)
                newSet = net.reachSet{i}(1,k).intersectHalfSpace(G,g);
                newVol = newVol + newSet.getStarCoverage();
            end
            
            fprintf('Percent coverage: %.5f for Layer %d, Neuron %d \n', newVol/volume, i,j);
            layerResults(j,1) = newVol/volume;
        end
        
        coverage{1,i} = layerResults;
    end
end

