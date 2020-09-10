classdef flowData < handle
    %FLOWDATA flow control information for the biped simulation
    
    properties      
        %Structs
        Configs = struct();     %additional Constraint Configuration struct
        
        Controls = struct(...   %holds function handles to controls, External functions are used to calculate 'work' done on the generalized system energy.
        'Internal',[], ...
        'External',[]);

        End_Step = struct(...   %step terminal data and relabeling
            'event_name','',...
            'A',@A_Swap_func,...
            'Adot',@Adot_Swap_func);

        Flags = struct('silent',true,...                            %display runtime outputs
                       'do_validation',true,...                     %validate impacts and other events
                       'terminate',false,...                        %terminate simulation early
                       'step_done',false,...                          %step is complete based on EndStep.event_name
                       'warnings',true,...
                       'rigid',true);

        Impacts = {};     %impact cell array   
     
        Parameters = struct(...
            'dim',[],...                                            %state space dimension
            'Environment',struct('g',9.81,'slope',0,'mu',inf));     %gravity constant, ground slope, foot-ground static friction coefficent

        Phases = struct();      %phase struct
                        
        State = struct('c_phase','NA',...                           %current phase
                       'c_configs',[],...                           %current configuration 
                       'PE_datum',0);                               %PE_datum
                                                
        %Not Structs
        eqnhandle;              %function pointer to dynamics function       
        E_func;                 %function pointer to generalized energy function
        odeoptions;             %struct with odeoptions
        tspan = 1;              %in simulation time duration for ode call
    end
    
    methods
        function obj = flowData()
            %FLOWDATA Construct an instance of this class
            %   Detailed explanation goes here
        end
        function R_gf = getRgf(this)
            %setRgf Rotation matrix based on current slope
            %   Foot/Ineretial Frame to Ground Frame by left multiplication
            slope = this.Parameters.Environment.slope;   %#ok<*PROP>
            R_gf = [ cos(-slope), -sin(-slope), 0, 0; 
                     sin(-slope),  cos(-slope), 0, 0;
                               0,            0, 1, 0;  
                               0,            0, 0, 1]; 
        end
        function setPhases(this,phaselist)
           %setPhases takes a cell array of phase names and assigns
           %constraint matrices based on naming of files.
           for i = 1:length(phaselist)
               name = phaselist{i};
               Aname = strcat('A_',name,'_func');
               Adotname = strcat('Adot_',name,'_func');
               this.Phases.(name).A = str2func(Aname);
               this.Phases.(name).Adot = str2func(Adotname);
               this.Phases.(name).name = name;
           end
        end
        function setConfigs(this,configlist)
           %setPhases takes a list of configuration names and assigns
           %constraint matrices based on naming of files.
           for i = 1:length(configlist)
               name = configlist{i};
               Aname = strcat('A_',name,'_func');
               Adotname = strcat('Adot_',name,'_func');
               this.Configs.(name).A = str2func(Aname);
               this.Configs.(name).Adot = str2func(Adotname);
               this.Configs.(name).name = name;
           end
        end
        function setImpacts(this)
           phasename = this.State.c_phase;
           this.Impacts = {};
           if strcmp(phasename,'Failure')
              myprint("Failure")
              this.Flags.terminate = true;
              return;
           end
           
           for i = 1:length(this.Phases.(phasename).events)
               name = this.Phases.(phasename).events{i}.name;
               this.Impacts{i}.name = name;
               guard_func_name = strcat('guard_',name);
               this.Impacts{i}.f = str2func(guard_func_name);  
               this.Impacts{i}.nextphase = this.Phases.(phasename).events{i}.nextphase;
               this.Impacts{i}.nextconfig = this.Phases.(phasename).events{i}.nextconfig;
               map_func_name = strcat('map_',name);
               if exist(map_func_name,'file') == 2
                    this.Impacts{i}.map = str2func(map_func_name);  
               else
                    this.Impacts{i}.map = @this.identityImpact;  
               end
           end
           for j = 1:length(this.State.c_configs)
               configname = this.State.c_configs{j};
               for i = 1:length(this.Configs.(configname).events)
                   name = this.Configs.(configname).events{i}.name;
                   this.Impacts{i}.name = name;
                   guard_func_name = strcat('guard_',name);
                   this.Impacts{i}.f = str2func(guard_func_name);
                   this.Impacts{i}.nextconfig = strcat('-',name);
                   this.Impacts{i}.nextphase = '';
                   this.Impacts{i}.map = str2func(map_func_name); 
               end
           end
        end
        function [impact_name,map_funcs] = setNextPhaseAndConfig(this,i_impact)
            %setNextPhaseAndConfig 
            if 0<i_impact && i_impact<=length(this.Impacts)
                impact_name = this.Impacts{i_impact}.name;
                impact = this.Impacts{i_impact};
                map_funcs{1} = impact.map;
                %maps to new phase
                if ~isempty(impact.nextphase)
                    this.State.c_phase = impact.nextphase;
                    
                %maps to new config
                elseif ~isempty(impact.nextconfig)
                    %remove config
                    if contains(impact.nextconfig,'-')
                        rm_name = erase(impact.nextconfig,'-');
                        [index,~] = ismember(this.State.c_configs,rm_name);
                        this.Impacts(index) = [];
                    %add config
                    else
                        this.State.c_configs{end+1} = impact.nextconfig;
                    end
                end
                
                %set guard functions
                this.setImpacts()

                if strcmp(impact.name,this.End_Step.event_name)
                    this.Flags.step_done = true;
                    map_funcs{end+1} = this.End_Step.map;
                end
            else
                impact_name = '';
                if ~this.Flags.silent
                    warning('invalid impact')
                end                
            end
        end
        function [A,Adot] = getConstraintMtxs(this,x,params)
            %getConstraintMtxs computes the current constraints matrices A,Adot based
            %on current phase and current configuration
            cnum = length(this.State.c_configs);
            %d = this.Parameters.dim/2;
            A = [];
            Adot = [];
            if this.Flags.step_done
                A = this.End_Step.A(x,params);
                Adot = this.End_Step.Adot(x,params);
            elseif isfield(this.Phases,this.State.c_phase)
                A = this.Phases.(this.State.c_phase).A(x,params);
                Adot = this.Phases.(this.State.c_phase).Adot(x,params);
            end
            
            for i=1:cnum
               A = [A;this.Configs.(this.State.c_configs{i}).A(x,params)];
               Adot = [Adot;this.Configs.(this.State.c_configs{i}).Adot(x,params)];
            end
        end
        function resetFlags(this)
            this.Flags.terminate = false;
            this.Flags.step_done = false;
        end
        function xout = identityImpact(this,xprev,xnext)
            xout = xnext;
        end
    end
end

