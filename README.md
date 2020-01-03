# Open Channel Flow Hydraulics tool with PSO Solver and Graphical User Interface

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%201.png)


# Abstract
A MATLAB based programed tool with graphical user interface (GUI) has been developed to analyze different problems of Open Channel Flow. The tool handles all kinds of channel cross-sections comprising rectangular, trapezoidal, triangular and irregular profiles. The tool analyzes different kinds of hydraulic problems using Energy and Momentum equations as well as Manning’s equation, in both English and SI units. It also handles the Gradually Varied Flow problems, for example the problem of multiple-slope channels connected to a nearby lake, utilizing Discrete-Step numerical method, plotting a flow profile with details of critical depth and hydraulic jump location shown. In most cases during the calculations, especially for irregular cross-sections, the tool needs to perform an iterative trial and error procedure to calculate some parameters of the flow which cannot be driven in a straight-forward analytical solvation. Here, a robust meta-heuristic optimization method called Particle Swarm Optimization (PSO) has been utilized in order to find unknown variables through an intelligent search procedure, which results in more accuracy and execution speed of the model.

![Output sample](https://github.com/behzadasd/Open-Channel-Hydraulics-GUI/blob/master/Figures/Rec-LakeChannel.gif)

![Output sample](https://github.com/behzadasd/Open-Channel-Hydraulics-GUI/blob/master/Figures/Rec-Manning.gif)

![Output sample](https://github.com/behzadasd/Open-Channel-Hydraulics-GUI/blob/master/Figures/Rec-Transition.gif)


# 1. Introduction
Open channel is a conveyance in which water flows with a free surface. Although closed conduits such as culverts and storm drains are open channels when flowing partially full, the term is generally applied to natural and improved watercourses, gutters, ditches, and channels. Water’s movement in an open channel is a difficult problem when everything is considered, especially with the variability of natural channels, but in many cases the major features can be expressed in terms of only a few variables, whose behavior can be described adequately by a simple theory. The principal forces at work are those of inertia, gravity and viscosity, each of which plays an important role. The developed formulas of the open channel flow can be utilized in a computer program to investigate the flow conditions and variables. Such a tool has been developed here.
In the remainder sections, methods and the tool’s application in different hydraulics problems is discussed. The report considers the readers as educated engineers with enough cognition of the hydraulics science, hence avoids unnecessary explanations of open channel flow’s basic formulas and theories; and directly discusses the methods and results. 

# 2. The Open Channel Flow Tool - General Overview
The Tool has 4 main components, comprising:

I) Cross-Section Selection Component

II) Transition Problem component (Specific Energy)

III) Manning’s equation component

IV) Lake-Channel Problem component (GVF)

The Tool handles all kinds of regular and irregular cross-sections, in both SI and English units. 
The Tool has a “Set Zero” pushbutton which returns the Tool to its initial condition. The “Update Variable” pushbutton re-gets the variables from the input boxes and enables the “Run” pushbutton.  The “Run” pushbutton executes the model with the variables entered in the input boxes and sends the results to GUI. This button also enables the “Plot Profile” pushbutton in the Lake-Channel Problem component (GVF) component, which plots the flow depth profile for different sections of the channel in its defined plot box on the GUI panel. The Cross-Section Selection component has two “Enable” and “Disable” pushbuttons which respectively enable and disable the option of loading a predefined cross-section profile from an excel file. The other feature of the Tool is that the operator of the tool can change the variables in the input boxes and push “Update Variable” and then “Run” and see the new results, without needing to restart the Tool.
One of the innovations of the developed Tool is utilization of the Particle Swarm Optimization algorithm (PSO) as it’s equation solver, instead of the common iterative trial and error procedure. The PSO is robust meta-heuristic optimization algorithm that has been coded-up as a separate lateral module of the Tool. 
In the trial and error process, the programmer needs to choose different values of the probable solution for the equation and check the error until finds the closest solution, and actually needs to check every possible solution starting from an initial value increasing with a step defined by the accuracy of the model. This procedure will decrease the speed of the model. Utilization of PSO has lead into incretion of the speed and accuracy of the Tool, since it applies an intelligent search process to find the proper solution for the given equations in a very little run time.

# 3. PSO Module - A general perspective of Optimization and the Meta-heuristics
As stated in the above section, the Tool utilizes the Particle Swarm Optimization algorithm (PSO) as it’s equation solver. The PSO is robust meta-heuristic optimization algorithm.  Optimization problems are ubiquitous in the mathematical modeling of real world systems and cover a very broad range of applications. Optimization can include a wide range of problems with the aim of searching for certain optimality. Subsequently, there are many diﬀerent ways of naming and classifying optimization problems, and typically the optimization techniques can also vary signiﬁcantly from problem to problem. 

