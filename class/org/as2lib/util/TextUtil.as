import org.as2lib.core.BasicClass;
import org.as2lib.util.StringUtil;
import org.as2lib.util.CharSet;
import org.as2lib.util.CharUtil;

/**
 * @author Martin Heidegger
 */
class org.as2lib.util.TextUtil extends BasicClass {
	
	private static var defaultCharSet:CharSet;
	 
	public static function getWordStartPosition(text:String, position:Number,
			charSet:CharSet):Number {
		var pos:Number = position;
		
		if (!charSet) {
			charSet = getDefaultCharSet();
		}
		while (!charSet[text.charCodeAt(pos)] ) {
			pos--;
			if (pos < 0) {
				return null;
			}
		}
		return pos;
	}

	/**
	 * Capitalizes the first character of the passed-in {@code string}.
	 * 
	 * @param string the string of which the first character shall be capitalized
	 * @return the passed-in {@code string} with the first character capitalized
	 */
	public static function ucFirst(string:String):String {
		 return string.charAt(0).toUpperCase() + string.substr(1);
	}
	
	/**
	 * Converts the first character of the given {@code string} to a lower case
	 * character.
	 * 
	 * @param string the string to convert
	 * @return the given {@code string} with a lower case first character
	 */
	public static function lcFirst(string:String):String {
		return string.charAt(0).toLowerCase() + string.substr(1);
	}
	
	/**
	 * Capitalizes the first character of every word in the passed-in {@code string}.
	 * 
	 * @param string the string of which the first character of every word shall be
	 * capitalized
	 * @return the {@code string} with the first character of every word capitalized
	 */
	public static function ucWords(string:String):String {
		var w:Array = string.split(" ");
		var l:Number = w.length;
		for (var i:Number = 0; i < l; i++){
			w[i] = ucFirst(w[i]);
		}
		return w.join(" ");
	}
	
	public static function getDefaultCharSet(Void):CharSet {
		if (!defaultCharSet) {
			defaultCharSet = new CharSet(true);
			var i:Number = 0;
			while (i<65) {
				defaultCharSet[i] = true;
				i++;
			}
			i = 91;
			while (i<97) {
				defaultCharSet[i] = true;
				i++;
			}
			i = 121;
			while (i<126) {
				defaultCharSet[i] = true;
				i++;
			}
		}
		return defaultCharSet;
	}
	
	public static function getWordAtPosition(text:String, position:Number,
			charSet:CharSet):String {
		if (!charSet) {
			charSet = getDefaultCharSet();
		}
		var start:Number = getWordStartPosition(text, position, charSet);
		if (start == null) {
			return null;
		}
		if (start == -1) {
			start = 0;
		}
		text = text.substring(start);
		return text.substring(0, CharUtil.getFirstMatch(text, charSet.inverse()));
	}
	
	private function TextUtil(Void) {
	}
}