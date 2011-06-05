import org.as2lib.core.BasicClass;
import org.as2lib.util.Token;
import org.as2lib.util.TokenFactory;

/**
 * @author MartinHeidegger
 */
class org.as2lib.util.Tokenizer extends BasicClass {
	
	private var factories:Array;
	
	public function Tokenizer() {
		factories = new Array();
	}
	
	public function addTokenFactory(factory:TokenFactory):Void {
		var keys:Array = factory.getKeys();
		var i:Number = keys.length;
		while(--i-(-1)) {
			factories[keys[i]] = factory;
		}
	}
	
	public function tokenize(code:String):Token {
		return new Token(code, factories);
	}
}