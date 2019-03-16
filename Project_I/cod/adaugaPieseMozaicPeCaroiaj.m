function [imgMozaic, params] = adaugaPieseMozaicPeCaroiaj(params)
%
%tratati si cazul in care imaginea de referinta este gri (are numai un canal)

imgMozaic = uint8(zeros(size(params.imgReferintaRedimensionata)));
[H,W,C,N] = size(params.pieseMozaic);
[h,w,c] = size(params.imgReferintaRedimensionata);

switch(params.criteriu)
case 'aleator'
    %pune o piese aleatoare in mozaic, nu tine cont de nimic
    tic;
    nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
    nrPieseAdaugate = 0;
    for i =1:params.numarPieseMozaicVerticala
        for j=1:params.numarPieseMozaicOrizontala
            %alege un indice aleator din cele N
            indice = randi(N);
            if c ~= 1
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indice);
            else
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = rgb2gray(uint8(params.pieseMozaic(:,:,:,indice)));
            end
            nrPieseAdaugate = nrPieseAdaugate+1;
            fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
        end
    end
    params.timpExecutie = toc;
case 'distantaCuloareMedie'
    %Completeaza dupa distanta euclidiana
    tic;
    meansImg = [];   
    nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
    nrPieseAdaugate = 0;
    ind = 0;
    dim = size(params.pieseMozaic,4);
if params.distinct == 0
    %completeaza fara a tine cont de imaginile adiacente
    fprintf('Completeaza fara a tine cont de imagini adiacente.\n');
    if c ~= 1
        %Imagine RGB
        fprintf('Imagine RGB.\n');
        for k = 1:dim
        img = params.pieseMozaic(:,:,:,k);                        
        punct2 = [mean(mean(img(:,:,1))) mean(mean(img(:,:,2))) mean(mean(img(:,:,3)))];
        meansImg(:,:,:,k) = punct2;
        end
         for i =1:params.numarPieseMozaicVerticala
            ind = ind + 1;
            for j=1:params.numarPieseMozaicOrizontala
                bloc = params.imgReferintaRedimensionata((i-1)*H+1:i*H,(j-1)*W+1:j*W,:);
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
              imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indice);
              nrPieseAdaugate = nrPieseAdaugate+1;
              fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                end
             end
             params.timpExecutie = toc;
    else
            %Imagine monocromatica
            fprintf('Imagine monocromatica.\n');
            tic;
            nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
            nrPieseAdaugate = 0;
            ind = 0;
            meansImg = [];   
            for k = 1:dim
                img = rgb2gray(uint8(params.pieseMozaic(:,:,:,k)));                        
                punct2 = [mean(mean(img))];
                meansImg(k) = punct2;
            end
            for i =1:params.numarPieseMozaicVerticala
                ind = ind + 1;
                for j=1:params.numarPieseMozaicOrizontala
                    bloc = params.imgReferintaRedimensionata((i-1)*H+1:i*H,(j-1)*W+1:j*W);
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
                    imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W) = rgb2gray(uint8(params.pieseMozaic(:,:,:,indice)));
                    nrPieseAdaugate = nrPieseAdaugate+1;
                    fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                end
            end
         params.timpExecutie = toc;   
        end
else
      %Completeaza cu imaginia adiacente distincte
      fprintf('Completare cu imagini adiacenta distincte. \n');
      tic;
      if c ~= 1
        %Imagine RGB
        fprintf('Imagine RGB');
        meansImg = [];   
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        ind = 0;
        imaginiFolosite = zeros( params.numarPieseMozaicVerticala + 1,params.numarPieseMozaicOrizontala + 1);
        for k = 1:dim
            img = params.pieseMozaic(:,:,:,k);                        
            punct2 = [mean(mean(img(:,:,1))) mean(mean(img(:,:,2))) mean(mean(img(:,:,3)))];
            meansImg(:,:,:,k) = punct2;
        end
        for i = 2:params.numarPieseMozaicVerticala + 1
           ind = ind + 1;
            for j = 2:params.numarPieseMozaicOrizontala + 1
                bloc = params.imgReferintaRedimensionata((i-2)*H+1:(i-1)*H,(j-2)*W+1:(j-1)*W,:);
                punct1 = [mean(mean(bloc(:,:,1))) mean(mean(bloc(:,:,2))) mean(mean(bloc(:,:,3)))]; 
                mindist = 999999;
                indice = 1;
                ok = 0;
                meansImg1 = meansImg;
                dim = size(params.pieseMozaic,4);
                k = dim;
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
                    if(imaginiFolosite(i-1,j) ~= indice && imaginiFolosite(i,j-1) ~= indice)
                            ok = 1;
                    else
                        meansImg1(:,:,:,indice) = Inf;
                        k = dim;
                        mindist = 999999;
                    end
                end
          imaginiFolosite(i,j) = indice;
          imgMozaic((i-2)*H+1:(i-1)*H,(j-2)*W+1:(j-1)*W,:) = params.pieseMozaic(:,:,:,indice);
          nrPieseAdaugate = nrPieseAdaugate+1;
          fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
        end
      end
      params.timpExecutie = toc;
      else
        %Imagine monocromatica
        fprintf('Imagine monocromatica. \n');
        tic;
        imaginiFolosite = zeros( params.numarPieseMozaicVerticala + 1,params.numarPieseMozaicOrizontala + 1);
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        ind = 0;
        meansImg = [];
        dim = size(params.pieseMozaic,4);
        for k = 1:dim
            img = rgb2gray(uint8(params.pieseMozaic(:,:,:,k)));                        
            punct2 = [mean(mean(img))];
            meansImg(k) = punct2;
        end
        for i =2:params.numarPieseMozaicVerticala+1
            ind = ind + 1;
            for j=2:params.numarPieseMozaicOrizontala+1
                bloc = params.imgReferintaRedimensionata((i-2)*H+1:(i-1)*H,(j-2)*W+1:(j-1)*W);
                punct1 = [mean(mean(bloc))]; 
                mindist = 999999;
                meansImg1 = meansImg;
                dim = size(params.pieseMozaic,4);
                k = dim;
                ok = 0;
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
                    if(imaginiFolosite(i-1,j) ~= indice && imaginiFolosite(i,j-1) ~= indice)
                            ok = 1;
                    else
                        meansImg1(indice) = Inf;
                        dim = dim - 1;
                        k = dim;
                        mindist = 999999;
                    end
                end
                imaginiFolosite(i,j) = indice;
                imgMozaic((i-2)*H+1:(i-1)*H,(j-2)*W+1:(j-1)*W) = rgb2gray(uint8(params.pieseMozaic(:,:,:,indice)));
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
            end
        end
        params.timpExecutie = toc;   
      end
    end
otherwise
    fprintf('EROARE, optiune necunoscuta \n');
end





