import org.as2lib.core.BasicInterface;

interface org.as2lib.data.math.Vector extends BasicInterface {
	
	public function setValue(index:Number, value:Number);
	
	public function clear(Void):Void;
	
	public function getValue(index:Number);
	
	public function size(Void):Number;
	
	public function toArray(Void):Array;
}