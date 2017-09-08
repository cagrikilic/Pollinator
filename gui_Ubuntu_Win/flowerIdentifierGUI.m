function varargout = flowerIdentifierGUI(varargin)
% FLOWERIDENTIFIERGUI MATLAB code for flowerIdentifierGUI.fig
%      FLOWERIDENTIFIERGUI, by itself, creates a new FLOWERIDENTIFIERGUI or raises the existing
%      singleton*.
%
%      H = FLOWERIDENTIFIERGUI returns the handle to a new FLOWERIDENTIFIERGUI or the handle to
%      the existing singleton*.
%
%      FLOWERIDENTIFIERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLOWERIDENTIFIERGUI.M with the given input arguments.
%
%      FLOWERIDENTIFIERGUI('Property','Value',...) creates a new FLOWERIDENTIFIERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before flowerIdentifierGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to flowerIdentifierGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Cagri Kilic
% cakilic@mix.wvu.edu

% back Modified by GUIDE v2.5 21-Jul-2017 17:15:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @flowerIdentifierGUI_OpeningFcn, ...
    'gui_OutputFcn',  @flowerIdentifierGUI_OutputFcn, ...
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


% --- Executes just before flowerIdentifierGUI is made visible.
function flowerIdentifierGUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to flowerIdentifierGUI (see VARARGIN)
handles.output = hObject;
clc;
cd(fileparts(which(mfilename)))
clear global;
evalin('base','clearvars');
global datasetNumber
datasetNumber=1;
handles.macroFolder = cd;
handles.ImageFolder = cd;
% Load list of poses in the image folder.
handles = LoadImageList(handles);
% Select none of the items in the listbox.
set(handles.lstImageList, 'value', []);
if ispc
filelist=dir(fullfile('poses\*.jpg'));
else
filelist=dir(fullfile('poses/*.jpg'));
end 
if ispc
filelist2=dir(fullfile('stages\*.jpg'));
else
filelist2=dir(fullfile('stages/*.jpg'));
end 

numFile=numel(filelist);
numFile2=numel(filelist2);

handles.filelist = filelist;
handles.filelist2 = filelist2;

handles.numFile=numFile;
handles.numFile2=numFile2;

