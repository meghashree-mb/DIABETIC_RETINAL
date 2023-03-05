function varargout = Main_gui(varargin)
% MAIN_GUI MATLAB code for Main_gui.fig
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main_gui

% Last Modified by GUIDE v2.5 06-May-2020 21:41:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Main_gui is made visible.
function Main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main_gui (see VARARGIN)

% Choose default command line output for Main_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I f p I2
% -- Getting Input File -- %

[f,p] = uigetfile('*.*');

if f == 0
    
    warndlg('You Have Cancelled.....');
    
else

I = imread([p f]);
I2=I;

% figure('name','Input image');
I=imresize(I,[256,256]);
axes(handles.axes7);

imshow(I);  % Display input image

title('Input Image','FontName','Times New Roman');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7




% --- Executes on button press in checkbox2.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
global Filt color
color = colorAutoCorrelogram(Filt);
% figure('Name','Colour features');
color = color(1:64);

 set(handles.uitable1,'data',color);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I5  seg_img

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

axes(handles.axes2);

imshow(seg_img);  

title('ROI','FontName','Times New Roman');



% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
global Filt Glcmfea

if ndims(Filt) == 3
   R = rgb2gray(Filt);
else
    
  R = Filt;
end

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
 set(handles.uitable1,'data',Glcmfea);


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6

global Glcmfea  color RPval Testfea Trainfea Target v td td1 td2
load Target
load Trainfea

Testfea = [Glcmfea color RPval ]; 

figure('Name','Test features');
td = uitable('data',Testfea);
save Testfea Testfea

%---Train feature---%

figure('Name','Trainfeatures');
td1 = uitable('data',Trainfea);

%---Target---%

figure('Name','Target');
td2 = uitable('data',Target);

%--Feature reduction--%
[COEFF, SCORE, LATENT] = pca(Trainfea);

v=LATENT;

 set(handles.uitable2,'data',v);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Testfea trainset Trainfea Target Yc
load('Target.mat')
load('Testfea.mat')
load('Trainfea.mat')

% Put the test features into variable 'test'

 svmtrain= fitcecoc(Trainfea,Target);
 Yc=predict(svmtrain,Testfea);
 
if Yc == 1
    msgbox('Identified Diabetic Retinal diseases type "Stage 1" by SVM classification');    
elseif Yc == 2
   msgbox('Identified Diabetic Retinal diseases type "Stage 2"by SVM classification');
elseif Yc == 3
    msgbox('Identified Diabetic Retinal diseases type "Stage 3"by SVM classification');
elseif Yc == 4
    msgbox('Identified Diabetic Retinal diseases type "Stage 4"by SVM classification');
    end  

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Testfea trainset Trainfea Target Yc
load confusiondata.mat
R = randperm(30,29);
S=confusiondata(R,1:82);
T=S(:,1:80);
Actual =S(:,81);
Predicted = S(:,82);
Results = confusionmat(Actual,Predicted)
set(handles.uitable4,'data',Results );
stage1=Results(1)
stage2=Results(6)
stage3=Results(11)
stage4=Results(16)

total=stage1+stage2+stage3+stage4;
accuracy=total/30;
accuracyper=accuracy*100;
set(handles.edit1,'string',accuracyper);
% figure,
% plotconfusion(Actual',Predicted');
 

% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in checkbox7.


% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I2
HSV = rgb2hsv(I2);
Heq = histeq(HSV(:,:,3));
HSV_mod = HSV;
HSV_mod(:,:,3) = Heq;

RGB = hsv2rgb(HSV_mod);
figure,subplot(1,2,1),imshow(I2);title('Before Histogram Equalization');

       subplot(1,2,2),imshow(RGB);title('After Histogram Equalization');
       %DISPLAY THE HISTOGRAM OF THE ORIGINAL AND THE EQUALIZED IMAGE

HIST_IN = zeros([256 3]);
HIST_OUT = zeros([256 3]);


%http://angeljohnsy.blogspot.com/2011/06/histogram-of-image.html
%HISTOGRAM OF THE RED,GREEN AND BLUE COMPONENTS

HIST_IN(:,1) = imhist(I2(:,:,1),256); %RED
HIST_IN(:,2) = imhist(I2(:,:,2),256); %GREEN
HIST_IN(:,3) = imhist(I2(:,:,3),256); %BLUE

HIST_OUT(:,1) = imhist(RGB(:,:,1),256); %RED
HIST_OUT(:,2) = imhist(RGB(:,:,2),256); %GREEN
HIST_OUT(:,3) = imhist(RGB(:,:,3),256); %BLUE

mymap=[1 0 0; 0.2 1 0; 0 0.2 1];

figure,subplot(1,2,1),bar(HIST_IN);colormap(mymap);legend('RED CHANNEL','GREEN CHANNEL','BLUE CHANNEL');title('Before Applying Histogram Equalization');
       subplot(1,2,2),bar(HIST_OUT);colormap(mymap);legend('RED CHANNEL','GREEN CHANNEL','BLUE CHANNEL');title('After Applying Histogram Equalization');


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  seg_img bin_img GL
bin_img=im2bw(seg_img);
bin_img=imcomplement(bin_img);
bin_img=GL+bin_img;
bin_img = 255 * repmat(uint8(bin_img), 1, 1, 3);
axes(handles.axes3);

imshow(bin_img);  % Display input image

title('Binaraized Image','FontName','Times New Roman');

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global seg_img bin_img I 
fin_img=I+bin_img;
I=fin_img;
axes(handles.axes10);

imshow(I);  % Display input image

title('Masking original Image','FontName','Times New Roman');
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I I5 I4 GL
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
se = strel('disk',15);
afterOpening = imopen(R,se);
se = strel('disk',20);
closeBW = imclose(afterOpening,se);
NI=imadjust(closeBW,[0.8 1.0]);
 %%%%%%%%%%%%ROI for glucoma
GL=im2bw(NI); 

I4 = imadjust(I,[.2 .5 0; .6 .6 1],[]);
I5 = imresize(I4,[256,256]);
axes(handles.axes9);

imshow(I5);  % Display input image

title('Enhanced Image','FontName','Times New Roman');


% --- Executes on bu    tton press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filt I
row = 256;

col = 256;

Resize = imresize(I,[row col]);

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
axes(handles.axes10);

imshow(Filt);  % Display input image

title('Filtered Image','FontName','Times New Roman');


% --- Executes during object creation, after setting all properties.
function checkbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global RPval Filt
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
 set(handles.uitable1,'data',RPval);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
