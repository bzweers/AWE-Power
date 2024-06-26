function [fval,inputs,outputs] = optObjective_awePower(x,i,inputs,kiteMass)

    global outputs

    % Kite mass
    outputs.m_k = kiteMass;
     
    % Assign variable values
    outputs.deltaL(i)                               = x(1);
    outputs.beta(i)                                 = x(2);
    outputs.gamma(i)                                = x(3);
    outputs.Rp_start(i)                             = x(4);
    outputs.vk_r_i(i,1:inputs.numDeltaLelems)       = x(0*inputs.numDeltaLelems+5:1*inputs.numDeltaLelems+4);
    outputs.CL_i(i,1:inputs.numDeltaLelems)         = x(1*inputs.numDeltaLelems+5:2*inputs.numDeltaLelems+4);
    outputs.vk_r(i,1:inputs.numDeltaLelems)         = x(2*inputs.numDeltaLelems+5:3*inputs.numDeltaLelems+4);
    outputs.kRatio(i,1:inputs.numDeltaLelems)       = x(3*inputs.numDeltaLelems+5:4*inputs.numDeltaLelems+4);
    outputs.CL(i,1:inputs.numDeltaLelems)           = x(4*inputs.numDeltaLelems+5:5*inputs.numDeltaLelems+4);
   
    % Main computation
    [inputs]  = computePower_awePower(i,inputs);
    
    % Objective: Maximise electrical cycle average power
    fval = - outputs.P_e_avg(i);

    % Objective: Maximise mechanical reel-out power
%     fval = - outputs.P_m_o(i);
        
end                    