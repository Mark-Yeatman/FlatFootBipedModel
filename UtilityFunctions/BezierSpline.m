%Author: Mark Yeatman
%With code and references from: 
%   cubic Bezier least square fitting by Dr. Murtaza Khan, 27 Jan 2016
%   https://pomax.github.io/bezierinfo/ 
%   http://www.cs.mtu.edu/~shene/COURSES/cs3621/NOTES/spline/Bezier/bezier-elev.html

classdef BezierSpline < handle
    %BEZIER Summary of this class goes here    
    %   Code assumptions:
    %       2D (x,y) only
    %       All splines have the same degree
    %
    
    %   How to use:
    %       Initialize a BezierSpline object to degree 3
    %       Call GenerateCurve with input data and degree 1 tolerance. 
    %       Call RecoverEquations to get list of symbolic equations for
    %       each spline. 
    
    properties      
        Degree;         %largest x exponent in the equation / order of the curve        
        NumOSplines;    %number of splines that make up curve       
        Weights;        %cell array of x,y,z pairs of control points ,{i} of (Nx3)        
    end
    
    methods
        
        function obj = BezierSpline(n,W,S)
            % Input:
            %   n = degree of curve
            %   W = list of weights
            %   S = Number of Splines 
            
            % add path for helper functions in fitting algorithm
            %path(path,strcat(pwd,'\cubicbezierlsufit'));
            
            % add path for toLatex function
            %path(path,strcat(pwd,'\Useful Functions'));
            
            if nargin ==0
                
            end
            
            if nargin == 1
                obj.Degree = n;
                obj.Weights = [];
                obj.NumOSplines = [];
            end
            
            if nargin == 2 && size(W,1) == n+1 && size(W,2) == 2
                obj.Degree = n;
                obj.Weights = W;
                obj.NumOSplines = 1;
            end
            
            if nargin == 3
                obj.Degree = n;
                
                if iscell(W)
                    obj.Weights = W;
                else
                    obj.Weights = cell{S};
                    for i=1:S
                       obj.Weights{i} = W(i,:,:);
                    end
                end
                
                obj.NumOSplines = S;
                
            end
        end
        
        %subsref allows you to treat the Bezier spline object like a function, and
        %use syntax like [x,y] = Bezier(t) to get a list of points, while
        %preserving dot notation for method and property calls
        function [varargout] = subsref(Bezier,in)
        % Calculates x,y coordinate pairs based off parametric t value and current weights/degree 
        % Inputs: 
        %   t = parametric variable
        %   j = spline #
        
        % Output:
        %   2 Nx1 matrices of x,y coordinates
            switch in(1).type
                case '.' %Make the methods and properties work as normal
                    [varargout{1:nargout}] = builtin('subsref', Bezier, in); 
                case '()' %Make it work like a function
                    switch length(in.subs)
                        case 0
                            return;
                        case 1
                            t = in.subs{1};
                            j = 1;
                        case 2
                            t = in.subs{1};
                            j = in.subs{2};
                    end

                    W = Bezier.Weights{j};
                    n = Bezier.Degree ;
                    x = 0;
                    y = 0;
                    for k = 1:n+1
                        xterm = W(k,1) .* nchoosek(n,k-1) .* (1-t).^(n-k+1) .* t.^(k-1) ;
                        yterm = W(k,2) .* nchoosek(n,k-1) .* (1-t).^(n-k+1) .* t.^(k-1) ;

                        x = x + xterm;
                        y = y + yterm;
                    end
                    varargout{1} = x;
                    varargout{2} = y;
            end
        end
        
        function [x,y,BreakIndices] = GenerateCurve(Bezier,DataX,DataY,MxAllowSqD,varargin)
            
            if nargin == 4            
