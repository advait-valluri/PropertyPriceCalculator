function formattedNumber = formatNUM(num, varargin)
% FORMATNUM Format a number in currency format using system locale or specified currency.
%
% Usage:
%   formattedNumber = formatNUM(12345678.90);         % Uses system locale
%   formattedNumber = formatNUM(12345678.90, 'USD');  % Format as USD
%   formattedNumber = formatNUM(12345678.90, 'INR');  % Format as INR (Indian-style commas)
%   formattedNumber = formatNUM(12345678.90, 'EUR');  % Format as Euro
%
% Input:
%   num - numeric value to format
%   varargin - optional currency type ('INR', 'USD', or 'EUR')
%
% Output:
%   formattedNumber - formatted currency string

import java.text.NumberFormat;
import java.util.Locale;

if nargin > 1
    currencyType = upper(varargin{1});
else
    currencyType = 'DEFAULT';  % Fallback to system locale
end

switch currencyType
    case 'USD'
        loc = Locale.US;
        formatter = NumberFormat.getCurrencyInstance(loc);
        formattedNumber = char(formatter.format(num));
    case 'EUR'
        loc = Locale.GERMANY;
        formatter = NumberFormat.getCurrencyInstance(loc);
        formattedNumber = char(formatter.format(num));
    case 'INR'
        % Custom Indian format
        currencySymbol = '₹';
        str = sprintf('%.2f', num);  % Force 2 decimal places
        parts = strsplit(str, '.');
        intPart = parts{1};
        decPart = parts{2};

        % Reverse integer part to simplify grouping
        revInt = fliplr(intPart);
        formatted = revInt(1:3);  % First 3 digits

        idx = 4;
        while idx <= length(revInt)
            formatted = [formatted, ',', revInt(idx:min(idx+1, end))]; %#ok<AGROW>
            idx = idx + 2;
        end

        formatted = fliplr(formatted);
        formattedNumber = [currencySymbol, formatted, '.', decPart];
    otherwise
        % Use system default locale
        loc = Locale.getDefault();
        formatter = NumberFormat.getCurrencyInstance(loc);
        formattedNumber = char(formatter.format(num));
end

end



