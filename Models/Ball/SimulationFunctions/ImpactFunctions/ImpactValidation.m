function [xnext,valid]= ImpactValidation(xprev,xnext,imp_name)
global flowdata     

    valid = true;    
    [A,~] = flowdata.getConstraintMtxs(xprev);
    if rank(A) >= flowdata.Parameters.dim/2
        valid = false;
        myprint('\nBiped is over constrained')
    end 
    
    if flowdata.Flags.step_done

    end
    if strcmp(imp_name ,'Landing')
        flowdata.State.pf2 = nan;
        flowdata.State.pf1(1) = xnext(1) + flowdata.Parameters.SLIP.L0*cos(flowdata.State.alpha); %keep y height at 0 because ground
    end
    if strcmp(imp_name ,'FullRelease')
        if ~isfield(flowdata.Parameters,'StepLength')
        %Update contact angle based on release angle
            z = XYtoLTheta1(xprev');
            r = 1; %0<r<1 , 0 =  mirror release angle, 1 = constant contact angle
            flowdata.State.alpha = z(2) + r*(flowdata.State.alpha - z(2));
        end
        flowdata.State.pf1(1) = nan;
        flowdata.State.pf2 = nan;
    end
    if strcmp(imp_name ,'TrailRelease')
         flowdata.State.pf2 = nan; %remove unconnected spring
    end
    if strcmp(imp_name ,'LeadStrike')  
        %lead foot becomes spring 1
        flowdata.State.pf2 = flowdata.State.pf1;       
        flowdata.State.pf1(1) = xnext(1) + flowdata.Parameters.SLIP.L0*cos(flowdata.State.alpha); %keep y height at 0 because ground

    end
end