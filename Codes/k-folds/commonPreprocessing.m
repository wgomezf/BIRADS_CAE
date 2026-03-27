function dataOut = commonPreprocessing(data)
    dataOut = cell(size(data));
    for col = 1:size(data,2)
        for idx = 1:size(data,1)
            if col < size(data,2)
                temp = single(data{idx,col});
                temp = imresize(temp,[128,128]);
                temp = rescale(temp);
                dataOut{idx,col} = temp;
            else
                dataOut{idx,col} = data{idx,col};
            end
        end
    end
end