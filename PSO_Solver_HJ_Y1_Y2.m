function [Profile_unkn, Y_unkn, A_Area_unkn, P_Perimeter_unkn] = PSO_Solver_HJ_Y1_Y2 (Y_kn, Ch_Ymin, Ch_Ymax, Ch_Q, g, Profile_datum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Particle Swarm Optimization Algorithm      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% M_kn (Known) calculation %%%
[~, A_Area_kn, ~, Y_bar_kn ] = hydro_Y_bar(Profile_datum, Y_kn );
M_kn=((Ch_Q^2)/(g * A_Area_kn )) + ( Y_bar_kn * A_Area_kn ) ;


N_pop=10; % Number of Particles
N_DV=1; % Number of Decision Variables
max_it=100; % Max number of iterations

%%% PSO Coefficients %%%
w=1;
wdamp=0.99;
c1=2;
c2=2;

dx=Ch_Ymax-Ch_Ymin;
V_max=0.1*dx;

Initial_Particle.position=[];
Initial_Particle.velocity=[];
Initial_Particle.cost=[];
Initial_Particle.pbest=[];
Initial_Particle.pbestcost=[];

Particle=repmat(Initial_Particle,N_pop,1); % Particles (Solutions)

All_Best_DV=zeros(max_it,N_DV); % Vector of best solution at each iteration
ALL_best_fitness=zeros(max_it,1); % Vector of best fitness at each iteration

for t=1:max_it
    if t==1 % 1st iteration
        
        ALL_best_fitness(1)=inf;
        for i=1:N_pop
            Particle(i).velocity=zeros(1,N_DV);
            Particle(i).position=Ch_Ymin+(Ch_Ymax-Ch_Ymin)*rand(1,N_DV);
                        
            y_t=Particle(i).position;
            %%% Y_c calculation %%%
            [~, A_Area_unkn, ~, Y_bar_unkn ] = hydro_Y_bar(Profile_datum, y_t );
            M_unkn=((Ch_Q^2)/(g * A_Area_unkn )) + ( Y_bar_unkn * A_Area_unkn ) ;
            
            error_t=abs(M_kn-M_unkn);
            
            Particle(i).cost=error_t;
            
            %Particle(i).cost=ObjFunc(Particle(i).position);
            
            Particle(i).pbest=Particle(i).position;
            Particle(i).pbestcost=Particle(i).cost;
            
            if Particle(i).pbestcost<ALL_best_fitness(t)
                All_Best_DV(t,:)=Particle(i).pbest;
                ALL_best_fitness(t)=Particle(i).pbestcost;
            end
        end
        
    else % Next iterations
        
        All_Best_DV(t,:)=All_Best_DV(t-1,:);
        ALL_best_fitness(t)=ALL_best_fitness(t-1);
        for i=1:N_pop
            
            Particle(i).velocity=w*Particle(i).velocity...
                +c1*rand*(Particle(i).pbest-Particle(i).position)...
                +c2*rand*(All_Best_DV(t,:)-Particle(i).position);
            
            Particle(i).velocity=min(max(Particle(i).velocity,-V_max),V_max);
            
            Particle(i).position=Particle(i).position+Particle(i).velocity;
            
            Particle(i).position=min(max(Particle(i).position,Ch_Ymin),Ch_Ymax);
            
             y_t=Particle(i).position;
            %%% Y_c calculation %%%
            [~, A_Area_unkn, ~, Y_bar_unkn ] = hydro_Y_bar(Profile_datum, y_t );
            M_unkn=((Ch_Q^2)/(g * A_Area_unkn )) + ( Y_bar_unkn * A_Area_unkn ) ;
            
            error_t=abs(M_kn-M_unkn);
            
            Particle(i).cost=error_t;
            
            % Particle(i).cost=ObjFunc(Particle(i).position);
            
            if Particle(i).cost<Particle(i).pbestcost
                Particle(i).pbest=Particle(i).position;
                Particle(i).pbestcost=Particle(i).cost;
                
                if Particle(i).pbestcost<ALL_best_fitness(t)
                    All_Best_DV(t,:)=Particle(i).pbest;
                    ALL_best_fitness(t)=Particle(i).pbestcost;
                end
            end
            
        end
        
    end
    
    %disp(['Iteration ' num2str(t) ':   Best Objective Function = ' num2str(ALL_best_fitness(t))]);
    
    w=w*wdamp;
end

Y_unkn=All_Best_DV(end,1);
%%% --- calculation %%%
[Profile_unkn, A_Area_unkn, P_Perimeter_unkn, ~ ] = hydro_Y_bar(Profile_datum, Y_unkn );


end
