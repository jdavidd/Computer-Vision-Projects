function d = selecteazaDrumVertical(E,metodaSelectareDrum)
%selecteaza drumul vertical ce minimizeaza functia cost calculate pe baza lui E
%
%input: E - energia la fiecare pixel calculata pe baza gradientului
%       metodaSelectareDrum - specifica metoda aleasa pentru selectarea drumului. Valori posibile:
%                           'aleator' - alege un drum aleator
%                           'greedy' - alege un drum utilizand metoda Greedy
%                           'programareDinamica' - alege un drum folosind metoda Programarii Dinamice
%
%output: d - drumul vertical ales

d = zeros(size(E,1),2);

switch metodaSelectareDrum
    case 'aleator'
        %pentru linia 1 alegem primul pixel in mod aleator
        linia = 1;
        %coloana o alegem intre 1 si size(E,2)
        coloana = randi(size(E,2));
        %punem in d linia si coloana coresponzatoare pixelului
        d(1,:) = [linia coloana];
        for i = 2:size(d,1)
            %alege urmatorul pixel pe baza vecinilor
            %linia este i
            linia = i;
            %coloana depinde de coloana pixelului anterior
            if d(i-1,2) == 1%pixelul este localizat la marginea din stanga
                %doua optiuni
                optiune = randi(2)-1;%genereaza 0 sau 1 cu probabilitati egale 
            elseif d(i-1,2) == size(E,2)%pixelul este la marginea din dreapta
                %doua optiuni
                optiune = randi(2) - 2; %genereaza -1 sau 0
            else
                optiune = randi(3)-2; % genereaza -1, 0 sau 1
            end
            coloana = d(i-1,2) + optiune;%adun -1 sau 0 sau 1: 
                                         % merg la stanga, dreapta sau stau pe loc
            d(i,:) = [linia coloana];
        end
    case 'greedy'
        %completati aici codul vostru
        linia = 1;
        [~, coloana] = min(E(1,:)); 
        d(1,:) = [linia coloana];
        for i = 2:size(d,1)
            linia = i;
            if d(i-1,2) == 1%pixelul este localizat la marginea din stanga
                %doua optiuni
                t = [E(i,d(i-1,2)) E(i,d(i-1,2)+1)];
                  [x, coloana] = min (t);
                 
            elseif d(i-1,2) == size(E,2)%pixelul este la marginea din dreapta
                %doua optiuni
                t  =  [E(i,d(i-1,2)-1) E(i,d(i-1,2))];
                 [x,coloana] = min (t);
            else
                t = [E(i,d(i-1,2)-1) E(i,d(i-1,2)) E(i,d(i-1,2)+1)];
                 [x, coloana] = min (t);
            end
            d(i,:) = [linia coloana];
        end
   
    case 'programareDinamica'
        %completati aici codul vostru
        m = zeros(size(E,1),size(E,2));
        m(1,:) = E(1,:);
        for i = 2:size(m,1)
            for j = 1:size(m,2)
                if j == 1
                    t = [m(i-1,j) m(i-1,j+1)];
                    m(i,j) = double(E(i,j)) + min (t) ;
                end
                if j == size(m,2)
                    t = [m(i-1,j-1) m(i-1,j)];
                    m(i,j) = double(E(i,j)) + min(t);
                end
                if j > 1 && j < size(m,2)
                    t = [m(i-1,j-1) m(i-1,j) m(i-1,j+1)];
                    m(i,j) = double(E(i,j))+ min(t);  
                end
            end
        end
       % m 
        [v,j]= min(m(size(m,1),:));
        d(size(m,1),:) = [size(m,1) j];
        i = size(m,1);
        ok = 0;
        k = 0;
        while(i > 1)
             if j == 1
                t = [m(i-1,j) m(i-1,j+1)];
                ok = 1;
             end
             if j == size(m,2)
                t = [m(i-1,j-1) m(i-1,j)];
                ok = 2;
             end
             if j > 1 && j < size(m,2)
                t = [m(i-1,j-1) m(i-1,j) m(i-1,j+1)];
                ok = 0;
             end
             v = min(t);
             if ok == 1
                 if v == m(i-1,j)
                     k = j;
                 end
                 if v == m(i-1,j+1)
                     k = j+1;
                 end
                 ok = -1;
             end
             if ok == 2
                 if v == m(i-1,j)
                     k = j;
                 end
                 if v == m(i-1,j-1)
                     k = j-1;
                 end
                 ok = -1;
             end
             if ok == 0 
                 if v == m(i-1,j)
                     k = j;
                 end
                 if v == m(i-1,j-1)
                     k = j-1;
                 end
                 if v == m(i-1,j+1)
                     k = j+1;
                 end
             end           
             d(i-1,:) = [i-1 k];
             j = k;            
             i = i - 1 ;
        end
    otherwise
        error('Optiune pentru metodaSelectareDrum invalida');
end

end