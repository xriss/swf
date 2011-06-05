import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.data.math.Vector;

class org.as2lib.data.math.vector.AbstractVector extends BasicClass implements Vector {
	
	private var v:TypedArray;
	
	public function AbstractVector(Void) {
		v = new TypedArray(Number);
	}
		
	public function setValue(index:Number, value:Number) {
		v[index] = value;
	}
	
	public function clear(Void):Void {
		v = new TypedArray(Number);
	}
	
	public function getValue(index:Number) {
		return v[index];
	}
	
	public function size(Void):Number {
		return v.length;
	}
	
	public function toArray(Void):Array {
		return v.slice();
	}
	
}