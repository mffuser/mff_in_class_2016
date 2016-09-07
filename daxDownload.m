% download DAX

% specify begin and end date
dateBeg = '01011990';
dateEnd = '01092016';

% specify assets
tickSymb1 = '^JJJJ';
tickSymb2 = '^KKKK';
tickSymbs = {tickSymb1; tickSymb2};

data = getPrices(dateBeg, dateEnd, tickSymbs);







