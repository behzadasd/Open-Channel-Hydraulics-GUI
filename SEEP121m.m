function [y2,v2,Q,E1,yc1,Fr1,Emin1,yc2,Fr2,Emin2,y1new,y1newa,v1new] = SEEP121m(y1,v1,b1,b2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Specific Energy Equation Problem - FUNCTION
%%% Rectangual Channel
%%%% No Upward/Downward Step 
%%%% Lateral Compaction/Expantion

%%%%%%%%%%%%%%%%%%%%% Definition Of Variables %%%%%%%%%%%%%%%%%%%%%%%%%%

% y1 : upstream depth of water [L]
% y2 : downstream depth of water [L]
% y1new : upstream depth of water after Choke, backwater depth [L]
% y1newa : downstream depth, alternate depth of upstream depth after choke
% v1 : upstream velocity of water [L/T]
% v1new : upstream velocity of water after Choke [L/T]
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
g = 32.2;

% Calculation of Critical Depth,yc, and Frude Number,Fr, upstream.
yc1 = (((y1*v1)^2)/g)^(1/3);
Fr1 = v1/sqrt(g*y1);
Emin1 = 1.5*yc1;

% Calculation of Critical Depth,yc, and Frude Number,Fr, downstream.
yc2 = (2/3)*Emin2 ;
Fr2 = (v2/sqrt(g*y2));

% Calculation of Flow Rate 
Q = y1*v1*b1;

% Calculation of Specific Energy upstream, E1.
E1 = y1 + (v1^2)/(2*g);

% Calculation of Minimum Specific Eneregy downstream, Emin2.
q2 = Q/b2;
Emin2 = 1.5*(((q2^2)/g)^(1/3));

%Calculation of y2
if Fr1 > 1 % SuperCritical Flow Condition
  if b1-b2 > 0
    if E1 > Emin2
        % Newton-Raphson Iterative Mth
          %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
          x_0 = y1 + E1 - Emin2 ;
          Poly = [1,-E1,0,((q2^2)/(2*g))];
        approxRoot = NRmethod(x_0,Poly);
         y2 = approxRoot(end);
         v2 = Q/(y2*b2);
    elseif E1 < Emin2
              disp('Choke will happen'); %% May be we have to do extra calculation as complementary.
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
                y = approxRoot(end) - yc2;
                i=i+1;
            end
            y1newa = a(1,1);
            y1new = a(1,2);
            y2 = yc2 ;
            v2 = Q / (yc2*b2) ;
            v1new = Q/(y1new*b1);
    else %E1 = Emin2
            % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            y = yc2 + y1;
            i = 1;
            a = zeros(1,2);
            while i < 3
                x_0 = y  ;
                Poly = [1,-(Emin2),0,((q1^2)/(2*g))];
                approxRoot = NRmethod(x_0,Poly);
               a(1,i) = approxRoot (end);
               y = approxRoot (end) - yc2;
               i=i+1;
            end
            y1new = a(1,1); % Refer to the notebook of Advanced Hydraulic class.
            y1newa = a(1,2);
            y2 = yc2 ;
            v1new = Q/(y1new*b1);
    end
    
  elseif b1-b2 < 0
      
   % Newton-Raphson Iterative Mth
          %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
          x_0 = y1 - Emin2 ;
          Poly = [1,-E1,0,((q2^2)/(2*g))];
         approxRoot = NRmethod(x_0,Poly);
         y2 = approxRoot(end);
         v2 = Q/(y2*b2);
  end
elseif Fr1 < 1 % SubCritical Flow Condition
     if b1-b2 > 0
       if E1 > Emin2
        % Newton-Raphson Iterative Mth
          %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
          x_0 = y1 - (E1 - Emin2) ;
          Poly = [1,-E1,0,((q2^2)/(2*g))];
         approxRoot = NRmethod(x_0,Poly);
         y2 = approxRoot(end);
         v2 = Q/(y2*b2);
       elseif E1 < Emin2
              disp('Choke will happen'); %% May be we have to do extra calculation as complementary.
                % Newton-Raphson Iterative Mth
                %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
                y = yc + y1;
                i = 1;
                a = zeros(1,2);
                while i < 3
                    x_0 = y  ;
                    Poly = [1,-(Emin2),0,((q1^2)/(2*g))];
                    approxRoot = NRmethod(x_0,Poly);
                    a(1,i) = approxRoot(end);
                    y = approxRoot(end) - yc2;
                    i=i+1;
                end
                y1new = a(1,1);
                y1newa = a(1,2);
                y2 = yc ;
                v2 = Q / (yc*b) ;
                v1new = Q/(y1new*b);
       else
                   % Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
            y = yc2 + y1;
            i = 1;
            a = zeros(1,2);
            while i < 3
                x_0 = y  ;
                Poly = [1,-(Emin2),0,((q1^2)/(2*g))];
               approxRoot = NRmethod(x_0,Poly);
               a(1,i) = approxRoot (end);
               y = approxRoot (end) - yc2;
               i=i+1;
            end
            y1new = a(1,1); % Refer to the notebook of Advanced Hydraulic class.
            y1newa = a(1,2);
            y2 = yc2 ;
            v1new = Q/(y1new*b1);    
       end
    
    elseif b1-b2 < 0
      
   % Newton-Raphson Iterative Mth
          %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
          x_0 = y1 + (E1 - Emin2) ;
          Poly = [1,-E1,0,((q2^2)/(2*g))];
         approxRoot = NRmethod(x_0,Poly);
         y2 = approxRoot(end);
         v2 = Q/(y2*b2);
     end
end


end
