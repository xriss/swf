/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;

// A collection of stacks of cards making up the game


class SwingDude
{
	var mc:MovieClip;

	var up;
	var bmp;
	
	var x,y;		// this pos
	var vx,vy,vm;	// this velocity
	var fx,fy,fm;	// last impulse
	var mas,rad;	// mass , radius
	var links;		// table of links/restraints/springs to calc forces etc
	
	var cpx,cpy;	// collision
	var cvx,cvy;
	var ccc;

	
	function SwingDude(_up)
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

		bmp=gfx.add_clip(mc,"dude",null)
		
		x=200;
		y=200;
		
		vx=0;
		vy=0;
		
		fx=0;
		fy=0;
		
		vm=32;
		fm=4;
		
		mas=1;	
		rad=50;
		
		links=new Array();


	}
	
	function clean()
	{
		mc.removeMovieClip(); mc=null;
		
	}

	function update()
	{	
		if(up.back.thunk(this))
		{
			x+=cpx/ccc;
			y+=cpy/ccc;
			vx+=(cvx/ccc)*(15/16.0);
			vy+=(cvy/ccc)*(15/16.0);
		}
		
		bmp._x=x-50;
		bmp._y=y-50;
	}
	
	
}
