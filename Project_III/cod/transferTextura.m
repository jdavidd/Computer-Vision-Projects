function [imgSintetizata] = transferTextura(parametri)


dimBloc = parametri.dimensiuneBloc;
nrBlocuri = parametri.nrBlocuri;
eroare = parametri.eroareTolerata;
[inaltimeTexturaInitiala,latimeTexturaInitiala,nrCanale] = size(parametri.texturaInitiala);
H = inaltimeTexturaInitiala;
W = latimeTexturaInitiala;
c = nrCanale;

[h,w,C] = size(parametri.imagine_texturata);
H2 = parametri.dimensiuneTexturaSintetizata(1);
W2 = parametri.dimensiuneTexturaSintetizata(2);
overlap = parametri.portiuneSuprapunere;

% o imagine este o matrice cu 3 dimensiuni: inaltime x latime x nrCanale
% variabila blocuri - matrice cu 4 dimensiuni: punem fiecare bloc (portiune din textura initiala) 
% unul peste altul 
    dims = [dimBloc dimBloc c nrBlocuri];
    blocuri = uint8(zeros(dims(1), dims(2),dims(3),dims(4)));
    nrIter = parametri.nrIteratii;
    imgTexturata = uint8(zeros(h,w,C));
    distanteX = zeros(1,size(blocuri,4));
    distanteY = zeros(1,size(blocuri,4));
    distanteXY = zeros(1,size(blocuri,4));
    prevDistance = zeros(1,size(blocuri,4));
    suprapunere = floor(overlap*dimBloc);
    tic;      
    imgTexturataMare = uint8(zeros(h,w,C));
    %Numarul de iteratii pt transferul texturii
    %Prima iteratie dureaza in jur de 1 minut pt bloc de dimensiune 36px
    %A doua iteratie 5 minute bloc de 12px
    %A 3 iteratie 10~15 minute bloc de 5px
     for it = 1:nrIter
        nrBlocuriY = ceil((size(imgTexturata,1)-dimBloc)/(dimBloc - suprapunere));
        nrBlocuriX = ceil((size(imgTexturata,2)-dimBloc)/(dimBloc - suprapunere));
        imgIteratie = imgTexturataMare;
        imgTexturataMare = uint8(zeros((nrBlocuriY * (dimBloc - suprapunere)) + dimBloc,(nrBlocuriX * (dimBloc - suprapunere)) + dimBloc,size(parametri.texturaInitiala,3)));
        nrBlocuriY = nrBlocuriY + 1;
        nrBlocuriX = nrBlocuriX + 1;
        [size_x size_y c] = size(imgTexturataMare);
        imgIteratie = imresize(imgIteratie,[size_x size_y]);
        
        alfa = 0.8*(it-1)/(nrIter-1) + 0.1;
        y = randi(H-dimBloc+1,nrBlocuri,1);
        x = randi(W-dimBloc+1,nrBlocuri,1);
        %extrage portiunea din textura initiala continand blocul
        blocuri = [];
        for p = 1:nrBlocuri
            blocuri(:,:,:,p) = parametri.texturaInitiala(y(p):y(p)+dimBloc-1,x(p):x(p)+dimBloc-1,:);
        end
        %imaginea initial, fata de care calculez intensitatea
        imagine = imresize(parametri.imagine_texturata,[size_x size_y]);

        for i = 1:nrBlocuriY
            for j = 1:nrBlocuriX
                startX = (j-1)*(dimBloc - suprapunere) + 1;
                startY = (i-1)*(dimBloc - suprapunere) + 1;
                endX = startX + dimBloc - 1;
                endY = startY + dimBloc - 1;
                
                patchSursa = imagine(startY:endY,startX:endX,:);
                patch = imgIteratie(startY:endY,startX:endX,:);
                if (i == 1 && j == 1)
                    k = randi(nrBlocuri);
                    imgTexturataMare(startY:endY,startX:endX,:) = blocuri(:,:,:,k);
                else
                    if (j > 1)
                        suprapunereImg = imgTexturataMare(startY:endY,startX:startX + suprapunere - 1,:);
                        distanteX = CalculeazaDistanta(blocuri, suprapunereImg, suprapunere,1);
                    end
                    if (i > 1)
                            suprapunereImg = imgTexturataMare(startY:startY + suprapunere - 1,startX:endX,:);
                            distanteY = CalculeazaDistanta(blocuri, suprapunereImg, suprapunere,2);
                    end
                    if ( i > 1 && j > 1)
                         suprapunereImg = imgTexturataMare(startY:startY + suprapunere - 1,startX:startX + suprapunere - 1,:);
                         distanteXY = CalculeazaDistanta(blocuri,suprapunereImg,suprapunere,3);
                    end
                
                    distante = zeros(1,size(blocuri,4));
                    if (j > 1)
                        distante = distante + distanteX;
                    end
                    if (i > 1)
                        distante = distante + distanteY;
                    end
                    if (i > 1 && j > 1)
                        distante = distante - distanteXY;
                    end
                    
                    
                    if (it > 1)
                        prevDistance = CalculeazaDistanta(blocuri,patch, dimBloc, 1);
                    end
                    intensitate = CalculeazaDistanta(blocuri, patchSursa, dimBloc, 1);
                    distante = alfa*(distante + prevDistance) + (1 - alfa)*intensitate;
                    [bestmatch,index] = min(distante);
                   
                    indexes = find(distante < (1 + eroare)*bestmatch);
                    if (size(indexes,2) ~= 0)
                        index = indexes(randi(numel(indexes)));
                    end
                    
                    M = ones(dimBloc,dimBloc);
                    old = imgTexturataMare(startY:endY,startX:endX,:);
                    new = blocuri(:,:,:,index);
                    if ( i > 1 && j > 1)
                        suprapunereImg_x = imgTexturataMare(startY:endY,startX:startX + suprapunere - 1,:);
                        suprapunereImg_y = imgTexturataMare(startY:startY + suprapunere - 1,startX:endX,:);
                        drumx = drum_x(blocuri(:,1:suprapunere,:,index), suprapunereImg_x, suprapunere);
                        drumy = drum_y(blocuri(1:suprapunere,:,:,index), suprapunereImg_y, suprapunere);
                        for k=1:size(M,1)
                            coloana = drumx(k,2);
                            M(k,1:coloana) = 0;
                        end

                        for k=1:size(M,1)
                           coloana = drumy(k,2);
                           M(1:coloana,k) = 0;
                        end
                        imgTexturataMare(startY:endY,startX:endX,:) = (1-M).*double(old) + M.*double(new);
