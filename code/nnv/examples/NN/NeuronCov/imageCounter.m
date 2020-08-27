function count = imageCounter(IStar,colorDepth)
    %%% This function takes an ImageStar and the color depth of the image
    %%% It returns the number of images included in the imagestar using the L infinity norm
    
    if isEmpty(IStar.LB) || isEmpty(IStar.UB)
    else
        upper = floor(IStar.UB * colorDepth);
        lower = ceil(IStar.LB * colorDepth);
        count = prod(upper - lower);
    end
end

