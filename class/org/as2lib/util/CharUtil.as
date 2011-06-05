import org.as2lib.core.BasicClass;
import org.as2lib.util.CharSet;

/**
 * @author HeideggerMartin
 */
class org.as2lib.util.CharUtil extends BasicClass {
	
	/**
	 * Returns the first character of the passed-in {@code string}.
	 * 
	 * @param string the string to return the first character of
	 * @return the first character of the {@code string}
	 */
	public static function firstChar(string:String):String {
		return string.charAt(0);
	}
	
	/**
	 * Returns the last character of the passed-in {@code string}.
	 * 
	 * @param string the string to return the last character of
	 * @return the last character of the {@code string}
	 */
	public static function lastChar(string:String):String {
		return string.charAt(string.length-1);
	}
	
	/**
	 * Evaluates the first position of any of the passed-in possibles matches in a string.
	 * 
	 * <p>This method helps to find from a bunch of possibel occurances the next
	 * matching. Therefore it uses a character match list. This list contains
	 * at the character code of all accepted characters a true value like:
	 * <code>
	 *    import org.as2lib.util.CharSet;
	 *    
	 *    var chasrSet:CharSet = new CharSet();
	 *    charSet["A"] = true;
	 *    charSet["B"] = true;
	 *    charSet["C"] = true;
	 *    // Charset with allowed A, B and C.
	 * </code>
	 * 
	 * @param string string to be searched in
	 * @param matches set of accepted characters
	 * @return the first position of any match, if non matches it returns -1
	 */
	public static function getFirstMatch(string:String, matches:CharSet):Number {
		if (matches.isInverse()) {
			for (var i:Number=0; i<string.length; i++) {
				if (!matches[string.charAt(i)]) {
					return i;
				}
			}
		} else {
			for (var i:Number=0; i<string.length; i++) {
				if (matches[string.charAt(i)]) {
					return i;
				}
			}
		}
		return -1;
	}
	
	private function CharUtil(Void) {}	
}