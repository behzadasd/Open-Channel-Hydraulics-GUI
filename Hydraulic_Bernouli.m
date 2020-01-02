function [y1, y2, v1, v2, Q, E1, E2, Emin, yc1, Fr1, Emin1, yc2, Fr2, Emin2, y1new, y1newa, v1new] = Hydraulic_Bernouli(g, b1, b2, dZ, y1, y2, v1, v2, Q, E1, E2, Emin, yc1, Fr1, Emin1, yc2, Fr2, Emin2, y1new, y1newa, v1new)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hObject    handle to pushbutton_Calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(dZ) && ~isempty(b1) && ~isempty(b2) && ~isempty(y1) && ~isempty(v1)   % y1 and v1 are known
    
    %%%%%%%%%%%%%%%%%% SpecificEnergy131m %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Specific Energy Equation Problem
    %%% Rectangual Channel
    %%%% Upward/Downward Step
    %%%% Lateral Contraction/Expantion
    %%%%%Function
    %%%%%%%%%%%%%%%%%%%%% Definition Of Variables %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % y1 : upstream depth of water [L]
    % y2 : downstream depth of water [L]
    % v1 : upstream velocity of water [L/T]
    % v2 : downstream velocity of water [L/T]
    % Q : flow rate [L^3 /T]
    % q1 : upstream discharge [L^3 /TL]
    % q2 : downstrean discharge [L^3 /TL]
    % b1 : channel width upstream[L]
    % b2 : channel width downstream[L]
    % E1 : Specific Energy at upstream of channel [L]
    % E2 : Specific Energy at downsteam of channel [L]
    % Fr : Frude Number [dimensionless]
    % yc1 : Critical Depth downstream [L]
    % yc2 : Critical Depth upstream [L]
    % Emin1 : Minimum Specific Energy downstream[L]
    % Emin2 : Minimum Specific Energy downstream[L]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% System of Units must be assigned in GUI ( SI , Eng,etc.)
    %% g , acceleration of gravity
    
    
    % Calculation of Critical Depth,yc, and Frude Number,Fr, upstream.
    q1 = y1*v1;
    yc1 = (((y1*v1)^2)/g)^(1/3);
    Fr1 = v1/sqrt(g*y1);
    Emin1 = 1.5*yc1;
    
    % Calculation of Flow Rate
    Q = y1*v1*b1;
    
    % Calculation of Specific Energy upstream, E1.
    E1 = y1 + (v1^2)/(2*g);
    
    % Calculation of Minimum Specific Eneregy downstream, Emin2.
    q2 = Q/b2;
    Emin2 = 1.5*(((q2^2)/g)^(1/3));
    yc2 = (2/3)*Emin2;
    
    
    %Calculation of y2
    if Fr1 < 1 % SuperCritical Flow Condition
        if (b1-b2) > 0 && (dZ > 0)
            % disp(2)
            if E1-dZ > Emin1
                if E1-dZ > Emin2
                    % Newton-Raphson Iterative Mth
                    %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                    x_0 = y1 - dZ ;
                    Poly = [1,-(E1-dZ),0,((q2^2)/(2*g))];
                    approxRoot = NRmethod(x_0,Poly);
                    y2 = approxRoot(end);
                    v2 = Q/(y2*b2);
                    Fr2 = v2/sqrt(g*y2);
                    
                elseif E1-dZ < Emin2
                    disp('Choke will happen');
                    % Newton-Raphson Iterative Mth
                    %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                    y = yc2 + y1;
                    i = 1;
                    a = zeros(1,2);
                    while i < 3
                        x_0 = y  ;
                        Poly = [1,-(Emin2),0,((q1^2)/(2*g))];
                        approxRoot = NRmethod(x_0,Poly);
                        a(1,i) = approxRoot(end);
                        y = approxRoot(end) - yc1;
                        i=i+1;
                    end
                    y1new = a(1,1);
                    y1newa = a(1,2);
                    y2 = yc2 ;
                    v2 = Q / (yc2*b2) ;
                    v1new = Q/(y1new*b1);
                    Fr2 = v2/sqrt(g*y2);
                else % E1-dZ = Emin2
                    
                    % Newton-Raphson Iterative Mth
                    %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                    x_0 = y1-yc1 ;
                    Poly = [1,-Emin2,0,((q1^2)/(2*g))];
                    approxRoot = NRmethod(x_0,Poly);
                    y1a = approxRoot(end);
                    y2 = yc2;
                    v2 = Q/(yc2*b2);
                    Fr2 = v2/sqrt(g*y2);
                end
                
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
                
            else
                disp('Choke will happen');
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                y = yc2 + y1;
                i = 1;
                a = zeros(1,2);
                while i < 3
                    x_0 = y  ;
                    Poly = [1,-(dZ+Emin2),0,((q1^2)/(2*g))];
                    approxRoot = NRmethod(x_0,Poly);
                    a(1,i) = approxRoot(end);
                    y = approxRoot(end) - yc1;
                    i=i+1;
                end
                y1new = a(1,1);
                y1newa = a(1,2);
                y2 = yc2 ;
                v2 = Q / (yc2*b2) ;
                v1new = Q/(y1new*b1);
                Fr2 = v2/sqrt(g*y2);
            end
            
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        elseif (b1-b2) < 0 && (dZ > 0)
            disp(4)
            if E1-dZ > Emin1
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                x_0 = y1-dZ ;
                Poly = [1,-(E1-dZ),0,((q2^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                y2 = approxRoot(end);
                v2 = Q/(y2*b2);
                Fr2 = v2/sqrt(g*y2);
            elseif E1-dZ < Emin1
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                x_0 = yc1 + dZ ;
                Poly = [1,-(E1-dZ),0,((q2^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                y2 = approxRoot(end);
                v2 = Q/(y2*b2);
                Fr2 = v2/sqrt(g*y2);
            else
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                x_0 = yc1 + dZ ;
                Poly = [1,-(Emin1),0,((q2^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                y2 = approxRoot(end);
                v2 = Q/(y2*b2);
                Fr2 = v2/sqrt(g*y2);
            end
            
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
        
        elseif (b1-b2) > 0 && (dZ < 0)
            %disp(3)
            if E1 - dZ > Emin2
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                x_0 = y1 - dZ ; %dZ<0
                Poly = [1,-(E1-dZ),0,((q2^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                y2 = approxRoot(end);
                v2 = Q/(y2*b2);
                Fr2 = v2/sqrt(g*y2);
            elseif E1-dZ < Emin2
                
                disp('Choke will happen');
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                y = yc2 + y1;
                i = 1;
                a = zeros(1,2);
                while i < 3
                    x_0 = y  ;
                    Poly = [1,-(dZ+Emin2),0,((q1^2)/(2*g))]; %dZ<0
                    approxRoot = NRmethod(x_0,Poly);
                    a(1,i) = approxRoot(end);
                    y = approxRoot(end) - yc1;
                    i=i+1;
                end
                y1new = a(1,1);
                y1newa = a(1,2);
                y2 = yc2 ;
                v2 = Q / (yc2*b2) ;
                v1new = Q/(y1new*b1);
                Fr1new = v1new/sqrt(g*y1new);
                Fr2 = v2/sqrt(g*y2);
            else
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                x_0 = y1 - yc2 ;
                Poly = [1,-(Emin2),0,((q1^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                y1newa = approxRoot(end);
                y2 = yc2 ;
                v2 = Q/(y2*b2);
                Fr2 = v2/sqrt(g*y2);
            end
           
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        elseif (b1-b2) < 0 && (dZ < 0)
            %disp(4)
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y1 + dZ +(Emin1 - Emin2) ;
            Poly = [1,-(E1-dZ) ,0,((q2^2)/(2*g))]; % dZ<0
            approxRoot = NRmethod(x_0,Poly);
            y2 = approxRoot(end);
            v2 = Q/(y2*b2);
            Fr2 = v2/sqrt(g*y2);
        
          %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%  
        
        elseif ((b1-b2) == 0) && (dZ ~= 0)
            
            b = b1 ;
            if dZ > 0
                
                if E1-dZ > Emin1
                    [y2,v2,Q,yc,Fr1,Emin] = SEEP111m(y1,v1,b,dZ);
                    Fr2 = v2/sqrt(g*y2);
                elseif E1-dZ < Emin1
                    [y2,v2,Q,yc,Fr1,Emin,y1new,y1newa,v1new] = SEEP111m(y1,v1,b,dZ);
                    Fr2 = v2/sqrt(g*y2);
                else
                    [y2,v2,Q,yc,Fr1,Emin,y1new,y1newa,v1new] = SEEP111m(y1,v1,b,dZ);
                    Fr2 = v2/sqrt(g*y2);
                end
            elseif dZ < 0
                [y2,v2,Q,yc,Fr1,Emin] = SEEP111m(y1,v1,b,dZ);
                Fr2 = v2/sqrt(g*y2);
            end
            
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        elseif (dZ == 0) && ((b1-b2) ~= 0)
            if b1-b2 > 0
                if E1 > Emin2
                    [y2,v2,Q,E1,yc1,Fr1,Emin1,yc2,Fr2,Emin2] = SEEP121m(y1,v1,b1,b2);
                elseif E1 < Emin2
                    [y2,v2,Q,E1,yc1,Fr1,Emin1,yc2,Fr2,Emin2,y1new,y1newa,v1new] = SEEP121m(y1,v1,b1,b2);
                else
                    [y2,v2,Q,E1,yc1,Fr1,Emin1,yc2,Fr2,Emin2,y1new,y1newa,v1new] = SEEP121m(y1,v1,b1,b2);
                end
            elseif b1-b2 < 0
                [y2,v2,Q,E1,yc1,Fr1,Emin1,yc2,Fr2,Emin2] = SEEP121m(y1,v1,b1,b2);
            end
            
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        elseif (dZ == 0) && ((b1-b2) == 0)
            y2 = y1 ;
            v2 = v1 ;
            Fr2 = v2/sqrt(g*y2);
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        end
       
    elseif Fr1 > 1
        if (b1-b2) > 0 && (dZ > 0)
            %disp(2)
            if E1-dZ > Emin1
                if E1-dZ > Emin2
                    % Newton-Raphson Iterative Mth
                    %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                    x_0 = y1 + (E1 - Emin2) ;
                    Poly = [1,-(E1-dZ),0,((q2^2)/(2*g))];
                    approxRoot = NRmethod(x_0,Poly);
                    y2 = approxRoot(end);
                    v2 = Q/(y2*b2);
                    Fr2 = v2/sqrt(g*y2);
                elseif E1-dZ < Emin2
                    disp('Choke will happen');
                    % Newton-Raphson Iterative Mth
                    %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                    y = yc2 + y1;
                    i = 1;
                    a = zeros(1,2);
                    while i < 3
                        x_0 = y  ;
                        Poly = [1,-(dZ+Emin2),0,((q1^2)/(2*g))];
                        approxRoot = NRmethod(x_0,Poly);
                        a(1,i) = approxRoot(end);
                        y = approxRoot(end) + yc1;
                        i=i+1;
                    end
                    y1newa = a(1,1); % Refer to the notebook of Advanced Hydraulic class.
                    y1new = a(1,2);
                    y2 = yc2 ;
                    v2 = Q / (yc2*b2) ;
                    v1new = Q/(y1new*b1);
                    Fr1new = v1new/sqrt(g*y1new);
                    Fr2 = v2/sqrt(g*y2);
                else % E1-dZ = Emin2
                    
                    % Newton-Raphson Iterative Mth
                    %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                    y = yc2 + y1;
                    i = 1;
                    a = zeros(1,2);
                    while i < 3
                        x_0 = y  ;
                        Poly = [1,-(dZ+Emin2),0,((q1^2)/(2*g))];
                        approxRoot = NRmethod(x_0,Poly);
                        a(1,i) = approxRoot(end);
                        y = approxRoot(end) - yc1;
                        i=i+1;
                    end
                    y1new = a(1,1); % Refer to the notebook of Advanced Hydraulic class.
                    y1newa = a(1,2);
                    y2 = yc2 ;
                    v1new = Q/(y1new*b1);
                    Fr1new = v1new/sqrt(g*y1new);
                    Fr2 = v2/sqrt(g*y2);
                end
                
            else
                disp('Choke will happen');
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                y = yc2 + y1;
                i = 1;
                a = zeros(1,2);
                while i < 3
                    x_0 = y  ;
                    Poly = [1,-(dZ+Emin2),0,((q1^2)/(2*g))];
                    approxRoot = NRmethod(x_0,Poly);
                    a(1,i) = approxRoot(end);
                    y = approxRoot(end) + yc1;
                    i=i+1;
                end
                y1newa = a(1,1); % Refer to the notebook of Advanced Hydraulic class.
                y1new = a(1,2);
                y2 = yc2 ;
                v2 = Q / (yc2*b2) ;
                v1new = Q/(y1new*b1);
                Fr1new = v1new/sqrt(g*y1new);
                Fr2 = v2/sqrt(g*y2);
            end
            
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        elseif (b1-b2) < 0 && (dZ > 0)
            %disp(4)
            if E1-dZ > Emin1
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                x_0 = y1-dz ;
                Poly = [1,-(E1-dZ),0,((q2^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                y2 = approxRoot(end);
                v2 = Q/(y2*b2);
                Fr2 = v2/sqrt(g*y2);
            elseif E1-dZ < Emin1
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                x_0 = yc1 + dZ ;
                Poly = [1,-(E1-dZ),0,((q2^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                y2 = approxRoot(end);
                v2 = Q/(y2*b2);
                Fr2 = v2/sqrt(g*y2);
            else
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                x_0 = yc1 + dZ ;
                Poly = [1,-(Emin1),0,((q2^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                y2 = approxRoot(end);
                v2 = Q/(y2*b2);
                Fr2 = v2/sqrt(g*y2);
            end
            
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        elseif (b1-b2) > 0 && (dZ < 0)
            disp(3)
            if E1 - dZ > Emin2
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                x_0 = y1 - dZ ; %dZ<0
                Poly = [1,-(E1-dZ),0,((q2^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                y2 = approxRoot(end);
                v2 = Q/(y2*b2);
                Fr2 = v2/sqrt(g*y2);
            elseif E1-dZ < Emin2
                
                disp('Choke will happen');
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                y = yc2 + y1;
                i = 1;
                a = zeros(1,2);
                while i < 3
                    x_0 = y  ;
                    Poly = [1,-(dZ+Emin2),0,((q1^2)/(2*g))]; %dZ<0
                    approxRoot = NRmethod(x_0,Poly);
                    a(1,i) = approxRoot(end);
                    y = approxRoot(end) - yc1;
                    i=i+1;
                end
                y1new = a(1,1);
                y1newa = a(1,2);
                y2 = yc2 ;
                v2 = Q / (yc2*b2) ;
                v1new = Q/(y1new*b1);
                Fr1new = v1new/sqrt(g*y1new);
                Fr2 = v2/sqrt(g*y2);
            else
                
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                y = yc2 + y1;
                i = 1;
                a = zeros(1,2);
                while i < 3
                    x_0 = y  ;
                    Poly = [1,-(dZ+Emin2),0,((q1^2)/(2*g))]; %dZ<0
                    approxRoot = NRmethod(x_0,Poly);
                    a(1,i) = approxRoot(end);
                    y = approxRoot(end) - yc1;
                    i=i+1;
                end
                y1new = a(1,1);
                y1newa = a(1,2);
                y2 = yc2 ;
                v1new = Q/(y1new*b1);
                Fr2 = v2/sqrt(g*y2);
            end
            
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        elseif (b1-b2) < 0 && (dZ < 0)
            %disp(4)
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y1 - dZ  ;
            Poly = [1,-(E1-dZ) ,0,((q2^2)/(2*g))]; % dZ<0
            approxRoot = NRmethod(x_0,Poly);
            y2 = approxRoot(end);
            v2 = Q/(y2*b2);
          
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
         elseif (b1-b2) == 0 && (dZ ~= 0) 
            if dZ > 0
                
                if E1-dZ > Emin1
                    [y2,v2,Q,yc,Fr1,Emin] = SEEP111m(y1,v1,b,dZ);
                    
                elseif E1-dZ < Emin1
                    [y2,v2,Q,yc,Fr1,Emin,y1new,y1newa,v1new] = SEEP111m(y1,v1,b,dZ);
                else
                    [y2,v2,Q,yc,Fr1,Emin,y1new,y1newa,v1new] = SEEP111m(y1,v1,b,dZ);
                end
            elseif dZ < 0
                [y2,v2,Q,yc,Fr1,Emin] = SEEP111m(y1,v1,b,dZ);
            end
            
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        elseif (dZ == 0) && ((b1-b2) ~= 0)
            if b1-b2 > 0
                if E1 > Emin2
                    [y2,v2,Q,E1,yc1,Fr1,Emin1,yc2,Fr2,Emin2] = SEEP121m(y1,v1,b1,b2);
                elseif E1 < Emin2
                    [y2,v2,Q,E1,yc1,Fr1,Emin1,yc2,Fr2,Emin2,y1new,y1newa,v1new] = SEEP121m(y1,v1,b1,b2);
                else
                    [y2,v2,Q,E1,yc1,Fr1,Emin1,yc2,Fr2,Emin2,y1new,y1newa,v1new] = SEEP121m(y1,v1,b1,b2);
                end
            elseif b1-b2 < 0
                [y2,v2,Q,E1,yc1,Fr1,Emin1,yc2,Fr2,Emin2] = SEEP121(y1,v1,b1,b2);
            end
            
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        elseif (dZ == 0) && ((b1-b2) == 0)
            y2 = y1 ;
            v2 = v1 ;
            Fr2 = v2/sqrt(g*y2);
            %Modification%
            E2 = y2 + (v2^2)/(2*g);
            %%%%%
            
        end
         
        
    end
    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif ~isempty(dZ) && ~isempty(b1) && ~isempty(b2) && (b1 - b1 == 0)&& ~isempty(y2) && ~isempty(v2)  %v2 and y2 are known
    b = b1;
    
    %%%%%%%%%%%%%%%%%% SpecificEnergy113 %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% System of Units must be assigned in GUI ( SI , Eng,etc.)
    %% g , acceleration of gravity
    %g = 32.2;
    % Calculation of Critical Depth,yc, and Frude Number,Fr.
    yc = (((y2*v2)^2)/g)^(1/3);
    Fr2 = v2/sqrt(g*y2);
    Emin = 1.5*yc;
    
    % Calculation of Flow Rate
    Q = y2*v2*b;
    
    % Calculation of Specific Energy upstream, E2.
    E2 = y2 + (v2^2)/(2*g);
    
    %Calculation of y1
    if Fr2 == 1.0000
        
        disp('Choke will happen/There will be Backwater'); %% May be we have to do extra calculation as complementary.
        
        %Calculation of y2
    elseif Fr2 > 1 % SuperCritical Flow Condition
        
        if dZ > 0 %%% it may not necessarily be inserted with any sign in GUD Input panel, it is better to let the user to choose whether it is upward/downward step
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y2 - dZ ;
            Poly = [1,-(E2+dZ),0,(((y2*v2)^2)/(2*g))];
            approxRoot = NRmethod(x_0,Poly);
            y1 = approxRoot(end);
            v1 = Q/(y1*b);
            
            
        elseif dZ < 0 %%% it may not necessarily be inserted with any sign in GUD Input panel, it is better to let the user to choose whether it is upward/downward step
            E2 = y2 + (v2^2)/(2*g);
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel
            x_0 = y2 + dZ ;
            Poly = [1,-(E2+dZ),0,(((y2*v2)^2)/(2*g))];  %%%%%%%% in GUI, we may use "if Upward", then insert "positive dZ" !!!
            approxRoot = NRmethod(x_0,Poly);
            y1 = approxRoot(end);
            v1 = Q/(y1*b);
        end
        
    elseif Fr2 < 1 % SubCritical Flow Condition
        
        if dZ > 0 %%% it may not necessarily be inserted with any sign in GUD Input panel, it is better to let the user to choose whether it is upward/downward step
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y2 + dZ ;
            Poly = [1,-(E2+dZ),0,(((y2*v2)^2)/(2*g))];
            approxRoot = NRmethod(x_0,Poly);
            y1 = approxRoot(end);
            v1 = Q/(y1*b);
            
        elseif dZ < 0 %%% it may not necessarily be inserted with any sign in GUD Input panel, it is better to let the user to choose whether it is upward/downward step
            E2 = y2 + (v2^2)/(2*g);
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel
            x_0 = y2 + dZ ;
            Poly = [1,-(E2+dZ),0,(((y2*v2)^2)/(2*g))];
            approxRoot = NRmethod(x_0,Poly);
            y1 = approxRoot(end);
            v1 = Q/(y1*b);
        end
    end
    
    % Modifications %
    % Calculation of Specific Energy upstream, E2.
    E1 = y1 + (v1^2)/(2*g);
    
    yc1 = yc;
    yc2 = yc;
    Fr1 = v1/sqrt(g*y1);
    Emin1 = Emin;
    Emin2 = Emin;
    y1new = [];
    v1new = [];
    y1newa = [];
    
    
elseif ~isempty(dZ) && ~isempty(b1) && ~isempty(b2) &&  ~isempty(y2) && ~isempty(v2)
    
    %%%%%%%%%%%%%%%%% SpecificEnergy123 %%%%%%%%%%%%%%%%
    
    %% System of Units must be assigned in GUI ( SI , Eng,etc.)
    %% g , acceleration of gravity
    %g = 32.2;
    
    % Calculation of Critical Depth,yc, and Frude Number,Fr.
    yc2 = (((y2*v2)^2)/g)^(1/3);
    Fr2 = v2/sqrt(g*y2);
    Emin2 = 1.5*yc2;
    
    % Calculation of Flow Rate
    Q = y2*v2*b2;
    
    % Calculation of Specific Energy upstream, E1.
    E2 = y2 + (v2^2)/(2*g);
    
    % Calculation of Minimum Specific Eneregy upstream, Emin1.
    q1 = Q/b1;
    Emin1 = 1.5*(((q1^2)/g)^(1/3));
    
    if Fr2 == 1.0000
        
        disp('Choke will happen/There will be Backwater'); %% May be we have to do extra calculation/insight view.
        
        %Calculation of y1
    elseif Fr2 > 1 % SuperCritical Flow Condition
        if b1-b2 > 0
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y2 - (E2 - Emin2) ;
            Poly = [1,-E2,0,((q1^2)/(2*g))];
            approxRoot = NRmethod(x_0,Poly);
            y1 = approxRoot(end);
            v1 = Q/(y1*b1);
            
            
        elseif b1-b2 < 0
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y2 + Emin2 ;
            Poly = [1,-E2,0,((q1^2)/(2*g))];
            approxRoot = NRmethod(x_0,Poly);
            y1 = approxRoot(end);
            v1 = Q/(y1*b1);
        end
    elseif Fr2 < 1 % SubCritical Flow Condition
        if b1-b2 > 0
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y2 + (E2 - Emin2) ;
            Poly = [1,-E2,0,((q1^2)/(2*g))];
            approxRoot = NRmethod(x_0,Poly);
            y1 = approxRoot(end);
            v1 = Q/(y1*b1);
            
            
        elseif b1-b2 < 0
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y2 - (E2 - Emin2) ;
            Poly = [1,-E2,0,((q1^2)/(2*g))];
            approxRoot = NRmethod(x_0,Poly);
            y1 = approxRoot(end);
            v1 = Q/(y1*b1);
        end
    end

    
end

end

