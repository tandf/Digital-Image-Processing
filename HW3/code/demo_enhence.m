function varargout = demo_enhence(varargin)
% DEMO_ENHENCE MATLAB code for demo_enhence.fig
%      DEMO_ENHENCE, by itself, creates a new DEMO_ENHENCE or raises the existing
%      singleton*.
%
%      H = DEMO_ENHENCE returns the handle to a new DEMO_ENHENCE or the handle to
%      the existing singleton*.
%
%      DEMO_ENHENCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO_ENHENCE.M with the given input arguments.
%
%      DEMO_ENHENCE('Property','Value',...) creates a new DEMO_ENHENCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demo_enhence_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demo_enhence_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo_enhence

% Last Modified by GUIDE v2.5 15-Oct-2018 14:44:22
%
% Bohao Fan
% 2018.10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo_enhence_OpeningFcn, ...
                   'gui_OutputFcn',  @demo_enhence_OutputFcn, ...
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


% --- Executes just before demo_enhence is made visible.
function demo_enhence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo_enhence (see VARARGIN)

% Choose default command line output for demo_enhence
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demo_enhence wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = demo_enhence_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
global k0;
global k1;
global k2;
global mean_global;
global std_global;
global mean_local;
global std_local;
global E;
k0 = get(handles.slider1,'Value'); 
set(handles.text1,'String', num2str(k0));
k2 = get(handles.slider3,'Value'); 
set(handles.text3,'String', num2str(k2));
k1 = get(handles.slider2,'Value'); 
if k1>k2
    k1 = k2;
    set(handles.slider2,'Value',k1); 
end
set(handles.text2,'String', num2str(k1));
mask = (mean_local<=k0*mean_global) & (std_local>=k1*std_global) & (std_local<=k2*std_global);
J2 = image;
J2(mask) = image(mask)*E;
axes(handles.axes2); 
imshow(uint8(mask*255))
axes(handles.axes3); 
imshow(uint8(J2))

mask1 = (mean_local<=k0*mean_global);
axes(handles.axes4); 
imshow(mask1)

mask2 = (std_local>=k1*std_global);
axes(handles.axes5); 
imshow(mask2)

mask3 = (std_local<=k2*std_global);
axes(handles.axes6); 
imshow(mask3)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
global k0;
global k1;
global k2;
global mean_global;
global std_global;
global mean_local;
global std_local;
global E;
k0 = get(handles.slider1,'Value'); 
set(handles.text1,'String', num2str(k0));
k2 = get(handles.slider3,'Value'); 
set(handles.text3,'String', num2str(k2));
k1 = get(handles.slider2,'Value'); 
if k1>k2
    k1 = k2;
    set(handles.slider2,'Value',k1); 
end
set(handles.text2,'String', num2str(k1));
mask = (mean_local<=k0*mean_global) & (std_local>=k1*std_global) & (std_local<=k2*std_global);
J2 = image;
J2(mask) = image(mask)*E;
axes(handles.axes2); 
imshow(uint8(mask*255))
axes(handles.axes3); 
imshow(uint8(J2))

mask1 = (mean_local<=k0*mean_global);
axes(handles.axes4); 
imshow(mask1)

mask2 = (std_local>=k1*std_global);
axes(handles.axes5); 
imshow(mask2)

mask3 = (std_local<=k2*std_global);
axes(handles.axes6); 
imshow(mask3)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
global k0;
global k1;
global k2;
global mean_global;
global std_global;
global mean_local;
global std_local;
global E;
E = 4;
k0 = get(handles.slider1,'Value'); 
set(handles.text1,'String', num2str(k0));
k1 = get(handles.slider2,'Value'); 
if k1>k2
    k1 = k2;
    set(handles.slider2,'Value',k1); 
end
set(handles.text2,'String', num2str(k1));
k2 = get(handles.slider3,'Value'); 
set(handles.text3,'String', num2str(k2));
[filename,pathname] = uigetfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif'},'Pick an image');
image = imread([pathname,filename]);
axes(handles.axes1); 
[x1,x2,x3] = size(image);
if x3>1
image = rgb2gray(image);
end
imshow(image);
image = double(image);
mean_global = mean2(image);
std_global = std2(image);
fun1 = @(x) mean2(x);
mean_local = nlfilter(image,[3 3],fun1);% slow
fun2 = @(x) std2(x);
std_local = nlfilter(image,[3 3],fun2);% slow
mask = (mean_local<=k0*mean_global) & (std_local>=k1*std_global) & (std_local<=k2*std_global);
J2 = image;
J2(mask) = image(mask)*E;
axes(handles.axes2); 
imshow(uint8(mask*255))
axes(handles.axes3); 
imshow(uint8(J2))

mask1 = (mean_local<=k0*mean_global);
axes(handles.axes4); 
imshow(mask1)

mask2 = (std_local>=k1*std_global);
axes(handles.axes5); 
imshow(mask2)

mask3 = (std_local<=k2*std_global);
axes(handles.axes6); 
imshow(mask3)
set (handles.slider1,'Visible','on')
set (handles.text1,'Visible','on')
set (handles.slider2,'Visible','on')
set (handles.text2,'Visible','on')
set (handles.slider3,'Visible','on')
set (handles.text3,'Visible','on')


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
global k0;
global k1;
global k2;
global mean_global;
global std_global;
global mean_local;
global std_local;
global E;
k0 = get(handles.slider1,'Value'); 
set(handles.text1,'String', num2str(k0));
k2 = get(handles.slider3,'Value'); 
set(handles.text3,'String', num2str(k2));
k1 = get(handles.slider2,'Value'); 
if k1>k2
    k1 = k2;
    set(handles.slider2,'Value',k1); 
end
set(handles.text2,'String', num2str(k1));
mask = (mean_local<=k0*mean_global) & (std_local>=k1*std_global) & (std_local<=k2*std_global);
J2 = image;
J2(mask) = image(mask)*E;
axes(handles.axes2); 
imshow(uint8(mask*255))
axes(handles.axes3); 
imshow(uint8(J2))

mask1 = (mean_local<=k0*mean_global);
axes(handles.axes4); 
imshow(mask1)

mask2 = (std_local>=k1*std_global);
axes(handles.axes5); 
imshow(mask2)

mask3 = (std_local<=k2*std_global);
axes(handles.axes6); 
imshow(mask3)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
