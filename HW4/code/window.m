function varargout = window(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @window_OpeningFcn, ...
                       'gui_OutputFcn',  @window_OutputFcn, ...
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
end

function sin_btn_KeyPressFcn(hObject, eventdata, handles, varargin) end
function figure1_CreateFcn(hObject, eventdata, handles) end

function window_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);

    resetfig = ones(256,256);
    axes(handles.axes1);imshow(resetfig);
    axes(handles.axes2);imshow(resetfig);
    axes(handles.axes3);imshow(resetfig);
    axes(handles.axes4);imshow(resetfig);
    axes(handles.axes5);imshow(resetfig);
    axes(handles.axes6);imshow(resetfig);
    setSin('Off', handles);
    setRect('Off', handles);
    setGauss('Off', handles);
end

function varargout = window_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
end

function sin_angle_Callback(hObject, eventdata, handles)
    displaySin(handles, hObject);
end

function sin_angle_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function sin_freq_Callback(hObject, eventdata, handles)
    displaySin(handles, hObject);
end

function sin_freq_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function sin_phase_Callback(hObject, eventdata, handles)
    displaySin(handles, hObject);
end

function sin_phase_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function rect_angle_Callback(hObject, eventdata, handles)
    displayRect(handles, hObject);
end

function rect_angle_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function rect_width_Callback(hObject, eventdata, handles)
    displayRect(handles, hObject);
end

function rect_width_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function rect_r_Callback(hObject, eventdata, handles)
    displayRect(handles, hObject);
end

function rect_r_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function gauss_std_Callback(hObject, eventdata, handles)
    displayGauss(handles, hObject);
end

function gauss_std_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function rect_centerx_Callback(hObject, eventdata, handles)
    displayRect(handles, hObject);
end

function rect_centerx_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function rect_centery_Callback(hObject, eventdata, handles)
    displayRect(handles, hObject);
end

function rect_centery_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function setSin(state, handles)
    set(handles.sin_angle, 'Visible', state);
    set(handles.sin_freq, 'Visible', state);
    set(handles.sin_phase, 'Visible', state);
    if length(state) == 2
        set(handles.text1, 'String', '角度');
        set(handles.text2, 'String', '频率');
        set(handles.text3, 'String', '相位');
        set(handles.text4, 'String', '');
        set(handles.text5, 'String', '');
    end
end

function setRect(state, handles)
    set(handles.rect_angle, 'Visible', state);
    set(handles.rect_width, 'Visible', state);
    set(handles.rect_r, 'Visible', state);
    set(handles.rect_centerx, 'Visible', state);
    set(handles.rect_centery, 'Visible', state);
    if length(state) == 2
        set(handles.text1, 'String', '角度');
        set(handles.text2, 'String', '宽度');
        set(handles.text3, 'String', '长宽比');
        set(handles.text4, 'String', '中心 x');
        set(handles.text5, 'String', '中心 y');
    end
end

function setGauss(state, handles)
    set(handles.gauss_std, 'Visible', state);
    if length(state) == 2
        set(handles.text1, 'String', '方差');
        set(handles.text2, 'String', '');
        set(handles.text3, 'String', '');
        set(handles.text4, 'String', '');
        set(handles.text5, 'String', '');
    end
end

function displaySin(handles, hObject)
    % Construct 2D sine wave
    [X, Y] = meshgrid(1:256);
    ang = get(handles.sin_angle, 'Value');
    freq = get(handles.sin_freq, 'Value');
    phase = get(handles.sin_phase, 'Value');
    sinf = sin(freq*(cos(ang)*X+sin(ang)*Y) + phase);
    axes(handles.axes1);imshow(sinf);
    axes(handles.axes4);surf(sinf);

    handles.f = sinf;
    guidata(hObject,handles);
end

function displayRect(handles, hObject)
    % Construct rect
    rect_ang = get(handles.rect_angle, 'Value');
    rect_width = get(handles.rect_width, 'Value'); 
    rect_r = get(handles.rect_r, 'Value'); 
    rect_center = [get(handles.rect_centerx, 'Value'),  get(handles.rect_centery, 'Value')];
    rect = zeros(256, 256);
    rect(128-uint16(rect_width*rect_r/2):128+uint16(rect_width*rect_r/2), 128-uint16(rect_width/2):128+uint16(rect_width/2))=1;
    rect = rect(1:256, 1:256);
    rect = imrotate(rect, rect_ang, 'nearest', 'crop');
    rect = imtranslate(rect,rect_center);
    axes(handles.axes1);imshow(rect)
    axes(handles.axes4);surf(rect);

    handles.f = rect;
    guidata(hObject,handles);
end

function displayGauss(handles, hObject)
    % Construct Gauss
    [X, Y] = meshgrid(1:256);
    gauss_std = get(handles.gauss_std, 'Value'); 
    gauss = exp(-((X-128).^2+(Y-128).^2)/(2*gauss_std^2));
    axes(handles.axes1);imshow(gauss)
    axes(handles.axes4);surf(gauss);

    handles.f = gauss;
    guidata(hObject,handles);
end

function sin_btn_Callback(hObject, eventdata, handles)
    displaySin(handles, hObject);
    setSin('On', handles);
    setRect('Off', handles);
    setGauss('Off', handles);
end

function rect_btn_Callback(hObject, eventdata, handles)
    displayRect(handles, hObject);
    setSin('Off', handles);
    setRect('On', handles);
    setGauss('Off', handles);
end

function gauss_btn_Callback(hObject, eventdata, handles)
    displayGauss(handles, hObject);
    setSin('Off', handles);
    setRect('Off', handles);
    setGauss('On', handles);
end

function btn1_Callback(hObject, eventdata, handles)
    F = dft2(handles.f);
    F = fftshift(F);
    step = 4;
    axes(handles.axes2);imshow(log(abs(F)),[-1 5])
    axes(handles.axes5);surf(log(abs(F(1:step:end,1:step:end))));
    axes(handles.axes3);imshow(angle(F)); 
    axes(handles.axes6);surf(angle(F(1:step:end,1:step:end)));
end
