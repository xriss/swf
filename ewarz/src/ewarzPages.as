/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#file_names={"pief"}


class #(VERSION_BASENAME)Pages
{
	
	var comms;
	
	var up; // Main

	var mc;
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function #(VERSION_BASENAME)Pages(_up)
	{
		up=_up;
		comms=up.comms;
	}
	
		
	function setup()
	{	
	var me;
	
		mc=gfx.create_clip(up.mc,null);
		
		var pages=ewarzData.pages;
		var pagename,page;
		var partname,part;
		var m;
		for(pagename in pages)
		{
			page=pages[pagename];
			
			mc[pagename]=gfx.create_clip(mc,null);
			
			m=mc[pagename];
			for(partname in page)
			{
				part=page[partname];
				
				switch(part.type)
				{
					case "image":
						m[partname]=gfx.add_clip(m,part.src,part.depth,part.x,part.y);
						m[partname]._width=part.w;
						m[partname]._height=part.h;
					break;
					
					case "xhtml":
						m[partname]=gfx.create_text_html(m,part.depth,part.x,part.y,part.w,part.h);
					break;
				}
			}
		}
		showpage("main");
		
/*
		mc.back=gfx.add_clip(mc,"screen_test");
		me=ewarzData.pages.main.display;
		mc.xhtml=gfx.create_text_html(mc,undefined,me.x,me.y,me.w,me.h);
*/

	}
	
	
	function clean()
	{		
		mc.removeMovieClip(); mc=null;	
	}
	
	function showpage(show_pagename)
	{
		var pagename,page;
		var pages=ewarzData.pages;
		for(pagename in pages)
		{
			page=pages[pagename];
			
			if(pagename==show_pagename)
			{
				mc[pagename]._visible=true;
			}
			else
			{
				mc[pagename]._visible=false;
			}
		}
	}

	
	function display(xhtml)
	{
		gfx.set_text_html(mc.main.main,16,0xffffff,xhtml);
	}
	
	function update()
	{
		if(comms.state!="ready")
		{
			display("Loading...")
				
			comms.setup();
			if(comms.state=="ready")
			{
				display("Connecting...")
				comms.send({ewarz:"connect"}); // request connection
			}
			return;
		}

// ok now we is setup
		
		
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