%                         imshow(imgTexturataMare);
                    else if (j >1)
                            suprapunereImg = imgTexturataMare(startY:endY,startX:startX + suprapunere - 1,:);
                            drum = drum_x(blocuri(:,1:suprapunere,:,index), suprapunereImg, suprapunere);
                            for k=1:size(M,1)
                                coloana = drum(k,2);
                                M(k,1:coloana) = 0;
                            end
                            imgTexturataMare(startY:endY,startX:endX,:) = (1-M).*double(old) + M.*double(new);
%                             imshow(imgTexturataMare);
                        else if (i >=  1)
                                suprapunereImg = imgTexturataMare(startY:startY + suprapunere - 1,startX:endX,:);
                                drum = drum_y(blocuri(1:suprapunere,:,:,index), suprapunereImg, suprapunere);
                                 for k=1:size(M,1)
                                    coloana = drum(k,2);
                                    M(1:coloana,k) = 0;
                                 end
                                imgTexturataMare (startY:endY,startX:endX,:) = (1-M).*double(old) + M.*double(new);
%                                 imshow(imgTexturataMare);
                            end
                        end
                    end
                    
                end
            end
        end
        figure();
        imshow(imgTexturataMare);
        dimBloc = floor(dimBloc/3);
        %Daca dimensiunea blocului e foarte mica dureaza foarte mult
        if dimBloc < 5
            dimBloc = 5;
        end
        
        suprapunere = floor(overlap*dimBloc)
        %Daca suprapunearea devine mai mica de 3
        if suprapunere < 3
            suprapunere = 3;
        end 
      
        imgg = strcat(parametri.numeImagine,num2str(it))
        imagine = strcat(strcat(imgg,'.'),'jpg');
        imwrite(imgTexturataMare, imagine);
        timp = toc
     end
        imgSintetizata = imgTexturataMare;
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru blocuri selectatate aleator');
        return
        total = toc
end

