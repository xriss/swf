/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class PlayItem
{
	var up;
	
	var mc;
	
	var x,y;
	
	var type;
	
	var active;
	
	var other;
	
	var id;
	
	var escount;
	
	var flavour;
	
	function PlayItem(_up,_x,_y,_type)
	{
		up=_up;
		
		setup(_x,_y,_type);
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup(_x,_y,_type)
	{
		x=_x;
		y=_y;
		
		escount=0;
		
//		frame=0;

		type=_type;
		
		flavour="vanilla";
		
		switch(type)
		{
		case "meta":

			mc=gfx.add_clip(up.imc,"obj_meta",null);
			mc._xscale=100*20/50;
			mc._yscale=100*20/50;
			mc._alpha=10;
			mc._x=10+_x*20;
			mc._y=590-_y*20;
			
			mc.gotoAndStop(1);
			
			active=false;
		
		break;
		case "bump":

			mc=gfx.add_clip(up.imc,"bumper",null);
			mc._xscale=100;
			mc._yscale=100;
			mc._alpha=100;
			mc._x=10+_x*20;
			mc._y=590-_y*20;
			
			mc.gotoAndStop(1);
			
			active=true;
		
		break;
		case "inout":
			mc={};
			mc._x=10+_x*20;
			mc._y=590-_y*20;
			active=false;		
		break;
		case "cannon":

			mc=gfx.create_clip(up.imc,null);
			mc._xscale=100;
			mc._yscale=100;
			mc._alpha=100;
			mc._x=10+_x*20;
			mc._y=590-_y*20;
			
			mc["bak"]=gfx.add_clip(mc,"cannon_bak",null);
			mc["mid"]=gfx.create_clip(mc,null);
			mc["for"]=gfx.add_clip(mc,"cannon_for",null);
			mc["bak"].gotoAndStop(1);
			mc["for"].gotoAndStop(1);
			
			active=true;
		
		break;
		case "whirl":

			mc=gfx.add_clip(up.imc,"whirl",null);
			mc._xscale=100;
			mc._yscale=100;
			mc._alpha=100;
			mc._x=10+_x*20;
			mc._y=590-_y*20;
			
			mc.vx=0;
			mc.vy=0;

			mc.gotoAndStop(1);
			
			active=true;
		
		break;
		}
		
	}
	
	function activate()
	{
		switch(type)
		{
		case "meta":

			mc._xscale=2*100*20/50;
			mc._yscale=2*100*20/50;
			
			active=true;
			mc._alpha=100;
			mc.gotoAndPlay(1);
			gfx.glow(mc , 0xffffff, .8, 16, 16, 1, 3, false, false );
			
		break;
		case "inout":
			active=true;		
		break;
		case "whirl":
			mc._visible=true;
			active=true;
		break;
		}
	}
	
	function disable()
	{
		switch(type)
		{
		case "whirl":
			mc._visible=false;
			active=false;		
		break;
		}
	}
	
	function clean()
	{
		mc.removeMovieClip();
	}

	function update()
	{
	var dx,dy,ss,s;
	var i,max_ss,max_other;
//		frame++;
		
		switch(type)
		{
		case "meta":

			if(active)
			{
				dx=mc._x-up.tards[0].mc._x;
				dy=mc._y-(up.tards[0].mc._y-30);
				
				if(((dx*dx)+(dy*dy))<(50*50))
				{
					up.score+=500;
					mc._visible=false;
					active=false;
					return true;
				}
			}
			
		break;
		case "bump":
		
			escount-=1; if(escount<0) { escount=0; }
			
			if(mc._xscale>100) { mc._xscale=100+(mc._xscale-100)*0.75; }
			if(mc._yscale>100) { mc._yscale=100+(mc._yscale-100)*0.75; }
			
			if((active)&&(up.tards[0].state!="inout")&&(escount<100))
			{
				dx=mc._x-up.tards[0].mc._x;
				dy=mc._y-(up.tards[0].mc._y-30);
				ss=(dx*dx)+(dy*dy);
				
				if((ss)<(60*60))
				{
					escount+=25;
					
					s=Math.sqrt(ss);
					
					if(s>0)
					{
						dx=dx/s;
						dy=dy/s;
					}
					
					
					_root.wetplay.PlaySFX("sfx_boing",0);
				
					up.tards[0].state="bounce";
					up.tards[0].bounce_wait=10;
					up.tards[0].vx=-dx*30;
					up.tards[0].vy=dy*30;
					
					mc._xscale=150;
					mc._yscale=150;
				}
			}
			
		break;
		case "inout":

			if(active)
			{
				if(!mc.mc)
				{
					mc.mc=gfx.add_clip(up.imc,"whirl",null);
					mc.mc._xscale=50;
					mc.mc._yscale=50;
					mc.mc._alpha=10;
					mc.mc._x=mc._x;
					mc.mc._y=mc._y;
				}
				
				mc.mc._rotation-=10;
				if(mc.mc._rotation<0) { mc.mc._rotation+=360; }
			
			
				dx=mc._x-up.tards[0].mc._x;
				dy=mc._y-(up.tards[0].mc._y-30);
				ss=(dx*dx)+(dy*dy);
				
				if((ss)<(50*50))
				{
					if((other)&&(up.tards[0].state!="inout"))
					{
//						up.tards[0].px=other.x*20+10;
//						up.tards[0].py=other.y*20+10;
						up.tards[0].state="inout";
						up.tards[0].inout_from=this;
						up.tards[0].inout_to=other;
						up.tards[0].inout_frame=0;
						
						up.tards[0].talk.display("Wheee!",50);
					}
				}
			}
			
		break;
		case "whirl":

			if(active)
			{
				mc._rotation-=10;
				if(mc._rotation<0) { mc._rotation+=360; }
				
				dx=mc._x-up.tards[0].mc._x;
				dy=mc._y-(up.tards[0].mc._y-30);
				
				if( up.tards[0].anim=="splat" ) // allow ducking
				{
					dy-=30;
				}
				
				ss=(dx*dx)+(dy*dy);
				
				if(flavour=="thrown")
				{
					if(mc.vx==null)
					{
						s=Math.sqrt(ss); if(s==0) { s=1; }
						mc.vx=-12*dx/s;
						mc.vy=-12*dy/s;
					}
					
					mc._rotation-=10;
				}
				else
				{
					if(dx<0) {mc.vx+=0.1}
					if(dx>0) {mc.vx-=0.1}
					if(dy<0) {mc.vy+=0.1}
					if(dy>0) {mc.vy-=0.1}
					
					if(mc.vx<-2) { mc.vx=-2; }
					if(mc.vx> 2) { mc.vx= 2; }
					if(mc.vy<-2) { mc.vy=-2; }
					if(mc.vy> 2) { mc.vy= 2; }
				}				
				
				mc._x+=mc.vx;
				mc._y+=mc.vy;
				
				x=mc._x/20;
				y=(600-mc._y)/20;
								
				
				if((ss)<(50*50))
				{
// find an out end that is as var away as pos

					max_other=null;
					max_ss=0;
					
					for(i=0;i<up.items.length;i++)
					{
						if( (up.items[i].type=="inout") && (up.items[i].active==false) )
						{
							dx=up.items[i].mc._x - mc._x;
							dy=up.items[i].mc._y - mc._y;
							ss=(dx*dx)+(dy*dy);
							if(ss>max_ss)
							{
								max_ss=ss;
								max_other=up.items[i];
							}
						}
					}

				
					if(max_other)&&(up.tards[0].state!="inout")
					{
//						up.tards[0].px=other.x*20+10;
//						up.tards[0].py=other.y*20+10;
						up.tards[0].state="inout";
						up.tards[0].inout_from=this;
						up.tards[0].inout_to=max_other;
						up.tards[0].inout_frame=0;
						up.tards[0].talk.display("Wheee!",50);
					}
				}
			}
			
		break;
		}
		
		return false;
	}

}