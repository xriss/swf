/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class #(VERSION_NAME)
{
	var mc;
	
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	static function main()
	{
		_root.#(VERSION_NAME)=new #(VERSION_NAME)();		
	}
	
	
	
	function #(VERSION_NAME)()
	{
	
	
		{
		var cm;
		var cmi;
		var f;
		
			cm = new ContextMenu();
			cm.hideBuiltInItems();
			
			f=function()
			{
				if( Stage["displayState"] == "normal" )
				{
					Stage["fullScreenSourceRect"] = new flash.geom.Rectangle( 10,10 , 400,300 );
					Stage["displayState"] = "fullScreen";
				}
				else
				{
					Stage["displayState"] = "normal";
				}
			};
			cmi = new ContextMenuItem("test full screen", delegate(f); );
			cm.customItems.push(cmi);
			
			
			_root.menu=cm;
		}
		
		
		mc=_root;
		
		var x,y,w,h;
		
		x=50;
		y=50;
		w=200;
		h=200;
		
		mc.lineStyle(undefined,undefined);
		mc.moveTo(x,y);
		mc.beginFill(0xffffff,100);
		mc.lineTo(x+w,y);
		mc.lineTo(x+w,y+h);
		mc.lineTo(x,y+h);
		mc.lineTo(x,y);
		mc.endFill();
		
		
	}

	
}
