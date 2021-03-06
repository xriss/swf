package flash.display;

extern class AVM1Movie extends flash.display.DisplayObject {
	function new() : Void;
	function addCallback(functionName : String, closure : Dynamic) : Void;
	function call(functionName : String, ?p1 : Dynamic, ?p2 : Dynamic, ?p3 : Dynamic, ?p4 : Dynamic, ?p5 : Dynamic ) : Void;
	private function _callAS2(functionName : String, arguments : flash.utils.ByteArray) : flash.utils.ByteArray;
	private function _callAS3(functionName : String, data : flash.utils.ByteArray) : Void;
	private var _interopAvailable(default,null) : Bool;
	private function _setCallAS3(closure : Dynamic) : Void;
	private var callbackTable : Dynamic;
}
