function [img] = amplificaContinut(img,factor,metodaSelectareDrum,...
                            ploteazaDrum,culoareDrum)
    
    [h,w,v] = size(img);
    imgM = imresize(img,factor);

    [H,W,V] = size(imgM);
    numarPixeliLatime = W - w;
    numarPixeliInaltime = H - h;
    imgM = micsoreazaLatime(imgM,numarPixeliLatime,metodaSelectareDrum,...
                          ploteazaDrum,culoareDrum);

    imgM = imrotate(imgM,-90);
    i = micsoreazaLatime(imgM,numarPixeliInaltime,metodaSelectareDrum,...
                            ploteazaDrum,culoareDrum);
    imgM= imrotate(i,90);
    img = imgM;
end

