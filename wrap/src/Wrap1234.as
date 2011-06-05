/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// WTF scroller

#DBG="dbg1234"

class Wrap1234
{
	static function main()
	{
		_global.wrap1234=new Wrap1234();
	}
	
	function Wrap1234()
	{
		System.security.allowDomain("*");

//		getURL("http://games.mochiads.com/c/g/batwsball/BatWsBall.swf","_level10");
		
		getURL("http://games.mochiads.com/c/g/roll/roll.swf","_level10");
		

/*
		_root.createEmptyMovieClip("wrap1234",1234);
		_root.wrap1234._lockroot=true;
		_root.wrap1234.loadMovie("http://games.mochiads.com/c/g/batwsball/BatWsBall.swf");
*/

// call once a sec to check we are still intercepting everything OK		
		setInterval(this,"update",10000);
		update();
	}
	
	var _sendChannel;
	var _sendChannelName;
	
	
	function scanmc(m,d)
	{
	var r=null;
	
	var idx;
	var t;
	
		for(idx in m)
		{
		
			if(idx=="__mochiservices")
			{
				return(m);
			}
		
			t=typeof(m[idx]);
			if((d<10)&&((t=="object")||(t=="movieclip")))
			{
				r=scanmc(m[idx],d+1);
				if(r)
				{
					return r;
				}
			}
		}
		
		return r;
	}
	
	var mochiservMC;
	
	function update(num)
	{
	
		if(!mochiservMC)
		{
			mochiservMC=scanmc(_level10,0);
		}
			
		if(mochiservMC)
		{
			if(mochiservMC.__mochiservices._gameRcvChannel.onReceive)
			{
				if( mochiservMC.__mochiservices._gameRcvChannel.onReceive != mochi_send_new)
				{
					mochiservMC.__mochiservices._gameRcvChannel.onReceive2=mochiservMC.__mochiservices._gameRcvChannel.onReceive;
					mochiservMC.__mochiservices._gameRcvChannel.onReceive=mochi_send_new;
				}
			}
		}
		
		#(DBG).print("********************"+mochiservMC);		
		#(DBG).dump(mochiservMC);
		
//		#(DBG).print("update:"+_level10._global.dbg);
	}
	
	function mochi_send_new(args)
	{
		#(DBG).dump(args);
		#(DBG).dump(args.args);
		
		_global.wrap1234.mochiservMC.__mochiservices._gameRcvChannel.onReceive2( args );
	}
}


