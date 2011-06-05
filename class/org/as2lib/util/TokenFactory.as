import org.as2lib.core.BasicInterface;
import org.as2lib.util.Token;

/**
 * @author MartinHeidegger
 */
interface org.as2lib.util.TokenFactory extends BasicInterface {
	public function tokenize(code:String, factories:Array):Token;
	public function getKeys(Void):Array;
}