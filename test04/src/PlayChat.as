/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class PlayChat
{
	var up;
	
	var mc;

	var active=false;
	
	var state="none";
	
	var speed=2;
	
	function PlayChat(_up)
	{
		up=_up;
	}

	function setup()
	{
		mc=gfx.create_clip(up.mc,null);
		mc._x=0;
		mc._y=480;
		
		mc.draw=gfx.create_clip(mc,null);
		mc.draw.cacheAsBitmap=true;
		
		gfx.clear(mc.draw);
		mc.draw.style.fill=0xff000000;
		gfx.draw_box(mc.draw,0,0,0,640,240);
		
		mc.draw.tf=gfx.create_text_html(mc.draw,null,20,20,640-40,240-40);
		
		
		state="none";
		
		show("poop");
	}

	function clean()
	{
		mc.removeMovieClip();
	}
	
	function show(txt)
	{
		if(state!="show")
		{
			state="show";
			speed=1;
			gfx.set_text_html(mc.draw.tf,32,0xffffff,"<p align=\"center\">If only I had never woken up...</p>");
		}
	}
	
	function hide()
	{
		if(state!="hide")
		{
			speed=1;
			state="hide";
		}
	}
	
	function update()
	{
	var d;
	
		if(state=="show")
		{
			d=240-mc._y;
			d=d*0.125;
			if(d>0) d=Math.ceil(d);
			if(d<0) d=Math.floor(d);
			if(d*d<1)
			{
				mc._y=240;
				mc._visible=true;
			}
			else
			{
				mc._y+=d;
				mc._visible=true;
			}
		}
		else
		if(state=="hide")
		{
			d=480-mc._y;
			d=d*0.125;
			if(d>0) d=Math.ceil(d);
			if(d<0) d=Math.floor(d);
			if(d*d<1)
			{
				mc._y=480;
				mc._visible=false;
			}
			else
			{
				mc._y+=d;
				mc._visible=true;
			}
		}
	}
}


