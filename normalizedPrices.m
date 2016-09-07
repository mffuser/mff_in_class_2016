daxDownload;

%% find missing values

nAss = size(data, 2) - 1;
imagesc(isnan(data{:, 2:end}), [-1 1])
set(gca, 'XTick', 1:nAss)
set(gca, 'XTickLabel', tabnames(data(:, 2:end)))

dates = data.Date;
set(gca, 'YTickLabel', datestr(dates(get(gca, 'YTick'))))

%% find first date with all values

dataMatr = data{:, 2:end};
allObs = all(~isnan(dataMatr), 2);
firstInd = find(allObs, 1);

%% 

validData = data(firstInd:end, :);
nObs = size(validData, 1);

% rescaled valid data
validData{:, 2:end} = validData{:, 2:end} ./ repmat(validData{1, 2:end}, nObs, 1);

%% get annualized return

% get time passed
yearsPassed = (validData.Date(end) - validData.Date(1))/365;

% get annualized return
((validData{end, 2:end} ./ validData{1, 2:end}).^(1/yearsPassed) - 1)*100

%% calculate return with annualized return of 3 %

i = 0.03;
endValue = 1*(1 + i).^(1:yearsPassed);

%% visualize normalized prices paths

plot(validData.Date, validData{:, 2:end})
datetick 'x'
grid on
legend(tabnames(validData(:, 2:end)), 'Location', 'Northwest')

hold on
plot(validData.Date(1) + 365*(1:yearsPassed), endValue)
hold off




