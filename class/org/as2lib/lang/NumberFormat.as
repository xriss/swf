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
import org.as2lib.util.CharSet;
import org.as2lib.util.CharUtil;
import org.as2lib.util.MathUtil;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.lang.NumberFormat extends BasicClass {
	
	public static var DEFAULT_NUMBER_FORMAT:String = "NUMBER";
	
	private var numberFormat:String;
	private var locale:Locale;
	
	public function NumberFormat(numberFormat:String, locale:Locale) {
		this.numberFormat = (numberFormat == null) ? DEFAULT_NUMBER_FORMAT : numberFormat;
		this.locale = (locale == null) ? LocaleManager.getInstance() : locale;
	}
	
	public function format(number:Number, numberFormat:String, locale:Locale):String {
		if (numberFormat == null) numberFormat = this.numberFormat;
		if (locale == null) locale = this.locale;
		var symbols:Properties = locale.getSymbols();
		var round:String = symbols.getProp("round");
		var comma:String = symbols.getProp("comma");
		var currency:String = symbols.getProp("currency");
		var nf:String = numberFormat.toUpperCase();
		switch (nf) {
			case "NUMBER":
			case "INTEGER":
			case "CURRENCY":
			case "PERCENT":
				numberFormat = symbols.getProp(nf);
		}
		var i:Number = 0;
		var l:Number = numberFormat.length;
		var last:Number = 0;
		var sep:Array = [];
		while (i < l) {
			var c:String = numberFormat.charAt(i);
			if (c == "'") {
				if (numberFormat.charAt(i + 1) == "'") {
					i += 2;
				}
				else {
					var quoteStart:Number = i;
					var quoteEnd:Number = i + 1;
					while (quoteEnd < l - 1) {
						if (numberFormat.charAt(quoteEnd) == "'") {
							if (numberFormat.charAt(quoteEnd+1) != "'") {
								break;
							}
							quoteEnd += 2;
						}
						else {
							quoteEnd++;
						}
					}
					i = quoteEnd + 1;
				}
			}
			else if (c == ";") {
				sep.push(numberFormat.substring(last, i));
				last = i + 1;
			}
			i++;
		}
		sep.push(numberFormat.substr(last));
		if (number < 0) {
			if (sep.length > 1) {
				return doFormat(number, sep[1], round, comma, currency);
			}
			return doFormat(number, sep[0], round, comma, currency);
		}
		return doFormat(number, sep[0], round, comma, currency);
	}
	
	private function doFormat(number:Number, format:String, round:String, comma:String, currency:String):String {
		var i:Number;
		var specialChars:String = "#%\u2030,.E-0\u00A4";
		var len = format.length;
		// Number modifications to work with
		var isNegative = (number < 0);
		number = Math.abs(number);
		// Prefix evaluation
		var prefix:String = "";
		i = 0;
		while (i < len) {
			var c:String = format.charAt(i);
			if (c == "'") {
				if (format.charAt(i + 1) == "'") {
					prefix += "'";
					i += 2;
				}
				else {
					var quoteStart:Number = i;
					var quoteEnd:Number = i+1;
					while (quoteEnd < format.length-1) {
						if (format.charAt(quoteEnd) == "'") {
							if (format.charAt(quoteEnd+1) != "'") {
								break;
							}
							quoteEnd += 2;
						} else {
							quoteEnd++;
						}
					}
					prefix += format.substring(quoteStart + 1, quoteEnd).split("''").join("'");
					i = quoteEnd+1;
				}
			}
			else if (specialChars.indexOf(c) > -1) {
				break;
			}
			else {
				prefix += c;
				i++;
			}
		}
		// Suffix evaluation
		var j:Number = len-1;
		var suffix:String = "";
		while (j > i) {
			var c:String = format.charAt(j);
			if (c == "'") {
				if (format.charAt(j - 1) == "'") {
					suffix = "'" + suffix;
					j -= 2;
				}
				else {
					var quoteStart:Number = j-1;
					var quoteEnd:Number = j;
					while (quoteStart > 0) {
						if (format.charAt(quoteStart) == "'") {
							if (format.charAt(quoteStart-1) != "'") {
								break;
							}
							quoteStart -= 2;
						} else {
							quoteStart--;
						}
					}
					suffix = suffix+format.substring(quoteStart+1, quoteEnd).split("''").join("'");
					j = quoteStart-1;
				}
			}
			else if (specialChars.indexOf(c) > -1) {
				break;
			}
			else {
				suffix = c + suffix;
				j--;
			}
		}
		// Number evaluation
		var numberFormat:String = format.substring(i, j + 1);
		// Settings checker (pre analysation)
		var usingMantissa:Number = -1;
		var actualMantissa:Boolean = false;
		var usingMinus:Number = -1;
		var usingPercent:Number = -1;
		var usingDecimal:Number = -1;
		var usingPermille:Number = -1;
		var preFractionCharacters:Number = 0;
		var postFractionCharacters:Number = 0;
		var postFractionZeroOnly:Number = 0;
		j = numberFormat.length;
		i = 0;
		while (i < j) {
			var c:String = numberFormat.charAt(i);
			if (c == "0") {
				if (!actualMantissa) {
					if (usingDecimal != -1) {
						postFractionCharacters++;
						postFractionZeroOnly++;
					} else {
						preFractionCharacters++;
					}
				}
			}
			else if (c == "#") {
				if (!actualMantissa) {
					if (usingDecimal == -1) {
						preFractionCharacters++;
					}
					else {
						postFractionCharacters++;
					}
				}
			}
			else if (c == ".") {
				if (!actualMantissa) {
					usingDecimal = i;
				}
			}
			else if (c == "-") {
				if (!actualMantissa) {
					usingMinus = i;
				}
			}
			else if (c == "E") {
				actualMantissa = true;
				usingMantissa = i;
			}
			else if (c == "%") {
				actualMantissa = false;
				usingPercent = i;
			}
			else if (c == "\u2030") {
				actualMantissa = false;
				usingPermille = i;
			}
			else if (c == "'") {
				actualMantissa = false;
				var quoteStart:Number = i;
				var quoteEnd:Number = i + 1;
				while (quoteEnd < format.length - 1) {
					if (format.charAt(quoteEnd) == "'") {
						if (format.charAt(quoteEnd+1) != "'") {
							break;
						}
						quoteEnd += 2;
					}
					else {
						quoteEnd++;
					}
				}	
				i = quoteEnd; 
			}
			else {
				actualMantissa = false;
			}
			i++;
		}
		// Concrete Number modifications
		var fraction:Number;
		var fractionFactor:Number = preFractionCharacters;
		if (usingPercent != -1) {
			number *= 100;
		} else if (usingPermille != -1) {
			number *= 1000;
		}
		if (usingMantissa != -1) {
			if (number == 0) {
				fraction = 0;
				fractionFactor = 0;
			} else {
				fraction = Math.pow(10, fractionFactor);
				while (fraction > number) {
					fraction = Math.pow(10, fractionFactor);
					fractionFactor--;
				} 
				number = number / fraction;
			}
		}
		if (round == "floor") {
			number = MathUtil.floor(number, postFractionCharacters);
		} else if (round == "ceil") {
			number = MathUtil.ceil(number, postFractionCharacters);
		} else {
			number = MathUtil.round(number, postFractionCharacters);
		}
		// Number writing
		i = 0;
		j = numberFormat.length;
		var numberResult = "";
		var numberAsString:String = String(number);
		var spos:Number = 0; // Position in numberAsString
		var slen:Number = numberAsString.length-1;	
		var sComma = numberAsString.indexOf(".");
		if (sComma < 0) {
			sComma = slen + 1;
		}
		var zeroWritten:Number = 0;
		var firstNumberWritten:Boolean = false;
		var negativeWritten:Boolean = false;
		if (number == Infinity) {
			postFractionZeroOnly = 0;
			postFractionCharacters = 1;
		}
		while (i < j) {
			var c:String = numberFormat.charAt(i);
			if (c == "0") {
				if (!firstNumberWritten) { 
					if (!negativeWritten) {
						if (isNegative && usingMinus == -1) {
							numberResult += "-";
						}
					}
					if (preFractionCharacters-zeroWritten > sComma) {
						numberResult += "0";
						zeroWritten++;
					} else {
						spos = sComma-preFractionCharacters+zeroWritten+1;
						numberResult += numberAsString.substring(0, spos);
						firstNumberWritten = true;
					}
				}
				else {
					if (number != Infinity) {
						if (spos > slen) {
							numberResult += "0";
						}
						else {
							numberResult += numberAsString.charAt(spos); 
							spos++;
						}
					}
				}
				i++;
			}
			else if (c == "#") {
				if (!firstNumberWritten) {
					if (spos <= slen) {
						spos = numberAsString.indexOf(".");
						if (spos < 0) {
							spos = slen-preFractionCharacters+2;
						}
						else {
							spos = spos-preFractionCharacters+1;
						}
						numberResult += numberAsString.substring(0,spos);
						firstNumberWritten = true;
					}
				}
				else {
					if (spos <= slen && number != Infinity) {
						numberResult += numberAsString.charAt(spos); 
						spos++;
					}
				}
				i++;
			}
			else if (c == "E") {
				var restFormat:String = numberFormat.substring(i+1);
				var restMantisseSet:CharSet = new CharSet(true);
				restMantisseSet["0"] = true;
				restMantisseSet["#"] = true;
				restMantisseSet["."] = true;
				restMantisseSet[";"] = true;
				restMantisseSet["-"] = true;
				var firstMatch:Number = CharUtil.getFirstMatch(restFormat, restMantisseSet);
				if (firstMatch < 0) {
					restFormat = restFormat.substr(0);
				} else {
					restFormat = restFormat.substring(0, firstMatch);
				}
				numberResult += c + doFormat(fractionFactor, restFormat, round, comma);
				i += restFormat.length+1;
			}
			else if (c == ".") {
				if (postFractionZeroOnly > 0 || spos <= slen || postFractionCharacters == 0) {
					numberResult += comma;
					spos ++;
				}
				i++;
			}
			else if (c == "\u00A4") {
				numberResult += currency;
				i++;
			}
			else if (c == "-") {
				if (isNegative) {
					numberResult += "-";
				}
				else {
					numberResult += "+";
				}
				i++;
			}
			else if (c == "'") {
				if (numberFormat.charAt(i + 1) == "'") {
					numberResult += "'";
					i += 2;
				}
				else {
					var quoteStart:Number = i;
					var quoteEnd:Number = i+1;
					while (quoteEnd < numberFormat.length-1) {
						if (numberFormat.charAt(quoteEnd) == "'") {
							if (numberFormat.charAt(quoteEnd+1) != "'") {
								break;
							}
							quoteEnd += 2;
						}
						else {
							quoteEnd++;
						}
					}
					numberResult += numberFormat.substring(quoteStart+1, quoteEnd).split("''").join("'"); 
					i = quoteEnd+1;
				}
			}
			else if(c == ",") {
				if (spos > 0) {
					numberResult += c;
				}
				i++;
			}
			else {
				numberResult += c;
				i++;
			}
		}
		// combining to one result
		return (prefix + numberResult + suffix);
	}
	
} 