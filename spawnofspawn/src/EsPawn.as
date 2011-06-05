/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

//import com.wetgenes.gfx;
//import com.wetgenes.dbg;

class EsPinger
{
	var max=32;
	
	var total;
	
	var mcs;

	var up;
	
	var idx;
	
	
	
	function EsPinger(_up)
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
			mc.idx=i;
			
			mc.type="pinger";
			
			mc.lineStyle(4,0xff0000,100);
			mc.beginFill(0xff0000,50);

			s1=16;
			
			
			mc.moveTo(-s1,-s1);
			mc.lineTo(s1,-s1);
			mc.lineTo(s1,s1);
			mc.lineTo(-s1,s1);
			mc.lineTo(-s1,-s1);
			
			mc.endFill();

			mc._visible=false;
			mc.active=false;
			mcs[i]=mc;
		}
		
		idx=0;
		
		total=0;
		

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
	var i,mc;
	var x,y;
	var xx,yy,rr;
	
		x=up.ship.mc._x;
		y=up.ship.mc._y;
	
		for(i=0;i<max;i++)
		{
			mc=mcs[i];
			if(mc.active)
			{
				mc.ox=mc._x; // remember old pos
				mc.oy=mc._y;
				
				mc_update(mc);
				
				xx=mc._x-x;
				yy=mc._y-y;
				rr=xx*xx+yy*yy;
				if(rr<((mc.rad*mc.rad)+(64*64)))
				{
					up.ship.hit=mc;	// only deal with one hit per frame
				}
			}
		}
	}
	
	function mc_update(mc)
	{
	var col;
	var cp;
	var x;
	
		if(mc.floater)
		{
			cp=mcs[(mc.idx+up.frame)%max];
			if((cp.active)&&(cp.floater))
			{
				x=cp._x-mc._x;
				if((x>0)&&(x<200))
				{
					mc.vx-=16;
					cp.vx+=16;
				}
				else
				if((x<0)&&(x>-200))
				{
					mc.vx+=16;
					cp.vx-=16;
				}
				
			}
			fizix_update(mc);
		}
		else
		{
			if(mc.fizon)
			{
				if( fizix_update(mc) ) // hit the floor
				{
					mc.fizon=false;
				}
			}
			else
			{
				if(mc.wait>0)
				{
					mc.wait--;
					
					col=up.back.GetYcol(mc._x);
					
					if(col.wet>32)
					{
						if(col.ca.wet>1)
						{
							mc.soak+=1;
							col.ca.wet-=1;
						}					
						if(col.cb.wet>1)
						{
							mc.soak+=1;
							col.cb.wet-=1;
						}					
					}
					
					mc._xscale=100+(100*mc.soak/1024);
					mc._yscale=mc._xscale;

					mc.rad=16+(16*mc.soak/1024);
					
					if(mc.soak>=1024) // become a floater
					{
						mc.floater=true;
						mc.rad=32;
					}
				}
				else
				{
					jump(mc);
					setwait(mc);
				}
			}
		}
	}
	
	function setwait(mc)
	{
		mc.wait=32+(up.rnd()&0x7f);
	}
	
	function jump(mc)
	{
		mc.fizon=true;
		mc.vx=(64*(up.rnd()/65535))-32;
		mc.vy=-16 -(16*(up.rnd()/65535));
	}
	
	function add(x,y,xv,yv)
	{
	var mc,i;
	
		for(i=0;i<max;i++)
		{
			mc=mcs[i];
			if(mc.active==false)
			{
				total++;
				
				mc.score=0;
								
				fizix_setup(mc,x,y,xv,yv,1,16);
		
				mc._visible=true;
				mc.active=true;
				mc._alpha=100;
				
				mc._xscale=100;
				mc._yscale=100;
				
				mc.fizon=true;
				
				mc.floater=false;
				mc.soak=0;
				
				setwait(mc);
								
				return mc; // done
			}
		}
	}
	
	function splat(mc)
	{
	var i,y;
	var col;
	
		if(mc.active)
		{
			total--;
			
			mc.active=false;
			mc._visible=false;
			
			col=up.back.GetYcol(mc._x);
			
			y=col.y-col.wet-32;			// move splash up to surface
			if(mc._y<y) { y=mc._y; }

			if(mc.floater)
			{
				up.score+=64;
				
				for(i=0;i<8;i++)
				{
					up.shot.shoot(mc._x,y, (((up.rnd()/0xffff)*64)-32) , (((up.rnd()/0xffff)*-32)) );
				}
			}
			else
			{
				up.score+=16;
				
				for(i=0;i<4;i++)
				{
					up.shot.shoot(mc._x,y, (((up.rnd()/0xffff)*64)-32) , (((up.rnd()/0xffff)*-32)) );
				}
			}
		}
	}
	

#FIZTTYPE="pinger"
#include "src/fizix.as"

}