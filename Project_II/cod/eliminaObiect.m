function [imgf] = eliminaObiect(img,metodaSelectareDrum,...
                            ploteazaDrum,culoareDrum)
    
    imshow(img);
    fereastra = getrect;
    xmin = fereastra(1);
    ymin = fereastra(2);
    w = fereastra(3);
    h = fereastra(4);
    xmax = xmin + w;
    ymax = ymin + h;
    if h  < w 
      for i = 1:h
        E = calculeazaEnergie(img);
        Einf = zeros(size(E));
        Einf(ymin:ymax,xmin:xmax) = (-10)^5;
        E = E + Einf;
        E = rot90(E,-1);
        drum = selecteazaDrumVertical(E,metodaSelectareDrum);
        if ploteazaDrum
            ploteazaDrumVertical(imrotate(img,-90),E,drum,culoareDrum);
            pause(1);
            close(gcf);
        end
        img = eliminaDrumVertical(imrotate(img,-90),drum);
        img = imrotate(img,90);
        ymax = ymax - 1;
      end
    else
      for i = 1:w
        E = calculeazaEnergie(img);
        Einf = zeros(size(E));
        Einf(ymin:ymax,xmin:xmax) = (-10)^5;
        E = E + Einf;
        drum = selecteazaDrumVertical(E,metodaSelectareDrum);
        if ploteazaDrum
            ploteazaDrumVertical(img,E,drum,culoareDrum);
            pause(1);
            close(gcf);
        end
        img = eliminaDrumVertical(img,drum);
        xmax = xmax - 1;
      end
    end
        imshow(img);
        imgf = img;
end

