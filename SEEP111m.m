function [y2,v2,Q,yc,Fr1,Emin,y1new,y1newa,v1new] = SEEP111m(y1,v1,b,dZ)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Specific Energy Equation Problem - FUNCTION
%%% Rectangual Channel
%%%% Upward/Downward Step
%%%% No Lateral Compaction/Expantion

%%%%%%%%%%%%%%%%%%%%% Definition Of Variables %%%%%%%%%%%%%%%%%%%%%%%%%%

% y1 : upstream depth of water [L]
% y2 : downstream depth of water [L]
% y1new : upstream depth of water after Choke, backwater depth [L]
% y1newa : downstream depth, alternate depth of upstream depth after choke
% v1 : upstream velocity of water [L/T]
% v1new : upstream velocity of water after Choke [L/T]
% v2 : downstream velocity of water [L/T]
% Q : flow rate [L^3 /T]
% b : channel width [L]
% dZ : upward/downward step of bottom of channel [L]
% E1 : Specific Energy at upstream of channel [L]
% E2 : Specific Energy at downsteam of channel [L]
% Fr1 : Frude Number upstream [dimensionless]
% Fr2 : Frude Number downstream [dimensionless]
% yc : Critical Depth [L]
% Emin : Minimum Specific Energy [L]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% System of Units must be assigned in GUI ( SI , Eng,etc.)
%% g , acceleration of gravity
g = 32.2;
% Calculation of Critical Depth,yc, and Frude Number,Fr.
yc = (((y1*v1)^2)/g)^(1/3);
Fr1 = v1/sqrt(g*y1);
Emin = 1.5*yc;

% Calculation of Flow Rate
Q = y1*v1*b;
q = Q/b;

% Calculation of Specific Energy upstream, E1.
E1 = y1 + (v1^2)/(2*g);

%Calculation of y2
if Fr1 > 1 % SuperCritical Flow Condition
    
    if dZ > 0 %%% it may not necessarily be inserted with any sign in GUD Input panel, it is better to let the user to choose whether it is upward/downward step
        if E1-dZ > Emin
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y1 + dZ ;
            Poly = [1,-(E1-dZ),0,(((y1*v1)^2)/(2*g))];
            approxRoot = NRmethod(x_0,Poly);
            y2 = approxRoot(end);
            v2 = Q/(y2*b);
        elseif E1-dZ < Emin
            %disp('1');
            disp('Choke will happen'); %% May be we have to do extra calculation as complementary.
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            y = dZ + y1;
            i = 1;
            a = zeros(1,2);
            while i < 3
                x_0 = y  ;
                Poly = [1,-(dZ+Emin),0,((q^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                a(1,i) = approxRoot(end);
                y = approxRoot(end) - yc;
                i=i+1;
            end
            y1newa = a(1,1);
            y1new = a(1,2);
            y2 = yc ;
            v2 = Q / (yc*b) ;
            v1new = Q/(y1new*b);
            
        else % E1-dZ = Emin
            %disp('2');
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            y = yc + y1;
            i = 1;
            a = zeros(1,2);
            while i < 3
                x_0 = y  ;
                Poly = [1,-(dZ+Emin),0,((q^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
                a(1,i) = approxRoot(end);
                y = approxRoot(end)-yc;
                i=i+1;
            end
            y1new = a(1,1); % Refer to the notebook of Advanced Hydraulic class.
            y1newa = a(1,2);
            y2 = yc ;
            v1new = Q/(y1new*b);
            
            
        end
    elseif dZ < 0 %%% it may not necessarily be inserted with any sign in GUD Input panel, it is better to let the user to choose whether it is upward/downward step
        %E1 = y1 + (v1^2)/(2*g);
        
        % Newton-Raphson Iterative Mth
        %% the values must be specifed in GUI Input panel
        x_0 = y1 + dZ ;
        Poly = [1,-(E1-dZ),0,(((y1*v1)^2)/(2*g))]; %%%%%%%% in GUI, we may use "if Upward", then insert "positive dZ" !!!
        approxRoot = NRmethod(x_0,Poly);
        y2 = approxRoot(end);
        v2 = Q/(y2*b);
    end
    
elseif Fr1 < 1 % SubCritical Flow Condition
    
    if dZ > 0 %%% it may not necessarily be inserted with any sign in GUD Input panel, it is better to let the user to choose whether it is upward/downward step
        if E1-dZ > Emin
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y1 - dZ ;
            Poly = [1,-(E1-dZ),0,(((y1*v1)^2)/(2*g))];
            [approxRoot] = NRmethod(x_0,Poly);
            y2 = approxRoot(end);
            v2 = Q/(y2*b);
            %y1new =[];
            %y1newa = [];
            %v1new = [];
        elseif  E1-dZ < Emin
            %disp('3');
            disp('Choke will happen'); %% May be we have to do extra calculation as complementary.
            
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            y = yc + y1;
            i = 1;
            a = zeros(1,2);
            while i < 3
                x_0 = y  ;
                Poly = [1,-(dZ+Emin),0,((q^2)/(2*g))];
                [approxRoot] = NRmethod(x_0,Poly);
                a(1,i) = approxRoot(end);
                y = approxRoot(end) - 2*dZ;
                i=i+1;
            end
            y1new = a(1,1);
            y1newa = a(1,2);
            y2 = yc ;
            v2 = Q / (yc*b) ;
            v1new = Q/(y1new*b);
        else
            %disp('4');
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            x_0 = y1-yc1 ;
            Poly = [1,-Emin,0,((q^2)/(2*g))];
            [approxRoot] = NRmethod(x_0,Poly);
            y1a = approxRoot(end);
            y2 = yc;
            v2 = Q/(yc*b);
        end
        
    elseif dZ < 0 %%% it may not necessarily be inserted with any sign in GUD Input panel, it is better to let the user to choose whether it is upward/downward step
        %E1 = y1 + (v1^2)/(2*g);
        
        % Newton-Raphson Iterative Mth
        %% the values must be specifed in GUI Input panel
        x_0 = y1 - dZ ;
        Poly = [1,-(E1-dZ),0,(((y1*v1)^2)/(2*g))];
        [approxRoot] = NRmethod(x_0,Poly);
        y2 = approxRoot(end);
        v2 = Q/(y2*b);
    end
end
end
