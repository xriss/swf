/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;

import SwingDude;


// A collection of stacks of cards making up the game


class SwingPlay
{
	var mc:MovieClip;

	var up;
	
	var dude;
	var hook;
	var back;
	var line;
	
	
	function SwingPlay(_up)
	{
		up=_up;
		
		setup();
		clean();
	}
	


	function setup()
	{
		mc=gfx.create_clip(up.mc,null);
		
		back=new SwingBack(this);
		
		line=new SwingLine(this);
		hook=new SwingHook(this);
		dude=new SwingDude(this);


//		mc.style= {			fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};
//		gfx.draw_box(mc,10,100,100,100,100);

	}
	
	function clean()
	{
		mc.removeMovieClip(); mc=null;
	}

	function update()
	{
		up.replay.update();

		back.update();
		dude.update();
		hook.update();
		line.update();
	}
	
	
}
