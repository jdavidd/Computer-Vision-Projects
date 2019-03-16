function [distanta] = CalculeazaDistanta(blocuri,suprapunereImg,suprapunere,d)

    distanta = zeros(1,size(blocuri,4));
    if (d == 1)
        for i = 1:size(blocuri,4)
            distanta(i) = dis(suprapunereImg,blocuri(:,1:suprapunere,:,i));
        end
    end
    if (d == 2)
        for i = 1:size(blocuri,4)
            distanta(i) = dis(suprapunereImg,blocuri(1:suprapunere,:,:,i));
        end
    end
    if (d == 3)
        for i = 1:size(blocuri,4)
            distanta(i) = dis(suprapunereImg,blocuri(1:suprapunere,1:suprapunere,:,i));
        end
    end
    
end
