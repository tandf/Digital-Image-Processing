function varargout = demo_bfilter(varargin)
% DEMO_BFILTER MATLAB code for demo_bfilter.fig
%      DEMO_BFILTER, by itself, creates a new DEMO_BFILTER or raises the existing
%      singleton*.
%
%      H = DEMO_BFILTER returns the handle to a new DEMO_BFILTER or the handle to
%      the existing singleton*.
%
%      DEMO_BFILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO_BFILTER.M with the given input arguments.
%
%      DEMO_BFILTER('Property','Value',...) creates a new DEMO_BFILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demo_bfilter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demo_bfilter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo_bfilter

% Last Modified by GUIDE v2.5 14-Oct-2018 19:01:08
%
% Bohao Fan
% 2018.10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo_bfilter_OpeningFcn, ...
                   'gui_OutputFcn',  @demo_bfilter_OutputFcn, ...
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
end

% --- Executes just before demo_bfilter is made visible.
function demo_bfilter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo_bfilter (see VARARGIN)

% Choose default command line output for demo_bfilter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demo_bfilter wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = demo_bfilter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
global imageselected;
global filtersize;
global graysigma;
global xselected;
global yselected;
global filter;
global spfilter;
global zyfilter;
filtersize = fix(get(handles.slider1,'Value')); 
set(handles.text1,'String', num2str(filtersize));
graysigma = fix(get(handles.slider2,'Value')); 
set(handles.text2,'String', num2str(graysigma));
[x,y,z] = size(image);
left = max(1,xselected-fix(filtersize/2));
right = min(x,xselected-fix(filtersize/2)+filtersize);
up = max(1,yselected-fix(filtersize/2));
down = min(y,yselected-fix(filtersize/2)+filtersize);
imageselected = image(left:right,up:down);
axes(handles.axes1)
imshow(image)
rectangle('position',[up left down-up right-left], 'edgecolor', [1 0 0])
axes(handles.axes2);
imshow(imageselected);
filter = bfilter(filtersize,image,xselected,yselected,graysigma);

axes(handles.axes3);
imshow(filter)
spfilter = sfilter(filtersize,image,xselected,yselected);
axes(handles.axes4);
imshow(spfilter)
zyfilter = zfilter(filtersize,image,xselected,yselected,graysigma);
axes(handles.axes5);
zyfilter = (zyfilter-min(zyfilter(:)))/(max(zyfilter(:))-min(zyfilter(:)));
imshow(zyfilter)
gausFilter = fspecial('gaussian',[filtersize filtersize],filtersize/3);
Is=imfilter(image,gausFilter,'replicate');
axes(handles.axes6);
imshow(Is(left:right,up:down))
Ib = imbilatfilt(image,graysigma*15,filtersize/3);
axes(handles.axes7);
imshow(Ib(left:right,up:down))
axes(handles.axes8);
imshow(Is)
axes(handles.axes9);
imshow(Ib)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
global imageselected;
global filtersize;
global graysigma;
global xselected;
global yselected;
global filter;
global spfilter;
global zyfilter;
filtersize = fix(get(handles.slider1,'Value')); 
set(handles.text1,'String', num2str(filtersize));
graysigma = fix(get(handles.slider2,'Value')); 
set(handles.text2,'String', num2str(graysigma));
[x,y,z] = size(image);
left = max(1,xselected-fix(filtersize/2));
right = min(x,xselected-fix(filtersize/2)+filtersize);
up = max(1,yselected-fix(filtersize/2));
down = min(y,yselected-fix(filtersize/2)+filtersize);
imageselected = image(left:right,up:down);
axes(handles.axes1)
imshow(image)
rectangle('position',[up left down-up right-left], 'edgecolor', [1 0 0])
axes(handles.axes2);
imshow(imageselected);
filter = bfilter(filtersize,image,xselected,yselected,graysigma);

axes(handles.axes3);
imshow(filter)
spfilter = sfilter(filtersize,image,xselected,yselected);
axes(handles.axes4);
imshow(spfilter)
zyfilter = zfilter(filtersize,image,xselected,yselected,graysigma);
axes(handles.axes5);
zyfilter = (zyfilter-min(zyfilter(:)))/(max(zyfilter(:))-min(zyfilter(:)));
imshow(zyfilter)
gausFilter = fspecial('gaussian',[filtersize filtersize],filtersize/3);
Is=imfilter(image,gausFilter,'replicate');
axes(handles.axes6);
imshow(Is(left:right,up:down))
Ib = imbilatfilt(image,graysigma*15,filtersize/3);
axes(handles.axes7);
imshow(Ib(left:right,up:down))
axes(handles.axes8);
imshow(Is)
axes(handles.axes9);
imshow(Ib)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif'},'Pick an image');
global image;
global imageselected;
global filtersize;
global graysigma;
global xselected;
global yselected;
global filter;
global spfilter;
global zyfilter;
image = imread([pathname,filename]);
axes(handles.axes1); 
imshow(image);
filtersize = fix(get(handles.slider1,'Value')); 
set(handles.text1,'String', num2str(filtersize));
graysigma = fix(get(handles.slider2,'Value')); 
set(handles.text2,'String', num2str(graysigma));
[x,y,z] = size(image);
cx = fix(x/2);
cy = fix(y/2);
xselected = cx;
yselected = cy;
imageselected = image(cx-fix(filtersize/2):cx-fix(filtersize/2)+filtersize,cy-fix(filtersize/2):cy-fix(filtersize/2)+filtersize);
axes(handles.axes1)
imshow(image)
rectangle('position',[cy-fix(filtersize/2) cx-fix(filtersize/2) filtersize filtersize], 'edgecolor', [1 0 0])
axes(handles.axes2);
imshow(imageselected);
filter = bfilter(filtersize,image,xselected,yselected,graysigma);

