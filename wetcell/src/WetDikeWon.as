/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// A collection of stacks of cards making up the game

class WetDikeWon
{

	var mc;
	var mcs;
	
	var up; // WetDikePlay
	
	var stars;
	
	var done;
	var steady;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	
// ser
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n; rnd(); }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}
	
	
	function WetDikeWon(_up)
	{
		up=_up;
		
		rnd_seed(0);
	}

	function setup()
	{
	var i;
	var bounds;
	var mct;
	
		_root.popup=this;
		
		mcs=new Array();
			
		mc=gfx.create_clip(_root.mc_popup,null);
	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		mc._y=200;
		
		mc.dx=0;
		mc._x=800;
				
		for(i=1;i<=2+16+5;i++)
		{
			mcs[i]=gfx.add_clip(mc,'won',null);
			mcs[i].gotoAndStop(i+1);
			
			if( (i>=2) && (i<=2+16) )
			{
				bounds = mcs[i].getBounds(mc);
				
				bounds.x=(bounds.xMin+bounds.xMax)/2;
				bounds.y=(bounds.yMin+bounds.yMax)/2;

				mcs[i].removeMovieClip();
				mcs[i]=gfx.create_clip(mc,null);
			
				mcs[i]._x=bounds.x;
				mcs[i]._y=bounds.y;
				
				mcs[i].ox=bounds.x;
				mcs[i].oy=bounds.y;
				
				mct=gfx.add_clip(mcs[i],'won',null);
				mct.gotoAndStop(i+1);
				mct._x=-bounds.x;
				mct._y=-bounds.y;
			}
		}
		
//		mcs[1]._alpha=75;
		
		stars=1;
		
		mc.onEnterFrame=delegate(update,null);
//		mc_popup.mc_front=gfx.add_clip(mc_popup,'won2',null);

		done=false;
		steady=false;
		
		Mouse.addListener(this);
	}

	function clean()
	{		
		if(_root.popup != this)
		{
			return;
		}
						
		mc.removeMovieClip();
		
		_root.popup=null;
		
		Mouse.removeListener(this);
		
		up.up.do_str("won");
	}
	
	function onMouseDown()
	{
		if(_root.popup != this)
		{
			return;
		}

		if(steady)
		{
			done=true;
			mc.dx=-800;
		}
	}

	function update()
	{
		var i;
		var star_width=55;
		
		if(_root.popup != this)
		{
			return;
		}
		
		mc._x+=(mc.dx-mc._x)/4;
		
		
		if(!done)
		{			
			if(mc._xmouse<400-star_width*1.5)	{ stars=1; }
			else
			if(mc._xmouse<400-star_width*0.5)	{ stars=2; }
			else
			if(mc._xmouse<400+star_width*0.5)	{ stars=3; }
			else
			if(mc._xmouse<400+star_width*1.5)	{ stars=4; }
			else
												{ stars=5; }
												
			for(i=1;i<=5;i++)
			{
				if(i<=stars)
				{
					mcs[2+16+i].dalpha=100;
				}
				else
				{
					mcs[2+16+i].dalpha=0;
				}
			}
		}
		
		for(i=1;i<=5;i++)
		{
			mcs[2+16+i]._alpha+=(mcs[2+16+i].dalpha-mcs[2+16+i]._alpha)/2;
		}
		
		for(i=1;i<=16;i++)
		{
		var b;
		
			b=mcs[2+i];
			
		var d;
		
			d= ( (b.dx-b._x)*(b.dx-b._x) ) + ( (b.dy-b._y)*(b.dy-b._y) );
			
			if( ( d < 4 ) || (b.dx==null) ) // new dest
			{
				b.dx=b.ox+((2*(rnd()/65535))-1)*4;
				b.dy=b.oy+((2*(rnd()/65535))-1)*16;
				b.drotation=((2*(rnd()/65535))-1)*16;
			}
			
			b._x+=(b.dx-b._x)/16;
			b._y+=(b.dy-b._y)/16;
			b._rotation+=(b.drotation-b._rotation)/16;
			
		}
		
		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(done)
			{
				clean();
			}
		}
		else
		{
			steady=false;
		}
	}
	
}
