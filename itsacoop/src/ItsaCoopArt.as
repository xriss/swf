/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!


class #(VERSION_NAME)Art
{

	var up; // RomZom

	var mc;
	
	var menu;
	var play;

	var gd;
	
	var score=0;
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	

	function #(VERSION_NAME)Art(_up)
	{
		up=_up;		

	}
			

	function setup()
	{	
	var i;
	var j;
	
		score=0;
			
		mc=gfx.create_clip(up.mc,null);
		
		play=new ItsaPlay(this);
		
		play.setup();
	}
	
	function clean()
	{
		play.clean();
		play=null;
		
		mc.removeMovieClip(); mc=null;	
	}
	
	

	function update()
	{
	var i;
	
		if(_root.popup) return;
		
		play.update();
		
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