handles.frameindex = 1;
handles.frameindex2 = 1;
handles.angle=0;
handles.ImageFolder2=cd;
currentFolder=pwd;
assignin('base','currentFolder',currentFolder)
% Update handles structure

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = flowerIdentifierGUI_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function Reset_Callback(~, ~, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%This button resets the GUI to its original version
cd(fileparts(which(mfilename)))
evalin('base','clear popChoice popChoice1 popVal popVal1')
evalin('base','clearvars -except currentFolder');
cla(handles.axes2,'reset')
cla(handles.axesImage,'reset')
close(gcbf)
flowerIdentifierGUI

% --- Executes on button press in DrawTool.
function DrawTool_Callback(~, ~, handles)
% hObject    handle to DrawTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global baseImageFileName

set(handles.singleFlower,'Value',0)
set(handles.clusterFlower,'Value',0)
cla(handles.axes2,'reset')
cla(handles.axes1,'reset')
cla(handles.axes11,'reset')
selectedListboxItem = get(handles.lstImageList, 'value');
ListOfImageNames = get(handles.lstImageList, 'string');
baseImageFileName = strcat(cell2mat(ListOfImageNames(selectedListboxItem)));
fullImageFileName = [handles.ImageFolder '/' baseImageFileName];
[im, ~] = imread(fullImageFileName);
axes(handles.axesImage); % Plot over original image.
hFH = imfreehand();% Actual line of code to do the drawing.
% Create a binary image ("mask") from the ROI object.
binaryImage = hFH.createMask();
assignin('base','binaryImage',binaryImage)
structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
x = xy(:, 2); % Columns.
y = xy(:, 1); % Rows.
assignin('base','x',x)
assignin('base','y',y)

hold on; % Don't blow away the image.
plot(x, y, 'LineWidth', 2,'Color',[0.2,0.2,0.9]);
drawnow; % Force it to draw immediately.
cxcy=mean(xy);
cx=cxcy(:, 2);
cy=cxcy(:, 1);
assignin('base','cx',cx)
assignin('base','cy',cy)
leftColumn = min(x);
rightColumn = max(x);
topLine = min(y);
bottomLine = max(y);
width = rightColumn - leftColumn;
height = bottomLine - topLine;

assignin('base','width',width)
assignin('base','height',height)
width1 = rightColumn - leftColumn + 1;
height1 = bottomLine - topLine + 1;
croppedImage2 = imcrop(im, [leftColumn, topLine, width1, height1]);
croppedImage = imcrop(im, [leftColumn, topLine, width, height]);
% Display cropped image.
axes(handles.axes2);
imshow(croppedImage2);
assignin('base','croppedImage',croppedImage)



% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(~, ~, handles)
% hObject    handle to the selected object in uibuttongroup1
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection1=get(handles.uibuttongroup1,'SelectedObject');
flowerSelection=get(selection1,'String');
assignin('base','flowerSelection',flowerSelection);

switch flowerSelection
    case 'Single'
        countFlower=1;
    case 'Cluster'
        x= inputdlg('How many flowers?:',...
            'Sample', [1 20]);
        if isempty(x)
            msgbox({'You did not enter the value' 'Number of flowers assumed as 2 '}, 'Error','error');
            countFlower=2;
            assignin('base','pose',pose);
        else
            countFlower = str2double(x{:});
        end%if the user pressed cancelled, then we exit this callback
        evalin('base','clear popChoice popChoice2 popVal popVal1')
end
assignin('base','countFlower',countFlower);


% --- Executes on button press in stages1.
function stages1_Callback(hObject, eventdata, handles)
% hObject    handle to stages1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in lstImageList.
function lstImageList_Callback(hObject, ~, handles)
% hObject    handle to lstImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lstImageList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstImageList
global baseImageFileName;
clear global imgOriginal;
global imgOriginal;	% Declare global so that other functions can see it, if they also declare it global.

% Change mouse pointer (cursor) to an hourglass.
% QUIRK: use 'watch' and you'll actually get an hourglass not a watch.
set(gcf,'Pointer','watch');
drawnow;	% Cursor won't change right away unless you do this.
selectedListboxItem = get(handles.lstImageList, 'value');
if isempty(selectedListboxItem)
    % Bail out if nothing was selected.
    % Change mouse pointer (cursor) to an arrow.
    set(gcf,'Pointer','arrow');
    drawnow;	% Cursor won't change right away unless you do this.
    return;
end
% If more than one is selected, bail out.
if length(selectedListboxItem) > 1
    baseImageFileName = '';
    % Change mouse pointer (cursor) to an arrow.
    set(gcf,'Pointer','arrow')
    drawnow;	% Cursor won't change right away unless you do this.
    return;
end
ListOfImageNames = get(handles.lstImageList, 'string');
baseImageFileName = strcat(cell2mat(ListOfImageNames(selectedListboxItem)));
fullImageFileName = [handles.ImageFolder '/' baseImageFileName];	% Prepend folder.

[~, ~, extension] = fileparts(fullImageFileName);
switch lower(extension)
    case {'.mov', '.wmv', '.asf'}
        msgboxw('Mov and wmv format video files are not supported by MATLAB.');
        % Change mouse pointer (cursor) to an arrow.
        set(gcf,'Pointer','arrow');
        drawnow;	% Cursor won't change right away unless you do this.
        return;
    otherwise
        % Display the image.
        imgOriginal = DisplayImage(handles, fullImageFileName);
end

% If imgOriginal is empty (couldn't be read), just exit.
if isempty(imgOriginal)
    % Change mouse pointer (cursor) to an arrow.
    set(gcf,'Pointer','arrow');
    drawnow;	% Cursor won't change right away unless you do this.
    return;
end

% Change mouse pointer (cursor) to an arrow.
set(gcf,'Pointer','arrow');
drawnow;	% Cursor won't change right away unless you do this.
guidata(hObject, handles);
return % from lstImageList_Callback()

% --- Executes during object creation, after setting all properties.
function lstImageList_CreateFcn(hObject, ~, ~)
% hObject    handle to lstImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSelectFolder.
function btnSelectFolder_Callback(hObject, ~, handles)
% hObject    handle to btnSelectFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
returnValue = uigetdir(handles.ImageFolder,'Select folder');
% returnValue will be 0 (a double) if they click cancel.
% returnValue will be the path (a string) if they clicked OK.
if returnValue ~= 0
    % Assign the value if they didn't click cancel.
    handles.ImageFolder = returnValue;
    handles = LoadImageList(handles);
    guidata(hObject, handles); 
end
return
function handles=LoadImageList(handles)
ListOfImageNames = {};
folder = handles.ImageFolder;
if ~isempty(handles.ImageFolder)
    if exist(folder,'dir') == false
        warningMessage = sprintf('Note: the folder used when this program was last run:\n%s\ndoes not exist on this computer.\nPlease run Step 1 to select an image folder.', handles.ImageFolder);
        msgboxw(warningMessage);
        return;
    end
else
    msgboxw('No folder specified as input for function LoadImageList.');
    return;
end
% If it gets to here, the folder is good.
ImageFiles = dir([handles.ImageFolder '/*.*']);
for Index = 1:length(ImageFiles)
    baseFileName = ImageFiles(Index).name;
    [~, ~, extension] = fileparts(baseFileName);
    extension = upper(extension);
    switch lower(extension)
        case {'.png', '.bmp', '.jpg', '.tif', '.avi'}
            % Allow only PNG, TIF, JPG, or BMP poses
            ListOfImageNames = [ListOfImageNames baseFileName];
        otherwise
    end
end
set(handles.lstImageList,'string',ListOfImageNames);
return

function imageArray = DisplayImage(handles, fullImageFileName)
% Read in image.
imageArray = []; % Initialize
try
    [imageArray, ~] = imread(fullImageFileName);
    % colorMap will have something for an indexed image (gray scale image with a stored colormap).
    % colorMap will be empty for a true color RGB image or a monochrome gray scale image.
catch ME
    % Will get here if imread() fails, like if the file is not an image file but a text file or Excel workbook or something.
    errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
    msgbox(sprintf('errorMessage'),'errorMessage','errorMessage');
    return;	% Skip the rest of this function
end

try
    % Display image array in a window on the user interface.
    %axes(handles.axesImage);
    hold off;	% IMPORTANT NOTE: hold needs to be off in order for the "fit" feature to work correctly.
    
    % Here we actually display the image in the "axesImage" axes.
    cla(handles.axesImage,'reset')
    imshow(imageArray, 'InitialMagnification', 'fit', 'parent', handles.axesImage);
    
    filename = fullImageFileName;
    L = filename=='/';
    m = find(L==1,1,'last');
    L = filename=='.';
    n = find(L==1,1,'last');
    str = filename(m+1:n-1);
    assignin('base','name',str)
%     mkdir (str)
    
    
    % Display a title above the image.
    [~, basefilename, extension] = fileparts(fullImageFileName);
    extension = lower(extension);
    % Display the title.
    caption = [basefilename, extension];
    title(handles.axesImage, caption, 'Interpreter', 'none', 'FontSize', 14);
    
catch ME
    errorMessage = sprintf('Error in function DisplayImage.\nError Message:\n%s', ME.message);
    
    msgbox(sprintf('errorMessage'),'errorMessage','errorMessage');
end
return; % from DisplayImage

% --- Executes on button press in savemat.
function savemat_Callback(~, ~, handles)
% hObject    handle to savemat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global datasetNumber;
global database;
filelist = handles.filelist;
frameindex  = handles.frameindex;
namePose=filelist(frameindex).name;
assignin('base','namePose',namePose)

name1=evalin('base','name');
data.name=(evalin('base','name'));
data.binaryImage=evalin('base','binaryImage');
data.cx=evalin('base','cx');
data.cy=evalin('base','cy');
data.croppedImage=(evalin('base','croppedImage'));
selection2=get(handles.uibuttongroup1,'SelectedObject');
data.countFlower=(evalin('base','countFlower'));
data.height=evalin('base','height');
data.width=evalin('base','width');
data.x=evalin('base','x');
data.y=evalin('base','y');
data.numPix=length(data.x);
axes(handles.axesImage)
xa=evalin('base','x');
ya=evalin('base','y');
plot(xa, ya, 'LineWidth', 2,'Color',[0.9,0.1,0.1]);
flowerSelection=get(selection2,'String');
assignin('base','flowerSelection',flowerSelection);
data.flowerSelection=flowerSelection;
switch flowerSelection
    case 'Single'
        frameindex=evalin('base','frameindex');
        if frameindex==1 || frameindex==2
            pose1=-90;
        elseif frameindex==3
            pose1=-75;
        elseif frameindex==4
            pose1=-60;
        elseif frameindex==5
            pose1=-45;
        elseif frameindex==6
            pose1=-30;
        elseif frameindex==7
            pose1=-15;
        elseif frameindex==8
            pose1=0;
        elseif frameindex==9
            pose1=15;
        elseif frameindex==10
            pose1=30;
        elseif frameindex==11
            pose1=45;
        elseif frameindex==12
            pose1=60;
        elseif frameindex==13
            pose1=75;
        elseif frameindex==14 || frameindex==15
            pose1=90;
        end
        pose2a=evalin('base','angle');
        if pose2a>180
            pose2=360-pose2a;
        elseif pose2a<-180
            pose2=pose2a+360;
        else
            pose2=pose2a;
        end
        data.pose=[pose1,pose2]; 
    case 'Cluster'
        data.pose=NaN;
end
frameindex2=evalin('base','frameindex2');
        if frameindex2==1 || frameindex2==2
            stage1='dormant_bud';
        elseif frameindex2==3
            stage1='bud_sprouting';
        elseif frameindex2==4
            stage1='flower_bud';
        elseif frameindex2==5
            stage1='half_open_flower';
        elseif frameindex2==6
            stage1='full_open_flower';
        elseif frameindex2==7
            stage1='unripe_green_berry';
        elseif frameindex2==8
            stage1='early_ripening_pink_berry';
        elseif frameindex2==9
            stage1='ripening_pink_berry';
        elseif frameindex2==10 || frameindex2==11
            stage1='ripe_berry';
        end
        data.stage=stage1;
% currentFolder=pwd;
% cd (name1)
database{datasetNumber}=data;
assignin('base','database',database)
Message = sprintf('Saving completed! Please go back to Step 2');
msgbox(Message)
cd(fileparts(which(mfilename)))
datasetNumber = datasetNumber +1;% Increment for next time.

% --- Executes on button press in finFolder.
function finFolder_Callback(~, ~, ~)
% hObject    handle to finFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','clearvars -except database');
currFold=pwd;
[filename,pathname] = uiputfile('*.mat','Save database as');
if pathname == 0 %if the user pressed cancelled, then we exit this callback
    msgbox('Nothing saved! Please save your folder!', 'Error','error');
    cd(currFold)
    return
end
saveDataName = fullfile(pathname,filename);
evalin('base', ['save(''', saveDataName ''')'])
cd (currFold)
assignin('base','currentFolder',currFold)



% --- Executes on button press in rotateCW.
function rotateCW_Callback(hObject, ~, handles)
% hObject    handle to rotateCW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
filelist = handles.filelist;
frameindex  = handles.frameindex;
if ispc
myfolder='poses\';
else
myfolder='poses/';
end 
currentframefile = filelist(frameindex).name;

ff=fullfile(myfolder,currentframefile);
angle=handles.angle-15;
assignin('base','angle',angle)
handles.angle=angle;
TheImage = imread(ff);
I=imrotate(TheImage,angle);
imshow(I);

guidata(hObject, handles);

% --- Executes on button press in RotateCCW.
function RotateCCW_Callback(hObject, ~, handles)
% hObject    handle to RotateCCW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
filelist = handles.filelist;
frameindex  = handles.frameindex;
if ispc
myfolder='poses\';
else
myfolder='poses/';
end 
currentframefile = filelist(frameindex).name;

ff=fullfile(myfolder,currentframefile);
angle=handles.angle+15;
assignin('base','angle',angle)
handles.angle=angle;
TheImage = imread(ff);
I=imrotate(TheImage,angle);
imshow(I);
guidata(hObject, handles);
% --- Executes on button press in next.
function next_Callback(hObject, ~, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.angle=0;
axes(handles.axes1);
filelist = handles.filelist;
numFile=handles.numFile;
frameindex  = handles.frameindex+1;
if ispc
myfolder='poses\';
else
myfolder='poses/';
end 
currentframefile = filelist(frameindex).name;
if frameindex == numFile
    set(handles.next,'Enable','off')
elseif frameindex >=1
    set(handles.back,'Enable','on')
    set(handles.next,'Enable','on')
    handles.frameindex = frameindex;
    ff=fullfile(myfolder,currentframefile);
    I=imread(ff);
    imshow(I);
end
angle=handles.angle;
assignin('base','angle',angle)
guidata(hObject, handles);
assignin('base','frameindex',frameindex)
% --- Executes on button press in back.
function back_Callback(hObject, ~, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.angle=0;
axes(handles.axes1);
filelist = handles.filelist;
numFile=handles.numFile;
frameindex  = handles.frameindex-1;
if ispc
myfolder='poses\';
else
myfolder='poses/';
end 

currentframefile = filelist(frameindex).name;
if frameindex ==1
    set(handles.back,'Enable','off')
elseif frameindex <= numFile
    set(handles.next,'Enable','on')
    set(handles.back,'Enable','on')
    handles.frameindex = frameindex;
    ff=fullfile(myfolder,currentframefile);
    I=imread(ff);
    imshow(I);
end

angle=handles.angle;
assignin('base','angle',angle)
guidata(hObject, handles);
assignin('base','frameindex',frameindex)

% --- Executes on button press in next2.
function next2_Callback(hObject, eventdata, handles)
% hObject    handle to next2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes11);
filelist2 = handles.filelist2;
numFile2=handles.numFile2;
frameindex2  = handles.frameindex2+1;
if ispc
myfolder='stages\';
else
myfolder='stages/';
end 
currentframefile = filelist2(frameindex2).name;
if frameindex2 == numFile2
    set(handles.next2,'Enable','off')
elseif frameindex2 >=1
    set(handles.back2,'Enable','on')
    set(handles.next2,'Enable','on')
    handles.frameindex2 = frameindex2;
    ff=fullfile(myfolder,currentframefile);
    I=imread(ff);
    imshow(I);
end

guidata(hObject, handles);
assignin('base','frameindex2',frameindex2)

% --- Executes on button press in back2.
function back2_Callback(hObject, eventdata, handles)
% hObject    handle to back2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes11);
filelist2 = handles.filelist2;
numFile2=handles.numFile2;
frameindex2  = handles.frameindex2-1;
if ispc
myfolder='stages\';
else
myfolder='stages/';
end 

currentframefile = filelist2(frameindex2).name;
if frameindex2 ==1
    set(handles.back2,'Enable','off')
elseif frameindex2 <= numFile2
    set(handles.next2,'Enable','on')
    set(handles.back2,'Enable','on')
    handles.frameindex2 = frameindex2;
    ff=fullfile(myfolder,currentframefile);
    I=imread(ff);
    imshow(I);
end


guidata(hObject, handles);
assignin('base','frameindex2',frameindex2)
