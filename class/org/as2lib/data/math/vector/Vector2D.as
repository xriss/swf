import org.as2lib.data.math.vector.LimitedVector;

class org.as2lib.data.math.vector.Vector2D extends LimitedVector {
	
	public function Vector2D(x:Number, y:Number) {
		super(2);
		if(x) setX(x);
		if(y) setY(y);

	}
	
	public function setX(x:Number):Void {
		setValue(0,x);
	}
	
	public function setY(y:Number):Void {
		setValue(1,y);
	}
	
	public function getX(Void):Number {
		return getValue(0);
	}
	
	public function getY(Void):Number {
		return getValue(1);
	}
	
	public function toString():String {
		var result:String ="";
		
		result += "x = "+getX()+"\n";
		result += "y = "+getY()+"\n";
		
		return result;
	}
	
}