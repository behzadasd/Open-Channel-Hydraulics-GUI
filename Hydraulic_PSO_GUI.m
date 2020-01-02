
function varargout = Hydraulic_PSO_GUI(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYDRAULIC_PSO_GUI MATLAB code for Hydraulic_PSO_GUI.fig
%      HYDRAULIC_PSO_GUI, by itself, creates a new HYDRAULIC_PSO_GUI or raises the existing
%      singleton*.
%
%      H = HYDRAULIC_PSO_GUI returns the handle to a new HYDRAULIC_PSO_GUI or the handle to
%      the existing singleton*.
%
%      HYDRAULIC_PSO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HYDRAULIC_PSO_GUI.M with the given input arguments.
%
%      HYDRAULIC_PSO_GUI('Property','Value',...) creates a new HYDRAULIC_PSO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Hydraulic_PSO_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Hydraulic_PSO_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Hydraulic_PSO_GUI

% Last Modified by GUIDE v2.5 12-May-2013 21:51:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Hydraulic_PSO_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @Hydraulic_PSO_GUI_OutputFcn, ...
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

% --- Executes on button press in pushbutton_Initiate.
function pushbutton_Initiate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Initiate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_Run_LK,'Enable','off');
set(handles.pushbutton_Run_MN,'Enable','off');
set(handles.pushbutton_PlotProfile_LK,'Enable','off');

evalin('base','clear')
evalin('base','clc')

Ch_n=[]; % Channel Manning Roughness
Ch_S=[]; % Channel Bed Slope
Ch_S1=[]; % Channel Bed Slope - 1st Part
Ch_S2=[]; % Channel Bed Slope - 2nd Part
Ch_Y=[]; % Channel Flow Depth
Ch_Q=[]; % Channel Flow Discharge
Ch_B=[]; % Channel Bed Width
Ch_z1=[]; % Channel Left Wall Slope
Ch_z2=[]; % Channel Right Wall Slope
Lk_E0=[]; % Lake Head Over the Channel Bed
Profile_datum=[];
Load_Data=0;
assignin('base','Ch_n',Ch_n)
assignin('base','Ch_S1',Ch_S1)
assignin('base','Ch_S2',Ch_S2)
assignin('base','Ch_S',Ch_S)
assignin('base','Ch_Y',Ch_Y)
assignin('base','Ch_Q',Ch_Q)
assignin('base','Ch_B',Ch_B)
assignin('base','Ch_z1',Ch_z1)
assignin('base','Ch_z2',Ch_z2)
assignin('base','Lk_E0',Lk_E0)
assignin('base','Profile_datum',Profile_datum)
assignin('base','Load_Data',Load_Data)

set(handles.checkbox_Unit_SI,'Value',0);
set(handles.checkbox_Unit_English,'Value',1);
Unit_SI=0;
assignin('base','Unit_SI',Unit_SI)

BE_dz =  [];
BE_b1 =  [];
BE_b2 =  [];
BE_y1 =  [];
BE_v1 =  [];
BE_y2 =  [];
BE_v2 =  [];
BE_Q =  [];
BE_E1 = [];
BE_E2 = [];
BE_Emin = [];
BE_yc1 = [];
BE_Fr1 = [];
BE_Emin1 = [];
BE_yc2 = [];
BE_Fr2 = [];
BE_Emin2 = [];
BE_y1new = [];
BE_y1newa = [];
BE_v1new = [];
assignin('base','BE_dz',BE_dz)
assignin('base','BE_b1',BE_b1)
assignin('base','BE_b2',BE_b2)
assignin('base','BE_y1',BE_y1)
assignin('base','BE_v1',BE_v1)
assignin('base','BE_y2',BE_y2)
assignin('base','BE_v2',BE_v2)
assignin('base','BE_Q',BE_Q)
assignin('base','BE_E1',BE_E1)
assignin('base','BE_E2',BE_E2)
assignin('base','BE_Emin',BE_Emin)
assignin('base','BE_yc1',BE_yc1)
assignin('base','BE_Fr1',BE_Fr1)
assignin('base','BE_Emin1',BE_Emin1)
assignin('base','BE_yc2',BE_yc2)
assignin('base','BE_Fr2',BE_Fr2)
assignin('base','BE_Emin2',BE_Emin2)
assignin('base','BE_y1new',BE_y1new)
assignin('base','BE_y1newa',BE_y1newa)
assignin('base','BE_v1new',BE_v1new)



