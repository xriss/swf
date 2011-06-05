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



class WetMove
{

	var from;	// stack number from
	var to;		// stack number to
	var len;	// number of cards
	
	var fx,fy;
	var tx,ty;
	
	var hide;
	var arrange;
	
	var txt;

	var mc;
	var mc2;
	var tf;
	var tf2;
	
	var tfs;
	var tfss;
	var mcs;

	var up; //WetTable

	function WetMove(_up)
	{
		up=_up;
		hide=false;
		arrange=false;
		
		txt="bigwords";		
		
		mc=null;
		tf=null;
		mcs=new Array();
		tfs=new Array();
		tfss=new Array();
		
		mc=gfx.create_clip(up.mc_moves,null);
		mc2=gfx.create_clip(mc,null);
		
//		tf=gfx.create_text_html(mc,null,-400,-32,800,64);
//		tf2=gfx.create_text_html(mc,null,-400-2,-32-2,800,64);
	}
	
	function set(_from,_to,_len)
	{
		from=_from;
		to=_to;
		len=_len;
		
	}
	
	static var colors=
	[
		0xff0000,
		0x00ff00,
		0x0000ff,
		0xff8000,
		0x00ff80,
		0x8000ff,
		0xff0080,
		0x80ff00,
		0x0080ff
	];
	
	
	function position_mcs()
	{
	
//		return; // no display...
	
	
	var s,i;
//	var box;
	var w,ww,ws;
	var c;
	
		ww=Math.sqrt(((tx-fx)*(tx-fx)) + ((ty-fy)*(ty-fy)) );
//		ww+=100;
		
		mc._x=(fx+tx)/2;
		mc._y=(fy+ty)/2;
		mc._rotation=Math.atan2(ty-fy,tx-fx)*180/Math.PI;
		
		if((mc._rotation<-90) || (mc._rotation>90))
		{
			mc._rotation+=180;
		}
		
		ws=ww/(txt.length-1)
		
		c=colors[(up.txtcolor++)%colors.length];
		
		for(i=0;i<txt.length;i++)
		{
			
			mcs[i]=gfx.create_clip(mc2,100-i);
			
//			tfss[i]=gfx.create_text_html(mcs[i],null,2-32,5+2-32,64,64);
			tfs[i]=gfx.create_text_html(mcs[i],null,-32,5-32,64,64);
			
			s="<p align=\"center\"><b>"+txt.charAt(i)+"</b></p>";
//			gfx.set_text_html(tfss[i],48,0,s);
			gfx.set_text_html(tfs[i],40,c,s);
			
			if(ws>120)
			{
				mcs[i]._xscale=400;
			}
			else
			if(ws>30)
			{
				mcs[i]._xscale=100*ws/30;
			}
			else
			{
				mcs[i]._xscale=100;
			}
			
/*
			if(tx<fx)
			{
				mcs[i]._yscale=150-100*((i+1)/txt.length);
			}
			else
			{
				mcs[i]._yscale=50+100*((i)/txt.length);
			}
			mcs[i]._xscale=mcs[i]._xscale*mcs[i]._yscale/100;
*/
			
			mcs[i]._x=(-(ww/2))+(i*ws);
			
			gfx.dropshadow(mcs[i] , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
		}
		
		if(arrange)
		{
			mc2._alpha=50;
		}

/*		
		s="<p align=\"center\"><b>"+txt+"</b></p>";
		
		gfx.set_text_html(tf,32,0x000000,s);
		gfx.set_text_html(tf2,32,0xff0000,s);
		
//		box=tf.getBounds(mc);
//		w=box.xMax-box.xMin;
		w=tf.textWidth;

		mc._xscale=100*ww/w;
		if(mc._xscale<50)	{ mc._xscale=50; }
		if(mc._xscale>200)	{ mc._xscale=200; }
*/

	}
	
	function clean()
	{
		if(mc)
		{
			mc.removeMovieClip()
		}
	}

}
