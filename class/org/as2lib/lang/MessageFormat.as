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
import org.as2lib.lang.DateFormat;
import org.as2lib.lang.Locale;
import org.as2lib.lang.NumberFormat;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.lang.MessageFormat extends BasicClass {

	private var pattern:String;
	private var tokens:Array;
	private var locale:Locale;
	private var dateFormat:DateFormat;
	private var numberFormat:NumberFormat;

	public function MessageFormat(pattern:String, locale:Locale) {
		applyPattern(pattern);
		setLocale(locale);
	}

	public function applyPattern(pattern:String):Void {
		if (pattern != null) {
			this.pattern = pattern;
			tokens = getTokens(pattern);
		}
	}

	public function getLocale(Void):Locale {
		return locale;
	}

	public function setLocale(locale:Locale):Void {
		this.locale = locale;
	}

	public function getNumberFormat(Void):NumberFormat {
		return numberFormat;
	}

	public function setNumberFormat(numberFormat:NumberFormat):Void {
		this.numberFormat = numberFormat;
	}

	public function getDateFormat(Void):DateFormat {
		return dateFormat;
	}

	public function setDateFormat(dateFormat:DateFormat):Void {
		this.dateFormat = dateFormat;
	}

	public function format(args:Array, pattern:String, locale:Locale):String {
		if (pattern == null) pattern = this.pattern;
		if (locale == null) locale = this.locale;
		if (dateFormat == null) {
			dateFormat = new DateFormat();
		}
		if (numberFormat == null) {
			numberFormat = new NumberFormat();
		}
		var result:String = "";
		var symbols:Properties = locale.getSymbols();
		var tokens:Array = tokens;
		if (tokens == null || pattern != null && pattern != this.pattern) {
			tokens = getTokens(pattern);
		}
		for (var i:Number = 0; i < tokens.length; i++) {
			var token = tokens[i];
			if (typeof(token) == "string") {
				result += tokens[i];
			}
			else {
				var num:Number = Number(token[0]);
				if (num == null && token[0].length > 1) {
					var args2:Array = token.slice(1);
					var args3:Array = [];
					var content:String = symbols.getProp(token[0]);
					if (content != pattern) {
						for (var j:String in args2) {
							if (args[args2[j]]) {
								args3[j] = args[args2[j]];
							}
							else {
								args3[j] = j;
							}
						}
						result += format(args3, content);
					}
				}
				else {
					var arg = args[num];
					if (token.length == 1) {
						if (arg != null) {
							result += arg;
						}
					}
					else {
						var type:String = token[1].toLowerCase();
						var style:String = token[2];
						if (type == "date") {
							if (arg instanceof Date) {
								result += dateFormat.format(arg, style, locale);
							}
						}
						else if (type == "number") {
							if (arg instanceof Number || typeof(arg) == "number") {
								// token[3].toLowerCase(), token[4].toLowerCase()
								result += numberFormat.format(arg, style, locale);
							}
						}
					}
				}
			}
		}
		return result;
	}

	private function getTokens(string):Array {
		var result:Array = new Array();
		var tokenStart:Number = 0;
		var escape:Boolean = false;
		for (var i:Number = 0; i < string.length; i++) {
			var c:String = string.charAt(i);
			if (c == "'") {
				if (string.charAt(i + 1) == "'") {
					result.push(string.substring(tokenStart, i + 1));
					tokenStart = i + 2;
					i++;
				}
				else {
					escape = !escape;
					result.push(string.substring(tokenStart, i));
					tokenStart = i + 1;
					if (i == string.length - 1) {
						result.push(string.substring(tokenStart));
					}
				}
			}
			else {
				if (!escape) {
					if (c == "{" ) {
						result.push(string.substring(tokenStart, i));
						tokenStart = i + 1;
					}
					else if (c == "}") {
						result.push(string.substring(tokenStart, i).split(","));
						tokenStart = i + 1;
					}
					else if (i == string.length - 1) {
						result.push(string.substring(tokenStart));
					}
				}
			}
		}
		return result;
	}

}