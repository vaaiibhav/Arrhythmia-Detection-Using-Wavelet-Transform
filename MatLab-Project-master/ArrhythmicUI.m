function varargout = ArrhythmicUI(varargin)
% ARRHYTHMICUI MATLAB code for ArrhythmicUI.fig
%      ARRHYTHMICUI, by itself, creates a new ARRHYTHMICUI or raises the existing
%      singleton*.
%
%      H = ARRHYTHMICUI returns the handle to a new ARRHYTHMICUI or the handle to
%      the existing singleton*.
%
%      ARRHYTHMICUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARRHYTHMICUI.M with the given input arguments.
%
%      ARRHYTHMICUI('Property','Value',...) creates a new ARRHYTHMICUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ArrhythmicUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ArrhythmicUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ArrhythmicUI

% Last Modified by GUIDE v2.5 09-Jan-2017 18:45:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ArrhythmicUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ArrhythmicUI_OutputFcn, ...
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


% --- Executes just before ArrhythmicUI is made visible.
function ArrhythmicUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ArrhythmicUI (see VARARGIN)

% Choose default command line output for ArrhythmicUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ArrhythmicUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ArrhythmicUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
%This function chooses what is to be plotted.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');

    Sig1_fft = fft(handles.Sig1(:, 2)); %RAW From timedomain to freq domain
    DF = handles.Fs/size(handles.Sig1,1)
     freq = 0:DF:handles.Fs/2;
     Sig1_fft = Sig1_fft(1:length(Sig1_fft)/2+1);
    %Perform filtering
    [Sig1Filter] = Filtering(handles.Sig1,handles.Fs);
    Sig1filt_fft = fft(Sig1Filter(:, 2)); % filtered freq domain signal
    Sig1filt_fft = Sig1filt_fft(1:length(Sig1filt_fft)/2+1);
    
    %handles.given_THD = 0;
    %Execute peak finder and RRinterval calculation function
    [Sig1Filter_PKS_ov05, PKS_ov05LOCS, handles.R_R_Interval ] = Peaks_and_RR( handles.given_THD, Sig1Filter, handles.Sig1);
    %Execute arrhythmic beat classification function
    [ handles.RR_Category ] = Beat_classifi( handles.R_R_Interval );    
    handles.HR = (60./handles.R_R_Interval);
    
    
% Set current data to the selected data set.
%If only one figure is needed, then the second figure is made invisible
switch str{val}; 
    case 'Raw' % User selects poincare.
        axes(handles.axes2);
        cla
        set(handles.axes2,'Visible','off');
        axes(handles.axes1);
        plot(handles.Sig1(:,1), handles.Sig1(:,2));
        
    case 'Frequency Domain' 
        axes(handles.axes1);
        plot(freq,20*log10(abs(Sig1_fft)));
        title('Original frequency domain signal')
        axes(handles.axes2);
         plot(freq,20*log10(abs(Sig1filt_fft)));
        title('Filtered frequency domain signal')
        
    case 'Filtered and Peaks'
        axes(handles.axes2);
        cla
        set(handles.axes2,'Visible','off');
        axes(handles.axes1);
        plot(handles.Sig1(:, 1), Sig1Filter(:, 2), PKS_ov05LOCS, Sig1Filter_PKS_ov05, 'o') 
        %hold on
        %plot (handles.PKS_ov05LOCS, handles.Sig1Filter_PKS_ov05, 'o')
        title('Filtered signal and peak detector')
        
    case 'Poincare Plot'
        axes(handles.axes2);
        cla
        set(handles.axes2,'Visible','off');
        axes(handles.axes1);
        plot(handles.R_R_Interval(1:end-1),handles.R_R_Interval(2:end), '.')
        title('Poincare Plot')
        xlabel('RR (n)')
        ylabel('RR (n-1)')
        
    case 'Arrhythmia Classification'
        PKS_ov05LOCS = PKS_ov05LOCS(1: end-1);
        axes(handles.axes2);
        cla
        set(handles.axes2,'Visible','off');
        axes(handles.axes1);
        %Plot arrhythmia classification
        plot(PKS_ov05LOCS,handles.RR_Category, 'x')
        title('Arrhythmic Beat Classification')
        ylim([0 5]);  
        
   case 'HR And RR-interval'
       PKS_ov05LOCS = PKS_ov05LOCS(1: end-1);
       %plot RR-interval
        axes(handles.axes1);
        plot(PKS_ov05LOCS, handles.R_R_Interval)
        ylabel('RR-interval[s]')
        %Plot HR
        axes(handles.axes2);
        plot(PKS_ov05LOCS,handles.HR)
        ylabel('Heart Rate ppm')
end
guidata(hObject,handles)


% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Data_load. 
%IN THIS FUNCTION
% MEASUREMENT FILE IS READ
function Data_load_Callback(hObject, eventdata, handles)
% hObject    handle to Data_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.txt','Select the text file');
data = dlmread([pathname, filename], ' ');
handles.Sig1 = data;
Dif_vect = diff(handles.Sig1(:,1)) %time between samples not constant. 
%Get more accurate value for time between samples by taking average of
%derivative
DT = mean(Dif_vect)
handles.Fs = 1/DT %Now we achieve accurate sampling frequency
guidata(hObject, handles);



% --- Executes on button press in DoCalc.
function DoCalc_Callback(hObject, eventdata, handles)
% hObject    handle to DoCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%AVG HR
HR_TOT = 0;
for t = 1:length(handles.HR)
    HR_TOT = HR_TOT + handles.HR(t);
end
AVG_HR = HR_TOT/length(handles.HR)

%AVG R-R
AVG_R_R = mean(handles.R_R_Interval)

%standard deviation
StDev_HR = std(handles.HR)
StDev_R_R = std(handles.R_R_Interval)

%Calculate how many findings there were in each arrhythmic classification
Cat2= 0;
Cat4= 0;
Cat3= 0;
for i = 1:length(handles.RR_Category)
    if handles.RR_Category(i) == 2
        Cat2 = Cat2 + 1;
    end
    if handles.RR_Category(i) == 3
        Cat3 = Cat3 + 1;
    end
    if handles.RR_Category(i) == 4
        Cat4 = Cat4 + 1;
    end
    cat2 = Cat2;
    cat3 = Cat3;
    cat4 = Cat4;
end
cat2
cat3
cat4
%count(handles.RR_Category, 2)

%View results for the user
set(handles.AvgHR, 'string' , ['AVG HR = ', num2str(AVG_HR)])
set(handles.AVG_RR, 'string' , ['AVG RR = ', num2str(AVG_R_R)])
set(handles.StdHR, 'string' , ['Standard deviation of HR = ', num2str(StDev_HR)])
set(handles.StdRR, 'string' , ['Standard deviation of RR = ', num2str(StDev_R_R)])
set(handles.ArrClas2, 'string' , ['VF Beat = ', num2str(cat2)])
set(handles.ArrClas3, 'string' , ['PVC = ', num2str(cat3)])
set(handles.ArrClas4, 'string' , ['2Deg Heart Block = ', num2str(cat4)])


function given_THD_Callback(hObject, eventdata, handles) %READ THRESHOLD VALUE, which is then used in peak finder
% hObject    handle to given_THD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.given_THD = str2double(get(hObject, 'string'));
%given_THD
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of given_THD as text
%        str2double(get(hObject,'String')) returns contents of given_THD as a double


% --- Executes during object creation, after setting all properties.
function given_THD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to given_THD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function AvgHR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AvgHR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
