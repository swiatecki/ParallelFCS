clear;
clc;
% Generates VHDL expressions for parallel FCS check 
% Nicholas Swiatecki <nicholas@swiatecki.com>

nBits = 8;

polyLen = 32;

topLeftEye = eye(31);

topLeft = horzcat(zeros(31,1),topLeftEye);

% Now add bottom of top left, the G's

% G
G = [1,1,1,0,1,1,0,1,1,0,1,1,1,0,0,0,1,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0];

topLeft = vertcat(topLeft,G);

% Now add the zeros in the top right part

top = horzcat(topLeft,zeros(polyLen,nBits));

% --- Generate lower half


lowerLeft = zeros(nBits,polyLen);
lowerLeft(1,1) = 1;

% Shift matrix
lowerRight = vertcat(zeros(1,nBits),eye(nBits));
lowerRight = lowerRight(1:nBits,:);
lowerRight(1,nBits) = 1;

% -- 

lower = horzcat(lowerLeft,lowerRight);

% -- merge top and bottom

M = vertcat(top,lower);

% -- Generate equations

%-- Run 8 iterations,modulu 2 for binary

M8 = mod(mpower(M,8),2);

%-- Extract equations
[rows,columns] = size(M8);
%Loop all colums

for i = 1:polyLen
    
    %-- Per colums operations
    outString = '';
    for j = 1:rows
        if M8(j,i) == 1
            
            %Not proud of this
            if j <= polyLen
                 variableString = sprintf(' R(%i)',j-1);
            else
                
              
                 %variableString = sprintf(' data_in_1(%i)',j-polyLen-1);
              % variableString = sprintf(' data_in_1(%i)',mod(j+7,40));
               variableString = sprintf(' data_in_1(%i)',40-j);
            end
            
           
            if isempty(outString)
                
                 outString = strcat(outString,variableString);
            else
                 xor = ' xor ';
                 outString = strcat(outString,xor,variableString);
            end
    
          
        end %end if 1
        
           
       
    end % end row iteration
    
   
        prefix = sprintf('R(%i) <=',i-1);
        outString = strcat(prefix,outString,';');
    
           
     disp(outString);
    
    % End column iteration
    
end
