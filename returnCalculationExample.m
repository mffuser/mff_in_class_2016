%% calculate return with missing observation

prices = [100, 104, NaN, 102];

% calculating returns straightforward: too many NaNs
discRets = (prices(2:end) - prices(1:end-1))./prices(1:end-1);

%% improved way to handle NaNs: 

% find holidays
isHoliday = isnan(prices);

% impute missing values with last observation
prices(isHoliday) = prices([isHoliday(2:end) false]);

% calculate returns
discRets = (prices(2:end) - prices(1:end-1))./prices(1:end-1);

% set returns on holiday to NaN
discRets(isHoliday(2:end)) = NaN;



