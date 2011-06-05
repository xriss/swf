//
//

/*

manic miner

I have found various bits of text lying around (all in regular ASCII format):

    * 33816 to 33818: "AIR" (3 characters)
    * 33839 to 33870: "High Score 000000 Score 000000" (32 characters)
    * 33871 to 33874: "Game" (4 characters)
    * 33875 to 33878: "Over" (4 characters) 
	
	
33833 - 33838  == 6 digits of score?
*/

package {
	import flash.external.ExternalInterface;
 	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.geom.Rectangle;
	import flash.utils.Endian;
	import ZXScreenData;
	import ZXBorderData;
	import ZXKeyboard;
	import ZXSpectrum;
	import SM;
	import Z80;
 	
import flash.net.navigateToURL;
import flash.net.URLRequest;
import flash.net.LocalConnection;

 	public class ZXSignals
	{
		public var wetcon:String;
			
		public var spec:ZXSpectrum;
		
  		public function ZXSignals( _spec:ZXSpectrum)
		{
			spec=_spec;
		}
				
		public function print(s:String):void
		{
			ExternalInterface.call("console.log",s);
		}
	
		public var score:Number=0;
	
		
		public function update():void
		{
		var s:String;
		var newscore:Number;
		var con:LocalConnection;

			s=String.fromCharCode(		
				spec._ram[33839-0x4000] ,
				spec._ram[33840-0x4000] ,
				spec._ram[33841-0x4000] ,
				spec._ram[33842-0x4000] ,
				spec._ram[33843-0x4000] ,
				spec._ram[33844-0x4000] ,
				spec._ram[33845-0x4000] ,
				spec._ram[33846-0x4000] ,
				spec._ram[33847-0x4000] ,
				spec._ram[33848-0x4000] );
			if( s=="High Score") // then this is probably manic miner...
			{				
				s=String.fromCharCode(		
					spec._ram[33833-0x4000] ,
					spec._ram[33834-0x4000] ,
					spec._ram[33835-0x4000] ,
					spec._ram[33836-0x4000] ,
					spec._ram[33837-0x4000] ,
					spec._ram[33838-0x4000] );
				
				newscore=parseInt(s,10);
					
				if( newscore != score)
				{
					score=newscore;
//					print( "Score : "+score );
					
					if(wetcon)
					{
						con = new LocalConnection();
						con.send( "_"+wetcon , "score" , "update" , score );
					}

				}
			}
			
		}
	}
	
	
}