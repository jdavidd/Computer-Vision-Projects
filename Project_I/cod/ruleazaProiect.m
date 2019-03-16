%proiect REALIZAREA DE MOZAICURI

%seteaza parametri pentru functie

%citeste imaginea care va fi transformata in mozaic
%puteti inlocui numele imaginii
params.imgReferinta = imread('../data/imaginiTest/bmw.jpg');
%seteaza directorul cu imaginile folosite la realizarea mozaicului
%puteti inlocui numele directorului
params.numeDirector = '../data/cifar/masini/';

params.tipImagine = 'png';
params.bloc = [];
%seteaza numarul de piese ale mozaicului pe orizontala
%puteti inlocui aceasta valoare
params.numarPieseMozaicOrizontala = 150;
params.numarPieseMozaicVerticala = 0;
params.indexes = [];
%numarul de piese ale mozaicului pe verticala va fi dedus automat

%seteaza optiunea de afisare a pieselor mozaicului dupa citirea lor din
%director
params.afiseazaPieseMozaic = 0;

%procent completare mozaic aleator complet random [95-99] 
%dupa procentul selectat restul de (100 - procent) este completat cu find
%de pixeli necompletati
%Depinzand de dim imag completarea in mod ALEATOR poate tine 1-3 MINUTE
params.procentCompletare = 99; 
%seteaza modul de aranjare a pieselor mozaicului
%optiuni: 'aleator','caroiaj'
params.modAranjare = 'aleator';
%seteaza criteriul dupa care realizeze mozaicul
%optiuni: 'aleator','distantaCuloareMedie'
params.criteriu = 'distantaCuloareMedie';
%Completare cu piese adiacente distincte 1 DA, 0 NU
params.distinct = 1;
%Completare cu hexagoane 1 fara 0
params.hexagon = 0;
params.timpExecutie = 0;
params.numeMozaic = 'bmw_caroiaj_distinct'

%%
%apeleaza functia principala
[imgMozaic,params] = construiesteMozaic(params);
imagine = strcat(strcat(params.numeMozaic,'.'),'jpg');
imwrite(imgMozaic, imagine);
figure
imshow(imgMozaic);
fprintf('Mozaicul a fost creat in %.2f secunde . ',params.timpExecutie);