% --- Executes on button press in pushbutton_UpVa_LK.
function pushbutton_UpVa_LK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_UpVa_LK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ch_n=str2double(get(handles.Ch_n_In,'String'));
Ch_S1=str2double(get(handles.Ch_S1_In,'String'));
Ch_S2=str2double(get(handles.Ch_S2_In,'String'));
Ch_Q=str2double(get(handles.Ch_Q_In,'String'));
Ch_B=str2double(get(handles.Ch_B_In,'String'));
Ch_z1=str2double(get(handles.Ch_z1_In,'String'));
Ch_z2=str2double(get(handles.Ch_z2_In,'String'));
Lk_E0=str2double(get(handles.Lk_E0_In,'String'));

if ~isnan(Ch_n)
assignin('base','Ch_n', Ch_n);
end
if ~isnan(Ch_S1)
assignin('base','Ch_S1', Ch_S1);
end
if ~isnan(Ch_S2)
assignin('base','Ch_S2', Ch_S2);
end
if ~isnan(Ch_Q)
assignin('base','Ch_Q', Ch_Q);
end
if ~isnan(Ch_B)
assignin('base','Ch_B', Ch_B);
end
if ~isnan(Ch_z1)
assignin('base','Ch_z1', Ch_z1);
end
if ~isnan(Ch_z2)
assignin('base','Ch_z2', Ch_z2);
end
if ~isnan(Lk_E0)
assignin('base','Lk_E0', Lk_E0);
end

set(handles.pushbutton_Run_LK,'Enable','on');


% --- Executes on button press in pushbutton_Run_LK.
function pushbutton_Run_LK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run_LK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ch_n=evalin('base','Ch_n');
Ch_S1=evalin('base','Ch_S1');
Ch_S2=evalin('base','Ch_S2');
Ch_Q=evalin('base','Ch_Q');
Ch_B=evalin('base','Ch_B');
Ch_z1=evalin('base','Ch_z1');
Ch_z2=evalin('base','Ch_z2');
Lk_E0=evalin('base','Lk_E0');
Profile_datum=evalin('base','Profile_datum');
Load_Data=evalin('base','Load_Data');
Unit_SI=evalin('base','Unit_SI');
if Unit_SI==1
    g=9.81;
else
    g=32.17;
end


[Profile_datum, Ch_Q, Ch_Yc, Ch_Sc, Ch_Yn1, Ch_Yn2, Scenario, Flow_Profile, P_Sec] = Hydraulics_GVF_LakeChannel(Profile_datum, Load_Data, Ch_B, Ch_z1, Ch_z2, Ch_n, Ch_S1, Ch_S2, Lk_E0, Ch_Q, g);

assignin('base','Ch_Q',Ch_Q)
assignin('base','Ch_Yc',Ch_Yc)
assignin('base','Ch_Sc',Ch_Sc)
assignin('base','Ch_Yn1',Ch_Yn1)
assignin('base','Ch_Yn2',Ch_Yn2)
assignin('base','Scenario',Scenario)
assignin('base','Profile_datum',Profile_datum)
assignin('base','Flow_Profile',Flow_Profile)
assignin('base','P_Sec',P_Sec)

set(handles.text_Ch_Q, 'String', Ch_Q);
set(handles.text_Ch_Yc, 'String', Ch_Yc);
set(handles.text_Ch_Sc, 'String', Ch_Sc);
set(handles.text_Ch_Yn1, 'String', Ch_Yn1);
set(handles.text_Ch_Yn2, 'String', Ch_Yn2);
set(handles.text_Slope, 'String', Scenario);

