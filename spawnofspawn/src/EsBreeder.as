/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

//import com.wetgenes.gfx;
//import com.wetgenes.dbg;

class EsBreeder
{
	var max=4;
	
	var mcs;

	var up;
	
	var idx;
	
	var reload;
	
	var poops;
	var pi;
	
	function EsBreeder(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup()
	{
	var i;
	var mc,s1,s2;
	
		mcs=[];
		
		for(i=0;i<max;i++)
		{
		
			mc=gfx.add_clip(up.mc,"breeder",null);
			mc._visible=false;
			mc.active=false;
			mcs[i]=mc;
		}
		
		idx=0;
		
		var s=1;
		var t=Math.sqrt(0.5);
		
		poops=[ s,0, t,t, 0,s, -t,t, -s,0, -t,-t, 0,-s, t,-t ]; // 8 dirs
		pi=0;

	}
	
	function clean()
	{
	var mc,i;
	
		for(i=0;i<max;i++)
		{
			mcs[i].removeMovieClip();
		}
	}

	function update()
	{
	var i;
	
		for(i=0;i<max;i++)
		{
			if(mcs[i].active)
			{
				mc_update(mcs[i]);
			}
		}
	}
	
	function mc_update(mc)
	{
// build force depent on position	

var sy,cy;
		cy=up.back.GetYcol(mc._x);
		sy=(cy.y-cy.wet)-mc._y;

//dbg.print(sy);

		if(mc._x > up.back.max_view_x-1024)
		{
			mc.dfx=-1/16;
		}
		if(mc._x < up.back.min_view_x+1024)
		{
			mc.dfx= 1/16;
		}

		if(sy <  1024)
		{
			mc.dfy=-1/8;
		}
		if(sy >  1024+512)
		{
			mc.dfy= 1/8;
		}
		
		fizix_update(mc);
		
		if(mc.reload>0)
		{
			mc.reload--;
		}
		else
		{
		var x,y;
		
			x=poops[pi];
			y=poops[pi+1];
			pi=(pi+2)&15;
			
			up.pinger.add(mc._x+x*100,mc._y+y*100,x*32,y*32);
			
			mc.reload=16+(up.pinger.total*4);
		}
		
	}
	
	function add()
	{
	var mc,i,x,y;
	
		for(i=0;i<max;i++)
		{
			mc=mcs[i];
			if(mc.active==false)
			{
				mc.score=0;
				
				x=up.back.min_view_x+400+(((up.back.max_view_x-up.back.min_view_x)-800)*up.rnd()/0xffff);
				
				y=up.back.gety(mc._x);
				
				y+=-200+(((up.back.min_view_y-mc._y)+400)*up.rnd()/0xffff);
				
				fizix_setup(mc,x,y,0,0,1,100);
		
				mc._visible=true;
				mc.active=true;
				mc._alpha=100;
				
				mc.dfx=1/16;
				mc.dfy=0;
				
				mc._xscale=200;
				mc._yscale=200;
				
				mc.reload=0;
				
				return mc; // done
			}
		}
	}
	
	function hit(mc)
	{
	}
	
	function pop(mc)
	{
	var i;
	
		mc.active=false;
		mc._visible=false;

		for(i=0;i<16;i++)
		{
			up.shot.shoot(mc._x,mc._y, (((up.rnd()/0xffff)*64)-32) , (((up.rnd()/0xffff)*64)-32) );
		}
		
		add();
		add();
		
		
		_root.wetplay.PlaySFX("sfx_wikwikwik",3);	
		
	}
	
#FIZTTYPE="breeder"	
#include "src/fizix.as"

}