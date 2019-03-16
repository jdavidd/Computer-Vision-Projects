 function [distanta] = dis(suprapunereImg,blocuri)
                       
    suprapunereImg = double(suprapunereImg);
    blocuri = double(blocuri);
        
    E = (double(suprapunereImg(:) - blocuri(:))).^2;
    distanta  = sum(E);
end

