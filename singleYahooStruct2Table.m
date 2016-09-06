function dataTable = singleYahooStruct2Table(thisStruct)
% process structure from Yahoo finance
% 
% - make table
% - make numeric dates
% - sort

%% get correct column name

thisName = thisStruct.Ticker;
validName = createValidVariableName(thisName);

%%
% get table with required columes
preDataTable = table(thisStruct.Date, thisStruct.AdjClose);
preDataTable.Properties.VariableNames{2} = validName;

% make numeric dates
%preDataTable.Date = preDataTable{:, 1};
preDataTable.Date = datenum(preDataTable.Var1, 'yyyy-mm-dd');

dataTable = preDataTable(:, {'Date', validName});

end