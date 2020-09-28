function CoP_foot_frame = Foot_COP(Lambda)
global flowdata    
    switch flowdata.State.c_phase
        case {"Heel","Flight"}
            CoP_foot_frame = 0;
        case "Flat"
            slope = flowdata.Parameters.Environment.slope;
            la = flowdata.Parameters.Biped.la;
            Fx = -Lambda(1);
            Fy = -Lambda(2);
            M = -Lambda(3);
            rot = [cos(slope), -sin(slope); sin(slope), cos(slope)];
            temp = rot*[Fx;Fy];
            Ft = temp(1); Fn = temp(2);
            CoP_foot_frame = (M-la*Ft)/Fn;
        case "Toe"
            CoP_foot_frame = flowdata.Parameters.Biped.lf;
        case "DSuppToeHeel"
            CoP_foot_frame = 0;
        case "DSuppToeFlat"
            slope = flowdata.Parameters.Environment.slope;
            la = flowdata.Parameters.Biped.la;
            Fx = -Lambda(3);
            Fy = -Lambda(4);
            M = -Lambda(5);
            rot = [cos(slope), -sin(slope); sin(slope), cos(slope)];
            temp = rot*[Fx;Fy];
            Ft = temp(1); Fn = temp(2);
            CoP_foot_frame = (M-la*Ft)/Fn;
    end
end

