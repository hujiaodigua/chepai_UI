function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 04-Feb-2018 19:42:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function m_file_Callback(hObject, eventdata, handles)
% hObject    handle to m_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_file_open_Callback(hObject, eventdata, handles)
% hObject    handle to m_file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fpath; %�����ļ�·��+�ļ���Ϊȫ�ֱ���

[filename, pathname] = uigetfile( ...
    {'*.bmp;*.jpg;*.png;*.jpeg','Image Files (*.bmp, *.jpg, *.png,*.jpeg)'; ...
    '*.*',                'All Files (*.*)'}, ...
    'Pick an image');
if isequal(filename,0) || isequal(pathname,0),
    return;
end

axes(handles.axes_src); 
fpath=[pathname filename]; 
img_src=imread(fpath);
imshow(img_src);  


% --------------------------------------------------------------------
function m_file_exit_Callback(hObject, eventdata, handles)
% hObject    handle to m_file_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;clear;close


% --- Executes during object creation, after setting all properties.
function axes_src_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_src (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_src


% --- Executes during object creation, after setting all properties.
function axes_show_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_show


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ���ƴ������
global fpath;
%% ��ȡ����ͼ��
% [fn,pn,~]=uigetfile('ChePaiKu\*.jpg','ѡ��ͼƬ');
% Is=imread([pn fn]);%����ԭʼͼ��
% clear fn pn
Is = fpath;% ����ԭʼͼ��
% figure
% imshow(Is)
load param_char
load param_num

%% �ҵ�����λ��
Iplate=findplate(Is);
[Iplate,angle]=rotateimg(Iplate);
% plate=finetune(sbw);
axes(handles.axes_show); 
imshow(Iplate)

%% �����ַ��ָ�
[Ipcrop, Ipchar] = cropplate(Iplate);  %clear Iplate;
% save Iplate Iplate

%% �����ַ�ʶ��  Ipchar�ǵ�һ�����ֿ��Ե����ó�����ʾ
%figure
resultc = recchar(Ipchar, param_char);
axes(handles.axes_show1); 
imshow(Ipchar);
title(resultc);
%[resultp,~] = recplate(Ipcrop, param_num)  %��һ�εĴ���ֱ���г���д�����Ҳ�Ҫʹ��subplot
%*************************************************************************
%% ʶ��
result=''; % ʶ�����洢��result��
j=1;
%% ʶ����ĸ 
for i=length(Ipcrop):-1:1
    %     i=2
    image=Ipcrop{i}; % ʶ���i��ͼƬ
    
    % Ԥ����
    image=imresize(image, param_num.img_size);
    image2=double(reshape(image, param_num.img_size(1)*param_num.img_size(2), 1)'); % ����ֱ����һ��PCA�����ɷַ�����
    image2=bsxfun(@times,image2,1./sum(image2,2));% ��һ����ȫ��ֵӳ�䵽0-1
    image2 = image2*param_num.coef(:,1:param_num.dim);% ��ά
    
    image2=bsxfun(@rdivide, image2, sqrt(param_num.latent(1:param_num.dim)+1e-6));% �׻�
    image2 = image2'; % ����Ҫʹ��������
    
    % ����
    val=sim(param_num.net,image2);
    [~ , temp] = max(val);
    ch=param_num.cate(temp);
    
    % �����ʾ
    result=[result;ch];
%     subplot(1,8,j+1)
    if j+1 == 2
        axes(handles.axes_show2); 
        imshow(image);
        title(ch);
    end
    if j+1 == 3
        axes(handles.axes_show3); 
        imshow(image);
        title(ch);
    end
    if j+1 == 4
        axes(handles.axes_show4); 
        imshow(image);
        title(ch);
    end
    if j+1 == 5
        axes(handles.axes_show5); 
        imshow(image);
        title(ch);
    end
    if j+1 == 6
        axes(handles.axes_show6); 
        imshow(image);
        title(ch);
    end
    if j+1 == 7
        axes(handles.axes_show7); 
        imshow(image);
        title(ch);
    end
    
    j=j+1;
end
%*************************************************************************

resultp = result;
res=strcat(resultc,resultp(1), ' ',resultp(2), resultp(3), resultp(4), resultp(5), resultp(6));
% fprintf('ʶ������%s %s  %s %s %s %s %s \n',resultc, resultp);
axes(handles.axes_src); 
imshow(imread(Is));
title(res)
set(handles.edit1,'string',res);%



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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
close(UI());
mainHandle=GUI_Home();
