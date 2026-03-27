function dataOut = augmentImages(data)
    dataOut = cell(size(data));
    for idx = 1:size(data,1)
        ImIn  = data{idx,1};
        ImOut = data{idx,2};
        Label = data{idx,3};
        if rand > 0.25
            tform = randomAffine2d("Scale",[0.8,1.2],"XTranslation",[-10 10],"YTranslation",[-10 10],"Rotation",[-10,10],"XReflection",true,"YReflection",true);
            outputView = affineOutputView([128 128 1],tform);
            ImIn = imwarp(ImIn,tform,OutputView=outputView); 
            ImOut = imwarp(ImOut,tform,OutputView=outputView); 
        end
        if rand > 0.25
            g = 0.5 + rand;
            ImIn = imadjust(ImIn,[],[],g);
            ImOut = imadjust(ImOut,[],[],g);
        end
        dataOut(idx,:) = {ImIn,ImOut,Label};
    end
end