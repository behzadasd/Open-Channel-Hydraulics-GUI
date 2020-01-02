function [Profile_datum, Ch_Q, Ch_Yc, Ch_Sc, Ch_Yn1, Ch_Yn2, Scenario, Flow_Profile, P_Sec] = Hydraulics_GVF_LakeChannel(Profile_datum, Load_Data, Ch_B, Ch_z1, Ch_z2, Ch_n, Ch_S1, Ch_S2, Lk_E0, Ch_Q, g)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Load_Data=0  No Need to Load Profile Data, B and Z will be given
%%% Load_Data=1  Necessary to Load Profile Data, No Need for B and Z

N_int=20;
joint_n=7; % Number of points for joint profiles
joint_c=1; % Coefficient of joint profile lenght comparing to previous profile [ (1/joint_c)*L ]

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

%%% No. 1 %%% E_zero , n , S , Z , B are Known - Q UnKnown %%%
if ( ~isempty(Lk_E0) && ~isempty(Ch_n) && ~isempty(Ch_S1) && ~isempty(Ch_S2) && isempty(Ch_Q))
    
    % Assume the channel is steep in the 1st sec. , find Sc and compare with S to investigate this assumption
    
    %%% Y_c calculation %%%
    [Profile_c, Ch_Yc, Ch_Q, A_Area_c, P_Perimeter_c] = PSO_Solver_E_Yc (0.001, 100, Lk_E0, g, Profile_datum);
    R_hyd_c=A_Area_c/P_Perimeter_c;
    Ch_V_c=Ch_Q/A_Area_c;
    Ch_Sc=(Ch_V_c/((man_n_c/Ch_n)*(R_hyd_c^(2/3))))^2;
    
    %%% Y_n1 calculation %%%
    [Profile_t1, Ch_Yn1, A_Area_t1, P_Perimeter_t1] = PSO_Solver_Q_Yn (0.001, 100, Ch_Q, Ch_n, Ch_S1, man_n_c, Profile_datum);
    
    %%% Y_n2 calculation %%%
    [Profile_t2, Ch_Yn2, A_Area_t2, P_Perimeter_t2] = PSO_Solver_Q_Yn (0.001, 100, Ch_Q, Ch_n, Ch_S2, man_n_c, Profile_datum);
    
    
    if Ch_S1 < Ch_Sc % That means the 1st sec. is mild and initial assumption of the section being steep is wrong
        
        [Profile_t, Ch_Yn1, Ch_Q, A_Area_t, P_Perimeter_t] = PSO_Solver_E_Yn (0.001, 100, Lk_E0, Ch_n, Ch_S1, man_n_c, g, Profile_datum);
        
        [Profile_c, Ch_Yc, A_Area_c, P_Perimeter_c] = PSO_Solver_Q_Yc (0.001, 100, Ch_Q, g, Profile_datum);
        
    end
    
    
    %%% No. 2 %%% Q , n , S , Z , B are Known - E_zero UnKnown %%%
elseif ( ~isempty(Ch_Q) && ~isempty(Ch_n) && ~isempty(Ch_S1) && ~isempty(Ch_S2) && isempty(Lk_E0))
    
    %%% Y_c calculation %%%
    [Profile_c, Ch_Yc, A_Area_c, P_Perimeter_c] = PSO_Solver_Q_Yc (0.001, 100, Ch_Q, g, Profile_datum);
    
    R_hyd_c=A_Area_c/P_Perimeter_c;
    Ch_V_c=Ch_Q/A_Area_c;
    Ch_Sc=(Ch_V_c/( (man_n_c/Ch_n)* (R_hyd_c^(2/3))) )^2;
    
    %%% Y_n1 calculation %%%
    [Profile_t1, Ch_Yn1, A_Area_t1, P_Perimeter_t1] = PSO_Solver_Q_Yn (0.001, 100, Ch_Q, Ch_n, Ch_S1, man_n_c, Profile_datum);
    
    %%% Y_n2 calculation %%%
    [Profile_t2, Ch_Yn2, A_Area_t2, P_Perimeter_t2] = PSO_Solver_Q_Yn (0.001, 100, Ch_Q, Ch_n, Ch_S2, man_n_c, Profile_datum);
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Channel Section Steepness or Mildness Detection %%%
if Ch_S1 < Ch_Sc
    Ch_status1='mild';
else
    Ch_status1='steep';
