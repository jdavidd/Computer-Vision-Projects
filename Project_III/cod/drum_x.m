function [drum] = drum_x(blocuri, suprapunereImg, suprapunere)


    bloc = blocuri(:,1:suprapunere,:);
    suprapunereImg = double(suprapunereImg);
    blocuri = double(blocuri);
    E = (double(suprapunereImg - blocuri)).^2;
    E = E(:,:,1) + E(:,:,2) + E(:,:,3);
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
    x = 1;
    drum = d;
end