set(handles.pushbutton_PlotProfile_LK,'Enable','on');


% --- Executes on button press in pushbutton_PlotProfile_LK.
function pushbutton_PlotProfile_LK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PlotProfile_LK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Flow_Profile=evalin('base','Flow_Profile');
P_Sec=evalin('base','P_Sec');
Ch_Yc=evalin('base','Ch_Yc');

%%% Ploting Flow Profile %%%
hold off
plot(handles.axes_FlowProfile, (1:Flow_Profile(end,1)),0.01,'Color','black','LineWidth',10)
hold on
plot(handles.axes_FlowProfile, (1:Flow_Profile(end,1)),Ch_Yc,'--')
hold on
plot(handles.axes_FlowProfile, Flow_Profile(:,1),Flow_Profile(:,2))
hold on
plot(handles.axes_FlowProfile, P_Sec(:,1),P_Sec(:,2),'Color','black','LineWidth',1)






% --- Executes just before Hydraulic_PSO_GUI is made visible.
function Hydraulic_PSO_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Hydraulic_PSO_GUI (see VARARGIN)

% Choose default command line output for Hydraulic_PSO_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Hydraulic_PSO_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Hydraulic_PSO_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function Ch_n_In_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_n_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_n_In as text
%        str2double(get(hObject,'String')) returns contents of Ch_n_In as a double
Ch_n=str2double(get(hObject,'String'));
assignin('base','Ch_n',Ch_n)


% --- Executes during object creation, after setting all properties.
function Ch_n_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_n_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Ch_S1_In_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_S1_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_S1_In as text
%        str2double(get(hObject,'String')) returns contents of Ch_S1_In as a double
Ch_S1=str2double(get(hObject,'String'));
assignin('base','Ch_S1',Ch_S1)

% --- Executes during object creation, after setting all properties.
function Ch_S1_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_S1_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Ch_S2_In_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_S2_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_S2_In as text
%        str2double(get(hObject,'String')) returns contents of Ch_S2_In as a double
Ch_S2=str2double(get(hObject,'String'));
assignin('base','Ch_S2',Ch_S2)

% --- Executes during object creation, after setting all properties.
function Ch_S2_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_S2_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ch_B_In_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_B_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_B_In as text
%        str2double(get(hObject,'String')) returns contents of Ch_B_In as a double
Ch_B=str2double(get(hObject,'String'));
assignin('base','Ch_B',Ch_B)

% --- Executes during object creation, after setting all properties.
function Ch_B_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_B_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ch_z1_In_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_z1_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_z1_In as text
%        str2double(get(hObject,'String')) returns contents of Ch_z1_In as a double
Ch_z1=str2double(get(hObject,'String'));
assignin('base','Ch_z1',Ch_z1)

% --- Executes during object creation, after setting all properties.
function Ch_z1_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_z1_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Ch_z2_In_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_z2_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_z2_In as text
%        str2double(get(hObject,'String')) returns contents of Ch_z2_In as a double
Ch_z2=str2double(get(hObject,'String'));
assignin('base','Ch_z2',Ch_z2)


% --- Executes during object creation, after setting all properties.
function Ch_z2_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_z2_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Lk_E0_In_Callback(hObject, eventdata, handles)
% hObject    handle to Lk_E0_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lk_E0_In as text
%        str2double(get(hObject,'String')) returns contents of Lk_E0_In as a double
Lk_E0=str2double(get(hObject,'String'));
assignin('base','Lk_E0',Lk_E0)



% --- Executes during object creation, after setting all properties.
function Lk_E0_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lk_E0_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ch_Q_In_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_Q_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_Q_In as text
%        str2double(get(hObject,'String')) returns contents of Ch_Q_In as a double
Ch_Q=str2double(get(hObject,'String'));
assignin('base','Ch_Q',Ch_Q)


