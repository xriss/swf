/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class OverItem
{
	var up;
	
	var mc;
	var tf;
	
	var type;
	var data;
	
	var flags;
	
	var _x,_y;
	var vx,vy;
	
	
	function OverItem(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup(nam,dat)
	{
		mc=gfx.create_clip(up.mc,null);
		
		type=nam;
		data=dat;
		
		flags=0;
		
		_x=0;
		_y=0;
		vx=0;
		vy=0;
		
		
		draw();
	}
	
	function draw()
	{
	var siz=2.00;
			
		switch(type)
		{
			case null:
			break;
			
			case "score":
				tf=gfx.create_text_html(mc,null,-100,-25,200,30);
				gfx.set_text_html(tf,24,0xffffff,"<p align=\"center\">"+data.str+"</p>");
			break;
		}
		
	}
	
	function clean()
	{
		mc.removeMovieClip();
	}

	function setxy(setx,sety,setvx,setvy)
	{
		if(setvx!=undefined) { vx=setvx; }
		if(setvy!=undefined) { vy=setvy; }
		
		_x=setx;
		_y=sety;
		if(mc)
		{
			mc._x=setx;
			mc._y=sety;
		}
	}
	
	function update()
	{
		switch(type)
		{
			case "score":
			
//				vy-=1;
				setxy(_x+vx,_y+vy);
				mc._alpha-=1;
				
				if(mc._alpha <= 0) return true; //die
				return false; // live
			break;
		}
	}	
	
/*
	function nextframe()
	{
		mc2.gotoAndStop(((mc2._currentframe+0)%20)+1);
	}
*/

}