Particle Swarm Optimization (PSO) algorithm is a stochastic population-based optimization approach, first published by (Kennedy & Eberhart, 1995). It is a biologically inspired algorithm which models the social dynamics of bird flocking or fish schooling. A large number of birds flock synchronously, change direction suddenly, scatter and regroup iteratively, and finally perch on a target. This form of social intelligence not only increases the success rate for food foraging but also expedites the process. The key idea is that in the flock, or school fish, any agent of the group can profit from the discoveries and previous experiences of all members of the school during search of food. This advantage can become decisive, outweighing the inconvenience of competition for food items, whenever the resource is unpredictably distributed in patches. That means information is socially shared by the bird flock or fish school and gives an evolutionary advantage.
In PSO, a collection of particles, called a “swarm”, move around in search space looking for the best solution to an optimization problem. All particles have their own velocity that drives the direction they move in. This velocity is affected by both the position of the particle with the best fitness and each particle’s own best fitness. Fitness refers to how well a particle performs. In a flock of birds this might be how close a bird is to a food source, in an optimization algorithm this refers to the proximity of the particle to optima. Each particle’s location is given by the parameters of the given optimization problem and a particle moves around in search space by adapting and changing these parameter values. At each time step, the particle’s fitness is measured by observing the parameter values (location) of the particle. A particle keeps track of the best position it has reached so far (called the personal best position) and is also aware of the position of the overall best particle at a certain time step (called the globally best position). At each time step the particle tries to adapt its velocity (i.e. speed and direction) to move closer to both the globally best position and the personal best position in order to improve its fitness. 

# 4. Components of the Tool
 4.1. Cross-Section Selection Component
The component is shown in figure 3. There are two options implemented in the tool for definition of a cross-section. The operator of the tool can either load a predefined cross-section profile from an excel file, or specify the characteristics of it by inputting the channel bed width (B) and side slopes (z1 and z2). An input of z1 and z2 close to zero with specified value of B would result in a rectangular channel cross-section. Similarly the operator can assign a value to the side slopes (z1 and z2), inputting the bed width close to zero, and actually acquire a triangular channel. The specified or loaded cross-section can be plotted by clicking on the “Plot Profile” button. This component also contains the unit definition panel, where the operator can select between the two commonly used SI and English unit systems.

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%203.png)
Figure 3 Cross-Section Definition Component

 4.2. Transition Problem component (Specific Energy)
Assuming small longitudinal bed slope of the channel and uniform velocity distribution, the critical flow in open-channel hydraulics is explained as a state of flow that can lead to any one of (1) minimum specific energy for a given flow, (2) maximum flow for a given specific energy, (3) minimum specific force for a given flow, (4) Froude number equal to unity, (5) the ratio between velocity head and hydraulic depth equal to half, and (6) the ratio between velocity of flow and celerity of small gravity waves in shallow water caused by gravity waves equal to unity (Chow, 1959). The critical flow condition is an attribute of the geometric property-cum-dimensions of a channel cross section. When a channel passes through a transition, the critical flow conditions govern the limits of changes in the geometric dimensions and alignment of the channel. All flows of water through open channels associate specific energy and specific force. There can be channel geometric dimensions that may make it impossible and infeasible for the flow to occur with the known specific energy and/or specific force, and the solutions of the specific energy and specific force equations become infeasible. For states other than the critical state of flow, the specific energy and specific force equations generally have two feasible and distinctly different depths as solutions for given flow and other geometric dimensions. For a particular combination of geometric dimensions, the two depths converge to a single depth at critical state of flow and make the limiting solutions, which are characterized by the critical flow conditions (Das, 2011). 
One of the most popular situations of this case is the transition problem where the channel cross-section faces a contraction or expansion in the width. The developed Tool here has a component for calculation of flow conditions after a contraction/expansion in the channel with/without an upward or downward step on the way of flow. The operator can specify flow depth and velocity at the upstream or downstream of the transition and calculate the flow condition, critical depth and specific energy at both sides. The Tool also specifies whether the choking will happen during the contraction or not. The Specific Energy problem component of the Tool is depicted in Figure 4.

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%204.png)
Figure 4 Specific Energy problem component

 4.3. Manning’s equation component
The well-known Manning’s equation is an empirical formula estimating open channel flow, or free-surface flow driven by gravity. The developed Tool has a component for calculation of flow characteristics utilizing the Manning’s equation for different sets of input data. The operator can specify the cross-section of the channel and then input either triple-set of the 4 main variables of the Manning’s equation, comprising roughness (n), bed slope (S), flow depth (Y) and flow discharge in the channel (Q), and run the tool to obtain the unknown variable. This component is shown in Figure 5.
The Manning’s equation component can be executed separately here, but it is also used by other components of the model to analyze the Gradually Varied Flow in the channel in the corresponding component.

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%205.png)
Figure 5 The Manning’s equation component

