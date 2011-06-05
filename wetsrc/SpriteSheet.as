/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


// break an image up into many sprites


class SpriteSheet
{
	var up;
	
	var mc;

	var pagex,pagey;
	
	var nam;

	var frame;	// frame to display, can be fractions
	
	var frame_fixed; // the actual integer frame to display

	var pages=1; // number of pages
	
	var sx=800; // size of the sprite sheet
	var sy=600;
	
	var cx=100; // size of each sprite in the sheet
	var cy=100;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

		
	function SpriteSheet(_up)
	{
		up=_up;
	}
	
	function setup_str(s) // setup by simple string
	{
		var i;
		var o={};
		
		var a1=s.split(",");
		for(i in a1)
		{
			var v=a1[i];
			var a2=v.split("=");
			var n=a2[1];
			if( n == Number(n) ) { n=Number(n); } // convert to number?
			o[ a2[0] ]=n;
		}
		
		return setup_opts(o);
	}
	function setup_opts(o) // setup by simple opts array
	{
		if(o.sx) { sx=o.sx; }
		if(o.sy) { sy=o.sy; }
		if(o.cx) { cx=o.cx; }
		if(o.cy) { cy=o.cy; }
		if(o.pages) { sx=o.pages; }
		
		setup(o.nam,o.hx,o.hy);
	}
		
	function setup(_nam,hx,hy)
	{
		mc=gfx.create_clip(up.mc,null);
		mc._x=-hx; // place rotation/handle point
		mc._y=-hy;
		
		mc.hx=-hx; // place rotation/handle point
		mc.hy=-hy;
		
		if(_nam)
		{
			load_img(_nam);
		}
		
		display_frame(0);
	}
	
	function loaded_img(it,nam)
	{
	var x;
	var y;
	
//dbg.print("loadedimg "+nam);

		for(y=0;y<(sy/cy);y++)
		{
			for(x=0;x<(sx/cx);x++)
			{
				_root.bmc.bmp_chop( nam , nam+"_"+y+"_"+x , x*cx,y*cy , cx,cy );
			}
		}
		
		_root.bmc.forget( nam );
	}
	

	function load_img(_nam)
	{
		nam=_nam;
		
		if(!_root.bmc.checkloading(nam)) // only set up the bitmaps once
		{
			_root.bmc.remember( nam , bmcache.create_img , //this is safe as it only works once
			{
				url:nam ,
				bmpw:sx , bmph:sy , bmpt:true ,
				hx:0 , hy:0 ,
				onload:delegate(loaded_img,nam)
			} );
		}
		
	}
	
	function clean()
	{
		mc.removeMovieClip();
		mc=null;
	}
	
	
	function pick(z,x,y)
	{
		pagex=x;
		pagey=y;
		
		var idstr=nam+"_"+y+"_"+x;
		
		_root.bmc.create(mc,idstr,1);
		
	}
	
	function display_frame(_frame)
	{
		frame=_frame;
		frame_fixed=Math.floor(frame);
		
		var z=Math.floor(frame_fixed/(sx*sy));
		var x=Math.floor(frame_fixed/sx);
		var y=Math.floor(frame_fixed%sx);
		pick(z,x,y);
	}

	function update()
	{
	
	}
	
}
