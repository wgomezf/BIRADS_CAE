function I = impreproc(I)
    I = single(I); % Convert to single datatype
    I = imresize(I,[128,128]); % Resize to 128x128 px
    I = rescale(I); % Normalize to range [0,1]
end