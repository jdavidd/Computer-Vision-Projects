function E = calculeazaEnergie(img)
%calculeaza energia la fiecare pixel pe baza gradientului
%input: img - imaginea initiala
%output: E - energia

%urmati urmatorii pasi:
%transformati imaginea in grayscale
%folositi un filtru sobel pentru a calcula gradientul in directia x si y
%calculati magnitudinea gradientului
%E - energia = gradientul imaginii

%completati aici codul vostru
fx = [-1 0 1;
     -2 0 2;
     -1 0 1];
 fy = [1 2 1;
       0 0 0;
       -1 -2 -1];
img = double(rgb2gray(img));
dx = imfilter(img,fx);
dy = imfilter(img,fy);
E = abs(dx) + abs(dy);

end