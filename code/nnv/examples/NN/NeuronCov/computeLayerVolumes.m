%%% A function that will iterate over every computed reachable layer and
%%% compute their volumes
function volumes = computeLayerVolumes(net)

    volumes = zeros(1,net.nL);
    % Step 1: Iterate over every single layer
    for i = 1:net.nL
        
        % Step 2: Calculate the volume of the sets covered by a given layer
        volume = 0.0; 
        numReachSet = size(net.reachSet{1,i}, 2);
   
        for j = 1:numReachSet
            %disp(net.reachSet{i}(1,j))
            newAdd = net.reachSet{i}(1,j).getStarCoverage();
            volume = volume + newAdd;
        end

        fprintf('Final Volume: %f.5\n', volume);     
        volumes(1,i) = volume;
    end
end