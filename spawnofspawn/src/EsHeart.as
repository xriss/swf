/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

//import com.wetgenes.gfx;
//import com.wetgenes.dbg;

class EsHeart
{
	var max=16;
	var fade=1;
	
	var mcs;

	var up;
	
	var idx;
	
	var pop_force;
	
	function EsHeart(_up)
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
		
			mc=gfx.add_clip(up.mc,"heart",null);
			mc._visible=false;
			mc.active=false;
			mcs[i]=mc;
		}
		
		idx=0;
		
		fade=1;
		
		pop_force=500;

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
	}
	
	function reset(mc)
	{
		mc._xscale=100;
		mc._yscale=100;
		mc.force=100*2;
		
		up.score-=mc.score;
		mc.score=0;
	}
	
	function add()
	{
	var mc,i;
	
		for(i=0;i<max;i++)
		{
			mc=mcs[i];
			if(mc.active==false)
			{
				mc.score=0;
				
				mc._x=up.back.min_view_x+400+(((up.back.max_view_x-up.back.min_view_x)-800)*up.rnd()/0xffff);
				
				mc._y=up.back.gety(mc._x);
				
				mc._y+=-200+(((up.back.min_view_y-mc._y)+400)*up.rnd()/0xffff);
				
				mc._visible=true;
				mc.active=true;
				mc._alpha=100;
				
				reset(mc);
				
				return mc; // done
			}
		}
	}
	
	function hit(mc)
	{
	
		up.score+=pop_force/100;
		mc.score+=pop_force/100;
	
	
		mc._xscale+=20;
		mc._yscale+=20;
		mc.force+=40;
		
		_root.wetplay.PlaySFX("sfx_hearthit",1);	
		
		if(mc.force>=pop_force)
		{
			up.score+=pop_force;
			
			pop_force+=500;
			pop(mc);
		}
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
}