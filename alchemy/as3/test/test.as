

package {
 	import flash.display.Sprite;
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ErrorEvent; 
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	
	import cmodule.test.CLibInit;
 	
 	public class test extends Sprite
	{
		public var libInitializer:CLibInit;
		public var lib:Object;


		public var bmd:BitmapData;
		public var bm:Bitmap;
		public var frame:int;

		public var ram:ByteArray;
		
  		public function test()
		{
			
			libInitializer = new CLibInit();
			lib = libInitializer.init();
			
			
			var ns:Namespace = new Namespace("cmodule.test");
			ram = (ns::gstate).ds;

			
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			frame=0;

			bmd= new BitmapData(200,200, true, 0xFFCCCCCC);
			bm = new Bitmap(bmd,"auto",false);
			addChild( bm );
		}
		
		
		public function onEnterFrame(event:Event):void
		{
			frame=frame+1;
//			bmd.fillRect( new Rectangle(0+(frame%64),0+(frame%64),100,100) ,0xFF0000FF+frame);
			
			ram.position=lib.render(200,200,60+frame*2,0+frame*1,-20+frame*3);
			bmd.setPixels( new Rectangle(0,0,200,200) , ram );
			
		}
	}
}