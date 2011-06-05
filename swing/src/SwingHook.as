/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;

// A collection of stacks of cards making up the game


class SwingHook
{
	var mc:MovieClip;

	var up;
	var bmp;
	
	var x,y;		// this pos
	var vx,vy,vm;	// this velocity
	var fx,fy,fm;	// last impulse
	var mas,rad;	// mass , radius
	var links;		// table of links/restraints/springs to calc forces etc
	
	var cpx,cpy;	// collision
	var cvx,cvy;
	var ccc;
	
	var maxlen;

	function SwingHook(_up)
	{
		up=_up;
		
		setup();
//		clean();
	}
	


	function setup()
	{
		mc=gfx.create_clip(up.mc,null);

//		mc.style= {			fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};
//		gfx.draw_box(mc,10,100,100,100,100);

		bmp=gfx.add_clip(mc,"hook",null);
		

		x=200;
		y=200;
		
		vx=16;
		vy=-16;
		
		fx=0;
		fy=0;
		
		vm=128;
		fm=8;
		
		mas=0;
		rad=8;
		
		links=new Array();
		
		
		maxlen=-1;
		
	}
	
	function clean()
	{
		mc.removeMovieClip(); mc=null;
		
	}

	function update()
	{
		var dx,dy,d,s,nx,ny,n,mx,my,m;
		
		
		if(up.up.replay.key_off&Replay.KEYM_MBUTTON)
		{
			if(maxlen>0) // letgo
			{
				maxlen=0;
				up.dude.links[0]=null;
			}
		}
		
		if(up.up.replay.key_on&Replay.KEYM_MBUTTON)
		{
			if(maxlen==0) // shoot
			{
				x=up.dude.x;
				y=up.dude.y;
				
				vx=up.up.replay.mouse_x+400 - up.dude.x;
				vy=up.up.replay.mouse_y+300 - up.dude.y;
				d=Math.sqrt(vx*vx+vy*vy);
				vx=128*vx/d;
				vy=128*vy/d;
				
				maxlen=-1;
				
				up.dude.links[0]=null;
			}
		}
		
		
		
	
		if(maxlen>0)
		{
		
			if(maxlen>64)
			{
//				maxlen=maxlen*63/64;
//				maxlen-=0.5;
			}
			if(maxlen<64)
			{
				maxlen=64;
			}

			
#if false then

			dx=x-up.dude.x;
			dy=y-up.dude.y;
					
			d=Math.sqrt( dx*dx + dy*dy );
		
			if(maxlen>50)
			{
//				maxlen=maxlen*63/64;
				maxlen-=1;
			}
			if(maxlen<50)
			{
				maxlen=50;
			}
			
			nx=dx/d;
			ny=dy/d;
			
			mx=ny;
			my=-nx;
			
			s=32+d-maxlen;
			
//			if(s>0)
			{
#if true then
				n = up.dude.vx*nx + up.dude.vy*ny;

				m = up.dude.vx*mx + up.dude.vy*my;

				up.dude.vx-=nx*n;
				up.dude.vy-=ny*n;

				if(s>0)
				{
					up.dude.vx+=nx*s/64;
					up.dude.vy+=ny*s/64;
				}

				if(n<0)
				{
					if(m<0)
					{
						up.dude.vx+=mx*n;
						up.dude.vy+=my*n;
					}
					else
					{
						up.dude.vx-=mx*n;
						up.dude.vy-=my*n;
					}
				}
#else


				up.dude.vx+=nx*s/maxlen;
				up.dude.vy+=ny*s/maxlen;


#end
			}
#end
		}
		else // still shooting
		if(maxlen==-1)
		{
			if(up.back.thunk(this))
			{
				x+=cpx/ccc;
				y+=cpy/ccc;
			
				vx=0;
				vy=0;
				
				dx=x-up.dude.x;
				dy=y-up.dude.y;
						
				d=Math.sqrt( dx*dx + dy*dy );
		
				maxlen=d*0.75;
/*				
				nx=dx/d;
				ny=dy/d;
				
				mx=ny;
				my=-nx;
				
				if(ny>nx)
				{
					up.dude.fx+=mx*4;
					up.dude.fy+=my*4;
				}
				else
				{
					up.dude.fx-=mx*4;
					up.dude.fy-=my*4;
				}
*/			
				up.dude.links[0]=this;
			}
		}
		else
		{
			x=up.dude.x;
			y=up.dude.y;		
		}


		bmp._x=x-16;
		bmp._y=y-16;
	}
	
	
}
