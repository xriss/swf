import org.as2lib.data.math.vector.LimitedVector;

class org.as2lib.data.math.vector.Vector3D extends LimitedVector {
	
	public function Vector3D(x:Number, y:Number, z:Number) {
		super(3);
		if(x) setX(x);
		if(y) setY(y);
		if(z) setZ(z);

	}
	
	public function setX(x:Number):Void {
		setValue(0,x);
	}
	
	public function setY(y:Number):Void {
		setValue(1,y);
	}
	
	public function setZ(z:Number):Void {
		setValue(2,z);
	}
	
	public function getX(Void):Number {
		return getValue(0);
	}
	
	public function getY(Void):Number {
		return getValue(1);
	}
	
	public function getZ(Void):Number {
		return getValue(2);
	}
	
	public function toString():String {
		var result:String ="";
		
		result += "x = "+getX()+"\n";
		result += "y = "+getY()+"\n";
		result += "z = "+getZ()+"\n";
		
		return result;
	}
	
}