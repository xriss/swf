/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class ccPlay
{

	var up; // Main

	var mc;
	
	var replay;
	
	var road;
	
				
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function ccPlay(_up)
	{
		
		up=_up;
		
		
	}
			

	function setup()
	{	
	
		mc=gfx.create_clip(up.mc);

		replay=new Replay(this);
		
		road=new ccRoad(this);
		road.setup();
		
		mc.car=gfx.add_clip(mc,"car1");
		
		mc.car._x=400;
		mc.car._y=400;
		
		Key.addListener(this);
	}
	
	
	function clean()
	{		
		Key.removeListener(this);
		
		replay.clean();
		road.clean();
		
		mc.removeMovieClip(); mc=null;
	}
	
	function update()
	{
	var i;
	
		replay.update();
		
		if( replay.key & Replay.KEYM_UP )
		{
			road.mc.vy+=0.5;
		}
		if( replay.key & Replay.KEYM_DOWN )
		{
			road.mc.vy-=0.5;
			if( road.mc.vy < 0 ) { road.mc.vy=0; }
		}
	
		if( replay.key & Replay.KEYM_LEFT )
		{
			mc.car._x-=2;
		}
		if( replay.key & Replay.KEYM_RIGHT )
		{
			mc.car._x+=2;
		}

		road.update();
	}
	
	
	function onKeyDown()
	{	
		replay.apply_keys_to_prekey();
	}
	
	function onKeyUp()
	{
		replay.apply_keys_to_prekey();
	}
	
}
