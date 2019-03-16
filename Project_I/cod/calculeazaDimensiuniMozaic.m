function params = calculeazaDimensiuniMozaic(params)
    %calculeaza dimensiunile mozaicului
    %obtine si imaginea de referinta redimensionata avand aceleasi dimensiuni
    %ca mozaicul

    %completati codul Matlab
    img = params.imgReferinta;
    x = size(img,1);
    y = size(img,2);
    ratio = y / x;
    img = params.pieseMozaic(:,:,:,1);
    l = size(img, 1);
    L = size(img, 2);
    %calculeaza automat numarul de piese pe verticala
    params.numarPieseMozaicVerticala = floor( (params.numarPieseMozaicOrizontala*L / ratio)/l );
   %t =  floor( (params.numarPieseMozaicOrizontala*40 / ratio)/28 )
   %calculeaza si imaginea de referinta redimensionata avand aceleasi dimensiuni ca mozaicul
   params.imgReferintaRedimensionata = imresize(params.imgReferinta,[params.numarPieseMozaicVerticala*l,params.numarPieseMozaicOrizontala*L])
end