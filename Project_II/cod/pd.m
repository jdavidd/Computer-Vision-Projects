        E = [31 100 65 12 18;
        10 13 47 157 6; 
        100 113 174 11 33; 
        88 124 41 20 140; 
        99 32 111 41 20 ];
         
       % E = [1 3 0;2 8 9;5 2 6]
        d = zeros(size(E,1),2);
        %%
        linia = 1;
        [x, coloana] = min(E(1,:));
        suma = 0;
        suma = suma + x;
        d(1,:) = [linia coloana]
        for i = 2:size(d,1)
            linia = i;
            if d(i-1,2) == 1%pixelul este localizat la marginea din stanga
                %doua optiuni
                t = [E(i,d(i-1,2)) E(i,d(i-1,2)+1)]
                  [x, coloana] = min (t)
                  suma = suma + x;
            elseif d(i-1,2) == size(E,2)%pixelul este la marginea din dreapta
                %doua optiuni
                t  =  [E(i,d(i-1,2)-1) E(i,d(i-1,2))]
                 [x,coloana] = min (t)
             suma = suma + x;
            else
                t = [E(i,d(i-1,2)-1) E(i,d(i-1,2)) E(i,d(i-1,2)+1)]
                 [x, coloana] = min (t)
             suma = suma + x;
            end
            [linia coloana] 
            d(i,:) = [linia coloana];
        end
        suma
        %%
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
        E
        m
        d
        t = 1;
        if t == 1 
            disp('fnb dg')
        end
        