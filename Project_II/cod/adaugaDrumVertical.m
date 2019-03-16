function [imgMarita] = adaugaDrumVertical(img,drum1)
    outImg = zeros(size(img,1),size(img,2)+1,size(img,3),'uint8');
    for i = 1:size(outImg,1)
        c = drum1(i,1);
        outImg(i,1:c-1,:) = img(i,1:c-1,:);
    end
    linie = zeros(size(img,1),1,3,'uint8');
    for i = 1:size(outImg,1)
        c = drum1(i,1);
        outImg(i,c,1) = (double(img(i,c-1,1))+ double(img(i,c,1))) /2;
        outImg(i,c,2) = (double(img(i,c-1,2))+ double(img(i,c,2))) /2;
        outImg(i,c,3) = (double(img(i,c-1,3))+ double(img(i,c,3))) /2;
        outImg(i,c+1,1) = (double(img(i,c,1))+double(img(i,c+1,1)))/2;
        outImg(i,c+1,2) = (double(img(i,c,2))+double(img(i,c+1,2)))/2;
        outImg(i,c+1,3) = (double(img(i,c,3))+double(img(i,c+1,3)))/2;
        outImg(i,c+2:end,:) = img(i,c+1:end,:);
    end
    imshow(outImg);
    imgMarita = outImg;
end

