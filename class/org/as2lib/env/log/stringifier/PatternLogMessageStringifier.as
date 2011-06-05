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
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.lang.DateFormat;
import org.as2lib.util.Stringifier;
import org.as2lib.util.StringUtil;

/**
 * {@code PatternLogMessageStringifier} stringifies {@link LogMessage} instances
 * based on a string conversion pattern.
 *
 * <p>A conversion pattern is composed of literal text and format control expressions
 * called conversion specifiers.
 *
 * <p>You are free to insert any literal text within the conversion pattern.
 *
 * <p>Each conversion specifier starts with a percent sign {@code "%"} and is followed
 * by optional format modifiers and a conversion character. The conversion character
 * specifies the type of data, e.g. message, level, date, logger name. The format
 * modifiers control such things as field width, padding, left and right justification.
 * The following is a simple example.
 *
 * <p>Let the conversion pattern be {@code "%-5l [%n{1}]: %m"} and assume that the logger
 * is configured with this stringifier. Then the statements
 * <code>
 *   var logger:Logger = LogManager.getLogger("org.as2lib.MyTest");
 *   logger.info("A informative message.");
 *   logger.warning("A warning!");
 * </code>
 *
 * <p>would yield the output
 * <code>
 *   INFO  [MyTest]: A informative message.
 *   WARNI [MyTest]: A warning!
 * </code>
 *
 * <p>Note that there is no explicit separator between text and conversion specifiers.
 * The pattern parser knows when it has reached the end of a conversion specifier when
 * it reads a conversion character. In the example above the conversion specifier
 * {@code %-5l} means the level of the logging event should be left justified to a width
 * of five characters. The recognized conversion characters are
 *
 * <table>
 *   <tr>
 *     <td>Conversion Character</td>
 *     <td>Description</td>
 *   </tr>
 *   <tr>
 *     <td>m</td>
 *     <td>Outputs the message.</td>
 *   </tr>
 *   <tr>
 *     <td>n</td>
 *     <td>
 *       Outputs the name of the logger. This conversion specifier can be optionally
 *       followed by a precision specifier, that is a decimal constant in curly braces.</br>
 *       If a precision specifier is given, then only the corresponding number of right
 *       most components of the logger name will be printed. By default the logger name
 *       is output in fully qualified form. The components of the logger name are separated
 *       by periods. This is because the logger name is mostly the name of the logging class.</br>
 *       For example, for the logger name {@code "org.as2lib.MyTest"}, the pattern {@code "%n{1}"}
 *       will output {@code "MyTest"}.
 *     </td>
 *   </tr>
 *   <tr>
 *     <td>l</td>
 *     <td>Outputs the level of the log message.</td>
 *   </tr>
 *   <tr>
 *     <td>d</td>
 *     <td>
 *       Outputs the date of the log message. The date conversion specifier can be followed
 *       by a set of braces containing a date and time pattern string. For detailed information
 *       on how this string may look like take a look at the {@link DateFormat} class.</br>
 *       For example {@code "%d{HH:mm:ss,SSS}"} or {@code "%d{MEDIUM}"}.
 *     </td>
 *   </tr>
 *   <tr>
 *     <td>o</td>
 *     <td>
 *       Outputs the name of the method that logged the message to be stringified if
 *       it is contained as string in the given {@code LogMessage} instance.
 *     </td>
 *   </tr>
 *   <tr>
 *     <td>O</td>
 *     <td>
 *       Outputs the name of the method that logged the message to be stringified if
 *       it is contained as string in the given {@code LogMessage} instance or if the
 *       log message contains the information needed to look up the method name.
 *     </td>
 *   </tr>
 *   <tr>
 *     <td>c</td>
 *     <td>
 *       Outputs the name of the class that implements the method that logged the message
 *       to be stringified if the log message contains the source class name.
 *     </td>
 *   </tr>
 *   <tr>
 *     <td>C</td>
 *     <td>
 *       Outputs the name of the class that implements the method that logged the message
 *       to be stringified if the log message either contains a source class name or a
 *       source object. In the latter case the class name is looked-up via reflections.
 *     </td>
 *   </tr>
 *   <tr>
 *     <td>f</td>
 *     <td>
 *       Outputs the name of the file that contains the class whose methods logged the
 *       message, if it is contained in the log message.
 *     </td>
 *   </tr>
 *   <tr>
 *     <td>L</td>
 *     <td>
 *       Outputs the line number from where the logging request was issued, if it is
 *       contained in the log message.
 *     </td>
 *   </tr>
 * </table>
 *
 * <p>By default the relevant information is output as is. However, with the aid of format
 * modifiers it is possible to change the minimum field width, the maximum field width and
 * justification.
 *
 * <p>The optional format modifier is placed between the percent sign and the conversion
 * character.
 *
 * <p>The first optional format modifier is the left justification flag which is just the
 * minus (-) character. Then comes the optional minimum field width modifier. This is a
 * decimal constant that represents the minimum number of characters to output. If the data
 * item requires fewer characters, it is padded on either the left or the right until the
 * minimum width is reached. The default is to pad on the left (right justify) but you can
 * specify right padding with the left justification flag. The padding character is space.
 * If the data item is larger than the minimum field width, the field is expanded to accommodate
 * the data. The value is never truncated.
 *
 * <p>This behavior can be changed using the maximum field width modifier which is designated
 * by a period followed by a decimal constant. If the data item is longer than the maximum field,
 * then the extra characters are removed from the end of the data item.
 * For example, it the maximum field width is eight and the data item is ten characters long,
 * then the last two characters of the data item are dropped.
 *
 * <p>Below are various format modifier examples for the level conversion specifier.
 * <table>
 *   <tr>
 *     <td>Format Modifier</td>
 *     <td>Left Justify</td>
 *     <td>Minimum Width</td>
 *     <td>Maximum Width</td>
 *     <td>Skip Undefined</td>
 *     <td>Comment</td>
 *   </tr>
 *   <tr>
 *     <td>%20l</td>
 *     <td>false</td>
 *     <td>20</td>
 *     <td>none</td>
 *     <td>false</td>
 *     <td>Left pad with spaces if the level name is less than 20 characters long.</td>
 *   </tr>
 *   <tr>
 *     <td>%-20c</td>
 *     <td>true</td>
 *     <td>20</td>
 *     <td>none</td>
 *     <td>false</td>
 *     <td>Right pad with spaces if the category name is less than 20 characters long.</td>
 *   </tr>
 *   <tr>
 *     <td>%.30c</td>
 *     <td>NA</td>
 *     <td>none</td>
 *     <td>30</td>
 *     <td>false</td>
 *     <td>Truncate from the end if the level name is longer than 30 characters.</td>
 *   </tr>
 *   <tr>
 *     <td>%20.30c</td>
 *     <td>false</td>
 *     <td>20</td>
 *     <td>30</td>
 *     <td>false</td>
 *     <td>
 *       Left pad with spaces if the level name is shorter than 20 characters. However, if
 *       level name is longer than 30 characters, then truncate from the end.</td>
 *   </tr>
 *   <tr>
 *     <td>%-20.30c</td>
 *     <td>true</td>
 *     <td>20</td>
 *     <td>30</td>
 *     <td>false</td>
 *     <td>
 *       Right pad with spaces if the level name is shorter than 20 characters. However, if
 *       level name is longer than 30 characters, then truncate from the end.</td>
 *   </tr>
 *   <tr>
 *     <td>%-10*c</td>
 *     <td>true</td>
 *     <td>10</td>
 *     <td>none</td>
 *     <td>true</td>
 *     <td>
 *       Right pad with spaces if the category name is less than 10 characters long. If
 *       the category name is {@code null} or {@code undefined}, skip this conversion
 *       specifier and literal text that occurs directly before this conversion specifier
 *       and after the previous conversion specifier.
 *     </td>
 *   </tr>
 * </table>
 *
 * <p>The above text is largely inspired by James P. Cakalic and Ceki Gülcü from the apache
 * log4j project.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.stringifier.PatternLogMessageStringifier extends BasicClass implements Stringifier {

	/** The default pattern if none has been specified. */
	public static var DEFAULT_PATTERN:String = "%d{HH:nn:ss.SSS} %l %*n - %m";

	/** Default pattern to stringify log messages for MTASC with. */
	public static var MTASC_PATTERN:String = "%d{HH:nn:ss.SSS} %l %c.%o():%L - %m";

	/** The escape character coming before a converter character. */
	private static var ESCAPE_CHARACTER:String = "%";

	/** Indicates that stringifier is in literal state. */
	private static var LITERAL_STATE:Number = 0;

	/** Indicates that stringifier is in converter state. */
	private static var CONVERTER_STATE:Number = 1;

	/** Indicates that stringifier is in minus state. */
	private static var MINUS_STATE:Number = 2;

	/** Indicates that stringifier is in dot state. */
	private static var DOT_STATE:Number = 3;

	/** Indicates that stringifier is in minimum state. */
	private static var MINIMUM_STATE:Number = 4;

	/** Indicates that stringifier is in maximum state. */
	private static var MAXIMUM_STATE:Number = 5;

	/** The pattern to stringify log messages. */
	private var pattern:String;

	/** The pattern as converter function. */
	private var converter:Function;

	/**
	 * Constructs a new {@code PatternLogMessageStringifier} instance.
	 *
	 * <p>If {@code pattern} is {@code null} or {@code undefined}, the {@link #DEFAULT_PATTERN}
	 * will be used.
	 *
	 * @param pattern the pattern to stringify log messages
	 */
	public function PatternLogMessageStringifier(pattern:String) {
		if (pattern == null) pattern = DEFAULT_PATTERN;
		this.pattern = pattern;
		converter = parse(pattern);
	}

	/**
	 * Returns the pattern used to stringify log messages.
	 *
	 * @return the log message stringification pattern
	 */
	public function getPattern(Void):String {
		return pattern;
	}

	/**
	 * Returns the string representation of the passed-in {@link LogMessage} instance.
	 *
	 * <p>The resulting string is totally determined by the pattern given on
	 * instantiation.
	 *
	 * @param target the {@code LogMessage} instance to stringify
	 * @return the string representation of the passed-in {@code target}
	 */
	public function execute(target):String {
		return converter(target);
	}

	/**
	 * Parses the given {@code pattern}.
	 *
	 * @param pattern the pattern to parse
	 * @return the converter function representing the pattern
	 */
	private function parse(a:String):Function {
		var r:Function = function(m:LogMessage):String {
			return arguments.callee.n(m);
		};
		var p:Function = r;
		var min:Number;
		var max:Number;
		var left:Boolean = false;
		var skip:Boolean = false;
		var s:Number = LITERAL_STATE;
		var c:String;
		var i:Number = 0;
		var l:Number = a.length;
		var x:String = "";
		while (i < l) {
			c = a.charAt(i++);
			switch (s) {
				case LITERAL_STATE:
					if (c == ESCAPE_CHARACTER) {
						if (a.charAt(i) == ESCAPE_CHARACTER) {
							x += c;
							i++;
						} else {
							if (x != "") {
								p.n = createLiteralConverter(x);
								p = p.n;
								x = "";
							}
							s = CONVERTER_STATE;
							min = null;
							max = null;
							left = false;
							skip = false;
						}
					} else {
						x += c;
					}
					break;
				case CONVERTER_STATE:
					switch (c) {
						case "-":
							left = true;
							break;
						case ".":
							s = DOT_STATE;
							break;
						case "*":
							skip = true;
							break;
						default:
							if (!isNaN(Number(c))) {
								min = Number(c);
								s = MINIMUM_STATE;
							} else {
								var b:String;
								if (a.charAt(i) == "{") {
									var z:Number = a.indexOf("}", i);
									if (i < z) {
										b = a.substring(i + 1, z);
									}
									i = z + 1;
								}
								p.n = createConverter(c, left, min, max, skip, b);
								p = p.n;
								s = LITERAL_STATE;
							}
					}
					break;
				case MINIMUM_STATE:
					if (!isNaN(Number(c))) {
						min = min * 10 + Number(c);
					} else {
						i--;
						s = CONVERTER_STATE;
					}
					break;
				case DOT_STATE:
					if (!isNaN(Number(c))) {
						max = Number(c);
						s = MAXIMUM_STATE;
					} else {
						i--;
						s = CONVERTER_STATE;
					}
					break;
				case MAXIMUM_STATE:
					if (!isNaN(Number(c))) {
						max = max * 10 + Number(c);
					} else {
						i--;
						s = CONVERTER_STATE;
					}
					break;
			}
		}
		if (x != "") {
			p.n = createLiteralConverter(x);
			p = p.n;
		}
		p.n = function(m:LogMessage):String {
			return "";
		};
		return r;
	}

	/**
	 * Creates a literal converter function for the given literal.
	 *
	 * @param l the literal to create a converter function for
	 * @return the literal converter function
	 */
	private function createLiteralConverter(l:String):Function {
		return function(m:LogMessage):String {
			var x:String = arguments.callee.n(m);
			if (arguments.callee.s) {
				arguments.callee.s = false;
				return x;
			}
			return (l + x);
		};
		// Flex 1.5 compiler does not recognize the first return and raises an error.
		// We work around this by returning null at the end, also this will never be made.
		return null;
	}

	/**
	 * Creates a converter.
	 *
	 * @param t the type of the converter to create
	 * @param l a boolean that determines whether to align left {@code true} or right
	 * {@code false}
	 * @param i the minimum number of characters
	 * @param a the maximum number of characters
	 * @param s whether to skip {@code null} or {@code undefined} values
	 * @param d any additional data
	 * @return the converter function for the given data
	 */
	private function createConverter(t:String, l:Boolean, i:Number, a:Number, s:Boolean, d:String):Function {
		// Refactor code and add support for proper handling of undefined values that shall not be shown at beginning of pattern (Remove literal text after conversion specifier in that case?).
		// Applies align left/right, minimum and maximum rules to string.
		var z:Function = function(w:String, x:Boolean, y:Number, b:Number):String {
			if (w == null) w = "unknown";
			if (w.length < y && y != null) {
				if (x) {
					return (w + StringUtil.multiply(" ", y - w.length));
				}
				return (StringUtil.multiply(" ", y - w.length) + w);
			}
			if (w.length > b && b != null) {
				return w.substr(0, b);
			}
			return w;
		};
		// Returns the requested number of nodes from the given string.
		var y:Function = function(w:String, b:Number):String {
			if (w == null) return w;
			var x:Array = w.split(".");
			if (b >= x.length) return w;
			var r:String = "";
			var j:Number = x.length;
			for (var k:Number = j - b; k < j; k++) {
				r += x[k];
				if (k != j - 1) r += ".";
			}
			return r;
		};
		switch (t) {
			case "m":
				return function(m:LogMessage):String {
					var x:String = m.getMessage();
					if (x == null && s) {
						arguments.caller.s = true;
						return arguments.callee.n(m);
					}
					return z(x, l, i, a) + arguments.callee.n(m);
				};
				break;
			case "l":
				return function(m:LogMessage):String {
					var x:String = m.getLevel().toString();
					if (x == null && s) {
						arguments.caller.s = true;
						return arguments.callee.n(m);
					}
					return z(x, l, i, a) + arguments.callee.n(m);
				};
				break;
			case "n":
				return function(m:LogMessage):String {
					var x:String = m.getLoggerName();
					if (x == null && s) {
						arguments.caller.s = true;
						return arguments.callee.n(m);
					}
					return z(y(x, Number(d)), l, i, a) + arguments.callee.n(m);
				};
				break;
			case "d":
				return function(m:LogMessage):String {
					var x:String = (new DateFormat(d)).format(new Date(m.getTimeStamp()));
					if (x == null && s) {
						arguments.caller.s = true;
						return arguments.callee.n(m);
					}
					return z(x, l, i, a) + arguments.callee.n(m);
				};
				break;
			case "o":
				return function(m:LogMessage):String {
					var x:String = m.getSourceMethodName();
					if (x == null && s) {
						arguments.caller.s = true;
						return arguments.callee.n(m);
					}
					return z(x, l, i, a) + arguments.callee.n(m);
				};
				break;
			case "O":
				return function(m:LogMessage):String {
					var x:String = m.getSourceMethodName();
					if (x == null) {
						var o = m.getSourceObject();
						if (o == null) o = ReflectUtil.getTypeByName(m.getLoggerName());
						x = ReflectUtil.getMethodName(m.getSourceMethod(), o);
						if (x == null && s) {
							arguments.caller.s = true;
							return arguments.callee.n(m);
						}
					}
					return z(x, l, i, a) + arguments.callee.n(m);
				};
				break;
			case "c":
				return function(m:LogMessage):String {
					var x:String = m.getSourceClassName();
					if (x == null && s) {
						arguments.caller.s = true;
						return arguments.callee.n(m);
					}
					return z(y(x, Number(d)), l, i, a) + arguments.callee.n(m);
				};
				break;
			case "C":
				return function(m:LogMessage):String {
					var x:String = m.getSourceClassName();
					if (x == null) {
						x = ReflectUtil.getTypeName(m.getSourceObject());
						if (x == null && s) {
							arguments.caller.s = true;
							return arguments.callee.n(m);
						}
					}
					return z(y(x, Number(d)), l, i, a) + arguments.callee.n(m);
				};
				break;
			case "f":
				return function(m:LogMessage):String {
					var x:String = m.getFileName();
					if (x == null && s) {
						arguments.caller.s = true;
						return arguments.callee.n(m);
					}
					return z(x, l, i, a) + arguments.callee.n(m);
				};
				break;
			case "L":
				return function(m:LogMessage):String {
					var x:String = m.getLineNumber().toString();
					if (x == null && s) {
						arguments.caller.s = true;
						return arguments.callee.n(m);
					}
					return z(x, l, i, a) + arguments.callee.n(m);
				};
				break;
		}
		return null;
	}

}