% --- Executes during object creation, after setting all properties.
function Ch_Q_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_Q_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_LoadProfileOn.
function pushbutton_LoadProfileOn_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_LoadProfileOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_LoadProfile,'Enable','on');
Load_Data=1;
assignin('base','Load_Data',Load_Data)

% --- Executes on button press in pushbutton_LoadProfileOff.
function pushbutton_LoadProfileOff_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_LoadProfileOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_LoadProfile,'Enable','off');
Load_Data=0;
assignin('base','Load_Data',Load_Data)

% --- Executes on button press in pushbutton_LoadProfile.
function pushbutton_LoadProfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_LoadProfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ExcelFileName=uigetfile('*.xlsx');
ExcelFileName=handles.ExcelFileName;
guidata(hObject, handles)

[Profile_nums, ~, ~] = xlsread(ExcelFileName , 'Sheet1');
Profile_datum(:,1)=Profile_nums(:,1);
Profile_datum(:,2)=Profile_nums(:,2)-min(Profile_nums(:,2));

assignin('base','Profile_datum',Profile_datum)


% --- Executes during object creation, after setting all properties.
function text_Ch_Q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_Q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Ch_Yc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_Yc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Ch_Sc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_Sc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Ch_Yn1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_Yn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Slope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Slope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_UpVa_MN.
function pushbutton_UpVa_MN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_UpVa_MN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ch_n=str2double(get(handles.Ch_n_In2,'String'));
Ch_S=str2double(get(handles.Ch_S_In,'String'));
Ch_Q=str2double(get(handles.Ch_Q_In2,'String'));
Ch_Y=str2double(get(handles.Ch_Yn_In,'String'));
Ch_B=str2double(get(handles.Ch_B_In,'String'));
Ch_z1=str2double(get(handles.Ch_z1_In,'String'));
Ch_z2=str2double(get(handles.Ch_z2_In,'String'));

if ~isnan(Ch_n)
assignin('base','Ch_n', Ch_n);
end
if ~isnan(Ch_S)
assignin('base','Ch_S', Ch_S);
end
if ~isnan(Ch_Y)
assignin('base','Ch_Y', Ch_Y);
end
if ~isnan(Ch_Q)
assignin('base','Ch_Q', Ch_Q);
end
if ~isnan(Ch_B)
assignin('base','Ch_B', Ch_B);
end
if ~isnan(Ch_z1)
assignin('base','Ch_z1', Ch_z1);
end
if ~isnan(Ch_z2)
assignin('base','Ch_z2', Ch_z2);
end

set(handles.pushbutton_Run_MN,'Enable','on');


% --- Executes on button press in pushbutton_Run_MN.
function pushbutton_Run_MN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run_MN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ch_n=evalin('base','Ch_n');
Ch_S=evalin('base','Ch_S');
Ch_Y=evalin('base','Ch_Y');
Ch_Q=evalin('base','Ch_Q');
Ch_B=evalin('base','Ch_B');
Ch_z1=evalin('base','Ch_z1');
Ch_z2=evalin('base','Ch_z2');
Profile_datum=evalin('base','Profile_datum');
Load_Data=evalin('base','Load_Data');
Unit_SI=evalin('base','Unit_SI');
if Unit_SI==1
    g=9.81;
else
    g=32.17;
end

[Ch_B, Ch_n, Ch_S, Ch_Y, Ch_Q, Ch_V ] = Hydraulics_Manning(Profile_datum, Load_Data, Ch_B, Ch_z1, Ch_z2, Ch_n, Ch_S, Ch_Y, Ch_Q, g);

assignin('base','Ch_Q',Ch_Q)
assignin('base','Ch_V',Ch_V)
assignin('base','Ch_S',Ch_S)
assignin('base','Ch_Y',Ch_Y)
assignin('base','Ch_B',Ch_B)
assignin('base','Ch_n',Ch_n)