%               BreakIndices = Bezier.Fit(DataX,DataY,MxAllowSqD);
%               Normalize input for fiting so that the tolerance value
%               actually means something
                BreakIndices = Bezier.Fit(DataX/max(abs(DataX)),DataY/max(abs(DataY)),MxAllowSqD);
                
                for i=1:length(Bezier.Weights)
                    Bezier.Weights{i} = [Bezier.Weights{i}(:,1)*max(abs(DataX)),...
                                         Bezier.Weights{i}(:,2)*max(abs(DataY))];
                end
                x = [];
                y = [];

                for j=1:Bezier.NumOSplines

                    %takes care of point overlap between splines, insures same
                    %number of data points are output
                    if j ~= Bezier.NumOSplines
                        t = linspace(0,1,BreakIndices(j+1)-BreakIndices(j));
                    else
                        t = linspace(0,1,BreakIndices(j+1)-BreakIndices(j)+1); 
                    end

                    [tempX,tempY] = Bezier.Crunch(t, j);
                    x = [x,tempX];
                    y = [y,tempY];
                end
                x = x';
                y = y';
            end
            if nargin == 2
                BreakIndices = DataX;

                x = [];
                y = [];

                for j=1:Bezier.NumOSplines

                    %takes care of point overlap between splines, insures same
                    %number of data points are output
                    if j ~= Bezier.NumOSplines
                        t = linspace(0,1,BreakIndices(j+1)-BreakIndices(j));
                    else
                        t = linspace(0,1,BreakIndices(j+1)-BreakIndices(j)+1); 
                    end

                    [tempX,tempY] = Bezier.Crunch(t, j);
                    x = [x,tempX];
                    y = [y,tempY];
                end
                x = x';
                y = y';
            end
        end
            
        function [EqList] = RecoverAllEquations(Bezier,S,varargin)
            % Returns Nx2 Cell array of symbolic parametric equations for
            % each spline. 
            % First Column is x(t), 2nd is y(t)
            % Enter 'show' for S arguement to get latex display of
            % equations. 
            EqList = sym(zeros(Bezier.NumOSplines,2));  
            
            for i = 1:Bezier.NumOSplines
               [EqList(i,1),EqList(i,2)] = Bezier.RecoverEquation(i);               
            end
            
            if nargin ==2 
               if strcmp(S,'show')
                   toLatex(EqList);
               end
            end
            
        end
        
        function [X,Y] = RecoverEquation(Bezier,SplineNum)
        % Creates a list of paired parametric symbolic equations for each
        % spline based on weight values. 
            X = 0;
            Y = 0;
            syms t;
            n = Bezier.Degree ;
            W = sym(Bezier.Weights{SplineNum});
            
            for k = 1:n+1
                xterm = W(k,1) * nchoosek(n,k-1)  * (1-t)^(n-k+1) * t^(k-1) ;
                yterm = W(k,2) * nchoosek(n,k-1)  * (1-t)^(n-k+1) * t^(k-1) ;
                
                X = X + xterm;
                Y = Y + yterm;
            end
            
        end
        
        function fbi = Fit(Bezier,DataX, DataY, MxAllowSqD)
        % Algorithms from Dr. Murtaza Khan  
        % Only works for cubic splines
        % Returns indices of spline break points. 
        % Requires many many functions from the 'cubicbezierlsufit' folder
            if Bezier.Degree ~= 3
               error('Curve must be degree 3'); 
            end
            
            if size(DataX,1) ==1
                DataX = DataX';
            end
            
            if size(DataY,1) ==1
                DataY = DataY';
            end
            
            Mat=[DataX,DataY];
            ei= length(DataX);
            ibi=[1;ei]; %first and last point are taken as initial break points
            
            [p0mat,p1mat,p2mat,p3mat,fbi]=bzapproxu(Mat,MxAllowSqD,ibi);    %fitting function, external to class
            
            Bezier.NumOSplines = size(p0mat,1);
            Bezier.Weights = cell(Bezier.NumOSplines,1);
            
            %convert Khan's output format in objet data format
            for i=1:Bezier.NumOSplines
               Bezier.Weights{i} = [p0mat(i,:);p1mat(i,:);p2mat(i,:);p3mat(i,:)]; 
            end           
        end
        
        function MatchEndPoints(Bezier, p1, p2, sp_num)
            %Finds the weights that match the end points and derivatives, assigns to
            %jth spline
            %Format of p1 and p2:
            %   [x,y;
            %  dx/dt, dy/dt;
            %  ddx/dt ... ]
            %  and so on
            degree = length(p1) + length(p2) - 1;
            W = zeros(length(p1) + length(p2), 2); 
            W(1,:) = p1(1,:);
            W(end,:) = p2(1,:);
            if length(p1) > 1
                for i = 2:length(p1)
                    for j = 1:2
                        W(i,j) = p1(i,j)/(degree - i + 2) + W(i-1,j);
                    end
                end
            end
            if length(p2) > 1
                for i = length(W):length(p2)
                    for j = 1:2
                        W(i,j) = p2(i,j)/(degree - i + 2) + W(i-1,j);
                    end
                end
            end
            Bezier.Weights{sp_num} = W;
            if Bezier.Degree < degree
                Bezier.Degree = degree;
            end
            
        end
        
        function RaiseTo(Bezier,n)
        %Algorithm taken directly from http://www.cs.mtu.edu/~shene/COURSES/cs3621/NOTES/spline/Bezier/bezier-elev.html  
        
            %must run (n-original degree curve) times
            for p = Bezier.Degree+1:n
                %for all spline functions
                for j=1:Bezier.NumOSplines
                    
                    
                    W = [Bezier.Weights{j}]; 
                    
                    NewW = [Bezier.Weights{j}(1,:);
                            zeros(p-1,2);
                            Bezier.Weights{j}(end,:)]; %add another row for new control point
                        
                    %execute n -> n+1 raise procedure
                    for i=2:p
                        NewW(i,:) = W(i-1,:).*(i-1)/(p) + ( 1 - (i-1)/p).*W(i,:) ;
                    end
                    
                    Bezier.Weights{j} = NewW;
                    
                end
            end
            Bezier.Degree = n;
        end
        
        function [eqlist,outsymbols] = Variablize(Bezier,sIndex,wIndex,symbols)
           % this function makes symoblic equations of splines, allows making weights into variables. 
           % sIndex is an Mx1 array that indicates which splines to use
           % wIndex is a MxN array of weight indexs to replace with  
           % corresponding symbols, which is an MxNarray
           %
           % output is a Mx2 array of parametric equations, where the
           % x=f(t) y =g(t) equations represent the indexed splines. 
           % and output symbols that have e.g subsituted ax for a and ay
           % for a in the appropiate places. 
           outsymbols= sym(zeros(2*size(symbols,2)*length(sIndex),1));
           eqlist = sym(zeros(length(sIndex),2));
           n = Bezier.Degree ;
           syms t;
           for m=1:length(sIndex)
               W = sym(Bezier.Weights{sIndex(m)});
               
               for i=1:size(symbols,2)
                   W(wIndex(m,i),1) = sym(strcat(char(symbols(m,i)),'x'),'real'); %x
                   W(wIndex(m,i),2) = sym(strcat(char(symbols(m,i)),'y'),'real'); %y
                   outsymbols((m-1)*2*size(symbols,2)+i) = sym(strcat(char(symbols(m,i)),'x'),'real');
                   outsymbols((m-1)*2*size(symbols,2)+i+1)= sym(strcat(char(symbols(m,i)),'y'),'real');
               end
               
               X = sym(0);
               Y = sym(0);
               
               for k = 1:n+1
                    xterm = W(k,1) * nchoosek(n,k-1)  * (1-t)^(n-k+1) * t^(k-1) ;
                    yterm = W(k,2) * nchoosek(n,k-1)  * (1-t)^(n-k+1) * t^(k-1) ;

                    X = X + xterm;
                    Y = Y + yterm;
               end
               eqlist(m,1)=X;
               eqlist(m,2)=Y;
           end
           
        end
        
    end
    
end
