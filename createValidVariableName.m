function validName = createValidVariableName(tickSymb)
% transform ticker symbol to valid name
%
% Input:
%   tickSymb    string 
%
% Output
%   validName   string

thisName = tickSymb(tickSymb ~= '^');
validName = matlab.lang.makeValidName(thisName);