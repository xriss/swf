package flash;

extern class Stage
{
	static var width:Float;
	static var height:Float;
	static var scaleMode:String;
	static var align:String;
	static var showMenu:Bool;
	static function addListener(listener:Dynamic):Void;
	static function removeListener(listener:Dynamic):Void;

#if flash_v9
	static var displayState : String;
	static function onFullScreen( full : Bool ) : Void;
#end

	private static function __init__() : Void untyped {
		flash.Stage = _global["Stage"];
	}

}
