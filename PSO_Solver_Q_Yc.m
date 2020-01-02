function [Profile_c, Ch_Yc, A_Area_c, P_Perimeter_c] = PSO_Solver_Q_Yc (X_min, X_max, Ch_Q, g, Profile_datum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Particle Swarm Optimization Algorithm      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_pop=10; % Number of Particles
N_DV=1; % Number of Decision Variables
max_it=100; % Max number of iterations

%%% PSO Coefficients %%%
w=1;
wdamp=0.99;
c1=2;
c2=2;

dx=X_max-X_min;
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
            Particle(i).position=X_min+(X_max-X_min)*rand(1,N_DV);
                        
            y_t=Particle(i).position;
            %%% Y_c calculation %%%
            [Profile_t, A_Area_t, ~ ] = hydro_Area(Profile_datum, y_t );
            
            T_TopWidth_t=Profile_t(end,1)-Profile_t(1,1); % Top Width
            Q_Discharge_t=(g*(A_Area_t^3)/T_TopWidth_t)^0.5;
            error_t = abs(Ch_Q - Q_Discharge_t);
            
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
            
            Particle(i).position=min(max(Particle(i).position,X_min),X_max);
            
            y_t=Particle(i).position;
            %%% Y_c calculation %%%
            [Profile_t, A_Area_t, ~ ] = hydro_Area(Profile_datum, y_t );
            
            T_TopWidth_t=Profile_t(end,1)-Profile_t(1,1); % Top Width
            Q_Discharge_t=(g*(A_Area_t^3)/T_TopWidth_t)^0.5;
            error_t = abs(Ch_Q - Q_Discharge_t);
            
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

Ch_Yc=All_Best_DV(end,1);
%%% --- calculation %%%
[Profile_c, A_Area_c, P_Perimeter_c ] = hydro_Area(Profile_datum, Ch_Yc );


end
