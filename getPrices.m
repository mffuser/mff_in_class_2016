function fullTable = getPrices(dateBeg, dateEnd, tickSymbs)
% download and process multiple assets
%
% Input
%   tickSymbs       cell array of ticker symbols

% download data
data = hist_stock_data(dateBeg, dateEnd, tickSymbs{:});

% get number of assets
nAss = length(data);
tableContainer = cell(1, nAss);

% transform individual structures to tables
for ii=1:nAss
   tableContainer{1, ii} = singleYahooStruct2Table(data(ii));
end

% join all tables
fullTable = tableContainer{1};
for ii=2:nAss
   fullTable = outerjoin(fullTable, tableContainer{ii}, ...
       'Keys', {'Date'}, 'MergeKeys', true, 'Type', 'full');
end

% get numerical dates
%fullTable.Date = datenum(fullTable.Date, 'yyyy-mm-dd');

% sort
fullTable = sortrows(fullTable, 'Date');

end