function richestPerson = findRichestPerson(coinNumbers)
% find the richest person
%
% Input:
%   coinNumbers     nPerson x 4 matrix
%
% Output:
%   richestPerson   scalar; index of richest person

% specify value of coins
coinValue = [0.25; 0.05; 0.1; 0.01];

% get overall amount of money for each person
moneyPerPerson = coinNumbers*coinValue;

% find richest one
[~, richestPerson] = max(moneyPerPerson);

end