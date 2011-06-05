/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// A collection of stacks of cards making up the game

class WetDikeSwish
{

	var mc;
	var mcs;
	
	var tf;
//	var tf_shadow;
	
	var up; // WetDikePlay
	
	var timeout=0;
	
	var last_track;
	var last_artist;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	
// ser
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n; rnd(); }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence poo
		return rnd_num;
	}
	
	
	function WetDikeSwish(_up)
	{
		up=_up;
		
		rnd_seed(0);
	}

	function setup()
	{
	var i;
	var bounds;
	var mct;
	
			
		mc=gfx.create_clip(up.mc,null);
	    mc.filters = [ new flash.filters.DropShadowFilter(2, 45, 0x000000, 1, 4, 4, 2, 3) ];
//		mc.cacheAsBitmap=true;

//		tf_shadow=gfx.create_text_html(mc,null,0,0,800,600);
		tf=gfx.create_text_html(mc,null,0,0,800,200);
//		tf.cacheAsBitmap=true;

		
//		tf_shadow._x=2;
//		tf_shadow._y=2;
		
		last_track="";
		last_artist="";

		mc.dx=-800;
		mc.dy=0;
		mc.xx=-800;
		mc.yy=0;
	}

	function clean()
	{				
		mc.removeMovieClip();
	}
	

	function update()
	{
		var track;
		var artist;
		var s;
		var px,py;
		
		px=mc.dx-mc.xx;
		py=mc.dy-mc.yy;
		if( (px*px+py*py) < (1*1) )
		{
			mc.xx=mc.dx;
			mc.yy=mc.dy;
		}
		else
		{
			mc.xx+=px*0.125;
			mc.yy+=py*0.125;
		}
		
		track=_root.wetplay.wetplayMP3.disp_title;
		artist=_root.wetplay.wetplayMP3.disp_creator;
		
		if((mc.dx==0)&&(mc.xx==0))
		{
				if(timeout<=0)
				{
					mc.dx=-800;
				}
				else
				{
					timeout--;
				}
		}
		else
		if((mc.dx==-800)&&(mc.xx==-800))
		{
			if( ( (track!=last_track) || (artist!=last_artist) ) && (_root.popup==null) && (up.dikeplay.display_scores<0))// new track?
			{
				s="";
				
				s+="<p align='center'><b>Now Playing<br>";
				s+=track+"<br>";
				s+="by<br>";
				s+=artist+"<br>";
				s+="</b></p>";
			
				gfx.set_text_html(tf,32,0xffcccccc,s);
//				gfx.set_text_html(tf_shadow,32,0xff000000,s);
				
				last_track=track;
				last_artist=artist;
				
				mc.xx=800;
				mc.dx=0;
				
				timeout=30*1;
			}
		}
		
		mc._x=Math.floor(mc.xx);
		mc._y=Math.floor(mc.yy);
		
// work out extents and hide if it should be invisible, slight speedup... 

//		dbg.print("TF="+tf.textWidth);
		if	(
				( (mc._x+400+(tf.textWidth/2)+10) < 0 )
//				||
//				( (mc._x-400-(tf.textWidth/2)-10) > 800 )
			)
		{
			tf._visible=false;
//			dbg.print("hide");
		}
		else
		{
			tf._visible=true;
//			dbg.print("show");
		}
		
	}
	
}