end
if Ch_S2 < Ch_Sc
    Ch_status2='mild';
else
    Ch_status2='steep';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Creating Flow Profile %%%
if (strcmpi(Ch_status1, 'mild')) && (strcmpi(Ch_status2, 'mild'))
    
    Scenario='1)mild - 2)mild';
    %%% Profile_joint1 + Profile_1end + Profile_joint2 *2
    [Table_profile_1end] = hydro_direct_step (Ch_Yn1, Ch_Yn2, Profile_datum, Ch_Q, Ch_S1, Ch_n, g, man_n_c, N_int);
    Profile_1end(:,2)=Table_profile_1end(:,1);
    Profile_1end(:,1)=Table_profile_1end(:,end);
    
    L_joint1=abs((Profile_1end(2,end)-Profile_1end(2,1))/joint_c);
    Profile_joint1=zeros(joint_n+1,2);
    Profile_joint1(:,2)=Ch_Yn1;
    for i=2:joint_n+1
        Profile_joint1(i,1)=(L_joint1/joint_n)*(i-1);
    end
    
    Profile_joint2=zeros(joint_n+1,2);
    Profile_joint2(:,2)=Ch_Yn2;
    for i=2:joint_n+1
        Profile_joint2(i,1)=(L_joint1/joint_n)*(i-1);
    end
    
    nn=4;
    Profile=zeros(2*N_int,2,nn);
    N(1,1)=size(Profile_joint1,1); Profile(1:N(1,1),:,1)=Profile_joint1;
    N(2,1)=size(Profile_1end,1); Profile(1:N(2,1),:,2)=Profile_1end;
    N(3,1)=size(Profile_joint2,1); Profile(1:N(3,1),:,3)=Profile_joint2;
    N(4,1)=size(Profile_joint2,1); Profile(1:N(4,1),:,4)=Profile_joint2;
    
    N_sec=N(1,1)+N(2,1);
    
    Flow_Profile=Profile_joint1;
    n=size(Profile_joint1,1);
    new_x=Profile_joint1(end,1);
    for k=2:nn
        
        kk=0;
        for i=n+1:n+N(k,1)
            kk=kk+1;
            Flow_Profile(i,1)=abs(Profile(kk,1,k))+new_x;
            Flow_Profile(i,2)=abs(Profile(kk,2,k));
        end
        n=n+N(k,1);
        new_x=new_x+abs(Profile(N(k,1),1,k));
        
    end
    
    P_Sec=zeros(2,2);
    P_Sec(1,1)=Flow_Profile(N_sec,1);
    P_Sec(2,1)=Flow_Profile(N_sec+1,1);
    P_Sec(1,2)=0.01;
    P_Sec(2,2)=max(Flow_Profile(:,2))*1.1;
    
end

if (strcmpi(Ch_status1, 'steep')) && (strcmpi(Ch_status2, 'steep'))
    
    Scenario='1)steep - 2)steep';
    %%% Profile_1beg + Profile_joint1 + Profile_2beg + Profile_joint2
    [Table_profile_1beg] = hydro_direct_step (Ch_Yc, Ch_Yn1, Profile_datum, Ch_Q, Ch_S1, Ch_n, g, man_n_c, N_int);
    Profile_1beg(:,2)=Table_profile_1beg(:,1);
    Profile_1beg(:,1)=Table_profile_1beg(:,end);
    
    L_joint1=abs((Profile_1beg(2,end)-Profile_1beg(2,1))/joint_c);
    Profile_joint1=zeros(joint_n+1,2);
    Profile_joint1(:,2)=Ch_Yn1;
    for i=2:joint_n+1
        Profile_joint1(i,1)=(L_joint1/joint_n)*(i-1);
    end
    
    [Table_profile_2beg] = hydro_direct_step (Ch_Yn1, Ch_Yn2, Profile_datum, Ch_Q, Ch_S2, Ch_n, g, man_n_c, N_int);
    Profile_2beg(:,2)=Table_profile_2beg(:,1);
    Profile_2beg(:,1)=Table_profile_2beg(:,end);
    
    L_joint2=abs((Profile_2beg(2,end)-Profile_2beg(2,1))/joint_c);
    Profile_joint2=zeros(joint_n+1,2);
    Profile_joint2(:,2)=Ch_Yn2;
    for i=2:joint_n+1
        Profile_joint2(i,1)=(L_joint2/joint_n)*(i-1);
    end
    
    nn=4;
    Profile=zeros(2*N_int,2,nn);
    N(1,1)=size(Profile_1beg,1); Profile(1:N(1,1),:,1)=Profile_1beg;
    N(2,1)=size(Profile_joint1,1); Profile(1:N(2,1),:,2)=Profile_joint1;
    N(3,1)=size(Profile_2beg,1); Profile(1:N(3,1),:,3)=Profile_2beg;
    N(4,1)=size(Profile_joint2,1); Profile(1:N(4,1),:,4)=Profile_joint2;
    
    N_sec=N(1,1)+N(2,1);
    
    Flow_Profile=Profile_1beg;
    n=size(Profile_1beg,1);
    new_x=Profile_1beg(end,1);
    for k=2:nn
        
        kk=0;
        for i=n+1:n+N(k,1)
            kk=kk+1;
            Flow_Profile(i,1)=abs(Profile(kk,1,k))+new_x;
            Flow_Profile(i,2)=abs(Profile(kk,2,k));
        end
        n=n+N(k,1);
        new_x=new_x+abs(Profile(N(k,1),1,k));
        
    end
    
    P_Sec=zeros(2,2);
    P_Sec(1,1)=Flow_Profile(N_sec,1);
    P_Sec(2,1)=Flow_Profile(N_sec+1,1);
    P_Sec(1,2)=0.01;
    P_Sec(2,2)=max(Flow_Profile(:,2))*1.1;
    
