/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class RomZomSkip
{
	var up;
	var mc;
	
	var mcs;
	
	var frame;
	var framerate;
	
	function RomZomSkip(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup()
	{
	var i;
	
		mc=gfx.create_clip(up.mc,null);
		
		mcs=new Array()
		
		frame=0;
		framerate=150;
		
		for(i=0;i<11;i++)
		{
			mcs[i]=gfx.add_clip(mc,"swf_play",null);
			mcs[i].gotoAndStop(i+1);
			mcs[i].cacheAsBitmap=true;
		}
		
		drawframe()
		
		up.play_background_loop("sfx_romzom");
				
		Key.addListener(this);
		Mouse.addListener(this);
	}
	
	function clean()
	{
		Key.removeListener(this);
		Mouse.removeListener(this);
		
		mc.removeMovieClip();
	}


	function drawframe()
	{
	var f;
	var i;
	
		f=Math.floor(frame/framerate);
		
		for (i=0;i<9;i++)
		{
			if(i==f)
			{
				mcs[i+1]._visible=true;
			}
			else
			{
				mcs[i+1]._visible=false;
			}
		}
		
	}
	
	function skip()
	{
		frame=(Math.floor(frame/framerate)+1)*framerate;
	}

	function onKeyDown()
	{
		skip();
	}
	
	function onMouseDown()
	{
		skip();
	}


	function update()
	{
	
		frame++;
		drawframe();
		
		
		if( Math.floor(frame/framerate) >=9 )
		{
			up.state_next="play";
		}
	}
	
}