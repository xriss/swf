/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

//import com.wetgenes.gfx;
//import com.wetgenes.dbg;

class EsShot
{
	var max=32;
	var fade=1;
	
	var mcs;

	var up;
	
	var idx;
	
	function EsShot(_up)
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
		
			mc=gfx.create_clip(up.mc,null);
			
			mc.lineStyle(4,0x0000ff,100);
			mc.beginFill(0x0000ff,50);

			s1=8;
			
			
			mc.moveTo(-s1,-s1);
			mc.lineTo(s1,-s1);
			mc.lineTo(s1,s1);
			mc.lineTo(-s1,s1);
			mc.lineTo(-s1,-s1);
			
			mc.endFill();
			
			
			mc._x=0;
			mc._y=0;
			
			mc._visible=false;
			
			mcs[i]=mc;
		}
		
		idx=0;
		
		fade=1;
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
	var mc,i;
	
		for(i=0;i<max;i++)
		{
			mc=mcs[i];
			
			if(mc._visible)
			{
				if(mc.active)
				{
					fizix_update(mc);
					if(mc.hit)
					{
						mc.active=false;
						up.heart.hit(mc.hit);
					}
				}
				else
				{
					mc._visible=false;
				}
				mc._alpha-=fade;
				if(mc._alpha<=0)	{	mc._visible=false;	}
			}
		}
		
	}
	
	function shoot(px,py,vx,vy)
	{
	var mc,i;
	
		mc=mcs[idx];
		
		fizix_setup(mc,px,py,vx,vy,1,8);
		mc._visible=true;
		mc.active=true;
		mc._alpha=100;
		
		idx++;
		if(idx>=max) { idx=0; }
	}

#FIZTTYPE="shot"	
#include "src/fizix.as"

}