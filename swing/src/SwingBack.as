/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;

import SwingDude;


// A collection of stacks of cards making up the game


class SwingBack
{
	var mc:MovieClip;

	var up;
	
	var back;
	
	var map;
	
	
	function SwingBack(_up)
	{
		up=_up;
		
		
		setup();
//		clean();
	}
	


	function setup()
	{
		mc=gfx.create_clip(up.mc,null);
		
		back=gfx.add_clip(mc,"back",null);
		
		map=new Array( 100 * 75 );
		
		var x,y;
		
		for(y=0;y<75;y++)
		{
			for(x=0;x<100;x++)
			{
				if( (x==0) || (y==0) || (x==99) || (y==74) )
				{
					map[x+(y*100)]=1;
				}
				else
				{
					map[x+(y*100)]=0;
				}
			}
		}
	}
	
	function clean()
	{
		mc.removeMovieClip(); mc=null;
	}

	function update()
	{
	}

// apply velocity/collision to a simple object

	function thunk(o)
	{
		var cx,cy,cr;
		var cxa,cya,cxb,cyb;
		var x,y;
		var ox,oy;
		var dx,dy,dd,d;
		var p,c;
		var nx,ny,n;
		var mx,my,m;
		var step,steps;
		
		var sx,sy;
		var fx,fy;
	
		var i,l,s;
		
		fx=0;
		fy=0.75;
		
		for(i=0;i<o.links.length;i++)
		{
			l=o.links[i];
			
			if(l.maxlen>0)
			{
				dx=l.x-o.x;
				dy=l.y-o.y;
				d=Math.sqrt( dx*dx + dy*dy );

				nx=dx/d;
				ny=dy/d;
				
				mx=ny;
				my=-nx;
				
				s=(d)/l.maxlen;
				
				if(s>0)
				{
					fx+=nx*s*s*0.75;
					fy+=ny*s*s*0.75;					
				}

			}
		}
		
//clip force
		if(fx >  o.fm) { fx= o.fm; }
		if(fx < -o.fm) { fx=-o.fm; }
		if(fy >  o.fm) { fy= o.fm; }
		if(fy < -o.fm) { fy=-o.fm; }
//clip vel
		if(o.vx >  o.vm) { o.vx= o.vm; }
		if(o.vx < -o.vm) { o.vx=-o.vm; }
		if(o.vy >  o.vm) { o.vy= o.vm; }
		if(o.vy < -o.vm) { o.vy=-o.vm; }
		
		if(o.mas>0) // only do impulse if mass is sensible
		{
			sx    = o.vx + 0.5*o.fx / o.mas;
			sy    = o.vy + 0.5*o.fy / o.mas;
			o.vx += ( ( o.fx + fx ) / 2*o.mas );
			o.vy += ( ( o.fy + fy ) / 2*o.mas );
			o.fx  = fx - (o.vx*1/64);
			o.fy  = fy - (o.vy*1/64);
		}
		else
		{
			sx    = o.vx ;
			sy    = o.vy ;
		}

		



		steps=Math.sqrt(sx*sx + sy*sy);
		steps=Math.ceil(steps/(o.rad/2));
		
		for(step=0;step<steps;step++)
		{
		
			o.x=o.x+(sx/steps); // move a fraction
			o.y=o.y+(sy/steps);
			
//collision ?

			cx=Math.floor((o.x+4)/8);
			cy=Math.floor((o.y+4)/8);
			cr=Math.floor((o.rad+8)/8);
			
			cxa=cx-cr; if(cxa< 0) { cxa= 0; }
			cxb=cx+cr; if(cxb>99) { cxb=99; }
			
			cya=cy-cr; if(cya< 0) { cya= 0; }
			cyb=cy+cr; if(cyb>74) { cyb=74; }
			
			o.ccc=0;
			o.cpx=0;
			o.cpy=0;
			o.cvx=0;
			o.cvy=0;
			
			for(y=cya;y<=cyb;y++)
			{
				for(x=cxa;x<=cxb;x++)
				{
					if(map[x+y*100])
					{
						dx=x*8+4-o.x;
						dy=y*8+4-o.y;
						dd=dx*dx+dy*dy;
						
						if(dd<o.rad*o.rad+4*4) //maybe hit
						{												
							d=Math.sqrt(dd);
							
							nx=dx/d;	// collision normal
							ny=dy/d;
							
							c=(nx*o.vx) + (ny*o.vy);
							
							if( c > 0 ) // ignore if we are not moving towards it
							{

								p=o.rad+4-d; // distance to push
								
								o.cpx+=-(nx*p);
								o.cpy+=-(ny*p);
								
								o.cvx+=-nx*c*2;
								o.cvy+=-ny*c*2;
								
								o.ccc+=1;
								
//								return true;
							}
						}
					}
				}
			}
			
			if(o.ccc)
			{			
				return o.ccc;
			}
		}
		return 0;
	}
	
	
}
