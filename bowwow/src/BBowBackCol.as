/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class BBowBackCol
{
//	var mc:MovieClip;

	var up;

// base height (-256 to place center brush)
	var idx;
	
	var x;
	var y;
	var yv;

	var item_wait;

//	var bmps;

	function BBowBackCol(_up,_idx)
	{
	var i;
	var last;
	
		up=_up;
		idx=_idx;
		
		
		if(idx>0) // relative to x-1
		{
			last=up.GetCol(idx-1);
		}
		else
		if(idx<0) // relative to x+1
		{
			last=up.GetCol(idx+1);
		}
		
		if(idx==0) // seed
		{
			x=0;
			y=0;
			yv=0;
			
				item_wait=16+(up.rnd()%16);
		}
		else
		{
		var cent=256*16;
		var xabs;
		var rnd_fix;
		
			x=idx*up.cw;
			
			xabs=x;
			if(xabs<0) { xabs=-xabs; }
			
			if(xabs<cent)
			{
				rnd_fix=0.05-(xabs/cent);	// 0 to -1
			}
			else
			{
				rnd_fix=0.05-1;
			}
			
			yv=(last.yv+(((up.rnd()/65535)+rnd_fix)*(up.cw/32)));
			y=last.y+yv+ (((up.rnd()/65535)-0.5)*(up.cw));
			
			if(y>up.maxy) { up.maxy=y; }
			if(y<up.miny) { up.miny=y; }
			
			item_wait=last.item_wait-1;
			
			if(item_wait<0) // add an item
			{
			var b;
			
				item_wait=16+(up.rnd()%16);
				
				
				if(up.rnd()>32768)
				{
					b=new BItem(up,256+(up.rnd()%512));
				}
				else
				{
					b=new BItem(up,-256-(up.rnd()%512));
				}
				
				b.x=x;
				b.y=y-1024 - (up.rnd()%4096);
				
				up.bitems[up.bitems.length+1]=b;
			}
		}
/*
		mc=gfx.create_clip(up.mc,null);
		
		bmps=new Array();

		y=0;
		
		for(i=-6;i<=2;i++)
		{
			if(i<0)
			{
				bmps[i]=gfx.add_clip(mc,"b_sky00");
			}
			else
			if(i>0)
			{
				bmps[i]=gfx.add_clip(mc,"b_dirt00");
			}
			else
			{
				bmps[i]=gfx.add_clip(mc,"b_flat00");
			}
			
			bmps[i]._y=(i*512)-256;
			
		}
*/
	}


	function setup()
	{
	}
	
	function clean()
	{
	}

	function update()
	{
	}
	
}
