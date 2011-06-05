import org.as2lib.util.Token;

/**
 * @author MartinHeidegger
 */
class org.as2lib.util.StringToken extends Token {
	public function StringToken(originalText:String, factories:Array) {
		super(originalText, factories);
	}
	
	public function getText(Void):String {
		return originalText;
	}
}