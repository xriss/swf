/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class WetBaseMentTitle
{
	var up;
	
	
	var mc;
	
	var mc_levels;
	
	var mc_tard;
	var mc_skill;
	
	var frame;
	
	function WetBaseMentTitle(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}



	
	
	var mcs;
	var buts;
	
	

	function setup()
	{
	var i;
	var x,y;
	var nmc;
	
		mc=gfx.create_clip(up.mc,null);
		
		mc.screen=gfx.add_clip(mc,"screen_title",null);
		mc.screen.cacheAsBitmap=true;
		
		mcs=[];
		buts=[];
		scan_mcs(mc.screen,mcs);
		build_buts(mcs,buts);
		
		for(var nam in mcs)
		{
//			dbg.print( nam + " : " + typeof(mcs[nam]))
		}
	}
	
	function build_buts(mcs,buts)
	{
	var aa;
	var bb;
	var b;
	
		for(var nam in mcs)
		{
			aa=nam.split("_");
			
			if((aa[1]=="but")||(aa[1]=="but1")||(aa[1]=="but2")) // this is a button
			{
				bb=buts[ aa[0] ];
				
				if(bb==undefined)
				{
					bb={};
					bb.nam=aa[0];
					buts[ aa[0] ]=bb; // new if empty
				}
				
				if(aa[1]=="but")
				{
					bb["m"]=mcs[nam];
					bb["m"]._visible=true;
					
					bb["m"].onRollOver=delegate(buts_over,bb);
					bb["m"].onRollOut=delegate(buts_out,bb);
					bb["m"].onReleaseOutside=delegate(buts_out,bb);
					bb["m"].onRelease=delegate(buts_release,bb);
					
					b=bb["m"].getBounds(mc);
/*
					bb["m"].hitArea=gfx.create_clip(mc,null);
					gfx.clear(bb["m"].hitArea);
					gfx.draw_box( bb["m"].hitArea , 0 , b.xMin , b.yMin , b.xMax-b.xMin , b.yMax-b.yMin );
					bb["m"].hitArea._visible=false;
*/
				}
				
				if(aa[1]=="but1")
				{
					bb["m1"]=mcs[nam];
					bb["m1"]._visible=true;
					
					bb["m1"].onRollOver=delegate(buts_over,bb);
					bb["m1"].onRollOut=delegate(buts_out,bb);
					bb["m1"].onReleaseOutside=delegate(buts_out,bb);
					bb["m1"].onRelease=delegate(buts_release,bb);
				}
				
				if(aa[1]=="but2")
				{
					bb["m2"]=mcs[nam];
					bb["m2"]._visible=false;
					
					bb["m2"].onRollOver=delegate(buts_over,bb);
					bb["m2"].onRollOut=delegate(buts_out,bb);
					bb["m2"].onReleaseOutside=delegate(buts_out,bb);
					bb["m2"].onRelease=delegate(buts_release,bb);
					
				}
			}
		}
	}
	
	function buts_over(bb)
	{
		bb.m1._visible=false;
		bb.m2._visible=true;
		
		bb.glow=1;
		bb.glow_dest=1;
//dbg.print("over "+bb.nam);
	}
	function buts_out(bb)
	{
		bb.m1._visible=true;
		bb.m2._visible=false;
		
		bb.glow_dest=0;
//dbg.print("out "+bb.nam);
	}
	function buts_release(bb)
	{
		switch(bb.nam)
		{
			case "challenge":
				up.state_next="choose";
			break;
			case "arcade":
				up.state_next="zoo";
			break;
		}
//dbg.print("clicked "+bb.nam);
	}
	
	function scan_mcs(obj,into)
	{
	var	child;
	
		for(var nam in obj)
		{
			child=obj[nam];						
			if( typeof(child)=="movieclip" )
			{
				scan_mcs(child,into);
				into[nam]=child;
//dbg.print(into[nam]);
			}
		}
		
	}

	
	function clean()
	{
		mc.removeMovieClip();
	}
	
	
	function update()
	{
	var i;
	var b;
	
		for(var nam in buts)
		{
			b=buts[nam];
			
			if(b.glow_dest!=undefined)
			{
				if(b.glow>b.glow_dest)
				{
					b.glow*=0.9;
					b.glow-=0.01;
				}
				
				if(b.glow>0)
				{
//					gfx.glow(b.m , 0xffffff, b.glow, 20, 20, 1, 3, false, false );
				}
				else
				{
					b.m.filters=null;
				}
			}
		}
	}

	
}