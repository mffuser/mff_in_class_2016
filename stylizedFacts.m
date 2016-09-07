% specify begin and end date
dateBeg = '01011990';
dateEnd = '01092016';

% specify assets
tickSymbs = {'^GSPC', '^GDAXI', '^DJI', '^N225'};

data = getPrices(dateBeg, dateEnd, tickSymbs);

discRets = price2retWithHolidays(data, true);

%% calculate evolution with constant interest rates

% get time passed
yearsPassed = (data.Date(end) - data.Date(1))/365;

% get value for each year
i = 0.08;
endValue = 5000*(1 + i).^(1:yearsPassed);

%% visualize log-prices: linear for exponential growth

figure('Position', [50 50 1200 600])
subplot(1, 2, 1)
plot(data.Date, data{:, 2:end})
hold on
plot(data.Date(1) + 365*(1:yearsPassed), endValue)
hold off
datetick 'x'
grid on

subplot(1, 2, 2)
plot(data.Date, log(data{:, 2:end}))
hold on
plot(data.Date(1) + 365*(1:yearsPassed), log(endValue))
hold off
datetick 'x'
grid on

%% get log percentage returns


