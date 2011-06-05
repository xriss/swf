/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class BItem
{
	var mc:MovieClip;

	var upmc:MovieClip;
	
	var ang;
	
	var active;
	var floating;
	
	var x,y;		// this pos
	var vx,vy,vm;	// this velocity
	var fx,fy,fm;	// last impulse
	var mas,rad;	// mass , radius
//	var links;		// table of links/restraints/springs to calc forces etc

	var deadtime;
	
	var back;
	var force;
	
	var rotspd;
	
	function BItem(_up,_force)
	{
		back=_up;
		
		x=0;
		y=0;
		
		vx=0;
		vy=0;
		vm=64;
		
		fx=0;
		fy=0;
		fm=16;
		
		mas=1;
		rad=50;
		
		ang=0;
		
		deadtime=0;
		
		rotspd=0;
		
//		links=null;
		
		setup(back.mc , _force);
	}

	function setup(_upmc,_force)
	{
		clean();
		
		force=_force;
		upmc=_upmc;
		if(force<0)
		{
			mc=gfx.add_clip(upmc,"whitehole");
			mc._xscale=-force*4;
			mc._yscale=-force*4;
			mc._alpha=40;
			
			rotspd=force/256;
		}
		else
		{
			mc=gfx.add_clip(upmc,"blackhole");
			mc._xscale=force*4;
			mc._yscale=force*4;
			mc._alpha=40;
			
			rotspd=force/256;
		}
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
			}
			
			if((vx!=0)||(vy!=0))
			{
				ang=Math.round((Math.atan2(vy,vx)*180/Math.PI));
			}
		}
		
		mc._x=x;
		mc._y=y;
/*
		if(rotspd)
		{
			mc._rotation+=rotspd;
		}
		else
*/
		{
			mc._rotation=ang;
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
		
		fx=0;
		fy=0.75;	// gravity
		

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
			o.fx  = fx - (o.vx*1/256);
			o.fy  = fy - (o.vy*1/256);
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
				return 1;
			}
			
		}
		return 0;
	}
}
