/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Properties;
import org.as2lib.lang.Locale;
import org.as2lib.lang.LocaleManager;
import org.as2lib.util.StringUtil;

/**
 * {@code DateFormat} formats a given date with a specified pattern.
 * 
 * <p>Use the declared constants as placeholders for specific parts of the date-time.
 *
 * <p>All characters from 'A' to 'Z' and from 'a' to 'z' are reserved, although not
 * all of these characters are interpreted right now. If you want to include plain
 * text in the pattern put it into quotes (') to avoid interpretation. If you want
 * a quote in the formatted date-time, put two quotes directly after one another.
 * For example: {@code "hh 'o''clock'"}.
 * 
 * <p>Example:
 * <code>
 *   var formatter:DateFormat = new DateFormat("dd.mm.yyyy HH:nn:ss S");
 *   trace(formatter.format(new Date(2005, 2, 29, 18, 14, 3, 58)));
 * </code>
 *
 * <p>Output:
 * <pre>
 *   29.03.2005 18:14:03 58
 * </pre>
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.lang.DateFormat extends BasicClass {
	
	/** The default date format pattern. */
	public static var DEFAULT_DATE_FORMAT:String = "MEDIUM";
	
	/** Placeholder for year in date format. */
	public static var YEAR:String = "y";
	
	/** Placeholder for month in year as number in date format. */
	public static var MONTH_AS_NUMBER:String = "m";
	
	/** Placeholder for month in year as text in date format. */
	public static var MONTH_AS_TEXT:String = "M";
	
	/** Placeholder for day in month as number in date format. */
	public static var DAY_AS_NUMBER:String = "d";
	
	/** Placeholder for day in week as text in date format. */
	public static var DAY_AS_TEXT:String = "D";
	
	/** Placeholder for hour in am/pm (1 - 12) in date format. */
	public static var HOUR_IN_AM_PM:String = "h";
	
	/** Placeholder for hour in day (0 - 23) in date format. */
	public static var HOUR_IN_DAY:String = "H";
	
	/** Placeholder for minute in hour in date format. */
	public static var MINUTE:String = "n";
	
	/** Placeholder for second in minute in date format. */
	public static var SECOND:String = "s";
	
	/** Placeholder for millisecond in date format. */
	public static var MILLISECOND:String = "S";
	
	/** Quotation beginning and ending token. */
	public static var QUOTE:String = "'";
	
	/** The locale to look-up names of months, days etc. */
	private var locale:Locale;
	
	/** Date format to generate the string representation of a given date. */
	private var dateFormat:String;
	
	/** Names of methods to invoke when specific placeholders are encountered. */
	private var m:Array;
	
	/**
	 * Constructs a new {@code DateFormat} instance.
	 *
	 * <p>If you do not pass-in a {@code dateFormat} or if the passed-in one is
	 * {@code null} or {@code undefined} the {@code DEFAULT_DATE_FORMAT} is used.
	 * 
	 * <p>If you do not pass-in a {@code locale} or if the passed-in one is
	 * {@code null} or {@code undefined}, the shared locale returned by
	 * {@code LocaleManager.getInstance()} is used.
	 * 
	 * @param dateFormat (optional) the date format pattern
	 * @param locale (optional) the locale to look-up names of months etc.
	 */
	public function DateFormat(dateFormat:String, locale:Locale) {
		this.dateFormat = (dateFormat == null) ? DEFAULT_DATE_FORMAT : dateFormat;
		this.locale = (locale == null) ? LocaleManager.getInstance() : locale;
		m = new Array();
		m[YEAR] = "formatYear";
		m[MONTH_AS_NUMBER] = "formatMonthAsNumber";
		m[MONTH_AS_TEXT] = "formatMonthAsText";
		m[DAY_AS_NUMBER] = "formatDayAsNumber";
		m[DAY_AS_TEXT] = "formatDayAsText";
		m[HOUR_IN_AM_PM] = "formatHourInAmPm";
		m[HOUR_IN_DAY] = "formatHourInDay";
		m[MINUTE] = "formatMinute";
		m[SECOND] = "formatSecond";
		m[MILLISECOND] = "formatMillisecond";
	}
	
	/**
	 * Formats the passed-in {@code date} with the specified date format pattern into a
	 * date-time string and returns the resulting string.
	 * 
	 * <p>If the passed-in {@code date} is {@code null} or {@code undefined}, the current
	 * date-time will be used instead.
	 *
	 * @param date the date-time value to format into a date-time string
	 * @param dateFormat (optional) format to overwrite the class default format
	 * @param locale (optional) the locale to look-up names of months etc.
	 * @return the formatted date-time string
	 */
	public function format(date:Date, dateFormat:String, locale:Locale):String {
		if (date == null) date = new Date();
		if (dateFormat == null) dateFormat = this.dateFormat;
		if (locale == null) locale = this.locale;
		var symbols:Properties = locale.getSymbols();
		var df:String = dateFormat.toUpperCase();
		switch (df) {
			case "SHORT":
			case "LONG":
			case "MEDIUM":
			case "FULL":
				dateFormat = symbols.getProp(df);
		}
		var result:String = "";
		var i:Number = 0;
		var tokenCount:Number;
		var token:String;
		var char:String;
		var l:Number = dateFormat.length;
		while (i < l) {
			char = dateFormat.charAt(i);
			var method:String = m[char];
			if (method != null) {
				tokenCount = -1;
				token = dateFormat.charAt(i);
				while (dateFormat.charAt(i+(++tokenCount)) == token);
				result += this[method](date, tokenCount, symbols);
				i += tokenCount;
			}
			else {
				if (char == QUOTE) {
					if (dateFormat.charAt(i + 1) == QUOTE) {
						result += "'";
						i += 2;
					}
					else {
						var quoteStart:Number = i;
						var quoteEnd:Number = i + 1;
						while (quoteEnd < l - 1) {
							if (dateFormat.charAt(quoteEnd) == QUOTE) {
								if (dateFormat.charAt(quoteEnd + 1) != QUOTE) {
									break;
								}
								quoteEnd += 2;
							}
							else {
								quoteEnd++;
							}
						}
						result += dateFormat.substring(quoteStart + 1, quoteEnd).split("''").join("'");
						i = quoteEnd + 1;
					}
				}
				else {
					result += char;
					i++;
				}
			}
		}
		return result;
	}
	
	/**
	 * Returns the number of tokens that occur in a succession from the beginning of the
	 * passed-in {@code string}.
	 * 
	 * <p>If the passed-in {@code string} is {@code null}, {@code undefined} or empty,
	 * 0 is returned.
	 *
	 * @param string the string to search through
	 * @param start start of reading in the string
	 * @return the number of tokens that occur in a succession
	 */
	private function getTokenCount(string:String, start:Number):Number {
		if (!string) return 0;
		var result:Number = -1;
		var token:String = string.charAt(start);
		while (string.charAt(start+(++result)) == token);
		return result;
	}
	
	/**
	 * Returns a string that contains the specified number of 0s.
	 *
	 * <p>A {@code count} less or equal than 0 or a {@code count} of value {@code null}
	 * or {@code undefined} results in en empty string.
	 * 
	 * @param count the number of 0s
	 * @return the specified number of 0s
	 */
	private function getZeros(count:Number):String {
		return StringUtil.multiply("0", count);
	}
	
	/**
	 * Formats the passed-in {@code year} into a year string with the specified
	 * {@code digitCount}.
	 * 
	 * <p>A {@code digitCount} less or equal than three results in a year string with
	 * two digits. A {@code digitCount} greater or equal than four results in a year
	 * string with four digits plus preceding 0s if the {@code digitCount} is greater
	 * than four.
	 *
	 * <p>If the passed-in {@code digitCount} is {@code null} or {@code undefined}, 0
	 * is used instead.
	 *
	 * @param date date to get the year from the account
	 * @param digitCount the number of favored digits
	 * @return the string representation of the year
	 */
	private function formatYear(date:Date, digitCount:Number):String {
		var year:Number = date.getFullYear();
		if (year == null) {
			year = 0;
		}
		if (digitCount == null || digitCount < 4) {
			return year.toString().substr(2);
		}
		return (getZeros(digitCount - 4) + year.toString());
	}
	
	/**
	 * Formats the passed-in {@code month} into a month as number string with the
	 * specified {@code digitCount}.
	 * 
	 * <p>A {@code digitCount} less or equal than one results in a month with one digit,
	 * if the month is less or equal than nine. Otherwise the month is represented by a
	 * two digit number. A {@code digitCount} greater or equal than two results in a
	 * month with preceding 0s.
	 *
	 * <p>If the passed-in {@code digitCount} is {@code null} or {@code undefined}, 0 
	 * is used instead.
	 * 
	 * @param month the month to format to a number string
	 * @param digitCount the number of favored digits
	 * @return the number representation of the month
	 */
	private function formatMonthAsNumber(date:Date, digitCount:Number):String {
		var month:Number = date.getMonth();
		if (month < 0 || month > 11 || month == null) {
			month = 0;
		}
		if (digitCount == null) digitCount = 0;
		var string:String = (month + 1).toString();
		return (getZeros(digitCount - string.length) + string);
	}
	
	/**
	 * Formats the passed-in {@code month} into a string with the specified 
	 * {@code tokenCount}.
	 * 
	 * <p>A {@code tokenCount} less or equal than three results in a month with three
	 * tokens. A {@code tokenCount} greater or equal than four results in a fully written
	 * out month.
	 *
	 * <p>If the passed-in {@code tokenCount} is {@code null} or {@code undefined}, 0
	 * is used instead.
	 * 
	 * <p>If the passed-in {@code month} is smaller than 0 or bigger than 11,
	 * 0 is used instead. 
	 *
	 * @param month the month to format to a string
	 * @param tokenCount the number of favored tokens
	 * @param symbols the symbols to look-up month names
	 * @return the string representation of the month
	 */
	private function formatMonthAsText(date:Date, tokenCount:Number, symbols:Properties):String {
		var month:Number = date.getMonth();
		if (month < 0 || month > 11 || month == null) {
			month = 0;
		}
		var key:String = (tokenCount < 4 || tokenCount == null) ? "short" : "long";
		return symbols.getProp(key + ".month." + (Math.abs(month) + 1));
	}
	
	/**
	 * Formats the passed-in {@code day} into a day as number string with the specified 
	 * {@code digitCount}.
	 * 
	 * <p>A {@code digitCount} less or equal than one results in a day with one digit,
	 * if the day is less or equal than nine. Otherwise the day is represented by a two
	 * digit number. A {@code digitCount} greater or equal than two results in a day with
	 * preceding 0s.
	 *
	 * <p>If the passed-in {@code digitCount} is {@code null} or {@code undefined}, 0
	 * is used instead.
	 *
	 * @param day the day of month to format to a number string
	 * @param digitCount the number of digits
	 * @return the number representation of the day
	 */
	private function formatDayAsNumber(date:Date, digitCount:Number):String {
		var day:Number = date.getDate();
		if (day < 1 || day > 31 || day == null) {
			day = 1;
		}
		if (digitCount == null) digitCount = 0;
		var string:String = day.toString();
		return (getZeros(digitCount - string.length) + string);
	}
	
	/**
	 * Formats the passed-in {@code day} into a string with the specified 
	 * {@code tokenCount}.
	 * 
	 * <p>A {@code tokenCount} less or equal than three results in a day with two 
	 * tokens. A {@code tokenCount} greater or equal than four results in a fully written
	 * out day.
	 *
	 * <p>If the passed-in {@code tokenCount} is {@code null} or {@code undefined}, 0 
	 * is used instead.
	 *
	 * @param day the day to format to a string
	 * @param tokenCount the number of favored tokens
	 * @param symbols the symbols to look-up day names
	 * @return the string representation of the day
	 */
	private function formatDayAsText(date:Date, tokenCount:Number, symbols:Properties):String {
		var day:Number = date.getDay();
		if (day < 0 || day > 6 || day == null) {
			day = 0;
		} 
		day++;
		var key:String = (tokenCount < 4  || tokenCount == null) ? "short.day." : "long.day.";
		return symbols.getProp(key + day);
	}
	
	/**
	 * Formats the passed-in {@code hour} into a number string from range 1 to 12.
	 * 
	 * <p>The resulting string contains only the specified {@code digitCount} if
	 * possible. This means if the hour is 3 and the {@code digitCount} 1 the resulting
	 * string contains one digit. But this is not possible with the hour 12. So in this
	 * case the resulting string contains 2 digits. If {@code digitCount} is greater
	 * than the actual number of digits, preceding 0s are added.
	 *
	 * <p>If the passed-in {@code digitCount} is {@code null} or {@code undefined}, 0
	 * is used instead.
	 *
	 * @param hour the hour to format
	 * @param digitCount the number of favored digits
	 * @return the string representation of {@code hour}
	 */
	private function formatHourInAmPm(date:Date, digitCount:Number):String {
		var hour:Number = date.getHours();
		if (hour < 0 || hour > 23 || hour == null) {
			hour = 0;
		}
		if (digitCount == null) digitCount = 0;
		var string:String;
		if (hour == 0) {
			string = "12";
		} else if (hour > 12) {
			string = (hour - 12).toString();
		} else {
			string = hour.toString();
		}
		return (getZeros(digitCount - string.length) + string);
	}
	
	/**
	 * Formats the passed-in {@code hour} into a number string from range 0 to 23.
	 * 
	 * <p>The resulting string contains only the specified {@code digitCount} if 
	 * possible. This means if the hour is 3 and the {@code digitCount} 1 the resulting
	 * string contains one digit. But this is not possible with the hour 18. So in this
	 * case the resulting string contains 2 digits. If {@code digitCount} is greater
	 * than the actual number of digits, preceding 0s are added.
	 *
	 * <p>If the passed-in {@code digitCount} is {@code null} or {@code undefined}, 0
	 * is used instead.
	 *
	 * @param hour the hour to format
	 * @param digitCount the number of favored digits
	 * @return the string representation of {@code hour}
	 */
	private function formatHourInDay(date:Date, digitCount:Number):String {
		var hour:Number = date.getHours();
		if (hour < 0 || hour > 23 || hour == null) {
			hour = 0;
		}
		if (digitCount == null) digitCount = 0;
		var string:String = hour.toString();
		return (getZeros(digitCount - string.length) + string);
	}
	
	/**
	 * Formats the passed-in {@code minute} into a number string with range 0 to 59.
	 * 
	 * <p>The resulting string contains only the specified {@code digitCount} if
	 * possible. This means if the minute is 3 and the {@code digitCount} 1, the
	 * resulting string contains only one digit. But this is not possible with the
	 * minute 46. So in this case the resulting string contains 2 digits. If
	 * {@code digitCount} is greater than the actual number of digits, preceding 0s are
	 * added.
	 *
	 * <p>If the passed-in {@code digitCount} is {@code null} or {@code undefined}, 0
	 * is used instead.
	 *
	 * @param minute the minute to format
	 * @param digitCount the number of favored digits
	 * @return the string representation of the {@code minute}
	 */
	private function formatMinute(date:Date, digitCount:Number):String {
		var minute:Number = date.getMinutes();
		if (minute < 0 || minute > 59 || minute == null) {
			minute = 0;
		}
		if (digitCount == null) digitCount = 0;
		var string:String = minute.toString();
		return (getZeros(digitCount - string.length) + string);
	}
	
	/**
	 * Formats the passed-in {@code second} into a number string with range 0 to 59.
	 * 
	 * <p>The resulting string contains only the specified {@code digitCount} if
	 * possible. This means if the second is 3 and the {@code digitCount} 1, the
	 * resulting string contains only one digit. But this is not possible with the
	 * second 46. So in this case the resulting string contains 2 digits. If
	 * {@code digitCount} is greater than the actual number of digits, preceding 0s are
	 * added.
	 *
	 * <p>If the passed-in {@code digitCount} is {@code null} or {@code undefined}, 0
	 * is used instead.
	 *
	 * @param second the second to format
	 * @param digitCount the number of favored digits
	 * @return the string representation of the {@code second}
	 */
	private function formatSecond(date:Date, digitCount:Number):String {
		var second:Number = date.getSeconds();
		if (second < 0 || second > 59 || second == null) {
			second = 0;
		}
		if (digitCount == null) digitCount = 0;
		var string:String = second.toString();
		return (getZeros(digitCount - string.length) + string);
	}
	
	/**
	 * Formats the passed-in {@code millisecond} into a number string with range 0 to
	 * 999.
	 * 
	 * <p>The resulting string contains only the specified {@code digitCount} if
	 * possible. This means if the millisecond is 7 and the {@code digitCount} 1, the
	 * resulting string contains only one digit. But this is not possible with the
	 * millisecond 588. So in this case the resulting string contains 3 digits. If
	 * {@code digitCount} is greater than the actual number of digits, preceding 0s are
	 * added.
	 *
	 * <p>If the passed-in {@code digitCount} is {@code null} or {@code undefined}, 0
	 * is used instead.
	 *
	 * @param millisecond the millisecond to format
	 * @param digitCount the number of favored digits
	 * @return the string representation of the {@code millisecond}
	 */
	private function formatMillisecond(date:Date, digitCount:Number):String {
		var millisecond:Number = date.getMilliseconds();
		if (millisecond < 0 || millisecond > 999 || millisecond == null) {
			millisecond = 0;
		}
		if (digitCount == null) digitCount = 0;
		var string:String = millisecond.toString();
		return (getZeros(digitCount - string.length) + string);
	}
	
}