/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.Sprintf;

class WetBioDay
{
	var wetbio:WetBio;
	
	var mcp:MovieClip;	// parent

	var mc:MovieClip;	// data
	var mcm:MovieClip;	// mask

	var x:Number;	// x pos
	var y:Number;	// x pos
	
	var w:Number;	// width of day to draw
	var h:Number;	// height of day to draw
	
	var d:Number;	// day number (counted since birth)
	
	var intellectual:Number; // +-1
	var emotional:Number; // +-1
	var physical:Number; // +-1
	
	function WetBioDay(_wetbio,_mcp)
	{
		wetbio=_wetbio;
		mcp=_mcp;
		w=20;
		h=164;
		d=0;
		setup();
		clean();
	}
		
// on entering this state
	function setup()
	{
		if(mc)	// rebuild main movieclip
		{
			mc.removeMovieClip();
			mc=null;
		}
		mc=gfx.create_clip(mcp,null);
		mc.t=this;
		mc._visible=true;
		
		if(mcm)	// rebuild main movieclip
		{
			mcm.removeMovieClip();
			mcm=null;
		}
		mcm=gfx.create_clip(mcp,null);
		mcm.t=this;
		mcm._visible=false;
		
		mc.setMask(mcm);

		update();
	}

// call to redraw this day, set w,h,n before calling
	function update()
	{
		mcm.clear();
		
		mcm.style=wetbio.view.styles.mask;
		gfx.draw_box(mcm,undefined,0,0,w,h)

		mcm._x=x;
		mcm._y=y;
		
		mc.clear();
		
		mc.style=wetbio.view.styles.curve_blu;
		intellectual=draw_wave(-w*d,w*33);

		mc.style=wetbio.view.styles.curve_red;
		emotional=draw_wave(-w*d,w*28);

		mc.style=wetbio.view.styles.curve_grn;
		physical=draw_wave(-w*d,w*23);

		mc._x=x;
		mc._y=y;
	}

// on leaving this state
	function clean()
	{
		mc._visible=false;
	}


// draw wave
	function draw_wave(start_x:Number,width_x:Number)
	{
		var yb=h/2;
		var xb=start_x;
		
		var overlap = 8;
		
		var xscale = width_x/(Math.PI*2);
		var yscale = (h/2)-4;
		var m1 = yscale/xscale;
		var b1 = 0;

		
		mc.lineStyle(4,mc.style.out&0xffffff,((mc.style.out>>24)&0xff)*100/255);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		var ang1;
		var si1;
		var co1;

		var ang2;
		var si2;
		var co2;
		
		var m2;
		var b2;
		var x;
		var y;

		ang1 = ((0-overlap) - start_x)/xscale ;
		si1 = Math.sin(ang1);
		co1 = Math.cos(ang1);
		m1 = (yscale/xscale)*co1;
		b1 = yscale*(si1 - ang1*co1);

		ang2 = ((w+overlap) - start_x)/xscale ;
		si2 = Math.sin(ang2);
		co2 = Math.cos(ang2)

		m2 = (yscale/xscale)*co2;
		b2 = yscale*(si2 - ang2*co2);
		x = (b1 - b2)/(m2 - m1);
		y = m2*x + b2;


/*
		mc.moveTo(0-overlap , yb );
		mc.lineTo(0-overlap , (yb-yscale*si1 + yb-yscale*si1 + yb-yscale*si2)/3);
		mc.lineTo(w+overlap , (yb-yscale*si1 + yb-yscale*si2 + yb-yscale*si2)/3);
		mc.lineTo(w+overlap , yb);
		mc.endFill();
*/

		mc.moveTo(0-overlap , yb );
		mc.lineTo(0-overlap , yb - yscale*si1 );
		if(Math.abs(m1 - m2) < 0.001)
		{
				mc.lineTo(w+overlap , yb - yscale*si2 );
		}
		else
		{
				mc.curveTo(xb + x, yb - y, w+overlap, yb - yscale*si2);
		}
		mc.lineTo(w+overlap , yb);
		mc.endFill();


//		m1 = m2;
//		b1 = b2;

		return(Math.sin(((w/2)-start_x)/xscale));
	}

}


