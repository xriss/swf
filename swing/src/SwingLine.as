/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;

// A collection of stacks of cards making up the game


class SwingLine
{
	var mc:MovieClip;

	var up;
	var bmp;
	
	var fx,fy;
	var tx,ty;
	
	
	function SwingLine(_up)
	{
		up=_up;
		
		setup();
//		clean();
	}
	


	function setup()
	{
		mc=gfx.create_clip(up.mc,null);

//		mc.style= {			fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};
//		gfx.draw_box(mc,10,100,100,100,100);


	}
	
	function clean()
	{
		mc.removeMovieClip(); mc=null;
		
	}

	function update()
	{
		fx=up.dude.x;
		fy=up.dude.y;
		tx=up.hook.x;
		ty=up.hook.y;
		
		mc.clear();
		mc.lineStyle(4,0xffffff,75);
		mc.moveTo(fx,fy);
		mc.lineTo(tx,ty);
		
		
	}
	
	
}
