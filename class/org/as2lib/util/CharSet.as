import org.as2lib.core.BasicClass;
import org.as2lib.util.CharSetInverser;

/**
 * @author Martin Heidegger
 */
dynamic class org.as2lib.util.CharSet extends BasicClass {
	private var isInversed:Boolean;
	private var inversed:CharSet;
	
	
	public function CharSet(inverse:Boolean) {
		isInversed = (inverse) ? true : false;
	}
	public function isInverse(Void):Boolean {
		return isInversed;
	}
	public function inverse(Void):CharSet {
		if (!inversed) {
			inversed = new CharSetInverser();
		}
		return inversed;
	}
}