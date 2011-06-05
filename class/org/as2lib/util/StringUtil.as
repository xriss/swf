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

/**
 * {@code StringUtil} offers a lot of different methods to work with strings.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 * @author Christophe Herreman
 * @author Flashforum.de Community
 */
class org.as2lib.util.StringUtil extends BasicClass {

	/** Default map for escaping keys. */	
	public static var DEFAULT_ESCAPE_MAP:Array = 
		["\\t", "\t", "\\n", "\n", "\\r", "\r", "\\\"", "\"", "\\\\", "\\", "\\'", "\'", "\\f", "\f", "\\b", "\b", "\\", ""];
	
	/**
	 * Replaces all occurencies of the passed-in string {@code what} with the passed-in
	 * string {@code to} in the passed-in string {@code string}.
	 * 
	 * @param string the string to replace the content of
	 * @param what the string to search and replace in the passed-in {@code string}
	 * @param to the string to insert instead of the passed-in string {@code what}
	 * @return the result in which all occurences of the {@code what} string are replaced
	 * by the {@code to} string
	 */
	public static function replace(string:String, what:String, to:String):String {
		return string.split(what).join(to);
	}

	/**
	 * Validates the passed-in {@code email} adress to a predefined email pattern.
	 * 
	 * @param email the email to check whether it is well-formatted
	 * @return {@code true} if the email matches the email pattern else {@code false}
	 */
	public static function checkEmail(email:String):Boolean {
		// The min Size of an Email is 6 Chars "a@b.cc";
		if (email.length < 6) {
			return false;
		}
		// There must be exact one @ in the Content
		if (email.split('@').length > 2 || email.indexOf('@') < 0) {
			return false;
		}
		// There must be min one . in the Content before the last @
		if (email.lastIndexOf('@') > email.lastIndexOf('.')) {
			return false;
		}
		// There must be min two Characters after the last .
		if (email.lastIndexOf('.') > email.length - 3) {
			return false;
		}
		// There must be min two Characters between the @ and the last .
		if (email.lastIndexOf('.') <= email.lastIndexOf('@') + 1) {
			return false;
		}
		return true;
	}
	
	/**
	 * Assures that the passed-in {@code string} is bigger or equal to the passed-in
	 * {@code length}.
	 * 
	 * @param string the string to validate
	 * @param length the length the {@code string} should have
	 * @return {@code true} if the length of {@code string} is bigger or equal to the
	 * 		   expected length else {@code false}, if no length was applied, it 
	 * 		   will always return {@code false}
	 */
	public static function assureLength(string:String, length:Number):Boolean {
		if (length < 0 || (!length && length !== 0)) {
			return false;
		}
		return (string.length >= length);
	}
	
