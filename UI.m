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
global fpath; %声明文件路径+文件名为全局变量

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
%% 车牌处理程序
global fpath;
%% 读取车牌图像
% [fn,pn,~]=uigetfile('ChePaiKu\*.jpg','选择图片');
% Is=imread([pn fn]);%输入原始图像
% clear fn pn
Is = fpath;% 输入原始图像
% figure
% imshow(Is)
load param_char
load param_num

%% 找到车牌位置
Iplate=findplate(Is);
[Iplate,angle]=rotateimg(Iplate);
% plate=finetune(sbw);
axes(handles.axes_show); 
imshow(Iplate)

%% 车牌字符分割
[Ipcrop, Ipchar] = cropplate(Iplate);  %clear Iplate;
% save Iplate Iplate

%% 车牌字符识别  Ipchar是第一个汉字可以单独拿出来显示
%figure
resultc = recchar(Ipchar, param_char);
axes(handles.axes_show1); 
imshow(Ipchar);
title(resultc);
%[resultp,~] = recplate(Ipcrop, param_num)  %这一段的代码直接列出来写，而且不要使用subplot
%*************************************************************************
%% 识别
result=''; % 识别结果存储在result中
j=1;
%% 识别字母 
for i=length(Ipcrop):-1:1
    %     i=2
    image=Ipcrop{i}; % 识别第i个图片
    
    % 预处理
    image=imresize(image, param_num.img_size);
    image2=double(reshape(image, param_num.img_size(1)*param_num.img_size(2), 1)'); % 行拉直，下一步PCA（主成分分析）
    image2=bsxfun(@times,image2,1./sum(image2,2));% 归一化，全部值映射到0-1
    image2 = image2*param_num.coef(:,1:param_num.dim);% 降维
    
    image2=bsxfun(@rdivide, image2, sqrt(param_num.latent(1:param_num.dim)+1e-6));% 白化
    image2 = image2'; % 最终要使用列向量
    
    % 仿真
    val=sim(param_num.net,image2);
    [~ , temp] = max(val);
    ch=param_num.cate(temp);
    
    % 结果显示
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
% fprintf('识别结果：%s %s  %s %s %s %s %s \n',resultc, resultp);
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
