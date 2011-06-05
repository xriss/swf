/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class BArrow
{
	var mc:MovieClip;

	var upmc:MovieClip;
	
	var ang;
	
	var active;
	
	var x,y;		// this pos
	var vx,vy,vm;	// this velocity
	var fx,fy,fm;	// last impulse
	var mas,rad;	// mass , radius
	
	var chain;		// link to the first of a dangling chain list

	var deadtime;
	
	var back;
	
	var id;
	
	function BArrow(_upmc,_back)
	{
		back=_back;
		
		id="arrow";
		
		x=0;
		y=0;
		
		vx=0;
		vy=0;
		vm=128;
		
		fx=0;
		fy=0;
		fm=16;
		
		mas=1;
		rad=4;
		
		ang=0;
		
		deadtime=0;
		
//		links=null;
		
		setup(_upmc);
	}

	function setup(_upmc)
	{
		clean();
		
		upmc=_upmc;
		mc=gfx.add_clip(upmc,"arrow");
	}
	
	function clean()
	{
		mc.removeMovieClip(); mc=null;
	}

	function update()
	{
	
		if(active==true)
		{
			if(thunk()>0)	// hit something?
			{
				active=false;
				back.shots++;
			}
			
			mc._x=x;
			mc._y=y;
			
			if((vx!=0)||(vy!=0))
			{
				ang=Math.round((Math.atan2(vy,vx)*180/Math.PI));
			}
		}
		
		mc._rotation=ang;
		
		if(chain)
		{
			chain.x=x;
			chain.y=y;
		}
	
	}
	
// apply velocity/collision to a simple object

	function thunk()
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
		
		var o=this;
		
		var friction;
		
		fx=0;
		fy=1.25;	// gravity

		
		friction=1/256;
//		friction=16/256;
		

		l=0;
		for(i=0;i<back.bitems.length;i++)
		{
		var	b=back.bitems[i];
		
			dx=o.x-b.x;
			dy=o.y-b.y;
			dd=dx*dx + dy*dy;
			
			s=b.force;
			s=s*s/dd;
			
//			dbg.print(s);
			if((s>1/256)&&(dd>0))
			{
				l++;
//			dbg.print(s);
				d=Math.sqrt( dd );
				if(b.force<0)
				{
					fx+=(dx/d)*s;
					fy+=(dy/d)*s;
				}
				else
				{
					fx-=(dx/d)*s;
					fy-=(dy/d)*s;
				}
			}
		}
//		dbg.print(l);
		
/*
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
*/
		
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
			o.fx  = fx - (o.vx*friction);
			o.fy  = fy - (o.vy*friction);
		}
		else
		{
			sx    = o.vx ;
			sy    = o.vy ;
		}

// move collision in small steps

		steps=Math.sqrt(sx*sx + sy*sy);
		steps=Math.ceil(steps/(o.rad/2));
		
		for(step=0;step<steps;step++)
		{
		
			o.x=o.x+(sx/steps); // move a fraction
			o.y=o.y+(sy/steps);
						
			if(o.y>back.GetY(o.x)+16-o.rad)
			{
				_root.wetplay.PlaySFX("sfx_thud",3);
				
				back.up.up.menu.show_hints();
				
				return 1;
			}
			
			for(i=0;i<back.bprops.length;i++)
			{
			var	b=back.bprops[i];
			var xd,yd;
			
				switch(b.state)
				{
					case "tower":
						if( (o.x>b.mx) && (o.x<b.px) && (o.y>b.my) && (o.y<b.py) )
						{
							b.hit(this);
							return 1;
						}
					break;
					
					case "apple":
						xd=o.x-b.x;
						yd=o.y-b.y;
						if( (xd*xd) + (yd*yd) < (50*50) )
						{
							b.hit(this);
							return 1;
						}
					break;
				}
			}
			
			
		}
		return 0;
	}
}
