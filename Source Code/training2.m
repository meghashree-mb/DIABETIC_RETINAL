[f,p] = uigetfile('*.*');
if f == 0
    warndlg('You Have Cancelled.....');
else
I = imread([p f]);
end

I=imresize(I,[256,256]);
%figure,imshow(I);title('Input image');
%title('Input image','FontName','Times New Roman');
I4 = imadjust(I,[.2 .5 0; .6 .6 1],[]);
I5 = imresize(I4,[256,256]);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
figure,imshow(R);
se = strel('disk',15);
afterOpening = imopen(R,se);
figure,imshow(afterOpening);
se = strel('disk',20);
closeBW = imclose(afterOpening,se);
figure, imshow(closeBW);
NI=imadjust(closeBW,[0.7 1.0]);
 figure, imshow(NI);
 GL=im2bw(NI);
  figure, imshow(GL);
figure,imshow(I5);title(' Contrast Enhanced ');
cform = colorspace('Lab<-RGB',I5);
% Apply the colorform
lab_he = cform;
% Classify the colors in a*b* colorspace using K means clustering.
% Since the image has 3 colors create 3 clusters.
% Measure the distance using Euclidean Distance Metric.
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 3;
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
%[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
% Label every pixel in tha image using results from K means
pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure,imshow(pixel_labels,[]), title('Image Labeled by Cluster Index');

% Create a blank cell array to store the results of clustering
segmented_images = cell(1,3);
% Create RGB label using pixel_labels
rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    colors = I5;
    colors(rgb_label ~= k) = 0;
    segmented_images{k} = colors;
end
figure,subplot(2,3,2);imshow(I5);title('Original Image'); subplot(2,3,4);imshow(segmented_images{1});title('Cluster 1'); subplot(2,3,5);imshow(segmented_images{2});title('Cluster 2');
subplot(2,3,6);imshow(segmented_images{3});title('Cluster 3');
set(gcf, 'Position', get(0,'Screensize'));
set(gcf, 'name','Segmented by K Means', 'numbertitle','off')
% Feature Extraction
pause(2)
x = inputdlg('Enter the cluster no. containing the ROI only:');
i = str2double(x);
% Extract the features from the segmented image
seg_img = segmented_images{i};
%figure,imshow(seg_img);title('clustured image');
%title('clustured image','FontName','Times New Roman');
bin_img=im2bw(seg_img);
figure,imshow(bin_img);
bin_img=imcomplement(bin_img);
bin_img=GL+bin_img;
figure,imshow(bin_img);
bin_img = 255 * repmat(uint8(bin_img), 1, 1, 3);
fin_img=I+bin_img;
I=fin_img;
figure,imshow(fin_img);


% -- Image Resize -- %

row = 256;

col = 256;

Resize = imresize(I,[row col]);

% figure('name','Resized image');

% imshow(Resize);  % Display resized image

% title('Resized Image','FontName','Times New Roman');

% -- Noise Filtering -- %

fmat = 3;    % Filter size

flevel = 0.5;      % Smoothening level

IM = fspecial('gaussian',fmat,flevel);

Filt = imfilter(Resize,IM);

% channel seperation
red = 1; 
green = 2;
blue = 3;

R = Filt(:,:,red);

G = Filt(:,:,green);

B = Filt(:,:,blue);


% -- Feature Extraction -- %
% figure('Name','Colour features');
%---colour feature---%

color = colorAutoCorrelogram(Filt);
% figure('Name','Colour features');
color = color(1:64);
% cf2 = uitable('data',color);

if ndims(Filt) == 3
   R = rgb2gray(Filt);
else
    R=Filt;
end


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

Trainfea = [Glcmfea color RPval]

% load('Target.mat')
% load('Testfea.mat')
% load('Trainfea.mat')
% 
% % Put the test features into variable 'test'
% 
%  Yc= multisvm(Trainfea,Target,Testfea);
%  
% if Yc == 1
%     msgbox('Identified Fruit type "Stage 1" by SVM classification');    
% elseif Yc == 2
%    msgbox('Identified Fruit type "Stage 2"by SVM classification');
% elseif Yc == 3
%     msgbox('Identified Fruit type "Stage 3"by SVM classification');
% elseif Yc == 4
%     msgbox('Identified Fruit type "Stage 4"by SVM classification');
%     end  
% close all
