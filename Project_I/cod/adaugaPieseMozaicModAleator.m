function [imgMozaic,params] = adaugaPieseMozaicModAleator(params)

    imgMozaic = uint8(zeros(size(params.imgReferintaRedimensionata)));
    [H,W,C,N] = size(params.pieseMozaic);
    [h,w,c] = size(params.imgReferintaRedimensionata);
    imgMozaic = zeros(h+H,w+W,c);
    pixeliOcupati = zeros(h+H,w+W) + 1;
    pixeliOcupati((H/2+1) : end-H/2, (W/2 + 1):end-W/2) = 0;
    nrTotalPiese = h*w;
    switch(params.criteriu)
        case 'aleator'
           i = 0;
           ind = 0;
           prag = 1;
           tic;
            while(prag == 1)
                lrand = randi(h);
                crand = randi(w);
                indice = randi(N);
                if c ~= 1
                    imgMozaic(lrand + 1:lrand + H,crand + 1:crand + W,:) = params.pieseMozaic(:,:,:,indice);
                    pixeliOcupati(lrand + 1:lrand + H,crand + 1:crand + W) = 1;
                else
                    imgMozaic(lrand + 1:lrand + H,crand + 1:crand + W,:) = rgb2gray(uint8(params.pieseMozaic(:,:,:,indice)));
                    pixeliOcupati(lrand + 1:lrand + H,crand + 1:crand + W) = 1;
                end
                if(i == 1000)
                    completare = size(find( pixeliOcupati((H/2+1) : end-H/2, (W/2 + 1):end-W/2) == 1), 1);
                    procent = floor((100*completare/nrTotalPiese)*100)/100;
                    if ( procent == params.procentCompletare )
                        prag = 0;                     
                    end
                    fprintf('Construim mozaic cu piese alese aleator ... %2.2f%% \n',100*completare/nrTotalPiese);
                i = 0;
                end
              i = i + 1;
              ind = ind + 1;
            end
            params.timpExecutie = toc;
            imgMozaic = uint8(imgMozaic(H/2:end,W/2:end,:));
            
            case 'distantaCuloareMedie'
               %Idee
               %Initial 95-99%% din imagine sau cat este dat ca parametru prin
               %campul procentCompletare este completat random fara a se
               %tine cont daca pixelul este deja ocupat
               %Restul de pixeli pana la 100% sunt completati cu find 
               dim = size(params.pieseMozaic,4);
               if c ~= 1 %Imaginea este RGB
                   imgMozaic = zeros(h,w,c);
                   pixeliOcupati = zeros(h,w);
                   for k = 1:dim
                       img = params.pieseMozaic(:,:,:,k);                        
                       punct2 = [mean(mean(img(:,:,1))) mean(mean(img(:,:,2))) mean(mean(img(:,:,3)))];
                       meansImg(:,:,:,k) = punct2;
                   end
                   i = 0;
                   ind = 0;
                   prag = 1;
                   tic;
                    while(prag == 1)
                        lrand = randi(h);
                        crand = randi(w);
                        if (lrand + H > h)
                            lrand = h - H + 1;
                            end
                        if (crand + W > w)
                            crand = w - W + 1;
                       end
                        x = 0;
                        while( (pixeliOcupati(lrand, crand) == 1) && (x < 2))
                            lrand = randi(h);
                            crand = randi(w);
                            if (lrand + H > h)
                                lrand = h - H + 1;
                            end
                            if (crand + W > w)
                                crand = w - W + 1;
                            end
                        x = x + 1;
                        end
                        bloc = params.imgReferintaRedimensionata(lrand:lrand + H - 1,crand:crand + W - 1,:);
                        punct1 = [mean(mean(bloc(:,:,1))) mean(mean(bloc(:,:,2))) mean(mean(bloc(:,:,3)))]; 
                        mindist = 999999;
                        indice = 1;
                        for k = 1:dim                     
                            punct2 = meansImg(:,:,:,k); 
                            distanta = sqrt( (punct1(1)-punct2(1))^2 + (punct1(2)-punct2(2))^2 + (punct1(3)-punct2(3))^2 );
                            if(mindist > distanta)
                                mindist = distanta;
                                indice = k;
                            end
                        end
                        imgMozaic(lrand:lrand + H - 1,crand:crand + W - 1,:) = params.pieseMozaic(:,:,:,indice);
                        pixeliOcupati(lrand:lrand + H - 1,crand:crand + W - 1) = 1;
                        if(i == 1000)
                            completare = size(find(pixeliOcupati == 1), 1);
                            procent = round((100*completare/nrTotalPiese)*100)/100;
                            if ( procent >= params.procentCompletare )
                                prag = 0;       
                            end
                         fprintf('Construim mozaic ... %2.2f%% \n',100*completare/nrTotalPiese);
                         ind = ind + i;
                         i = 0;  
                        end
                        i = i + 1;   
                    end
                   %Restul de 5% completez cu find
                   prag = 1;
                   while(prag == 1)
                       [l,c] = find(pixeliOcupati == 0);
                       if (size(l,1) > 0)
                           if(size(l,1) > 1000)
                               t = 1;
                               indiciL = [];
                               indiciC = [];
                               while (t < 101)
                                   indexr = randi(numel(l));
                                   indiciL(t) = l(indexr);
                                   if (indiciL(t) + H > h)
                                        indiciL(t) = h - H + 1;
                                   end
                                   indiciC(t) = c(indexr);
                                   if (indiciC(t) + W > w)
                                       indiciC(t) = w - W + 1;
                                   end
                                   t = t + 1;
                               end
                           else
                                t = 1;
                                indiciL = [];
                                indiciC = [];
                                indexr = randi(numel(l));
                                indiciL(t) = l(indexr);
                                if (indiciL(t) + H > h)
                                      indiciL(t) = h - H + 1;
                                end
                                indiciC(t) = c(indexr);
                                if (indiciC(t) + W > w)
                                    indiciC(t) = w - W + 1;
                                end
                           end
                       end
                       d = size(indiciL,2);
                       for ix = 1:d
                        bloc = params.imgReferintaRedimensionata(indiciL(ix):indiciL(ix) + H - 1,indiciC(ix):indiciC(ix) + W - 1,:);
                        punct1 = [mean(mean(bloc(:,:,1))) mean(mean(bloc(:,:,2))) mean(mean(bloc(:,:,3)))]; 
                        mindist = 999999;
                        indice = 1;
                        for k = 1:dim                     
                            punct2 = meansImg(:,:,:,k); 
                            distanta = sqrt( (punct1(1)-punct2(1))^2 + (punct1(2)-punct2(2))^2 + (punct1(3)-punct2(3))^2 );
                            if(mindist > distanta)
                                mindist = distanta;
                                indice = k;
                            end
                        end
                        imgMozaic(indiciL(ix):indiciL(ix) + H - 1,indiciC(ix):indiciC(ix) + W - 1,:) = params.pieseMozaic(:,:,:,indice);
                        pixeliOcupati(indiciL(ix):indiciL(ix) + H - 1 ,indiciC(ix):indiciC(ix) + W - 1) = 1;
                       end
                        if(i == 25)
                            completare = size(find(pixeliOcupati == 1), 1);
                            procent = round((100*completare/nrTotalPiese)*100)/100;
                            if ( completare == nrTotalPiese)
                                prag = 0;       
                            end
                         fprintf('Construim mozaic ... %2.2f%% \n',procent);
                         ind = ind + i;
                         i = 0;  
                        end
                        i = i + 1;
                   end
                   fprintf("Mozaic complet");
                   params.timpExecutie = toc;
                   imgMozaic = uint8(imgMozaic(H:end,W:end,:));
                 
               else %Imaginiea este monocromatica
                   dim = size(params.pieseMozaic,4);
                   imgMozaic = zeros(h,w,c);
                   pixeliOcupati = zeros(h,w);
                   meansImg = [];   
                   for k = 1:dim
                       img = rgb2gray(uint8(params.pieseMozaic(:,:,:,k)));                        
                       punct2 = [mean(mean(img))];
                       meansImg(k) = punct2;
                   end
                   i = 0;
                   ind = 0;
                   prag = 1;
                   tic;
                   while(prag == 1)
                        lrand = randi(h);
                        crand = randi(w);
                        if (lrand + H > h)
                            lrand = h - H + 1;
                            end
                        if (crand + W > w)
                            crand = w - W + 1;
                        end
                        x = 0;
                        %Caut alta pozitie daca este ocupata dar de un nr
                        %limitat de ori
                        while( (pixeliOcupati(lrand, crand) == 1) && (x < 10))
                            lrand = randi(h);
                            crand = randi(w);
                            if (lrand + H > h)
                            lrand = h - H + 1;
                            end
                            if (crand + W > w)
                                crand = w - W + 1;
                            end
                        x = x + 1;
                        end    
                    bloc = params.imgReferintaRedimensionata(lrand:lrand + H - 1,crand:crand + W - 1);
                    punct1 = [mean(mean(bloc))]; 
                    mindist = 999999;
                    indice = 1;
                    for k = 1:dim                      
                        punct2 = meansImg(k); 
                        distanta = sqrt( (punct1(1)-punct2(1))^2);
                        if(mindist > distanta)
                            mindist = distanta;
                            indice = k;
                        end
                    end
                    imgMozaic(lrand:lrand + H - 1,crand:crand + W - 1) = rgb2gray(uint8(params.pieseMozaic(:,:,:,indice)));
                    pixeliOcupati(lrand:lrand + H - 1,crand:crand + W - 1) = 1;
                    if (i == 1000)
                        completare = size(find(pixeliOcupati == 1), 1);
                        procent = round((100*completare/nrTotalPiese)*100)/100;
                        if ( procent >= params.procentCompletare )
                            prag = 0;       
                        end
                     fprintf('Construim mozaic ... %2.2f%% \n',100*completare/nrTotalPiese);
                         ind = ind + i;
                         i = 0;  
                    end
                    i = i + 1;
                   end
               %Restul de 0.05% completez cu find
               prag = 1;
               while(prag == 1)
                   [l,c] = find(pixeliOcupati == 0);
                   if (size(l,1) > 0)
                       indexr = randi(numel(l));
                       lrand = l(indexr);
                       crand = c(indexr);
                   end
                   if (lrand + H > h)
                        lrand = h - H + 1;
                   end
                   if (crand + W > w)
                        crand = w - W + 1;
                   end
                   bloc = params.imgReferintaRedimensionata(lrand:lrand + H - 1,crand:crand + W - 1);
                   punct1 = [mean(mean(bloc))]; 
                   mindist = 999999;
                   indice = 1;
                    for k = 1:dim                     
                        punct2 = meansImg(k); 
                        distanta = sqrt( (punct1(1)-punct2(1))^2);
                        if(mindist > distanta)
                            mindist = distanta;
                            indice = k;
                        end
                    end
                    imgMozaic(lrand:lrand + H - 1,crand:crand + W - 1) = rgb2gray(uint8(params.pieseMozaic(:,:,:,indice)));
                    pixeliOcupati(lrand:lrand + H - 1,crand:crand + W - 1) = 1;
                    if(i == 250)
                        completare = size(find(pixeliOcupati == 1), 1);
                        procent = round((100*completare/nrTotalPiese)*100)/100;
                        if ( completare == nrTotalPiese || params.STOP == 1 )
                            prag = 0;       
                        end
                     fprintf('Construim mozaic ... %2.2f%% \n',procent);
                     ind = ind + i;
                     i = 0;  
                    end
                i = i + 1;
               end
               fprintf("Mozaic complet \n");
               params.timpExecutie = toc;
               imgMozaic = uint8(imgMozaic(H:end,W:end,:));
          end
   otherwise
    fprintf('EROARE, optiune necunoscuta \n');
end