import org.as2lib.util.Token;

/**
 * @author MartinHeidegger
 */
class org.as2lib.lang.parser.date.DateToken extends Token {
	
	public function DateToken(originalText:String, factories:Array) {
		super(originalText, factories);
	}
	
	private function getDate(attributes:Array):Date {
		return attributes["date"];
	}
}