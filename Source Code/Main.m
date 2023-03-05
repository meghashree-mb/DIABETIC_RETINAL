% -- Clear Commands  -- %

clear All;
close All;
clc;
warning off;

% -- Getting Input File -- %

[f,p] = uigetfile('*.*');

if f == 0
    
    warndlg('You Have Cancelled.....');
    
else

I = imread([p f]);

figure('name','Input image');

imshow(I);  % Display input image

title('Input Image','FontName','Times New Roman');
end

%---split&merge---%

Th = graythresh(rgb2gray(I));

BG = im2bw(I,Th);

figure('name','BS');

imshow(BG);  % Display input image

title('BS Image','FontName','Times New Roman');


I = imresize(I,[256 256]);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
BG = imresize(BG,[256 256]);

for ii = 1:size(I,1)
    for jj = 1:size(I,2)
        if BG(ii,jj) == 1
            OUT(ii,jj,1) = 0;
            OUT(ii,jj,2) = 0;
            OUT(ii,jj,3) = 0;
        elseif BG(ii,jj) == 0
            OUT(ii,jj,1) = R(ii,jj);
            OUT(ii,jj,2) = G(ii,jj);
            OUT(ii,jj,3) = B(ii,jj);
        end    

    end
end


figure('name','BS image');

imshow(uint8(OUT));  % Display input image

title('BS Image','FontName','Times New Roman');


% -- Image Resize -- %

row = 256;

col = 256;

Resize = imresize(I,[row col]);

figure('name','Resized image');

imshow(Resize);  % Display resized image

title('Resized Image','FontName','Times New Roman');

% -- Noise Filtering -- %

fmat = 3;    % Filter size

flevel = 0.5;      % Smoothening level

IM = fspecial('gaussian',fmat,flevel);

Filt = imfilter(Resize,IM);

figure('name','Filtered image');

imshow(Filt);  % Display filtered image

title('Filtered Image','FontName','Times New Roman');

% -- Chanel Seperation -- %

% channel seperation
red = 1; 
green = 2;
blue = 3;

R = Filt(:,:,red);

G = Filt(:,:,green);

B = Filt(:,:,blue);


figure('name','R - G - B');

subplot(1,3,1);

imshow(R);  

title('Red Band Image','FontName','Times New Roman');

subplot(1,3,2);

imshow(G);  

title('Green Band Image','FontName','Times New Roman');

subplot(1,3,3);

imshow(B);  

title('Blue Band Image','FontName','Times New Roman');


% -- Feature Extraction -- % 


%---colour feature---%

color = colorAutoCorrelogram(Filt);
figure('Name','Colour features');
color = color(1:64);
cf2 = uitable('data',color);


% -- GLCM Texture Feature -- %

GLCM2 = graycomatrix(R,'Offset',[2 0;0 2]);

stats = glcm(GLCM2,0);

v1=stats.autoc(1);
v2=stats.contr(1);
v3=stats.corrm(1);
v4=stats.corrp(1);
v5=stats.cprom(1);
v6=stats.cshad(1);
v7=stats.dissi(1);
v8=stats.energ(1);
v9=stats.entro(1);
v10=stats.homom(1);
v11=stats.homop(1);
v12=stats.maxpr(1);

Glcmfea = [v1 v2 v3 v4 v5 v6 v7];
figure('Name','texture features');
td5 = uitable('data',Glcmfea);

load Target
load Trainfea
% load Trainfea2

%--Shape feature---%


Rval1 = regionprops(im2bw(Filt),'EquivDiameter'); 
Rval2 = regionprops(im2bw(Filt),'MinorAxisLength'); 
Rval3 = regionprops(im2bw(Filt),'Area');

Rval4 = regionprops(im2bw(Filt),'MajorAxisLength');
Rval5 = regionprops(im2bw(Filt),'Perimeter');
Rval6 = regionprops(im2bw(Filt),'FilledArea');
Rval7 = regionprops(im2bw(Filt),'FilledImage');
Rval8 = regionprops(im2bw(Filt),'Extent');


R1 = Rval1(1,1).EquivDiameter;
R2 = Rval2(1,1).MinorAxisLength;
R3 = Rval3(1,1).Area;
R4 = Rval4(1,1).MajorAxisLength;
R5 = Rval5(1,1).Perimeter;
R6 = Rval6(1,1).FilledArea;
R7 = Rval7(1,1).FilledImage;
R7 = mean(mean(R7));
R8= Rval8(1,1).Extent;

RPval = [R1 R2 R3 R4 R5 R6 R7 R8];
figure('Name','Shapefeatures');
td2 = uitable('data',RPval);

Testfea = [Glcmfea color RPval]; 

figure('Name','Test features');
td = uitable('data',Testfea);
save Testfea Testfea
%---Train feature---%

figure('Name','Trainfeatures');
td3 = uitable('data',Trainfea);

%---Target---%

figure('Name','Target');
td4 = uitable('data',Target);

% fv1 = [ color , GLCM2 ];

%--Feature reduction--%
[COEFF, SCORE, LATENT] = pca(Trainfea);

v=LATENT;
% covarianceMatrix = cov(Trainfea2);
% [V,D] = eig(covarianceMatrix);
% 
% reducedDimension = COEF(:,1:14);
% reducedData = Trainfea2 * reducedDimension;
figure('Name','PCA Feature Reduction');

td5 = uitable('data',v);
%feature vector 

% %y = x;
% %z = 0*y;
% myVector = zeros(N+1,1);
% 
% for n= 0:N
%     z = z+1+2.*n;
%     myVector(n+1) = z;
% end

 %--classification--%
load('Target.mat')
load('Testfea.mat')
load('Trainfea.mat')

% Put the test features into variable 'test'

 Yc= multisvm(Trainfea,Target,Testfea);

if Yc == 1
    msgbox('Identified Fruit type "Apple" by NN classification');    
elseif Yc == 2
   msgbox('Identified Fruit type "Graphes"by NN classification');

elseif Yc == 3
    msgbox('Identified Fruit type "Bosc Pears"by NN classification');
 
elseif Yc == 4
    msgbox('Identified Fruit type "Banana"by NN classification');
    
elseif Yc == 5
    msgbox('Identified Fruit type "Blackberries"by NN classification');
   
elseif Yc == 6
    msgbox('Identified Fruit type "Blue berries"by NN classification');

elseif Yc == 7
    msgbox('Identified Fruit type "Anjou Pears"by NN classification');

elseif Yc == 8
    msgbox('Identified Fruit type "Cantaloupes"by NN classification');

elseif Yc == 9
    msgbox('Identified Fruit type "Guava"by NN classification');

elseif Yc == 10
    msgbox('Identified Fruit type "Avocados"by NN classification');

 elseif Yc == 11
    msgbox('Identified Fruit type "Mango"by NN classification');
 
elseif Yc == 12
    msgbox('Identified Fruit type "orange"by NN classification');
  
elseif Yc == 13
    msgbox('Identified Fruit type "Pappaya"by NN classification');

elseif Yc == 14
    msgbox('Identified Fruit type "Passion fruits"by NN classification');
  
elseif Yc == 15
    msgbox('Identified Fruit type "Pineapple"by NN classification');

elseif Yc == 16
    msgbox('Identified Fruit type "Pomegranate"by NN classification');

elseif Yc == 17
    msgbox('Identified Fruit type "Strawberry"by NN classification');
    
elseif Yc == 18
    msgbox('Identified Fruit type "watermelon"by NN classification');
    end  

 % -- Performance Analysis (NN) -- %
% 

Actual = Trainfea(:,79);
Predicted = Actual;
figure,
plotconfusion(Actual,Target');