axes(handles.axes3);
imshow(filter)
spfilter = sfilter(filtersize,image,xselected,yselected);
axes(handles.axes4);
imshow(spfilter)
zyfilter = zfilter(filtersize,image,xselected,yselected,graysigma);
axes(handles.axes5);
zyfilter = (zyfilter-min(zyfilter(:)))/(max(zyfilter(:))-min(zyfilter(:)));
imshow(zyfilter)
gausFilter = fspecial('gaussian',[filtersize filtersize],filtersize/3);
Is=imfilter(image,gausFilter,'replicate');
axes(handles.axes6);
imshow(Is(cx-fix(filtersize/2):cx-fix(filtersize/2)+filtersize,cy-fix(filtersize/2):cy-fix(filtersize/2)+filtersize))
Ib = imbilatfilt(image,graysigma*15,filtersize/3);
axes(handles.axes7);
imshow(Ib(cx-fix(filtersize/2):cx-fix(filtersize/2)+filtersize,cy-fix(filtersize/2):cy-fix(filtersize/2)+filtersize))
axes(handles.axes8);
imshow(Is)
axes(handles.axes9);
imshow(Ib)
end

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
end
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
global imageselected;
global filtersize;
global graysigma;
global xselected;
global yselected;
global filter;
global spfilter;
global zyfilter;
[h,w,z] = size(image);
pos1 = get(handles.axes1,'CurrentPoint');
y = fix(pos1(1,1));
x = fix(pos1(1,2));
if (x<h-10 && x>10 && y < w-10 && y>10)
    xselected = x;
    yselected = y;
filtersize = fix(get(handles.slider1,'Value')); 
graysigma = fix(get(handles.slider2,'Value')); 
[x,y,z] = size(image);
left = max(1,xselected-fix(filtersize/2));
right = min(x,xselected-fix(filtersize/2)+filtersize);
up = max(1,yselected-fix(filtersize/2));
down = min(y,yselected-fix(filtersize/2)+filtersize);
imageselected = image(left:right,up:down);
axes(handles.axes1)
imshow(image)
rectangle('position',[up left down-up right-left], 'edgecolor', [1 0 0])
axes(handles.axes2);
imshow(imageselected);
size(image)
filter = bfilter(filtersize,image,xselected,yselected,graysigma);
axes(handles.axes3);
imshow(filter)
spfilter = sfilter(filtersize,image,xselected,yselected);
axes(handles.axes4);
imshow(spfilter)
zyfilter = zfilter(filtersize,image,xselected,yselected,graysigma);
axes(handles.axes5);
zyfilter = (zyfilter-min(zyfilter(:)))/(max(zyfilter(:))-min(zyfilter(:)));
imshow(zyfilter)
gausFilter = fspecial('gaussian',[filtersize filtersize],filtersize/3);
Is=imfilter(image,gausFilter,'replicate');
axes(handles.axes6);
imshow(Is(left:right,up:down))
Ik = Is(left:right,up:down);
Ib = imbilatfilt(image,graysigma*15,filtersize/3);
axes(handles.axes7);
imshow(Ib(left:right,up:down))
axes(handles.axes8);
imshow(Is)
axes(handles.axes9);
imshow(Ib)
end
end

function result = bfilter(s,I,x,y,s2)
[h,w,z] = size(I);
s1 = (s-1)/3;
if s<0
    result = 0;
else
center = fix(s/2);
G = rgb2gray(I);
left = max(1,x-center);
right = min(h,x+s-center);
up = max(1,y-center);
down = min(w,y+s-center);
Gs = G(left:right,up:down);
centercountx = x - left;
centercounty = y - up;
result = ones((right-left),(down-up));
for i = 1:(right-left)
    for j = 1:(down-up)
        result(i,j) = result(i,j)*exp((-(i-centercountx)^2-(j-centercounty)^2)/2/s1^2);
        result(i,j) = result(i,j)*exp(-double(Gs(i,j)-Gs(centercountx,centercounty))^2/2/s2^2);
    end
end
 result = result/max(result(:));
end
end

function result = sfilter(s,I,x,y)
[h,w,z] = size(I);
s1 = (s-1)/3;
if s<0
    result = 0;
else
center = fix(s/2);
G = rgb2gray(I);
left = max(1,x-center);
right = min(h,x+s-center);
up = max(1,y-center);
down = min(w,y+s-center);
Gs = G(left:right,up:down);
centercountx = x - left;
centercounty = y - up;
result = ones((right-left),(down-up));
for i = 1:(right-left)
    for j = 1:(down-up)
        result(i,j) = result(i,j)*exp((-(i-centercountx)^2-(j-centercounty)^2)/2/s1^2);
    end
end
end
end

function result = zfilter(s,I,x,y,s2)
[h,w,z] = size(I);
s1 = (s-1)/3;
if s<0
    result = 0;
else
center = fix(s/2);
G = rgb2gray(I);
left = max(1,x-center);
right = min(h,x+s-center);
up = max(1,y-center);
down = min(w,y+s-center);
Gs = G(left:right,up:down);
centercountx = x - left;
centercounty = y - up;
result = ones((right-left),(down-up));
for i = 1:(right-left)
    for j = 1:(down-up)
        result(i,j) = result(i,j)*exp(-double(Gs(i,j)-Gs(centercountx,centercounty))^2/2/s2^2);
    end
end
end
end
