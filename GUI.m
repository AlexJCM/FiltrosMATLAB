%% Descripcion del Programa
% Programa que mediante una interfaz gráfica permite cargar una imagen de
% cualquier tamaño y aplicar 3 filtros en la misma.
%
%% Instrucciones de uso
% Luego de cargar una imagen se debe cargar 3 matrices 5x5 de la carpeta 
% data-kernels .Finalmente se debe presionar el boton PROCESAR(el cual se 
% activa cuando  % se cargue una imagen) para obtener y presentar la imagen 
% original junto con 3 imagenes replicas modificadas.
%
%% Excepciones
% El programa presentará distintos mensajes y advertencias si
% el formtato de la matriz es incorrecta o si faltan matrices por cargar.
%
%% Autor
% Alex John Chamba Macas
%
%% Version
% 1.1
%
%% Repositorio del proyecto
% https://github.com/AlexJCM/FiltrosMATLAB
%


function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig

% Last Modified by GUIDE v2.5 05-Mar-2019 20:28:49

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Para centrar la interfaz grafica(GUI) en la pantalla
scrsz = get(0, 'ScreenSize');
pos_act = get(gcf,'Position');
xr = scrsz(3)-pos_act(3);
xp = round(xr/2);
yp = scrsz(4)-pos_act(4);
set(gcf,'Position',[xp, yp, pos_act(3) pos_act(4)]);

% Desactiva el boton procesar ya que aun no se carga una imagen
set(handles.procesar,'Enable','off')

% Cambiar el color de fondo del Static Text 
set(handles.mensaje,'BackgroundColor','black');

% Ponemos todas como falso ya que aun no se carga ninguna matriz
handles.hayMatrizA = false;%------------
handles.hayMatrizB = false;%------------
handles.hayMatrizC = false;%------------

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cargar Imagen
function cargar_Callback(hObject, eventdata, handles)
[Name,Path] = uigetfile({'*.jpg;'},'Seleccione una Imagen');

imagen =imread(fullfile(Path, Name));
axes(handles.axes1);
image(imagen);

% Oculta el Static Text luego de cargar una imagen
set(handles.mensaje, 'Visible', 'off');

% Habilita el boton procesar luego de haber cargado una imagen
set(handles.procesar,'Enable','on')

handles.img = imagen;
guidata(hObject, handles);

% --- Executes on button press in procesar.
function procesar_Callback(hObject, eventdata, handles)
import Imagen;

% Se comprueba si todas las matrices NO han sido cargadas aun
if (handles.hayMatrizA || handles.hayMatrizB || handles.hayMatrizC)
    % Se comprueba que matriz ha sido cargada
    if (handles.hayMatrizA)
        if (handles.hayMatrizB)
            if (handles.hayMatrizC)
                disp('Procesando imagen... Espere...');
                % Obtenemos la imagen cargada
                imagenOriginal = handles.img;
                % Obtenemos la matrices cargadas
                MatrixA = handles.kernela;
                MatrixB = handles.kernelb;
                MatrixC = handles.kernelc;
                % Creamos un objeto Imagen con 4 parametros
                miImagen2 = Imagen(imagenOriginal, MatrixA, MatrixB, MatrixC);
                %Utlizamos la funcion principal del objeto Imagen
                procesarImagen(miImagen2);
            else
                dialogC = warndlg('No ha cargado aún la matriz C','Advertencia');
            end
        else
            dialogB = warndlg('No ha cargado aún la matriz B','Advertencia');
        end
    else
        dialogA = warndlg('No ha cargado aún la matriz A','Advertencia');
    end
else
    dialogGeneral = warndlg('NINGUNA MATRIZ HA SIDO CARGADA AUN','AVISO');
end




% --- Executes on button press in limpiar y reinicia la GUI
function limpiar_Callback(hObject, eventdata, handles)
clear all, close all, clc
GUI


% --- Executes on button press in CargarMatrizA.
function CargarMatrizA_Callback(hObject, eventdata, handles)
[Name,Path] = uigetfile('*.txt','Select Matriz 5x5');

try
    matriz =load(fullfile(Path, Name));
   
    tamanio = size(matriz, 2);
   
    if (tamanio == 5)
        disp("A es una matriz de 5x5")
        texto = 'Matriz A Cargada';
        set(handles.rutaMatrizA,'ForegroundColor',[0.08 0.82 0.08]);
    elseif (tamanio == 3)
        f = errordlg('La matriz cargada es de 3x3','Advertencia');
        texto = 'Error';
        set(handles.rutaMatrizA,'ForegroundColor',[1 0 0]);
    end
    
    set(handles.rutaMatrizA, 'String', texto);
    
    handles.hayMatrizA = true;%------------
    
    handles.kernela = matriz;
    guidata(hObject, handles);
    
catch    
    f = errordlg('Formato de matriz desconocido','File Error');
    set(handles.rutaMatrizA, 'String', 'ERROR');
    set(handles.rutaMatrizA,'ForegroundColor',[1 0 0]);      
    
end

% --- Executes on button press in CargarMatrizB.
function CargarMatrizB_Callback(hObject, eventdata, handles)
[Name,Path] = uigetfile('*.txt','Select Matriz 5x5');

try
    matrizb =load(fullfile(Path, Name));
    
    tamanio = size(matrizb, 2);
    if (tamanio == 5)
        disp("B es una matriz de 5x5");
        texto = 'Matriz B Cargada';
        set(handles.rutaMatrizB,'ForegroundColor',[0.08 0.82 0.08]);
    elseif (tamanio == 3)
        f = errordlg('La matriz escogida es de 3x3','Advertencia');
        texto = 'Error';
        set(handles.rutaMatrizB,'ForegroundColor',[1 0 0]);
    end
    
    set(handles.rutaMatrizB, 'String', texto);
    
    handles.hayMatrizB = true;%------------
    
    handles.kernelb = matrizb;
    guidata(hObject, handles);
    
catch   
    f = errordlg('Formato de matriz desconocido','File Error');
    set(handles.rutaMatrizB, 'String', 'ERROR');
    set(handles.rutaMatrizB,'ForegroundColor',[1 0 0]);     
end


% --- Executes on button press in CargarMatrizC.
function CargarMatrizC_Callback(hObject, eventdata, handles)
[Name,Path] = uigetfile('*.txt','Select Matriz 5x5');

try
    matrizc =load(fullfile(Path, Name));
    
    tamanio = size(matrizc, 2);
    if (tamanio == 5)
        disp("C es una matriz de 5x5");
        texto = 'Matriz C Cargada';
        set(handles.rutaMatrizC,'ForegroundColor',[0.08 0.82 0.08]);
    elseif (tamanio == 3)
        f = errordlg('La matriz selecionada es de 3x3','Advertencia');
        texto = 'Error';
        set(handles.rutaMatrizC,'ForegroundColor',[1 0 0]);
    end
    
    set(handles.rutaMatrizC, 'String', texto);
    
    handles.hayMatrizC = true;%------------
    
    handles.kernelc = matrizc;
    guidata(hObject, handles);
    
catch   
    f = errordlg('Formato de matriz desconocido','File Error');
    set(handles.rutaMatrizC, 'String', 'ERROR');
    set(handles.rutaMatrizC,'ForegroundColor',[1 0 0]); 
   
end