set(handles.text_Ch_Q2, 'String', Ch_Q);
set(handles.text_Ch_V, 'String', Ch_V);
set(handles.text_Ch_S, 'String', Ch_S);
set(handles.text_Ch_Yn2m, 'String', Ch_Y);
set(handles.text_Ch_B, 'String', Ch_B);
set(handles.text_Ch_n, 'String', Ch_n);

set(handles.pushbutton_PlotProfile_MN,'Enable','on');


% --- Executes on button press in pushbutton_PlotProfile_MN.
function pushbutton_PlotProfile_MN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PlotProfile_MN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function Ch_Q_In2_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_Q_In2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_Q_In2 as text
%        str2double(get(hObject,'String')) returns contents of Ch_Q_In2 as a double
Ch_Q=str2double(get(hObject,'String'));
assignin('base','Ch_Q',Ch_Q)

% --- Executes during object creation, after setting all properties.
function Ch_Q_In2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_Q_In2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ch_Yn_In_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_Yn_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_Yn_In as text
%        str2double(get(hObject,'String')) returns contents of Ch_Yn_In as a double
Ch_Y=str2double(get(hObject,'String'));
assignin('base','Ch_Y',Ch_Y)

% --- Executes during object creation, after setting all properties.
function Ch_Yn_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_Yn_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ch_S_In_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_S_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_S_In as text
%        str2double(get(hObject,'String')) returns contents of Ch_S_In as a double
Ch_S=str2double(get(hObject,'String'));
assignin('base','Ch_S',Ch_S)

% --- Executes during object creation, after setting all properties.
function Ch_S_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_S_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ch_n_In2_Callback(hObject, eventdata, handles)
% hObject    handle to Ch_n_In2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ch_n_In2 as text
%        str2double(get(hObject,'String')) returns contents of Ch_n_In2 as a double
Ch_n=str2double(get(hObject,'String'));
assignin('base','Ch_n',Ch_n)

% --- Executes during object creation, after setting all properties.
function Ch_n_In2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ch_n_In2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_Ch_Q2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_Q2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Ch_S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Ch_V_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Ch_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Ch_B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Ch_Yn2m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_Yn2m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Ch_Yn2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Ch_Yn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_PlotProfeBase.
function pushbutton_PlotProfeBase_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PlotProfeBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Load_Data=evalin('base','Load_Data');
if Load_Data==0
    
    Ch_B=str2double(get(handles.Ch_B_In,'String'));
    Ch_z1=str2double(get(handles.Ch_z1_In,'String'));
    Ch_z2=str2double(get(handles.Ch_z2_In,'String'));
    if ( ~isempty(Ch_B) && ~isempty(Ch_z1) && ~isempty(Ch_z2) )
        %%% Trapezoidal Channel Char. %%%
        y_zero=20;
        Profile_datum=zeros(4,2);
        Profile_datum(1,2)=y_zero; Profile_datum(4,2)=y_zero;
        Profile_datum(2,1)=y_zero*Ch_z1;
        Profile_datum(3,1)=Profile_datum(2,1)+Ch_B;
        Profile_datum(4,1)=Profile_datum(3,1)+y_zero*Ch_z2;
        Profile_datum(:,1)=Profile_datum(:,1)+2;
        
    end
    
elseif Load_Data==1
    
    Profile_datum=evalin('base','Profile_datum');
    
end

%%% Ploting Created Channel Profile %%%
plot(handles.axes_PlotProfile, Profile_datum(:,1),Profile_datum(:,2),'LineWidth',5,'Color','blue')


% --- Executes on button press in checkbox_Unit_SI.
function checkbox_Unit_SI_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Unit_SI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Unit_SI
set(handles.checkbox_Unit_SI,'Value',1);
set(handles.checkbox_Unit_English,'Value',0);
Unit_SI=1;
assignin('base','Unit_SI',Unit_SI)

