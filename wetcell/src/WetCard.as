/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// 0x01 - 0x0d hearts ace to king
// 0x11 - 0x1d spades ace to king
// 0x21 - 0x2d diamonds ace to king
// 0x31 - 0x3d clubs ace to king

// A single card, located in a stack of cards

class WetCard
{

	var mc:MovieClip;
//	var mcp:MovieClip;
	var mcs:MovieClip;

	var up;
	var id;
	
	var x,y; // placed offset in stack
	
	var back:Boolean;
	
// create a card of the given ID in the given stack

	function add_card(thisid)
	{
/*
		if(_root.usecardgfxs=="wii")
		{
			mcs=gfx.add_clip(mc,alt.Sprintf.format('w%02x',thisid),null);
			mcs._xscale=200;
			mcs._yscale=200;
		}
		else
*/
		{
			mcs=gfx.add_clip(mc,alt.Sprintf.format('k%02x',thisid),null);
		}
	}
	function get_x()
	{
		return up.mc._x + Math.floor(mc._x*#(CARD_SCALE));
	}
	
	function get_y()
	{
		return up.mc._y + Math.floor(mc._y*#(CARD_SCALE));
	}


	function WetCard(_up,_id)
	{
		x=null; // to be filled in by stack
		y=null;
		up=_up;
		mc=gfx.create_clip(up.mc,null);
		mc.filters = [ new flash.filters.DropShadowFilter(1, 45, 0x000000, 0.25, 8, 8, 2, 3) ];
		
		if(typeof(_id)=='number')
		{
			id=_id;
//			mcp=gfx.create_clip(mc);

			add_card(id);
			
//			mcp.id=id;
			mcs._x=-50-2+((up.up.rnd()&63)/16);
			mcs._y=-71-2+((up.up.rnd()&63)/16);
			mc._rotation=0-2+((up.up.rnd()&63)/16);			
			back=false;
		}
		else
		{
			var c=_id; // card passed in to copy
			id=c.id;
			
			back=c.back;
//			mcp=gfx.create_clip(mc);
//			mcp.id=id;
			if(back)
			{
//				mcp._visible=false;
//				mcs=gfx.add_clip(mc,'k42',null);
				add_card(0x42);
			}
			else
			{
//				mcp._visible=true;
//				mcs=gfx.add_clip(mc,alt.Sprintf.format('k%02x',id),null);
				add_card(id);
			}
			mcs._x=c.mcs._x;
			mcs._y=c.mcs._y;
//			mcp._x=c.mcs._x;
//			mcp._y=c.mcs._y;
			mc._rotation=c.mc._rotation;
		}
		
/*
		var t=
		[
			"http://img.photobucket.com/albums/v221/detachable/four/th_bri112.jpg",
			"http://img.photobucket.com/albums/v221/detachable/four/th_bri111.jpg",
			"http://img.photobucket.com/albums/v221/detachable/four/th_bri110.jpg",
			"http://img.photobucket.com/albums/v221/detachable/four/th_bri109.jpg",
			"http://img.photobucket.com/albums/v221/detachable/four/th_bri108.jpg",
			"http://smg.photobucket.com/albums/v221/detachable/four/th_bri106.jpg",
			"http://smg.photobucket.com/albums/v221/detachable/four/th_bri105.jpg",
			"http://smg.photobucket.com/albums/v221/detachable/four/th_bri103.jpg",
			"http://smg.photobucket.com/albums/v221/detachable/four/th_bri102.jpg",
			"http://smg.photobucket.com/albums/v221/detachable/four/th_bri101.jpg",
			"http://smg.photobucket.com/albums/v221/detachable/four/th_bri100.jpg"
		]
		mcp.url=t[id%10];
		
		
		mcp.image.removeMovieClip();
		mcp.image=gfx.create_clip(mcp);
		mcp.image._lockroot=true;
		mcp.image.loadMovie(mcp.url);
		
		mcp.image._xscale=100*142/120;
		mcp.image._yscale=mcp.image._xscale;		
		mcp.scrollRect=new flash.geom.Rectangle(0, 0, 100, 142);
*/
		


	}

	function setback(_back:Boolean)
	{
		if(back!=_back) // change
		{
			back=_back;
			
			mcs.removeMovieClip();
			
			if(back)
			{
//				mcp._visible=false;
//				mcs=gfx.add_clip(mc,'k42',null);
				add_card(0x42);
			}
			else
			{
//				mcp._visible=true;
//				mcs=gfx.add_clip(mc,alt.Sprintf.format('k%02x',id),null);
				add_card(id);
			}
			mcs._x=-50-2+((up.up.rnd()&63)/16);
			mcs._y=-71-2+((up.up.rnd()&63)/16);
//			mcp._x=-50-2+((up.up.rnd()&63)/16);
//			mcp._y=-71-2+((up.up.rnd()&63)/16);
			mc._rotation=0-2+((up.up.rnd()&63)/16);
		}
	}

	function remove_mc()
	{
//		mcp.removeMovieClip();
		mcs.removeMovieClip();
		mc.removeMovieClip();
	}
}
