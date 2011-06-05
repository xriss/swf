/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class BLink
{
	var mc:MovieClip;	// shared
	
	var back;

	var active;

	var x,y;		// this pos
	var lx,ly;		// last pos
	var nx,ny;		// next pos
	var len;		// forced distance between links
	
	var weight;
	var friction;
	
/*
	var vx,vy,vm;	// this velocity
	var fx,fy,fm;	// last impulse
	var mas,rad;	// mass , radius
*/
	
// only two links max, simple linked list links[0] is next and links[1] is prev
	var links;
	
	
	
	var deadtime;
	
	function BLink(_up)
	{
		back=_up;
		mc=back.mc;
		
		x=0;
		y=0;
		
		lx=0;
		ly=0;
		
		len=16;
		
		weight=1;
		friction=1;
		
/*		
		vx=0;
		vy=0;
		vm=64;
		
		fx=0;
		fy=0;
		fm=16;
		
		mas=1;
		rad=50;
*/		
//		ang=0;
		
//		deadtime=0;
		
		links=new Array();
		links[0]=null;
		links[1]=null;
		
		setup();
	}

	function setup()
	{
		clean();
	}
	
	function clean()
	{
	}

	function update(flag)
	{
	var dx,dy,d;
	var fx,fy,f;
	var s;
	
	var rez;
			
		if(flag==1) // first pass
		{
			rez=friction;

/*
			if(links[0]==null)
			{
				rez=1/16;
				y+=4;
			}
*/
			
			nx=x;
			ny=y;

			x+=(x-lx)*rez;	// apply forces
			y+=weight+(y-ly)*rez;
			
			
		}
		else // second pass , handle constraints
		{
			rez=6/8;
			
			fx=0;
			fy=0;
			f=1;
			
			if(links[0])
			{
				dx=links[0].x-x;
				dy=links[0].y-y;
				
				d=Math.sqrt(dx*dx+dy*dy);
				if(d>len)
				{
					dx=dx/d;
					dy=dy/d;
					x-=dx*(len-d)*rez;
					y-=dy*(len-d)*rez;
//					f+=1;
				}
			}
			if(links[1])
			{
				dx=links[1].x-x;
				dy=links[1].y-y;
				
				d=Math.sqrt(dx*dx+dy*dy);
				if(d>len)
				{
					dx=dx/d;
					dy=dy/d;
					x-=dx*(len-d)*rez;
					y-=dy*(len-d)*rez;
//					f+=1;
				}
			}
			
			dy=back.GetY(x)+4;
			if(y>dy)
			{
				y=dy;
			}

			
//			x+=fx/f;
//			y+=fy/f;
		
			lx=nx;
			ly=ny;
		}
	
		if(active==true)
		{
//			if(thunk()>0)	// hit something?
			{
//				active=false;
			}
			
		}	
	}
}
