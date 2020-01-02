function [Table_profile] = hydro_direct_step (y1, y2, Profile_datum, Ch_Q, Ch_S, Ch_n, g, man_n_c, N_int)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y1 --> x1=0

Table_profile=zeros(N_int+1 ,10); % Direct Step Method Table
Table_profile(1,1)=y1;

for i=2:N_int+1
    Table_profile(i,1)=Table_profile(i-1,1)-((abs(y1-y2))/N_int)*sign(y1-y2); % Depth
end

for i=1:N_int+1
    
    [~, A_Area, P_Perimeter ] = hydro_Area(Profile_datum, Table_profile(i,1) );
   
    Table_profile(i,2)= A_Area; % Area
    Table_profile(i,3)= A_Area/P_Perimeter; % Hydraulic Radius
    Table_profile(i,4)=Table_profile(i,1)+ (Ch_Q^2)/(2*g*(A_Area^2)); % E
    Table_profile(i,5)=(((Ch_Q)*(Ch_n))/((man_n_c*A_Area)*(Table_profile(i,3)^(2/3))))^2; % Sf
    
end

for i=2:N_int+1
    Table_profile(i,6)=(Table_profile(i,5)+Table_profile(i-1,5))/2; % Sf average
    Table_profile(i,7)=Ch_S-Table_profile(i,6); % S0-Sf
    Table_profile(i,8)=Table_profile(i,4)-Table_profile(i-1,4); % delta-E
    Table_profile(i,9)=Table_profile(i,8)/Table_profile(i,7); % delta-X
    Table_profile(i,10)=Table_profile(i,9)+Table_profile(i-1,10); % X
end

end
