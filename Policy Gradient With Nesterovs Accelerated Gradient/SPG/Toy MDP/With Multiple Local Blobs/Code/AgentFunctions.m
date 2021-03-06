
classdef AgentFunctions < matlab.mixin.Copyable & handle
    properties (SetAccess = protected)
        thetas; % weights
        sigma;
        variables;  %parameters
        centres;
    end
    
    properties (SetAccess = private)
        initialized_states;
        agentKernel;
        mdp;       
    end
    
   
    methods (Access=public)
        function obj = AgentFunctions(initialized_states, sigma, agentKernel, mdp)
            
            obj.mdp = mdp;
            %initialization of constant parameters
            
           %initializing the policy parameters
            
            obj.sigma = sigma;
            obj.agentKernel = agentKernel;
            obj.initialized_states = initialized_states;
            
            obj.thetas = obj.initialize_thetas();  
            obj.centres  = obj.set_centres();
          


        end
        
        
        function thetas = initialize_thetas(obj)
            %what should be the size of the thetas/parameters of policy?
            
            thetas = 0.1 * (1- 2.*rand(obj.initialized_states,1));
       
            obj.variables = thetas;
                    
        end
                
        function update_thetas(obj, thetas)
            obj.thetas = thetas;
        end
        
        function update_variables(obj, variables)
            obj.update_thetas(variables);
            obj.variables = obj.thetas;
            
%             obj.update_centres(variables);
%             obj.variables = obj.centres;
        end
        
        
        function update_centres (obj, centres)
            obj.centres = centres;
        end
       
        function  centres = set_centres(obj)
           centres= zeros(obj.initialized_states, obj.mdp.state_dim);
            
            for i = 1: obj.initialized_states
                centres(i,:) = obj.mdp.uniform_state();
            end
            
          
        end
        
      

           function [myaction] = det_policy(obj, state)
            Phi_vec = obj.agentKernel.compute_kernel(state, obj.centres);
%                      
             myaction = Phi_vec*obj.thetas;
 
           end
        
        %stochastic policy defined here
        function [action] = policy(obj, state)
            action = obj.det_policy(state); 
            action = action + obj.sigma*rand(size(action));
        end
%         
        
        
        
        
        function [logPi] = DlogPiDTheta(obj, state, action)
            Phi = obj.agentKernel.compute_kernel(state, obj.centres);
            c = (action - obj.det_policy(state))/(obj.sigma)^2;
            
            mult = bsxfun(@times, c, Phi);
            logPi = mult;
            
        end
        
        
        function [init] = zeroVariables(obj)
            init = zeros(size(obj.variables));
        end
        
        
        
        
    end
    
    
end




       



       