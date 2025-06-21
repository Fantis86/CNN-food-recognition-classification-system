function varargout = Main(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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






% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;




% 初始化 axes1
axes(handles.axes1);
cla reset;
axis on; 
box on;
% 清空坐标轴的刻度标签
set(gca, 'XTickLabel', '', 'YTickLabel', '');


axes(handles.axes2);
cla reset;
axis on; 
box on;
% 清空坐标轴的刻度标签
set(gca, 'XTickLabel', '', 'YTickLabel', '');






% 读取模型
load('ResNet_3_classes.mat', 'model');
handles.model = model;

% Get class names from the model
handles.class_names = model.Layers(end).ClassNames;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

% 选择图像文件
[filename, filepath] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'}, '选择图像文件');
if filename == 0
    % 用户取消选择
    return;
end

% 读取选择的图像
imgPath = fullfile(filepath, filename);
Img = imread(imgPath);

% 调整图像尺寸
inputSize = handles.model.Layers(1).InputSize;
Img = imresize(Img, inputSize(1:2));

% 在axes2中显示图像
axes(handles.axes1);

imshow(Img);

% 进行分类预测
[labels, scores] = classify(handles.model, Img);

% 在text5中显示类别
set(handles.text5, 'String', [char(labels)]);

% 在text6中显示准确率
accuracy = 100 * scores(handles.class_names == labels);
set(handles.text6, 'String', [num2str(accuracy, '%.2f') '%']);


% 将上述的可视化
[~, idx] = sort(scores, 'descend');
idx = idx(10:-1:1);
classNamesTop = handles.model.Layers(end).ClassNames(idx);
scoresTop = scores(idx);

% 在axes2中绘制条形图
axes(handles.axes2);
cla reset;
mybar = barh(scoresTop);
xlim([0 1.1]);
yticklabels(classNamesTop);
xtips = mybar(1).YEndPoints + 0.02;
ytips = mybar(1).XEndPoints;
labels = string(round(mybar(1).YData, 2));
text(xtips, ytips, labels, 'VerticalAlignment', 'middle');
title('指名前3的预测结果');
xlabel('置信度值');





% 退出按钮实现
function pushbutton3_Callback(hObject, eventdata, handles)

choice = questdlg('确定要退出?', ...
    '退出', ...
    '确定','取消','取消');
switch choice
    case '确定'
        close;
    case '取消'
        return;
end




function edit2_Callback(hObject, eventdata, handles)





% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
