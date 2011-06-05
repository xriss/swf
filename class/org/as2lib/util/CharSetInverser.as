import org.as2lib.util.CharSet;

/**
 * 
 * @author Martin Heidegger
 */
dynamic class org.as2lib.util.CharSetInverser extends CharSet {
	
	private var wrappedCharSet:CharSet;
	
	public function CharSetInverter(charSet:CharSet) {
		wrappedCharSet = charSet;
	}
	
	public function __resolve(name:String) {
		return (wrappedCharSet[name]);
	}
	
	public function isInverse(Void):Boolean {
		return (!super.isInverse());
	}
}