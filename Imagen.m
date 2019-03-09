classdef Imagen
    properties
        imagen
        kernel1
        kernel2
        kernel3
    end
    
    methods
        %% Constructor
        % Todo objeto imagen debe tener los siguientes 4 parametros
        function obj=Imagen(i, k1, k2, k3)
            obj.imagen = i;
            obj.kernel1 = k1;
            obj.kernel2 = k2;
            obj.kernel3 = k3;
        end
        
        %% Procesar Imagenes
        % Funcion que procesa una imagen y devuelve 3 imagenes modificadas
        % por su respectivo kernel
        %% Inputs
        % Un objeto imagen
        %% Outputs
        % Retorna la imagen original y 3 imagenes procesadas
        %%
        function procesarImagen(objImg)
            %imagen_original = imread(obj.imagen);
            imagen_original = objImg.imagen;
            % Obtenemos el alto y ancho de la imagen
            alto = size(imagen_original, 1);
            ancho = size(imagen_original, 2);
            
            % Descomponer imagen original en 3 imagenes simples que representan a cada banda
            R = imagen_original(:,:,1);
            G = imagen_original(:,:,2);
            B = imagen_original(:,:,3);
            
            MatrizA = objImg.kernel1;
            MatrizB = objImg.kernel2;
            MatrizC = objImg.kernel3;
            
            % Forma un array de tamaño alto x 2 para aniadirlo a ambos
            % lados de cada banda de la imagen
            O1 = zeros(alto,2);
            SubMatriz1 = [O1 R O1];
            SubMatriz2 = [O1 G O1];
            SubMatriz3 = [O1 B O1];
            
            % se le añade 4 al 1280 ya que aumentamos ligeramente el ancho
            % de la imagen en las lineas anteriores. Ahora repetimos el
            % proceso anterior pero para la parte superior e inferior
            % de la iamgen
            O2 = zeros(2,(ancho+4));
            L1 = [O2;SubMatriz1;O2];
            L2 = [O2;SubMatriz2;O2];
            L3 = [O2;SubMatriz3;O2];
            
            %convertir a tipo de dato double
            N1 = double(L1);
            N2 = double(L2);
            N3 = double(L3);
            
            for x=1:alto
                for y=1:ancho
                    E1 = N1(x:x+4,y:y+4);
                    P1 = MatrizA.*E1;
                    S1 = (1/256)*sum(sum(P1));
                    X1(x,y) = S1;
                    
                    E2 = N2(x:x+4,y:y+4);
                    P2 = MatrizA.*E2;
                    S2 = (1/256)*sum(sum(P2));
                    Y1(x,y) = S2;
                    
                    E3 = N3(x:x+4,y:y+4);
                    P3 = MatrizA.*E3;
                    S3 = (1/256)*sum(sum(P3));
                    Z1(x,y) = S3;
                    %--------------FOTO 2--------
                    E4 = N1(x:x+4,y:y+4);
                    P4 = MatrizB.*E4;
                    S4 = (1/256)*sum(sum(P4));
                    X2(x,y) = S4;
                    
                    E5 = N2(x:x+4,y:y+4);
                    P5 = MatrizB.*E5;
                    S2 = (1/256)*sum(sum(P5));
                    Y2(x,y) = S2;
                    
                    E6 = N3(x:x+4,y:y+4);
                    P6 = MatrizB.*E6;
                    S3 = (1/256)*sum(sum(P6));
                    Z2(x,y) = S3;
                    %-------------FOTO 3 ---------
                    E7 = N1(x:x+4,y:y+4);
                    P7 = MatrizC.*E7;
                    S1 = (1/256)*sum(sum(P7));
                    X3(x,y) = S1;
                    
                    E8 = N2(x:x+4,y:y+4);
                    P8 = MatrizC.*E8;
                    S2 = (1/256)*sum(sum(P8));
                    Y3(x,y) = S2;
                    
                    E9 = N3(x:x+4,y:y+4);
                    P9 = MatrizC.*E9;
                    S3 = (1/256)*sum(sum(P9));
                    Z3(x,y) = S3;
                end
            end
            
            MatrizOriginal(:,:,1) = R;
            MatrizOriginal(:,:,2) = G;
            MatrizOriginal(:,:,3) = B;
            
            %convertir a tipo de dato uint8 y guardar
            MatrizFinalA(:,:,1) = uint8(X1);
            MatrizFinalA(:,:,2) = uint8(Y1);
            MatrizFinalA(:,:,3) = uint8(Z1);
            %-------------------------------------------------------------------
            %convertir a tipo de dato uint8 y guardar
            MatrizFinalB(:,:,1) = uint8(X2);
            MatrizFinalB(:,:,2) = uint8(Y2);
            MatrizFinalB(:,:,3) = uint8(Z2);
            %-------------------------------------------------------------------
            %convertir a tipo de dato uint8 y guardar
            MatrizFinalC(:,:,1) = uint8(X3);
            MatrizFinalC(:,:,2) = uint8(Y3);
            MatrizFinalC(:,:,3) = uint8(Z3);
            
            
            %-----Para guardar la matriz en cualquier fichero------------
            %imwrite(MatrizFinalA,'imagenes-finales/final1.jpg')
            %imwrite(MatrizFinalB,'imagenes-finales/final2.jpg')
            %imwrite(MatrizFinalC,'imagenes-finales/final3.jpg')
            
            f = figure('Name','3-Filters','NumberTitle','off','Position', [60 15 1000 650]);
            set(f, 'MenuBar', 'none');
            set(f, 'ToolBar', 'none');
            movegui(f, 'center');
            
            subplot(2, 2, 1);
            imshow(MatrizOriginal);
            title('ORIGINAL')
            
            subplot(2 ,2, 2);
            imshow(MatrizFinalA);
            title('FILTRO 1')
            
            subplot(2 ,2, 3);
            imshow(MatrizFinalB);
            title('FILTRO 2')
            
            subplot(2 ,2, 4);
            imshow(MatrizFinalC);
            title('FILTRO 3')
            
        end
        
    end
    
end
