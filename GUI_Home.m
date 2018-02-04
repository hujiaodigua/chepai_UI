function varargout = GUI_Home(varargin)
% GUI_HOME MATLAB code for GUI_Home.fig
%      GUI_HOME, by itself, creates a new GUI_HOME or raises the existing
%      singleton*.
%
%      H = GUI_HOME returns the handle to a new GUI_HOME or the handle to
%      the existing singleton*.
%
%      GUI_HOME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_HOME.M with the given input arguments.
%
%      GUI_HOME('Property','Value',...) creates a new GUI_HOME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Home_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Home_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Home

% Last Modified by GUIDE v2.5 05-Jun-2017 14:20:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Home_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Home_OutputFcn, ...
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


% --- Executes just before GUI_Home is made visible.
function GUI_Home_OpeningFcn(hObject, eventdata, handles, varargin)
a=imread('CHD.jpg'); % 加载标志
axes(handles.axes1); % 添加的axes的tag为axes1
imshow(a); % 显示

% Choose default command line output for GUI_Home
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Home wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Home_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
close(GUI_Home());
mainHandle=UI();


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
clear
close all
clc
