function [Profile, A_Area, P_Perimeter, Y_bar ] = hydro_Y_bar(Profile_datum, Y_lim )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Y_lim < max(Profile_datum(:,2))
    
    profile_zero=[];
    profile_zero(:,1)=Profile_datum(:,1);
    profile_zero(:,2)=Profile_datum(:,2);
    for i=size(profile_zero,1):-1:1
        
        if profile_zero(i,2) > Y_lim
            profile_zero(i,:)=[];
        end
        
    end
    
    Profile=zeros(size(profile_zero,1)+2,2);
    Profile(2:end-1,:)=profile_zero;
    Profile(1,2)=Y_lim; Profile(end,2)=Y_lim;
    
    i_mat=zeros(2,2);
    counter_y=0;
    for i=1:size(Profile_datum,1)-1
        if ( Profile_datum(i,2) > Y_lim ) && ( Profile_datum(i+1,2) <= Y_lim )
            counter_y=counter_y+1;
            i_mat(counter_y,1)=i;
            i_mat(counter_y,2)=i+1;
        elseif ( Profile_datum(i,2) < Y_lim ) && ( Profile_datum(i+1,2) >= Y_lim )
            counter_y=counter_y+1;
            i_mat(counter_y,1)=i;
            i_mat(counter_y,2)=i+1;
        end
    end
    
    k=1;
    delta_x_1=( (Y_lim  - min(Profile_datum(i_mat(k,1),2),Profile_datum(i_mat(k,2),2))) / ...
        (max(Profile_datum(i_mat(k,1),2),Profile_datum(i_mat(k,2),2)) - min(Profile_datum(i_mat(k,1),2),Profile_datum(i_mat(k,2),2))) ) * ( abs(Profile_datum(i_mat(k,1),1) - Profile_datum(i_mat(k,2),1)) ) ;
    if delta_x_1 > 0
        Profile(1,1)= max(Profile_datum(i_mat(k,1),1) , Profile_datum(i_mat(k,2),1)) - delta_x_1 ;
    else
        Profile(1,1)= max(Profile_datum(i_mat(k,1),1) , Profile_datum(i_mat(k,2),1)) + delta_x_1 ;
    end
    k=2;
    delta_x_2=( (Y_lim  - min(Profile_datum(i_mat(k,1),2),Profile_datum(i_mat(k,2),2))) / ...
        (max(Profile_datum(i_mat(k,1),2),Profile_datum(i_mat(k,2),2)) - min(Profile_datum(i_mat(k,1),2),Profile_datum(i_mat(k,2),2))) ) * ( abs(Profile_datum(i_mat(k,1),1) - Profile_datum(i_mat(k,2),1)) ) ;
    Profile(end,1)= min(Profile_datum(i_mat(k,1),1) , Profile_datum(i_mat(k,2),1)) +delta_x_2 ;
    
else
    
    Profile =Profile_datum;
    
end

Profile(:,1)=Profile(:,1)-Profile(1,1);

area_zero=( abs(Profile(end,1)-Profile(1,1)))*(max(Profile(:,2)-min(Profile(:,2))));
area_under=0;
for i=2:size(Profile,1)
    area_under=area_under+ (( abs(Profile(i,1)-Profile(i-1,1))) * (Profile(i,2)+Profile(i-1,2)) *0.5);
end
A_Area=area_zero-area_under; % Wetted Area

P_Perimeter=0; % Wetted Perimeter
for i=2:size(Profile,1)
    P_Perimeter=P_Perimeter+(((Profile(i,1)-Profile(i-1,1))^2)+((Profile(i,2)-Profile(i-1,2))^2))^0.5;
end

%%% Y_bar Calculation %%%

A_i=zeros(size(Profile,1)-1,1);
Y_i=zeros(size(Profile,1)-1,1);
AY_i=zeros(size(Profile,1)-1,1);
for i=2:size(Profile,1)
    
    A_i(i-1,1)= (abs(Profile(i,1)-Profile(i-1,1)))*(max(Profile(:,2)-min(Profile(:,2)))) - (( abs(Profile(i,1)-Profile(i-1,1))) * (Profile(i,2)+Profile(i-1,2)) *0.5) ;
    y2= max( (max(Profile(:,2)-min(Profile(:,2))))-Profile(i,2) , (max(Profile(:,2)-min(Profile(:,2))))-Profile(i-1,2) );
    y1= min( (max(Profile(:,2)-min(Profile(:,2))))-Profile(i,2) , (max(Profile(:,2)-min(Profile(:,2))))-Profile(i-1,2) );
    Y_i(i-1,1)=( ((y1^2)/2) + (abs(y2-y1)/2) *( (y2/3)+(2*y1/3)) ) / ((y1+y2)/2) ;
    AY_i(i-1,1)=A_i(i-1,1)*Y_i(i-1,1);

end

Y_bar=sum(AY_i) / sum(A_i) ; % Section Y_bar from the Water Surface

end

