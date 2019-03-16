function imgSintetizata = realizeazaSintezaTexturii(parametri)

dimBloc = parametri.dimensiuneBloc;
nrBlocuri = parametri.nrBlocuri;
eroare = parametri.eroareTolerata;
[inaltimeTexturaInitiala,latimeTexturaInitiala,nrCanale] = size(parametri.texturaInitiala);
H = inaltimeTexturaInitiala;
W = latimeTexturaInitiala;
c = nrCanale;

H2 = parametri.dimensiuneTexturaSintetizata(1);
W2 = parametri.dimensiuneTexturaSintetizata(2);
overlap = parametri.portiuneSuprapunere;

% o imagine este o matrice cu 3 dimensiuni: inaltime x latime x nrCanale
% variabila blocuri - matrice cu 4 dimensiuni: punem fiecare bloc (portiune din textura initiala) 
% unul peste altul 
dims = [dimBloc dimBloc c nrBlocuri];
blocuri = uint8(zeros(dims(1), dims(2),dims(3),dims(4)));

%selecteaza blocuri aleatoare din textura initiala
%genereaza (in maniera vectoriala) punctul din stanga sus al blocurilor
y = randi(H-dimBloc+1,nrBlocuri,1);
x = randi(W-dimBloc+1,nrBlocuri,1);
%extrage portiunea din textura initiala continand blocul
for i =1:nrBlocuri
    blocuri(:,:,:,i) = parametri.texturaInitiala(y(i):y(i)+dimBloc-1,x(i):x(i)+dimBloc-1,:);
end

imgSintetizata = uint8(zeros(H2,W2,c));
nrBlocuriY = ceil(size(imgSintetizata,1)/dimBloc);
nrBlocuriX = ceil(size(imgSintetizata,2)/dimBloc);
imgSintetizataMaiMare = uint8(zeros(nrBlocuriY * dimBloc,nrBlocuriX * dimBloc,size(parametri.texturaInitiala,3)));