4.4. Lake-Channel Problem component (GVF component)
Figure 6 illustrates the Lake-Channel Problem component of the Tool. This component is actually the main component of the developed Tool for calculation of the Gradually Varied Flow (GVF) in the channel. The predefined situation for this component is a slope-varying regular/irregular cross-sectioned channel connected to a nearby lake/reservoir with a specified value of water head above the channel bed. The tool executes the model for any of the variables of discharge (Q) or water head above the channel (E_0) given. The Tool utilizes the Manning’s equation component for analysis of the flow here.  Execution of the model with given inputs by clicking on the “Run” will enable the “Plot Profile” pushbutton. This pushbutton plots the flow depth profile along the channel. The Tool uses the Direct-Step numerical method to calculate the flow profile along the channel. Details of cross-section slope change location, critical depth line and location of the probable hydraulic jump through the channel are shown in the plot. The Tool also specifies the steepness/mildness of the channel bed slope for the given inputs.
It is obvious that the operator can simply input the slopes of the two sections equal to each other and solve a single-sloped channel connected to a lake. The operator can load any irregular cross-section profile for the channel and by inputting channel bed roughness (n), slope (S) and lake head (E_0), subsequently acquire the critical depth (Yc), critical slope (Sc), discharge (Q), flow condition(Sub/Super Critical) and flow depth profile from the model.

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%206.png)
Figure 6 Lake-Channel Problem component

# 5. Testing the developed Tool
In this section, some hydraulics problems are solved by the developed Tool and the results are shown.
The first problem to be solved is a transition problem where water flows in a rectangular channel with initial width of B1=10 ft. and secondary width of B2=9 ft. which results in a 1 ft. contraction. The initial flow depth and velocity is Y1=10 ft. and V1=10 ft. /sec, respectively. The result of the model’s run is shown in Figure 7. The Tool indicates the flow condition is Sub-Critical in both upstream and downstream sections and no chocking will happen. The secondary l flow depth and velocity is Y2=9.367 ft. and V1=11.864 ft. /sec, respectively. The model is run with the same situation but with more contraction on the width, where the secondary width of the B2=5 ft. The Tool indicates the flow condition in this case will be is Super-Critical and chocking will happen. The results for this case are depicted in Figure 8.

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%207.png)
Figure 7 Example 1 Results - First Case

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%208.png)
Figure 8 Example 1 Results - Second Case

The second problem solved with the developed Tool is the problem 4.34 of Lake-Channel in the Henderson’s book. Figure 9 illustrates the situation of this problem. The definition of this kind of problem is presented in section 4.3. 

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%209.png)

Figure 9 Example 2 – Solved Lake-Channel problem definition

Figure 10 depicts the results of this problem. The results indicates critical depth of the channel as Yc = 4.667 ft. and critical slope as Sc = 0.002452, with a discharge of Q=1715.37 ft3/sec. The results also show that the channel slope is steep at the first section and mild in the second section. The flow depth profile of this case is shown in Figure 11. It can be seen from this Figure that the flow starts with an S2 cure and decreases from Yc to Yn1 and continues through the first sec. and at the end of the first sec. goes from super-critical to sub-critical condition through a hydraulic jump, which occurs before the slope change in the channel, and continues in Yn2 depth at the second sec.
It can be seen from the Figure 10 that Yc is greater that slope of the channel at the first section and less than slope of the channel at the second section, which would result in first section being steep and second one being mild, as seen the results. Decreasing the slope of the first sec. to a value less than Sc should result in a channel with mild slope at both sections. The model is run with the same situation as before, except with decreasing the slope of the first section to 0.002 (less than Sc). The flow depth profile of this case is shown in Figure 12. As seen in this Figure, flow rises from Yn1 to Yn2 through a M1 curve and continues in the second section. 

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%2010.png)

Figure 10 Example 2 Results - First Case

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%2011.png)

Figure 11 Example 2 Flow Depth Plot - First Case (s1 > Sc > s2)

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%2012.png)

Figure 12 Example 2 Flow Depth Plot - Second Case (Sc > s1 > s2)

The model is also run with the same situation as the previous case, except with increasing the slope of the second section to 0.0035 and the slope of the first section to the initial value of 0.005 (s1 > s2 > Sc). Results indicate the slope of both sections steep in this case, as expected. The flow depth profile of this case is shown in Figure 13. The next case is setting s1 = 0.005 and s2 = 0.008 (s2 > s1 > Sc). The flow depth profile of this case is shown in Figure 14. In both Figures 13 and 14, flow decreases from Yc to Yn1 through a S2 curve, continues at Yn1, and at the beginning of the second sec. changes the flow depth to Yn2 through a S3 curve.

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%2013.png)

Figure 13 Example 2 Flow Depth Plot - Third Case (s1 > s2 > Sc)

![Alt text](https://raw.githubusercontent.com/behzadasd/Open-Channel-Hydraulics-GUI/master/Figures/Pic%2014.png)

Figure 14 Example 2 Flow Depth Plot - Forth Case (s2 > s1 > Sc)






