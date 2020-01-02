function [Ch_B, Ch_n, Ch_S, Ch_Y, Ch_Q, Ch_V ] = Hydraulics_Manning(Profile_datum, Load_Data, Ch_B, Ch_z1, Ch_z2, Ch_n, Ch_S, Ch_Y, Ch_Q, g)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Load_Data=0  No Need to Load Profile Data, B and Z will be given
%%% Load_Data=1  Necessary to Load Profile Data, No Need for B and Z

if g < 20
    man_n_c=1; % Manning N Coefficient - For Metric Units
else
    man_n_c=1.486; % Manning N Coefficient - For English Units
end

%%% Creating/Loading Channel Profile %%%
if Load_Data==0
    
    if ( ~isempty(Ch_B) && ~isempty(Ch_z1) && ~isempty(Ch_z2) )
        %%% Trapezoidal Channel Char. %%%
        y_zero=1000;
        Profile_datum=zeros(4,2);
        Profile_datum(1,2)=y_zero; Profile_datum(4,2)=y_zero;
        Profile_datum(2,1)=y_zero*Ch_z1;
        Profile_datum(3,1)=Profile_datum(2,1)+Ch_B;
        Profile_datum(4,1)=Profile_datum(3,1)+y_zero*Ch_z2;
    end
    
end

for jjj=1:1
    
    %%% No. 1 %%% Y , n , S , Z , B are Known - Q and V UnKnown %%%
    if ( ~isempty(Ch_Y) && ~isempty(Ch_n) && ~isempty(Ch_S) && isempty(Ch_Q) )
        
        [Profile, A_Area, P_Perimeter ] = hydro_Area(Profile_datum, Ch_Y );
        R_hyd=A_Area/P_Perimeter;
        Ch_V=(man_n_c/Ch_n)* (R_hyd^(2/3)) * (Ch_S^(1/2)) ;
        Ch_Q=Ch_V*A_Area;
        
        %%% No. 2 %%% Y , n , Z , B are Known - S UnKnown %%%
    elseif ( ~isempty(Ch_Q) && ~isempty(Ch_n) && ~isempty(Ch_Y) && isempty(Ch_S) )
        
        [Profile, A_Area, P_Perimeter ] = hydro_Area(Profile_datum, Ch_Y );
        R_hyd=A_Area/P_Perimeter;
        Ch_V=Ch_Q/A_Area;
        Ch_S=(Ch_V/( (man_n_c/Ch_n)* (R_hyd^(2/3))) )^2;
        
        %%% No. 2 %%% Y , S , Z , B are Known - n UnKnown %%%
    elseif ( ~isempty(Ch_Q) && ~isempty(Ch_S) && ~isempty(Ch_Y) && isempty(Ch_n) )
        
        [Profile, A_Area, P_Perimeter ] = hydro_Area(Profile_datum, Ch_Y );
        R_hyd=A_Area/P_Perimeter;
        Ch_V=Ch_Q/A_Area;
        Ch_n=(man_n_c * (R_hyd^(2/3)) * (Ch_S^(1/2)) )/ Ch_V;
        
        %%% No. 4 %%% Q , n , S , Z , B are Known - Y UnKnown %%%
    elseif ( ~isempty(Ch_Q) && ~isempty(Ch_n) && ~isempty(Ch_S) && isempty(Ch_Y) )
        
        y_t=0;
        y_step=0.01;
        error_min=0.01;
        error_t=1E10;
        for t=1:10000
            y_t=y_t+y_step;
            [Profile_t, A_Area_t, P_Perimeter_t ] = hydro_Area(Profile_datum, y_t );
            R_hyd_t=A_Area_t/P_Perimeter_t;
            Ch_V_t=(man_n_c/Ch_n)* (R_hyd_t^(2/3)) * (Ch_S^(1/2)) ;
            Ch_Q_t = (Ch_V_t) * (A_Area_t);
            error_t = Ch_Q - Ch_Q_t;
            
            if error_t < error_min
                Ch_V=Ch_V_t;
                Ch_Y=y_t;
                break
            end
        end
        
        %%% No. 5 %%% Q , Y , n , S , Z are Known - B UnKnown %%%
    elseif ( ~isempty(Ch_Q) && ~isempty(Ch_Y) && ~isempty(Ch_S) && ~isempty(Ch_n) && isempty(Ch_B) )
        
        b_t=0;
        b_step=0.01;
        error_min=0.01;
        error_t=1E10;
        for t=1:10000
            b_t=b_t+b_step;
            
            A_Area_t= (b_t*Ch_Y) + ((Ch_Y^2)/2)*(Ch_z1+Ch_z2) ;
            P_Perimeter_t=b_t+ Ch_Y *( sqrt(1+Ch_z1^2)+ sqrt(1+Ch_z2^2) );
            R_hyd_t=A_Area_t/P_Perimeter_t;
            Ch_V_t=(man_n_c/Ch_n)* (R_hyd_t^(2/3)) * (Ch_S^(1/2)) ;
            Ch_Q_t = (Ch_V_t) * (A_Area_t);
            error_t = Ch_Q - Ch_Q_t;
            
            if error_t < error_min
                Ch_V=Ch_V_t;
                Ch_B=b_t;
                break
            end
        end
        
        
        
    end
    
    
end


