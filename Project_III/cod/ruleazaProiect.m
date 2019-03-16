%citeste imaginea
img = imread('../data/vangogh.jpg');
imgt = imread('../data/d.jpg');
%seteaza parametri
parametri.texturaInitiala = img;
parametri.imagine_texturata = imgt;
parametri.dimensiuneTexturaSintetizata = [2*size(img,1) 2*size(img,2)];
parametri.dimensiuneBloc = 36;

parametri.nrBlocuri = 2000;
parametri.nrIteratii = 4;

parametri.eroareTolerata = 0.1;
parametri.portiuneSuprapunere = 1/6;
% parametri.metodaSinteza = 'blocuriAleatoare'; 
% parametri.metodaSinteza = 'eroareSuprapunere';
parametri.metodaSinteza = 'frontieraCostMinim';
parametri.numeImagine = 'Ggb'

% imgSintetizata = realizeazaSintezaTexturii(parametri);
% imagine = strcat(strcat(parametri.numeImagine,'.'),'jpg');
% imwrite(imgSintetizata, imagine);
imgTexturata = transferTextura(parametri);

