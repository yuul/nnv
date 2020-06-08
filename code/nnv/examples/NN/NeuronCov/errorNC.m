function [error] = errorNC(volume, testing)

    volArray = volume{1,1}(:,1);
    testArray = testing{1,1};
    
    for i = 2:size(volume,2)
        volArray = vertcat(volArray, volume{1,i}(:,1));
        testArray = vertcat(testArray, testing{1,i});
    end

    % compute the root mean square error
    error = sqrt(mean((volArray - testArray).^2));
end