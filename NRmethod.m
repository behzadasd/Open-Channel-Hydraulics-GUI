%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Behzad Asadieh, Ph.D.           %%%
%%% University of Pennsylvania      %%%
%%% basadieh@sas.upenn.edu          %%%
%%% github.com/behzadasd            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Newton-Raphson Iterative Mth
            %% the values must be specifed in GUI Input panel, e.g. MaxNumIter, tol,etc.
function [approxRoot] = NRmethod(x_0,Poly)
          
            MaxNumIter = 20 ; % it can be assigned by user in GUI
            tol = 1.0000e-07 ; % it can be assigned by user in GUI
            [numRows,numCols]   = size(Poly);
            degPoly = max(numRows,numCols) - 1;
            
            %  The derivative of the polynomial a(x) is created.
            polyDeriv = zeros(1,degPoly);
            for k = 1:degPoly
                polyDeriv(k) = (degPoly - k + 1) * Poly(k);
            end
            
            %  Use Newton/Raphson iteration to compute a root of the polynomial.
            
            approxRoot = x_0;
            numSteps   =  MaxNumIter;
            error = 10000;
            for k = 1:MaxNumIter
                polyValue   = polyval(Poly,approxRoot(k));
                polyPrime   = polyval(polyDeriv,approxRoot(k));
                approxRootNew = approxRoot(k) - polyValue/ polyPrime;
                error = abs(polyValue) + abs(approxRoot(k)-approxRootNew);
                approxRoot(k+1) = approxRootNew;
                if error < tol / 5
                    numSteps   = k;
                    break;
                end
            end
end
