import org.as2lib.core.BasicClass;

/**
 * @author HeideggerMartin
 */
class org.as2lib.util.TrimUtil extends BasicClass {
	
	
	/**
	 * Removes all empty characters at the beginning and at the end of the passed-in 
	 * {@code string}.
	 *
	 * <p>Characters that are removed: spaces {@code " "}, line forwards {@code "\n"} 
	 * and extended line forwarding {@code "\t\n"}.
	 * 
	 * @param string the string to trim
	 * @return the trimmed string
	 */
	public static function trim(string:String):String {
		return leftTrim(rightTrim(string));
	}
	
	/**
	 * Removes all empty characters at the beginning of a string.
	 *
	 * <p>Characters that are removed: spaces {@code " "}, line forwards {@code "\n"} 
	 * and extended line forwarding {@code "\t\n"}.
	 * 
	 * @param string the string to trim
	 * @return the trimmed string
	 */
	public static function leftTrim(string:String):String {
		return leftTrimForChars(string, "\n\t\n ");
	}

	/**
	 * Removes all empty characters at the end of a string.
	 * 
	 * <p>Characters that are removed: spaces {@code " "}, line forwards {@code "\n"} 
	 * and extended line forwarding {@code "\t\n"}.
	 * 
	 * @param string the string to trim
	 * @return the trimmed string
	 */	
	public static function rightTrim(string:String):String {
		return rightTrimForChars(string, "\n\t\n ");
	}
	
	/**
	 * Removes all characters at the beginning of the {@code string} that match to the
	 * set of {@code chars}.
	 * 
	 * <p>This method splits all {@code chars} and removes occurencies at the beginning.
	 * 
	 * <p>Example:
	 * <code>
	 *   trace(StringUtil.rightTrimForChars("ymoynkeym", "ym")); // oynkeym
	 *   trace(StringUtil.rightTrimForChars("monkey", "mo")); // nkey
	 *   trace(StringUtil.rightTrimForChars("monkey", "om")); // nkey
	 * </code>
	 * 
	 * @param string the string to trim
	 * @param chars the characters to remove from the beginning of the {@code string}
	 * @return the trimmed string
	 */
	public static function leftTrimForChars(string:String, chars:String):String {
		var from:Number = 0;
		var to:Number = string.length;
		while (from < to && chars.indexOf(string.charAt(from)) >= 0){
			from++;
		}
		return (from > 0 ? string.substr(from, to) : string);
	}
	
	/**
	 * Removes all characters at the end of the {@code string} that match to the set of
	 * {@code chars}.
	 * 
	 * <p>This method splits all {@code chars} and removes occurencies at the end.
	 * 
	 * <p>Example:
	 * <code>
	 *   trace(StringUtil.rightTrimForChars("ymoynkeym", "ym")); // ymoynke
	 *   trace(StringUtil.rightTrimForChars("monkey***", "*y")); // monke
	 *   trace(StringUtil.rightTrimForChars("monke*y**", "*y")); // monke
	 * </code>
	 * 
	 * @param string the string to trim
	 * @param chars the characters to remove from the end of the {@code string}
	 * @return the trimmed string
	 */
	public static function rightTrimForChars(string:String, chars:String):String {
		var from:Number = 0;
		var to:Number = string.length - 1;
		while (from < to && chars.indexOf(string.charAt(to)) >= 0) {
			to--;
		}
		return (to >= 0 ? string.substr(from, to+1) : string);
	}
	
	/**
	 * Removes all characters at the beginning of the {@code string} that matches the
	 * {@code char}.
	 * 
	 * <p>Example:
	 * <code>
	 *   trace(StringUtil.leftTrimForChar("yyyymonkeyyyy", "y"); // monkeyyyy
	 * </code>
	 * 
	 * @param string the string to trim
	 * @param char the character to remove, uses the first character if it
	 * 		  contains more than one
	 * @return the trimmed string
	 */
	public static function leftTrimForChar(string:String, char:String):String {
		return leftTrimForChars(string, char.charAt(0));
	}
	
	/**
	 * Removes all characters at the end of the {@code string} that matches the passed-in
	 * {@code char}.
	 * 
	 * <p>Example:
	 * <code>
	 *   trace(StringUtil.rightTrimForChar("yyyymonkeyyyy", "y"); // yyyymonke
	 * </code>
	 * 
	 * @param string the string to trim
	 * @param char the character to remove, uses the first character if it
	 * 		  contains more than one
	 * @return the trimmed string
	 */
	public static function rightTrimForChar(string:String, char:String):String {
		return rightTrimForChars(string, char.charAt(0));
	}
	
	private function TrimUtil(Void) {
	}
}