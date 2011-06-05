import org.as2lib.core.BasicClass;
import org.as2lib.util.StringToken;
import org.as2lib.util.TokenFactory;

/**
 * @author Martin Heidegger
 */
class org.as2lib.util.Token extends BasicClass {
	
	public var next:Token;
	public var first:Token;
	public var prev:Token;
	public var parent:Token;
	
	private var originalText:String;
	private var factories:Array;
	private var lastToken:Token;
		
	public function Token(originalText:String, factories:Array) {
		this.originalText = originalText;
		this.factories = factories;
	}
	
	public function getFirst(Void):Token {
		var curr:Token = this;
		while (curr.prev != null) {
			curr = curr.prev;
		}
		return curr;
	}
	
	public function getLast(Void):Token {
		var curr:Token = this;
		while (curr.next != null) {
			curr = curr.next;
		}
		return curr;
	}
	
	public function getOriginalText(Void):String {
		return originalText;
	}
	
	public function getText(attributes:Array):String {
		if (!first) {
			evaluateTokens();			
		}
		var result:String = "";
		var curr:Token = first;
		while (curr) {
			result += curr.getText(attributes);
			curr = curr.next;
		}
		return result;
	}
	
	private function addToken(token:Token):Void {
		if (!first) {
			first = token;
		} else {
			lastToken.next = token;
			token.prev = lastToken;
		}
		token.parent = this;
		lastToken = token;
	}
	
	private function evaluateTokens(Void):Void {
		var start:Number = 0;
		var end:Number = 0;
		var length:Number = originalText.length;
		while (end < length) {
			var char:String = originalText.charAt(end);
			for (var name:String in factories) {
				if (name.charAt(0) == char) {
					if (originalText.substr(end,name.length) == name) {
						var factory:TokenFactory = factories[name];
						if ( start != end) {
							addToken(new StringToken(originalText.substring(start,end)));
						}
						var nextToken:Token = factory.tokenize(originalText.substr(end),factories);
						addToken(nextToken);
						start = end = end+nextToken.getOriginalText().length;
						continue;
					}
				}
			}
			end++;
		}
		if (start != end) {
			addToken(new StringToken(originalText.substr(start), factories));
		}
	}
}