end

if (strcmpi(Ch_status1, 'mild')) && (strcmpi(Ch_status2, 'steep'))
    
    Scenario='1)mild - 2)steep';
    %%% Profile_joint1 + Profile_1end + Profile_1beg + Profile_joint2
    [Table_profile_1end] = hydro_direct_step (Ch_Yn1, Ch_Yn2, Profile_datum, Ch_Q, Ch_S1, Ch_n, g, man_n_c, N_int);
    Profile_1end(:,2)=Table_profile_1end(:,1);
    Profile_1end(:,1)=Table_profile_1end(:,end);
    
    L_joint1=abs((Profile_1end(2,end)-Profile_1end(2,1))/joint_c);
    Profile_joint1=zeros(joint_n+1,2);
    Profile_joint1(:,2)=Ch_Yn1;
    for i=2:joint_n+1
        Profile_joint1(i,1)=(L_joint1/joint_n)*(i-1);
    end
    
    [Table_profile_2beg] = hydro_direct_step (Ch_Yc, Ch_Yn2, Profile_datum, Ch_Q, Ch_S2, Ch_n, g, man_n_c, N_int);
    Profile_2beg(:,2)=Table_profile_2beg(:,1);
    Profile_2beg(:,1)=Table_profile_2beg(:,end);
    
    Profile_joint2=zeros(joint_n+1,2);
    Profile_joint2(:,2)=Ch_Yn2;
    for i=2:joint_n+1
        Profile_joint2(i,1)=(L_joint1/joint_n)*(i-1);
    end
    
    nn=4;
    Profile=zeros(2*N_int,2,nn);
    N(1,1)=size(Profile_joint1,1); Profile(1:N(1,1),:,1)=Profile_joint1;
    N(2,1)=size(Profile_1end,1); Profile(1:N(2,1),:,2)=Profile_1end;
    N(3,1)=size(Profile_2beg,1); Profile(1:N(3,1),:,3)=Profile_2beg;
    N(4,1)=size(Profile_joint2,1); Profile(1:N(4,1),:,4)=Profile_joint2;
    
    N_sec=N(1,1)+N(2,1);
    
    Flow_Profile=Profile_joint1;
    n=size(Profile_joint1,1);
    new_x=Profile_joint1(end,1);
    for k=2:nn
        
        kk=0;
        for i=n+1:n+N(k,1)
            kk=kk+1;
            Flow_Profile(i,1)=abs(Profile(kk,1,k))+new_x;
            Flow_Profile(i,2)=abs(Profile(kk,2,k));
        end
        n=n+N(k,1);
        new_x=new_x+abs(Profile(N(k,1),1,k));
        
    end
    
    P_Sec=zeros(2,2);
    P_Sec(1,1)=Flow_Profile(N_sec,1);
    P_Sec(2,1)=Flow_Profile(N_sec+1,1);
    P_Sec(1,2)=0.01;
    P_Sec(2,2)=max(Flow_Profile(:,2))*1.1;
    
