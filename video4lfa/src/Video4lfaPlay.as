/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!


class #(VERSION_NAME)Play
{

	var up; // main class

	var mc;
	var vid;
	var over;
	

	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function #(VERSION_NAME)Play(_up)
	{
		up=_up;
	}
			

	function setup()
	{	
	var i;
	var j;
			
		mc=gfx.create_clip(up.mc,null);
		mc.vid=gfx.create_clip(mc,null); // scale to make youtube logo a little smaller...
		mc.vid._xscale=100*800/320;
		mc.vid._yscale=100*800/320;
		vid=gfx.add_clip(mc.vid,"v002",null);
		vid.gotoAndPlay(290);
		over=gfx.create_clip(mc,null);
		
	}
	
	function clean()
	{
		
		mc.removeMovieClip(); mc=null;
	}
	
	function update()
	{
	var i;
			
		if(_root.popup) return;
	
		_root.signals.signal("#(VERSION_NAME)","update",this);
				
	}

	function do_str(str)
	{
		switch(str)
		{
			default:
				up.do_str(str)
			break;
		}
	}
	
}
