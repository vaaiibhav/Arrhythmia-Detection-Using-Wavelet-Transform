function varargout = saish(varargin)
% SAISH MATLAB code for saish.fig
%      SAISH, by itself, creates a new SAISH or raises the existing
%      singleton*.
%
%      H = SAISH returns the handle to a new SAISH or the handle to
%      the existing singleton*.
%
%      SAISH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAISH.M with the given input arguments.
%
%      SAISH('Property','Value',...) creates a new SAISH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before saish_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to saish_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help saish

% Last Modified by GUIDE v2.5 25-Apr-2017 01:08:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @saish_OpeningFcn, ...
                   'gui_OutputFcn',  @saish_OutputFcn, ...
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


% --- Executes just before saish is made visible.
function saish_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to saish (see VARARGIN)

% Choose default command line output for saish
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes saish wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = saish_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_load_data.
function btn_load_data_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ecg;
ecg =uigetfile('*.dat','Select the DAT file');


% --- Executes on button press in btn_calculate.
function btn_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to btn_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ecg;
[tm,sig]=rdsamp(ecg,1);
tm=tm(1:1000);
sig=sig(1:1000);
plot(tm,sig);
xlabel('Samples');
ylabel('Voltage(mV)');
[rpeaks,locs_Rwave] = findpeaks(sig,'MinPeakHeight',0.5,'MinPeakDistance',200);
% [~,locs_Pwave] = findpeaks(sig,'MinPeakHeight',0.2,'MaxPeakHeight',0.4,'MinPeakDistance',200);
sig_inverted = -sig;
[speak,locs_Swave] = findpeaks(sig_inverted,'MinPeakHeight',0.5,...
                                        'MinPeakDistance',200);
plot(tm,sig)
plot(locs_Rwave,sig(locs_Rwave),'rv','MarkerFaceColor','r')
plot(locs_Swave,sig(locs_Swave),'rs','MarkerFaceColor','b')
axis([0 1850 -1.1 1.1])
grid on
legend('ECG Signal','R-waves','S-waves')
xlabel('Samples')
ylabel('Voltage(mV)')
title('R-wave and S-wave ')                                    
                                    