end

if (strcmpi(Ch_status1, 'steep')) && (strcmpi(Ch_status2, 'mild'))
    
    %%% Profile_1beg + Profile_joint1 + Profile_2beg + Profile_joint2
    [Table_profile_1beg] = hydro_direct_step (Ch_Yc, Ch_Yn1, Profile_datum, Ch_Q, Ch_S1, Ch_n, g, man_n_c, N_int);
    Profile_1beg(:,2)=Table_profile_1beg(:,1);
    Profile_1beg(:,1)=Table_profile_1beg(:,end);
    
    L_joint1=abs((Profile_1beg(2,end)-Profile_1beg(2,1))/joint_c);
    Profile_joint1=zeros(joint_n+1,2);
    Profile_joint1(:,2)=Ch_Yn1;
    for i=2:joint_n+1
        Profile_joint1(i,1)=(L_joint1/joint_n)*(i-1);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Hydraulic Jump Location Track %%%
    [~, Y_jump2, ~, ~] = PSO_Solver_HJ_Y1_Y2 (Ch_Yn1, Ch_Yc, 100, Ch_Q, g, Profile_datum);
    [~, Y_jump1, ~, ~] = PSO_Solver_HJ_Y1_Y2 (Ch_Yn2, 0.001, Ch_Yc, Ch_Q, g, Profile_datum);
    
    
    if Y_jump2 < Ch_Yn2 % ( Y_jump1 < Ch_Yn1 ---> impossible ---> jump is gonna occur before the transition )  %%% This means the jump is gonna occur before the slope transition followed by a S1 curve
        
        Scenario='1)steep - 2)mild';
        %%% Profile_1beg + Profile_joint1 + Profile_1end_a + Profile_1end_b + Profile_2beg + Profile_joint2
        
        [Table_profile_1end_a] = hydro_direct_step (Ch_Yn1, Ch_Yc, Profile_datum, Ch_Q, Ch_S1, Ch_n, g, man_n_c, N_int);
        Profile_1end_a(:,2)=Table_profile_1end_a(:,1);
        Profile_1end_a(:,1)=Table_profile_1end_a(:,end);
        
        [Table_profile_1end_b] = hydro_direct_step (Ch_Yc, Y_jump2, Profile_datum, Ch_Q, Ch_S1, Ch_n, g, man_n_c, N_int);
        Profile_1end_b(:,2)=Table_profile_1end_b(:,1);
        Profile_1end_b(:,1)=Table_profile_1end_b(:,end);
        
        [Table_profile_2beg] = hydro_direct_step (Y_jump2, Ch_Yn2, Profile_datum, Ch_Q, Ch_S2, Ch_n, g, man_n_c, N_int);
        Profile_2beg(:,2)=Table_profile_2beg(:,1);
        Profile_2beg(:,1)=Table_profile_2beg(:,end);
        
        Profile_2beg(:,1)=Profile_2beg(:,1)*(1/5); %%% For a scaled and better looking Flow Profile Plot
        
        L_joint2=abs((Profile_2beg(2,end)-Profile_2beg(2,1))/joint_c);
        Profile_joint2=zeros(joint_n+1,2);
        Profile_joint2(:,2)=Ch_Yn2;
        for i=2:joint_n+1
            Profile_joint2(i,1)=(L_joint2/joint_n)*(i-1);
        end
        
        nn=6;
        Profile=zeros(2*N_int,2,nn);
        N(1,1)=size(Profile_1beg,1); Profile(1:N(1,1),:,1)=Profile_1beg;
        N(2,1)=size(Profile_joint1,1); Profile(1:N(2,1),:,2)=Profile_joint1;
        N(3,1)=size(Profile_1end_a,1); Profile(1:N(3,1),:,3)=Profile_1end_a;
        N(4,1)=size(Profile_1end_b,1); Profile(1:N(4,1),:,4)=Profile_1end_b;
        N(5,1)=size(Profile_2beg,1); Profile(1:N(5,1),:,5)=Profile_2beg;
        N(6,1)=size(Profile_joint2,1); Profile(1:N(6,1),:,6)=Profile_joint2;
        
        N_sec=N(1,1)+N(2,1)+N(3,1)+N(4,1);
        
        Flow_Profile=Profile_1beg;
        n=size(Profile_1beg,1);
        new_x=Profile_1beg(end,1);
        for k=2:nn
            
            kk=0;
            for i=n+1:n+N(k,1)
                kk=kk+1;
                Flow_Profile(i,1)=abs(Profile(kk,1,k))+new_x;
                Flow_Profile(i,2)=abs(Profile(kk,2,k));
            end
            n=n+N(k,1);
            new_x=new_x+abs(Profile(N(k,1),1,k));
            
        end
        
        P_Sec=zeros(2,2);
        P_Sec(1,1)=Flow_Profile(N_sec,1);
        P_Sec(2,1)=Flow_Profile(N_sec+1,1);
        P_Sec(1,2)=0.01;
        P_Sec(2,2)=max(Flow_Profile(:,2))*1.1;
        
    elseif Y_jump1 > Ch_Yn1 %%% This means the jump is gonna occur after the slope transition after a M2 curve
        
        Scenario='1)steep - 2)mild';
        %%% Profile_1beg + Profile_joint1 + Profile_2beg_a + Profile_2beg_b + Profile_joint2
        %%% Ch_Yn1 ---> Y_jump1;
        
        [Table_profile_2beg_a] = hydro_direct_step (Y_jump1, Ch_Yc, Profile_datum, Ch_Q, Ch_S2, Ch_n, g, man_n_c, N_int);
        Profile_2beg_a(:,2)=Table_profile_2beg_a(:,1);
        Profile_2beg_a(:,1)=Table_profile_2beg_a(:,end);
        
        [Table_profile_2beg_b] = hydro_direct_step (Ch_Yc, Ch_Yn2, Profile_datum, Ch_Q, Ch_S2, Ch_n, g, man_n_c, N_int);
        Profile_2beg_b(:,2)=Table_profile_2beg_b(:,1);
        Profile_2beg_b(:,1)=Table_profile_2beg_b(:,end);
        
        L_joint2=abs((Profile_2beg(2,end)-Profile_2beg(2,1))/joint_c);
        Profile_joint2=zeros(joint_n+1,2);
        Profile_joint2(:,2)=Ch_Yn2;
        for i=2:joint_n+1
            Profile_joint2(i,1)=(L_joint2/joint_n)*(i-1);
        end
        
        nn=5;
        Profile=zeros(2*N_int,2,nn);
        N(1,1)=size(Profile_1beg,1); Profile(1:N(1,1),:,1)=Profile_1beg;
        N(2,1)=size(Profile_joint1,1); Profile(1:N(2,1),:,2)=Profile_joint1;
        N(3,1)=size(Profile_2beg_a,1); Profile(1:N(3,1),:,3)=Profile_2beg_a;
        N(4,1)=size(Profile_2beg_b,1); Profile(1:N(4,1),:,4)=Profile_2beg_b;
        N(5,1)=size(Profile_joint2,1); Profile(1:N(5,1),:,5)=Profile_joint2;
        
        N_sec=N(1,1)+N(2,1);
        
        Flow_Profile=Profile_1beg;
        n=size(Profile_1beg,1);
        new_x=Profile_1beg(end,1);
        for k=2:nn
            
            kk=0;
            for i=n+1:n+N(k,1)
                kk=kk+1;
                Flow_Profile(i,1)=abs(Profile(kk,1,k))+new_x;
                Flow_Profile(i,2)=abs(Profile(kk,2,k));
            end
            n=n+N(k,1);
            new_x=new_x+abs(Profile(N(k,1),1,k));
            
        end
        
        P_Sec=zeros(2,2);
        P_Sec(1,1)=Flow_Profile(N_sec,1);
        P_Sec(2,1)=Flow_Profile(N_sec+1,1);
        P_Sec(1,2)=0.01;
        P_Sec(2,2)=max(Flow_Profile(:,2))*1.1;
        
        
        
        
        
    end
    
end



%[Table_profile] = hydro_direct_step (Ch_Yc, Ch_Yn1, Profile_datum, Ch_Q, Ch_S1, Ch_n, g, man_n_c, N_int);
%Flow_Profile(:,1)=Table_profile(:,10); % Flow X (Distance)
%Flow_Profile(:,2)=Table_profile(:,1); % Flow Y (Depth)

%[xx,yy] = smoothLine(Flow_Profile(:,1),Flow_Profile(:,2));
%plot(Flow_Profile(:,1),Flow_Profile(:,2),'or-');
%hold on;
%plot(xx,yy);





end