switch parametri.metodaSinteza
    
    case 'blocuriAleatoare'
        %%
        %completeaza imaginea de obtinut cu blocuri aleatoare
        for y=1:nrBlocuriY
            for x=1:nrBlocuriX
                indice = randi(nrBlocuri);
                imgSintetizataMaiMare((y-1)*dimBloc+1:y*dimBloc,(x-1)*dimBloc+1:x*dimBloc,:)=blocuri(:,:,:,indice);
                imshow(imgSintetizataMaiMare);
            end
        end
        
        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru blocuri selectatate aleator');
        return

    
    case 'eroareSuprapunere'
        %%
        %completeaza imaginea de obtinut cu blocuri ales in functie de eroare de suprapunere
        nrBlocuriY = ceil((size(imgSintetizata,1)-dimBloc)/(dimBloc - 6));
        nrBlocuriX = ceil((size(imgSintetizata,2)-dimBloc)/(dimBloc - 6));
        imgSintetizataMaiMare = uint8(zeros((nrBlocuriY * (dimBloc - 6)) + dimBloc,(nrBlocuriX * (dimBloc - 6)) + dimBloc,size(parametri.texturaInitiala,3)));
        nrBlocuriY = nrBlocuriY + 1;
        nrBlocuriX = nrBlocuriX + 1;
        suprapunere = floor(overlap*dimBloc);
        distanteX = zeros(1,size(blocuri,4));
        distanteY = zeros(1,size(blocuri,4));
        distanteXY = zeros(1,size(blocuri,4));
      
        for i = 1:nrBlocuriY
            for j = 1:nrBlocuriX
                startX = (j-1)*(dimBloc - suprapunere) + 1;
                startY = (i-1)*(dimBloc - suprapunere) + 1;
                endX = startX + dimBloc - 1;
                endY = startY + dimBloc - 1;
                if (i == 1 && j == 1)
                    k = randi(nrBlocuri);
                    imgSintetizataMaiMare(startY:endY,startX:endX,:) = blocuri(:,:,:,k);
                else
                    if (j > 1)
                        suprapunereImg = imgSintetizataMaiMare(startY:endY,startX:startX + suprapunere - 1,:);
                        distanteX = CalculeazaDistanta(blocuri, suprapunereImg, suprapunere,1);
                    end
                    if (i > 1)
                            suprapunereImg = imgSintetizataMaiMare(startY:startY + suprapunere - 1,startX:endX,:);
                            distanteY = CalculeazaDistanta(blocuri, suprapunereImg, suprapunere,2);
                    end
                    if ( i > 1 && j > 1)
                         suprapunereImg = imgSintetizataMaiMare(startY:startY + suprapunere - 1,startX:startX + suprapunere - 1,:);
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

                    [bestmatch,index] = min(distante);
                   
                    indexes = find(distante < (1 + eroare)*bestmatch);
                    if (size(indexes,2) ~= 0)
                        index = indexes(randi(numel(indexes)));
                    end
                    imgSintetizataMaiMare(startY:endY,startX:endX,:) = blocuri(:,:,:,index);
                    imshow(imgSintetizataMaiMare);
                end
                 
            end
        end
        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru blocuri selectatate aleator');
        return
                
	case 'frontieraCostMinim'
        %
        %completeaza imaginea de obtinut cu blocuri ales in functie de eroare de suprapunere + forntiera de cost minim
        nrBlocuriY = ceil((size(imgSintetizata,1)-dimBloc)/(dimBloc - 6));
        nrBlocuriX = ceil((size(imgSintetizata,2)-dimBloc)/(dimBloc - 6));
        imgSintetizataMaiMare = uint8(zeros((nrBlocuriY * (dimBloc - 6)) + dimBloc,(nrBlocuriX * (dimBloc - 6)) + dimBloc,size(parametri.texturaInitiala,3)));
        nrBlocuriY = nrBlocuriY + 1;
        nrBlocuriX = nrBlocuriX + 1;
        suprapunere = floor(overlap*dimBloc);
        distanteX = zeros(1,size(blocuri,4));
        distanteY = zeros(1,size(blocuri,4));
        distanteXY = zeros(1,size(blocuri,4));
       
        for i = 1:nrBlocuriY
            for j = 1:nrBlocuriX
                startX = (j-1)*(dimBloc - suprapunere) + 1;
                startY = (i-1)*(dimBloc - suprapunere) + 1;
                endX = startX + dimBloc - 1;
                endY = startY + dimBloc - 1;
                if (i == 1 && j == 1)
                    k = randi(nrBlocuri);
                    imgSintetizataMaiMare(startY:endY,startX:endX,:) = blocuri(:,:,:,k);
                else
                    if (j > 1)
                        suprapunereImg = imgSintetizataMaiMare(startY:endY,startX:startX + suprapunere - 1,:);
                        distanteX = CalculeazaDistanta(blocuri, suprapunereImg, suprapunere,1);
                    end
                    if (i > 1)
                            suprapunereImg = imgSintetizataMaiMare(startY:startY + suprapunere - 1,startX:endX,:);
                            distanteY = CalculeazaDistanta(blocuri, suprapunereImg, suprapunere,2);
                    end
                    if ( i > 1 && j > 1)
                         suprapunereImg = imgSintetizataMaiMare(startY:startY + suprapunere - 1,startX:startX + suprapunere - 1,:);
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

                    [bestmatch,index] = min(distante);
                   
                    indexes = find(distante < (1 + eroare)*bestmatch);
                    if (size(indexes,2) ~= 0)
                        index = indexes(randi(numel(indexes)));
                    end
                    
                    M = ones(dimBloc,dimBloc);
                    old = imgSintetizataMaiMare(startY:endY,startX:endX,:);
                    new = blocuri(:,:,:,index);
                    if ( i > 1 && j > 1)
                        suprapunereImg_x = imgSintetizataMaiMare(startY:endY,startX:startX + suprapunere - 1,:);
                        suprapunereImg_y = imgSintetizataMaiMare(startY:startY + suprapunere - 1,startX:endX,:);
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
                        imgSintetizataMaiMare(startY:endY,startX:endX,:) = (1-M).*double(old) + M.*double(new);
                    else if (j >1)
                            if j == 1
                                imgSintetizataMaiMare(startY:endY,startX:endX,:) = new;
                            else
                            suprapunereImg = imgSintetizataMaiMare(startY:endY,startX:startX + suprapunere - 1,:);
                            drum = drum_x(blocuri(:,1:suprapunere,:,index), suprapunereImg, suprapunere);
                            for k=1:size(M,1)
                                coloana = drum(k,2);
                                M(k,1:coloana) = 0;
                            end
                            imgSintetizataMaiMare(startY:endY,startX:endX,:) = (1-M).*double(old) + M.*double(new);
                            end
                        else if (i >=  1)
                                suprapunereImg = imgSintetizataMaiMare(startY:startY + suprapunere - 1,startX:endX,:);
                                drum = drum_y(blocuri(1:suprapunere,:,:,index), suprapunereImg, suprapunere);
                                 for k=1:size(M,1)
                                    coloana = drum(k,2);
                                    M(1:coloana,k) = 0;
                                 end
                                imgSintetizataMaiMare (startY:endY,startX:endX,:) = (1-M).*double(old) + M.*double(new);
                            end
                        end
                    end
                    
                end
            end
        end
        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru blocuri selectatate aleator');
        return
        
       
end
       
    
