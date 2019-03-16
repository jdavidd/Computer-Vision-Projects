function [imgMozaic, params] = construiesteMozaic(params)
    %functia principala a proiectului
    %primeste toate datele necesare in structura params


    %incarca toate imaginile mici = piese folosite pentru mozaic
    params = incarcaPieseMozaic(params);

    %calculeaza noile dimensiuni ale mozaicului
    params = calculeazaDimensiuniMozaic(params);

    %adauga piese mozaic
    switch params.modAranjare
        case 'caroiaj'
            if params.hexagon
                [imgMozaic,params] = adaugaPieseMozaicPeCaroiajHexagoane(params);
            else
                [imgMozaic,params] = adaugaPieseMozaicPeCaroiaj(params);
            end
        case 'aleator'
            [imgMozaic,params] = adaugaPieseMozaicModAleator(params);

end