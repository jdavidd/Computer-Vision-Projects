function [imgMozaic, params] = adaugaPieseMozaicPeCaroiajHexagoane(params)
    tic;
    imgMozaic = uint8(zeros(size(params.imgReferintaRedimensionata)));
    [H,W,C,N] = size(params.pieseMozaic);
    [h,w,c] = size(params.imgReferintaRedimensionata);
     masca = zeros(H,W);
     nrTotalPiese = 74 * params.numarPieseMozaicVerticala;
     nrPieseAdaugate = 0;
     ms = 14;
     md = 27;
     for i = 1:H/2 
         for j = ms:md
             masca(i,j) = 1;
         end
         ms = ms - 1;
         md = md + 1;
     end
     ms = 1;
     md = 40;
     for i = H/2+1:H
         for j = ms:md
             masca(i,j) = 1;
         end
         ms = ms + 1;
         md = md - 1;
     end
     pieseOrizontala = floor(4000/54);
     imgMozaic = zeros(h,w,c);
     dim = size(params.pieseMozaic,4);
     if params.distinct == 0
        %completeaza fara a tine cont de imaginile adiacente
        fprintf('Completeaza fara a tine cont de imagini adiacente.\n');
        if c ~= 1
             %Imagine RGB
             fprintf('Imagine RGB.\n')
             for k = 1:dim
                img = params.pieseMozaic(:,:,:,k);                        
                punct2 = [mean(mean(img(:,:,1))) mean(mean(img(:,:,2))) mean(mean(img(:,:,3)))];
                meansImg(:,:,:,k) = punct2;
             end
             for i = 1:params.numarPieseMozaicVerticala
                 for j = 1:pieseOrizontala
                    bloc = params.imgReferintaRedimensionata((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14,:);
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
                    r =  masca.*params.pieseMozaic(:,:,:,indice) + (1-masca).*imgMozaic((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14,:);
                    imgMozaic((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14,:) = r;
                    nrPieseAdaugate = nrPieseAdaugate+1;
                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese/2);
                end
             end
             for i = 1:params.numarPieseMozaicVerticala-1
                 for j = 1:pieseOrizontala-1
                    bloc = params.imgReferintaRedimensionata((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1,:);
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

                    r =  masca.*params.pieseMozaic(:,:,:,indice) + (1-masca).*imgMozaic((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1,:);
                    imgMozaic((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1,:) = r;
                    nrPieseAdaugate = nrPieseAdaugate+1;
                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese/2);
                end
             end
             imgMozaic = uint8(imgMozaic(1:h-H/2,1:w-W/2,:));
             params.timpExecutie = toc;
        else
            %Imagine monocromatica
            fprintf('Imagine monocromatica.\n');
            meansImg = [];
            for k = 1:dim
                img = rgb2gray(uint8(params.pieseMozaic(:,:,:,k)));                        
                punct2 = [mean(mean(img))];
                meansImg(k) = punct2;
            end
            for i = 1:params.numarPieseMozaicVerticala
             for j = 1:pieseOrizontala
                bloc = params.imgReferintaRedimensionata((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14);
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
                r =  masca.*double(rgb2gray(uint8(params.pieseMozaic(:,:,:,indice))))+(1-masca).*imgMozaic((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14);
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14) = r;
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese/2);
            end
            end
            for i = 1:params.numarPieseMozaicVerticala-1
                     for j = 1:pieseOrizontala-1
                        bloc = params.imgReferintaRedimensionata((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1);
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

                    r =  masca.*double(rgb2gray(uint8(params.pieseMozaic(:,:,:,indice)))) + (1-masca).*imgMozaic((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1);
                    imgMozaic((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1,:) = r;
                    nrPieseAdaugate = nrPieseAdaugate+1;
                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese/2);
                end
             end
            imgMozaic = uint8(imgMozaic(1:h-H/2,1:w-W/2,:));
            params.timpExecutie = toc;    
        end
     else
         matricepiese = zeros(params.numarPieseMozaicVerticala,2*pieseOrizontala);
         %Imagine cu hexagoane disticte
         fprintf('Imagine cu hexagoane distincte\n');
         if c ~= 1
             %Imagine RGB
             fprintf('Imagine RGB\n');
             for k = 1:dim
                img = params.pieseMozaic(:,:,:,k);                        
                punct2 = [mean(mean(img(:,:,1))) mean(mean(img(:,:,2))) mean(mean(img(:,:,3)))];
                meansImg(:,:,:,k) = punct2;
             end
             for i = 1:params.numarPieseMozaicVerticala
                 for j = 1:pieseOrizontala
                    bloc = params.imgReferintaRedimensionata((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14,:);
                    punct1 = [mean(mean(bloc(:,:,1))) mean(mean(bloc(:,:,2))) mean(mean(bloc(:,:,3)))]; 
                    mindist = 999999;
                    indice = 1;
                    ok = 0;
                    k = dim;
                    meansImg1 = meansImg;
                    while (ok == 0)
                        while (k > 0)                    
                            punct2 = meansImg1(:,:,:,k); 
                            distanta = sqrt( (punct1(1)-punct2(1))^2 + (punct1(2)-punct2(2))^2 + (punct1(3)-punct2(3))^2 );
                            if(mindist > distanta)
                                mindist = distanta;
                                indice = k;
                            end
                            k = k - 1;
                        end
                        if(i == 1)
                            ok = 1;
                        else if(matricepiese(i-1,2*(j-1)+1) ~= indice)
                                ok = 1;
                            else
                                meansImg1(:,:,:,indice) = Inf;
                                k = dim;
                                mindist = 999999;
                            end
                        end
                    end
                    matricepiese(i,2*(j-1)+1) = indice;
                    r =  masca.*params.pieseMozaic(:,:,:,indice) + (1-masca).*imgMozaic((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14,:);
                    imgMozaic((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14,:) = r;
                    nrPieseAdaugate = nrPieseAdaugate+1;
                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese/2);
                end
             end
             for i = 1:params.numarPieseMozaicVerticala-1
                 for j = 1:pieseOrizontala-1
                    bloc = params.imgReferintaRedimensionata((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1,:);
                    punct1 = [mean(mean(bloc(:,:,1))) mean(mean(bloc(:,:,2))) mean(mean(bloc(:,:,3)))]; 
                    mindist = 999999;
                    indice = 1;
                    ok = 0;
                    k = dim;
                    meansImg1 = meansImg;
                    while (ok == 0)
                        while (k > 0)                    
                            punct2 = meansImg1(:,:,:,k); 
                            distanta = sqrt( (punct1(1)-punct2(1))^2 + (punct1(2)-punct2(2))^2 + (punct1(3)-punct2(3))^2 );
                            if(mindist > distanta)
                                mindist = distanta;
                                indice = k;
                            end
                            k = k - 1;
                        end
                        if (i==1)
                            if((matricepiese(i,2*(j-1)+1) ~= indice) && (matricepiese(i+1,2*(j-1)+1) ~= indice) && (matricepiese(i,2*j+1) ~= indice) && (matricepiese(i+1,2*j+1) ~= indice))
                                ok = 1;
                            else
                                meansImg1(:,:,:,indice) = Inf;
                                k = dim;
                                mindist = 999999;
                            end
                        else
                            if( (matricepiese(i-1,2*j) ~= indice) && (matricepiese(i,2*(j-1)+1) ~= indice) && (matricepiese(i+1,2*(j-1)+1) ~= indice) && (matricepiese(i,2*j+1) ~= indice) && (matricepiese(i+1,2*j+1) ~= indice))
                                ok = 1;
                            else
                                meansImg1(:,:,:,indice) = Inf;
                                k = dim;
                                mindist = 999999;
                            end
                        end
                    end
                    matricepiese(i,2*j) = indice;
                    r =  masca.*params.pieseMozaic(:,:,:,indice) + (1-masca).*imgMozaic((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1,:);
                    imgMozaic((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1,:) = r;
                    nrPieseAdaugate = nrPieseAdaugate+1;
                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese/2);
                end
             end
             imgMozaic = uint8(imgMozaic(1:h-H/2,1:w-W/2,:));
             params.timpExecutie = toc;
         else
             %Imagine monocromatica
             fprintf('Imagine monocromatica.\n');
             for k = 1:dim
                img = rgb2gray(uint8(params.pieseMozaic(:,:,:,k)));                        
                punct2 = [mean(mean(img))];
                meansImg(k) = punct2;
             end
             for i = 1:params.numarPieseMozaicVerticala
                 for j = 1:pieseOrizontala
                    bloc = params.imgReferintaRedimensionata((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14);
                    punct1 = [mean(mean(bloc))];                     
                    mindist = 999999;
                    indice = 1;
                    ok = 0;
                    k = dim;
                    meansImg1 = meansImg;
                    while (ok == 0)
                        while (k > 0)                    
                            punct2 = meansImg1(k); 
                            distanta = sqrt( (punct1(1)-punct2(1))^2); 
                            if(mindist > distanta)
                                mindist = distanta;
                                indice = k;
                            end
                            k = k - 1;
                        end
                        if(i == 1)
                            ok = 1;
                        else if(matricepiese(i-1,2*(j-1)+1) ~= indice)
                                ok = 1;
                            else
                                meansImg1(indice) = Inf;
                                k = dim;
                                mindist = 999999;
                            end
                        end
                    end
                    matricepiese(i,2*(j-1)+1) = indice;
                    r =  masca.*params.pieseMozaic(:,:,:,indice) + (1-masca).*imgMozaic((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14);
                    imgMozaic((i-1)*H+1:i*H,(j-1)*W+1+(j-1)*14:j*W+(j-1)*14) = rgb2gray(uint8(r));
                    nrPieseAdaugate = nrPieseAdaugate+1;
                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese/2);
                end
             end
             for i = 1:params.numarPieseMozaicVerticala-1
                 for j = 1:pieseOrizontala-1
                    bloc = params.imgReferintaRedimensionata((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1);
                    punct1 = [mean(mean(bloc))]; 
                    mindist = 999999;
                    indice = 1;
                    ok = 0;
                    k = dim;
                    meansImg1 = meansImg;
                    while (ok == 0)
                        while (k > 0)                    
                            punct2 = meansImg1(k); 
                            distanta = sqrt( (punct1(1)-punct2(1))^2); 
                            if(mindist > distanta)
                                mindist = distanta;
                                indice = k;
                            end
                            k = k - 1;
                        end
                        if (i==1)
                            if((matricepiese(i,2*(j-1)+1) ~= indice) && (matricepiese(i+1,2*(j-1)+1) ~= indice) && (matricepiese(i,2*j+1) ~= indice) && (matricepiese(i+1,2*j+1) ~= indice))
                                ok = 1;
                            else
                                meansImg1(indice) = Inf;
                                k = dim;
                                mindist = 999999;
                            end
                        else
                            if( (matricepiese(i-1,2*j) ~= indice) && (matricepiese(i,2*(j-1)+1) ~= indice) && (matricepiese(i+1,2*(j-1)+1) ~= indice) && (matricepiese(i,2*j+1) ~= indice) && (matricepiese(i+1,2*j+1) ~= indice))
                                ok = 1;
                            else
                                meansImg1(indice) = Inf;
                                k = dim;
                                mindist = 999999;
                            end
                        end
                    end
                    matricepiese(i,2*j) = indice;
                    r =  masca.*params.pieseMozaic(:,:,:,indice) + (1-masca).*imgMozaic((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1);
                    imgMozaic((i-1)*H+H/2+1:i*H+H/2,(j-1)*W+28+(j-1)*14:j*W+28+(j-1)*14-1) = rgb2gray(uint8(r));
                    nrPieseAdaugate = nrPieseAdaugate+1;
                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese/2);
                end
             end
             imgMozaic = uint8(imgMozaic(1:h-H/2,1:w-W/2,:));
             params.timpExecutie = toc;     
         end
     end
end