% --- Executes on button press in checkbox_Unit_English.
function checkbox_Unit_English_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Unit_English (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Unit_English

set(handles.checkbox_Unit_SI,'Value',0);
set(handles.checkbox_Unit_English,'Value',1);
Unit_SI=0;
assignin('base','Unit_SI',Unit_SI)


% --- Executes on button press in pushbutton_UpVa_BE.
function pushbutton_UpVa_BE_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_UpVa_BE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BE_y1=str2double(get(handles.BE_Y1,'String'));
BE_v1=str2double(get(handles.BE_V1,'String'));
BE_y2=str2double(get(handles.BE_Y2,'String'));
BE_v2=str2double(get(handles.BE_V2,'String'));
BE_b1=str2double(get(handles.BE_B1,'String'));
BE_b2=str2double(get(handles.BE_B2,'String'));
BE_dz=str2double(get(handles.BE_dz,'String'));

if ~isnan(BE_y1)
assignin('base','BE_y1', BE_y1);
end
if ~isnan(BE_v1)
assignin('base','BE_v1', BE_v1);
end
if ~isnan(BE_y2)
assignin('base','BE_y2', BE_y2);
end
if ~isnan(BE_v2)
assignin('base','BE_v2', BE_v2);
end
if ~isnan(BE_b1)
assignin('base','BE_b1', BE_b1);
end
if ~isnan(BE_b2)
assignin('base','BE_b2', BE_b2);
end
if ~isnan(BE_dz)
assignin('base','BE_dz', BE_dz);
end

set(handles.pushbutton_Run_BE,'Enable','on');


% --- Executes on button press in pushbutton_Run_BE.
function pushbutton_Run_BE_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Run_BE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BE_dz= evalin('base','BE_dz');
BE_b1= evalin('base','BE_b1');
BE_b2= evalin('base','BE_b2');
BE_y1= evalin('base','BE_y1');
BE_v1= evalin('base','BE_v1');
BE_y2= evalin('base','BE_y2');
BE_v2= evalin('base','BE_v2');
BE_Q= evalin('base','BE_Q');
BE_E1= evalin('base','BE_E1');
BE_E2= evalin('base','BE_E2');
BE_Emin= evalin('base','BE_Emin');
BE_yc1= evalin('base','BE_yc1');
BE_Fr1= evalin('base','BE_Fr1');
BE_Emin1= evalin('base','BE_Emin1');
BE_yc2= evalin('base','BE_yc2');
BE_Fr2= evalin('base','BE_Fr2');
BE_Emin2= evalin('base','BE_Emin2');
BE_y1new= evalin('base','BE_y1new');
BE_y1newa= evalin('base','BE_y1newa');
BE_v1new= evalin('base','BE_v1new');
Unit_SI=evalin('base','Unit_SI');
if Unit_SI==1
    g=9.81;
else
    g=32.17;
end

[BE_y1, BE_y2, BE_v1, BE_v2, BE_Q, BE_E1, BE_E2, BE_Emin, BE_yc1, BE_Fr1, BE_Emin1, BE_yc2, BE_Fr2, BE_Emin2, BE_y1new, BE_y1newa, BE_v1new] = Hydraulic_Bernouli(g, BE_b1, BE_b2, BE_dz, BE_y1, BE_y2, BE_v1, BE_v2, BE_Q, BE_E1, BE_E2, BE_Emin, BE_yc1, BE_Fr1, BE_Emin1, BE_yc2, BE_Fr2, BE_Emin2, BE_y1new, BE_y1newa, BE_v1new);

%assignin('base','BE_dz',BE_dz)
assignin('base','BE_b1',BE_b1)
assignin('base','BE_b2',BE_b2)
assignin('base','BE_y1',BE_y1)
assignin('base','BE_v1',BE_v1)
assignin('base','BE_y2',BE_y2)
assignin('base','BE_v2',BE_v2)
assignin('base','BE_Q',BE_Q)
assignin('base','BE_E1',BE_E1)
assignin('base','BE_E2',BE_E2)
assignin('base','BE_Emin',BE_Emin)
assignin('base','BE_yc1',BE_yc1)
assignin('base','BE_Fr1',BE_Fr1)
assignin('base','BE_Emin1',BE_Emin1)
assignin('base','BE_yc2',BE_yc2)
assignin('base','BE_Fr2',BE_Fr2)
assignin('base','BE_Emin2',BE_Emin2)
assignin('base','BE_y1new',BE_y1new)
assignin('base','BE_y1newa',BE_y1newa)
assignin('base','BE_v1new',BE_v1new)

set(handles.text_BE_Y1,'String',BE_y1);
set(handles.text_BE_Y2,'String',BE_y2);
set(handles.text_BE_V1,'String',BE_v1);
set(handles.text_BE_V2,'String',BE_v2);
set(handles.text_BE_q,'String',BE_Q);

set(handles.text_BE_Yc1,'String',BE_yc1);
set(handles.text_BE_Yc2,'String',BE_yc2);
set(handles.text_BE_E1,'String',BE_E1);
set(handles.text_BE_E2,'String',BE_E2 );

if (BE_b1 - BE_b2 == 0 )
    
    set(handles.text_BE_Yc1,'String',BE_yc1);
    set(handles.text_BE_Yc2,'String',BE_yc1);
    set(handles.text_BE_E1,'String',BE_E1);
    set(handles.text_BE_E2,'String',BE_E1 );
    
    if (BE_Fr1 > 1) && (BE_Fr2 > 1)
        set(handles.text_UpS_CN,'String','Super-critical'); %%%
        set(handles.text_DnS_CN,'String','Super-critical'); %%%
        
        if BE_y1 > BE_y2
            set(handles.text_WaterDepth,'String','Reduction in Water Depth'); %%%
        else
            set(handles.text_WaterDepth,'String','Incretion in Water Depth'); %%%
        end
        
    elseif (BE_Fr1 < 1) && (BE_Fr2 < 1)
        set(handles.text_UpS_CN,'String','Sub-critical'); %%%
        set(handles.text_DnS_CN,'String','Sub-critical'); %%%%
        
        if BE_y1 > BE_y2
            set(handles.text_WaterDepth,'String','Reduction in Water Depth'); %%%
        else
            set(handles.text_WaterDepth,'String','Incretion in Water Depth'); %%%
        end
        
    elseif (BE_Fr1 < 1) && (BE_Fr2 == 1) && ~isempty(BE_y1new)
        set(handles.text_UpS_CN,'String','Sub-critical'); %%%
        set(handles.text_DnS_CN,'String','Control'); %%%
        set(handles.text_Chock,'String','Choking'); %%%
    elseif (BE_Fr1 > 1) && (BE_Fr2 == 1) && ~isempty(BE_y1new)
        set(handles.text_UpS_CN,'String','Super-critical'); %%%
        set(handles.text_DnS_CN,'String','Control'); %%%
        set(handles.text_Chock,'String','Choking'); %%%
    end
    
    %%%%%%%%% end of flow status %%%%%%%%%%
    
else
    
    set(handles.text_BE_Yc1,'String',BE_yc1);
    set(handles.text_BE_Yc2,'String',BE_yc2);
    set(handles.text_BE_E1,'String',BE_E1);
    set(handles.text_BE_E2,'String',BE_E2 );
    
    %%Flow Status%%
    
    if (BE_Fr1 > 1) && (BE_Fr2 > 1)
        set(handles.text_UpS_CN,'String','Super-critical'); %%%
        set(handles.text_DnS_CN,'String','Super-critical'); %%%
        
        if BE_y1 > BE_y2
            set(handles.text_WaterDepth,'String','Reduction in Water Depth'); %%%
        else
            set(handles.text_WaterDepth,'String','Incretion in Water Depth'); %%%
        end
        
    elseif (BE_Fr1 < 1) && (BE_Fr2 < 1)
        set(handles.text_UpS_CN,'String','Sub-critical'); %%%
        set(handles.text_DnS_CN,'String','Sub-critical'); %%%
        
        if BE_y1 > BE_y2
            set(handles.text_WaterDepth,'String','Reduction in Water Depth'); %%%
        else
            set(handles.text_WaterDepth,'String','Incretion in Water Depth'); %%%
        end
        
    elseif (BE_Fr1 < 1) && (BE_Fr2 == 1) && ~isempty(BE_y1new)
        set(handles.text_UpS_CN,'String','Sub-critical'); %%%
        set(handles.text_DnS_CN,'String','Control'); %%%
        
    elseif (BE_Fr1 > 1) && (BE_Fr2 == 1) && ~isempty(BE_y1new)
        set(handles.text_UpS_CN,'String','Super-critical'); %%%
        set(handles.text_DnS_CN,'String','Control'); %%%
        
    end
    
    
end


function BE_Y1_Callback(hObject, eventdata, handles)
% hObject    handle to BE_Y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BE_Y1 as text
%        str2double(get(hObject,'String')) returns contents of BE_Y1 as a double
BE_y1=str2double(get(hObject,'String'));
assignin('base','BE_y1',BE_y1)



% --- Executes during object creation, after setting all properties.
function BE_Y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BE_Y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BE_V1_Callback(hObject, eventdata, handles)
% hObject    handle to BE_V1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BE_V1 as text
%        str2double(get(hObject,'String')) returns contents of BE_V1 as a double
BE_v1=str2double(get(hObject,'String'));
assignin('base','BE_v1',BE_v1)

% --- Executes during object creation, after setting all properties.
function BE_V1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BE_V1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BE_Y2_Callback(hObject, eventdata, handles)
% hObject    handle to BE_Y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BE_Y2 as text
%        str2double(get(hObject,'String')) returns contents of BE_Y2 as a double
BE_y2=str2double(get(hObject,'String'));
assignin('base','BE_y2',BE_y2)

% --- Executes during object creation, after setting all properties.
function BE_Y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BE_Y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BE_V2_Callback(hObject, eventdata, handles)
% hObject    handle to BE_V2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BE_V2 as text
%        str2double(get(hObject,'String')) returns contents of BE_V2 as a double
BE_v2=str2double(get(hObject,'String'));
assignin('base','BE_v2',BE_v2)

% --- Executes during object creation, after setting all properties.
function BE_V2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BE_V2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BE_B1_Callback(hObject, eventdata, handles)
% hObject    handle to BE_B1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BE_B1 as text
%        str2double(get(hObject,'String')) returns contents of BE_B1 as a double
BE_b1=str2double(get(hObject,'String'));
assignin('base','BE_b1',BE_b1)

% --- Executes during object creation, after setting all properties.
function BE_B1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BE_B1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BE_B2_Callback(hObject, eventdata, handles)
% hObject    handle to BE_B2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BE_B2 as text
%        str2double(get(hObject,'String')) returns contents of BE_B2 as a double
BE_b2=str2double(get(hObject,'String'));
assignin('base','BE_b2',BE_b2)

% --- Executes during object creation, after setting all properties.
function BE_B2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BE_B2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BE_dz_Callback(hObject, eventdata, handles)
% hObject    handle to BE_dz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BE_dz as text
%        str2double(get(hObject,'String')) returns contents of BE_dz as a double
BE_dz=str2double(get(hObject,'String'));
assignin('base','BE_dz',BE_dz)

% --- Executes during object creation, after setting all properties.
function BE_dz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BE_dz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_BE_Y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_BE_Y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_BE_V1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_BE_V1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_BE_Y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_BE_Y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_BE_V2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_BE_V2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_BE_Yc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_BE_Yc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_BE_Yc2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_BE_Yc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_BE_q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_BE_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_UpS_CN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_UpS_CN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_DnS_CN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_DnS_CN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_BE_E1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_BE_E1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_BE_E2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_BE_E2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Chock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Chock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_WaterDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_WaterDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
