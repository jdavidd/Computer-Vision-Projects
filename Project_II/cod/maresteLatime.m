function [img] = maresteLatime(img,numarPixeliLatime,metodaSelectareDrum,ploteazaDrum,culoareDrum)

    imgCopy = img;
    matriceDrumuri = zeros(size(img,1),numarPixeliLatime);
    for i = 1:numarPixeliLatime
        E = calculeazaEnergie(imgCopy);

        %alege drumul vertical care conecteaza sus de jos
        drum = selecteazaDrumVertical(E,metodaSelectareDrum);
        %afiseaza drum
        matriceDrumuri(:,i) = drum(:,2);
        if ploteazaDrum
            ploteazaDrumVertical(imgCopy,E,drum,culoareDrum);
            pause(1);
            close(gcf);
        end
        %elimina drumul din imagine
        imgCopy = eliminaDrumVertical(imgCopy,drum);
    end
    imgMarita = img;
    drum1 = matriceDrumuri(:,i);
    imgMarita = adaugaDrumVertical(imgMarita,drum1); 
    for i = 2:numarPixeliLatime
        drum2 = matriceDrumuri(:,i);
        drum = drum2;
        x = find(drum2>drum1);
        drum2(x) = drum2(x) + 1;
        drum1 = drum2;
        imgMarita = adaugaDrumVertical(imgMarita,drum2);
    end
    img = uint8(imgMarita);
end

