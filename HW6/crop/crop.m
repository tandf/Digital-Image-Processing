for index = 1 : 3
    path = [num2str(index), 'crop\'];

    files = dir(fullfile([path '*.jpg']));
    fileslength = length(files);

    for i = 1 : fileslength

        imgfullpath = strcat(path, files(i).name);
        img = im2double(imread(imgfullpath));
        R = img(:, :, 1);
        G = img(:, :, 2);
        B = img(:, :, 3);

        mask = (G ./ (R + G + B) > 0.46);

        % 对蒙版做闭操作，去除背景中的杂点
        se=strel('disk',3);
        mask=imclose(mask,se);
        % 对蒙版做开操作，补全人体部分的空洞
        se=strel('disk',9);
        mask=imopen(mask,se);

        R(mask) = 0;
        G(mask) = 0;
        B(mask) = 0;
        masked = img;
        masked(:, :, 1) = R;
        masked(:, :, 2) = G;
        masked(:, :, 3) = B;

        imwrite(masked, ['result\', path, files(i).name]);

    end
end