	/**
	 * Evaluates if the passed-in {@code chars} are contained in the passed-in
	 * {@code string}.
	 *
	 * <p>This methods splits the {@code chars} and checks if any character is contained
	 * in the {@code string}.
	 * 
	 * <p>Example:
	 * <code>
	 *   trace(StringUtil.contains("monkey", "kzj0")); // true
	 *   trace(StringUtil.contains("monkey", "yek")); // true
	 *   trace(StringUtil.contains("monkey", "a")); // false
	 * </code>
	 * 
	 * @param string the string to check whether it contains any of the characters
	 * @param chars the characters to look whether any of them is contained in the
	 * {@code string}
	 * @return {@code true} if one of the {@code chars} is contained in the {@code string}
	 */
	public static function contains(string:String, chars:String):Boolean {
		if(chars == null || string == null) {
			return false;
		}
		for (var i:Number = chars.length-1; i >= 0 ; i--) {
			if (string.indexOf(chars.charAt(i)) >= 0) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Evaluates if the passed-in {@code stirng} starts with the {@code searchString}.
	 * 
	 * @param string the string to check
	 * @param searchString the search string that may be at the beginning of {@code string}
	 * @return {@code true} if {@code string} starts with {@code searchString} else
	 * {@code false}.
	 */
	public static function startsWith(string:String, searchString:String):Boolean {
		if (string.indexOf(searchString) == 0) {
			return true;
		}
		return false;
	}
	
	/**
	 * Tests whether the {@code string} ends with {@code searchString}.
	 *
	 * @param string the string to check
	 * @param searchString the string that may be at the end of {@code string}
	 * @return {@code true} if {@code string} ends with {@code searchString}
	 */
	public static function endsWith(string:String, searchString:String):Boolean {
		if (string.lastIndexOf(searchString) == (string.length - searchString.length)) {
			return true;
		}
		return false;
	}
	
	/**
	 * Adds a space indent to the passed-in {@code string}.
	 *
	 * <p>This method is useful for different kind of ASCII output writing. It generates
	 * a dynamic size of space indents in front of every line inside a string.
	 * 
	 * <p>Example:
	 * <code>
	 *   var bigText = "My name is pretty important\n"
	 *                 + "because i am a interesting\n"
	 *                 + "small example for this\n"
	 *                 + "documentation.";
	 *   var result = StringUtil.addSpaceIndent(bigText, 3);
	 * </code>
	 * 
	 * <p>Contents of {@code result}:
	 * <pre>
	 *   My name is pretty important
	 *      because i am a interesting
	 *      small example for this
	 *      documentation.
	 * </pre>
	 *
	 * <p>{@code indent} will be floored.
	 * 
	 * @param string the string that contains lines to indent
	 * @param indent the size of the indent, will be set to 0 if its small than 0
	 * @return the indented string
	 */
	public static function addSpaceIndent(string:String, size:Number):String {
		if (string == null) {
			string = "";
		}
		if (size < 0) {
			size = 0;
		}
		var indentString:String = multiply(" ", size);
		return indentString+replace(string, "\n", "\n"+indentString);
	}
	
	/**
	 * Multiplies the passed-in {@code string} by the passed-in {@code factor} to create
	 * long string blocks.
	 * 
	 * <p>Example:
	 * <code>
	 *   trace("Result: "+StringUtil.multiply(">", 6); // Result: >>>>>>
	 * </code>
	 *
	 * @param string the source string to multiply
	 * @param factor the number of times to multiply the {@code string}
	 * @result the multiplied string
	 */
	public static function multiply(string:String, factor:Number):String {
		var result:String="";
		for (var i:Number = factor; i > 0; i--) {
			result += string;
		}
		return result;
	}
	
	/**
	 * Replaces keys defined in a keymap.
	 * 
	 * <p>This method helps if you need to escape characters in a string. But it
	 * can be basically used for any kind of keys to be replaced.
	 * 
	 * <p>To be expected as keymap is a map like:
	 * <code>
	 *   ["keyToReplace1", "replacedTo1", "keyToReplace2", "replacedTo2", ... ]
	 * </code> 
	 * 
	 * @param string String that contains content to be removed.
	 * @param keyMap Map that contains all keys. (DEFAULT_ESCAPE_MAP will be used
	 * 		  if no keyMap gets passed.
	 * @param ignoreUnicode Pass "true" to ignore automatic parsing of unicode escaped characters.
	 * @return Escaped string.
	 */
	public static function escape(string:String, keyMap:Array, ignoreUnicode:Boolean):String {
		if (string == null) {
			return string;
		}
		if (!keyMap) {
			keyMap = DEFAULT_ESCAPE_MAP;
		}
		var i:Number = 0;
		var l:Number = keyMap.length;
		while (i<l) {
			string = string.split(keyMap[i]).join(keyMap[i+1]);
			i+=2;
		}
		if (!ignoreUnicode) {
			i = 0;
			l = string.length;
			while (i<l) {
				if (string.substring(i, i+2) == "\\u") {
					string = 
						string.substring(0,i) + 
						String.fromCharCode(
							parseInt(string.substring(i+2, i+6), 16)
						) +
						string.substring(i+6);
				}
				i++;
			}
		}
		return string;
	}
	
	/**
	 * Private Constructor.
	 */
	private function StringUtil(Void) {
	}
	
}