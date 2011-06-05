/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game

class BDude
{
	var mc:MovieClip;
	var rotmc;

	var up;
	
	var x,y,ang;
		
	var ball,arms,feet;
	var arrow;
	
	var reload;
	var pull;
	var shoot;
	
	var frame;
	
	var tiedto;
	
	var shot_type;
	
	var shots;
	
	var tower;
		
	static var pullx=
	[
		 65,
		 55,
		 45,
		 35,
		 25,
		 20,
		 20,
		 20,
		 20,
		 20,
		 19
		
	];
	
	function BDude(_up)
	{
		up=_up;
		mc=gfx.create_clip(up.mc,null);
		rotmc=gfx.create_clip(mc,null);
		
		tower=null;
		
		x=0;
		y=0;
		
		ball=gfx.add_clip(rotmc,"ball_target");
//		ball=gfx.add_clip(mc,"ball_blue");
		feet=gfx.add_clip(mc,"binion_feet");
		arrow=new BArrow(rotmc,up);
		arms=gfx.add_clip(rotmc,"binion_arms");
		
		ball._xscale=64;
		ball._yscale=64;
		ball._x=-32;
		ball._y=-32;
		
		arrow.mc._x=50+60;
		arrow.mc._y=-16;
		
		tiedto=null;
		
		reload=1;
		
		shot_type="arrow";
		
		shots=0;
	}

	function setup()
	{
	}
	
	function clean()
	{
	}

	function update()
	{
	var armang;
	var armflip;
	
	
		if(tiedto)
		{
			x=tiedto.x;
			y=tiedto.y-50;
		}
	
		mc._x=x;
		mc._y=y;
		
		while(ang> 180) { ang-=360; }
		while(ang<-180) { ang+=360; }
		
		if(ang>90)
		{
			armang=ang-180;
			armflip=-100;
		}
		else
		if(ang<-90)
		{
			armang=ang+180;
			armflip=-100;
		}
		else
		{
			armang=ang;
			armflip=100;
		}
		
		if(shoot>0) // shoot
		{		
			var a;
			var nx,ny;
			
			a=new BArrow(up.mc,up);		
			up.up.barrows[up.up.barrows.length]=a;
			
			nx=Math.cos(Math.PI*ang/180);
			ny=Math.sin(Math.PI*ang/180);
			
			a.vx=nx*64*1.25*shoot;
			a.vy=ny*64*1.25*shoot;
						
			a.active=true;
			a.x=x+(nx*64);
			a.y=y+(ny*64);

			
			if(shot_type=="move")
			{
				a.vx*=0.5;
				a.vy*=0.5;
			}
				
			a.ang=ang;

			shoot=0;
			
			a.update();
			
			up.up.focus=a;
			

			var i;
			var l;
			var lp=null;
			
			up.blinks=new Array();
			
			if(shot_type!="arrow")
			{
				for(i=0;i<16;i++)
				{
					l=new BLink(up);
					
					if(shot_type=="arrow")
					{
						l.weight=2;
						l.friction=58/64;
						up.mcb._visible=false;
					}
					else
					if(shot_type=="boom")
					{
						l.weight=2;
						l.friction=58/64;
						up.mcb._visible=true;
					}
					else
					if(shot_type=="move")
					{
						l.weight=2;
						l.friction=58/64;
						up.mcb._visible=false;
					}
					
					if(lp==null) // first
					{
						a.chain=l;
						
						l.x=-90;
						l.y=0;
						arrow.mc.localToGlobal(l);
						up.mc.globalToLocal(l);
						
						l.lx=l.x;
						l.ly=l.y;
					}
					else	// not first
					{
						lp.links[0]=l;
						l.links[1]=lp;
						
						l.x=lp.x;
						l.y=lp.y;
						
						l.lx=l.x;
						l.ly=l.y;
					}
					
					up.blinks[up.blinks.length]=l;
					
					lp=l;
					
					dbg.print(l.x + ":" + l.y);
				}
			}
			
// tied foot to last link
			if(shot_type=="move")
			{
				tiedto=l;
			}
			
		}
		
		if(reload>0)
		{
			frame=22-Math.ceil(11*reload);
			
			if(frame<12)	{ frame=12; }
			if(frame>21)	{ frame=21; }
			
			reload-=0.1;
			if(reload<=0)
			{
				reload=0;
			}
		}
		else
		if(pull)
		{
			frame=Math.ceil(11*pull);
			
			if(frame>11)	{ frame=11; }
			if(frame<1)		{ frame=1; }
		}
		else
		{
			frame=1;
		}
		
//		dbg.print(frame);

		if(frame<=11)
		{
			arrow.mc._x=50+pullx[frame-1];
			
			arrow.mc._visible=true;
		}
		else
		{
			arrow.mc._visible=false;
		}

// bug? do this to make the next goto and stop work...	
		arms.gotoAndPlay(1);
		feet.gotoAndPlay(1);
		
		arms.gotoAndStop(frame);
		feet.gotoAndStop(frame);
		
		rotmc._rotation=armang;
		rotmc._xscale=armflip;
		feet._xscale=armflip;
	}
	
}
