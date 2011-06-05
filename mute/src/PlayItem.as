/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


#TARDCOUNT=#(xtra.dir("art/tard/*.png"))
#--*/ silly highlighter got confuzzled

#if VERSION_SITE=="pepere" then
#TARDCOUNT=1
#end

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
	
	var pickup_wait;
	
	var xscore;

	var finalx,finaly;
		
	function PlayItem(_up,_x,_y,_type)
	{
		up=_up;
		
		xscore=1;
		
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
		case "mute_m":
		case "mute_u":
		case "mute_t":
		case "mute_e":

			mc=gfx.create_clip(up.mc,null);
			switch(type)
			{
				case "mute_m": mc.mc=gfx.add_clip(mc,"obj_mute_m",null,0,-20); finalx=800-270; finaly=100-2400; break;
				case "mute_u": mc.mc=gfx.add_clip(mc,"obj_mute_u",null,0,-20); finalx=800-200; finaly=100-2400; break;
				case "mute_t": mc.mc=gfx.add_clip(mc,"obj_mute_t",null,0,-20); finalx=800-130; finaly=100-2400; break;
				case "mute_e": mc.mc=gfx.add_clip(mc,"obj_mute_e",null,0,-20); finalx=800-60; finaly=100-2400; break;
			}
			mc._xscale=100*30/50;
			mc._yscale=100*30/50;
			
			mc._x=10+_x*20;
			mc._y=590-_y*20;
			mc.vx=0;
			mc.vy=0;
			mc.atrest=false;
			
			gfx.glow(mc , 0xffffff, .8, 16, 16, 1, 3, false, false );
			
			mc.gotoAndStop(1);
			active=true;
			
			pickup_wait=0;
			
		break;

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

		
			mc=gfx.add_clip(up.imc,"obj_tard_"+ ((up.rndg()%#(TARDCOUNT))+1)	,null);
//			mc=gfx.add_clip(up.imc,"bumper"	,null);
			mc._xscale=100;
			mc._yscale=100;
			mc._alpha=100;
			mc._x=10+_x*20;
			mc._y=590-_y*20;
			
			mc.gotoAndStop(1);
			
			mc.cacheAsBitmap=true;
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
		if(up.gen_talk.origin_mc==mc)
		{
			up.gen_talk.origin_mc=null;
		}
		mc.removeMovieClip();
	}

	function update()
	{
	var dx,dy,ss,s;
	var i,max_ss,max_other,it,l;
//		frame++;
		
		switch(type)
		{
		case "mute_m":
		case "mute_u":
		case "mute_t":
		case "mute_e":
		
			if(active)
			{
				if(pickup_wait>0) { pickup_wait--; }
				
				if(pickup_wait==0)
				{
					dx=mc._x-up.tards[0].mc._x;
					dy=mc._y-(up.tards[0].mc._y-30);
					
					if(((dx*dx)+(dy*dy))<(50*50))
					{
						if(up.tards[0].hold==null)
						{
							_root.wetplay.PlaySFX("sfx_step",2);
									
							mc.swapDepths(0x1000);
							up.tards[0].hold=this;
							up.tards[0].ignore_jump=true; // wait to release jump before we chuck
						}
					}
				}
				
// do fizix	
				if( up.tards[0].hold!=this)
				{
					if(!mc.atrest)
					{
						mc.vy+=1;
						
						
						for(i=0;i<up.items.length;i++) // check bounces
						{
							it=up.items[i];
							
							if((it.type=="bump")&&(it.active)&&(it.escount<100))
							{
								dx=mc._x-it.mc._x;
								dy=mc._y-it.mc._y;
								ss=(dx*dx)+(dy*dy);
								
								if((ss)<(50*50))
								{
									it.escount+=25;
									
									s=Math.sqrt(ss);
									
									if(s>0)
									{
										dx=dx/s;
										dy=dy/s;
									}
									
									_root.wetplay.PlaySFX("sfx_jar",2);
								
									mc.vx=dx*10;
									mc.vy=dy*10;
									
									it.mc._xscale=150;
									it.mc._yscale=150;
									
									it.active=false;
									
									it.xscore=xscore;
									
									xscore+=1;
									pickup_wait=0;
									
//									it.whine();
									
								}
							}
						}
						
						
						fizix_move()

//						mc._x+=mc.vx;
//						mc._y+=mc.vy;
					}
					else
					{
						if(mc._y<=-2260) // got it to top
						{
							active=false;
							
						var p={};
						
							p.x=0;
							p.y=0;
							mc.localToGlobal(p);
							up.up.over.mc.globalToLocal(p);
							up.up.over.add_floater("<b>2048</b><font size=\"12\">pts</font>",p.x,p.y);
							up.score+=2048;
							up.mute+=1;
							_root.wetplay.PlaySFX("sfx_jar",1);
						}
					}
				}
	
			}
			else // float to finalx,finaly
			{
				mc._x=finalx;
				mc._y=finaly;
				mc._xscale=100*60/50;
				mc._yscale=100*60/50;
			}
			
		break;
		
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
					
					whine();
				}
			}
			
			if(!active)
			{
			var p={};
//			var dx,dy
			
				p.x=0;
				p.y=0;
				mc.localToGlobal(p);
				up.up.over.mc.globalToLocal(p);
			
				for(i=5;i>0;i--)
				{
					dx=16*((up.rndg()-0x8000)/0x8000);
					dy=8*((up.rndg()-0x8000)/0x8000)-32;
					l=FieldItem.hard_launch(up.up.over, "ether", p.x,p.y , dx, dy );
				}
				
				up.up.over.add_floater("<b>"+(128*xscore)+"</b><font size=\"12\">pts</font>",p.x,p.y);
				
				up.score+=(128*xscore);
			
				return true; // disable and remove
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
	
	
	function getcol(x,y,s)
	{
		return up.getcol(x-(up.x2/20),-(y-(up.y2/20)),s);
	}
	
	function fizix_move()
	{
	var	vv=Math.floor((Math.sqrt(mc.vx*mc.vx+mc.vy*mc.vy))/20)*2+1;
		
	var vvx=mc.vx;
	var vvy=mc.vy;
	
	var ncx;
	var ncy;
	
		
		if(vv>0)
		{
		var vs;
		var vcx,vcy;
		var vpx,vpy;
		var tcx,tcy;
		var lcx,lcy;
		
		var first_col;
		var lid,nid;
		
		
			vvx=mc.vx/vv;
			vvy=mc.vy/vv;
		
/*
			dbgframe("vv :"+vv+"<br>");
			dbgframe("vvx :"+vvx+"<br>");
			dbgframe("vvy :"+vvy+"<br>");
*/
			while(vv>0)
			{
				lcx=Math.floor((mc._x)/20);
				lcy=Math.ceil((mc._y)/20);
				lid=getcol(lcx,lcy,1); // last type
				
				ncx=Math.floor((mc._x+vvx)/20);
				ncy=Math.ceil((mc._y+vvy)/20);
					
				if(lcx!=ncx)// x cell move
				{
//					dbgframe("xcell<br>");
			
					nid=getcol(ncx,lcy,1); // next type
										
					if( ( (lid==0) && (nid!=0) ) || (nid==1) ) // hit edge
					{
						if(vvx>0) // right edge
						{
							mc._x=lcx*20+19;
						}
						else
						if(vvx<0) // left edge
						{
							mc._x=lcx*20;
						}
						
						vvx=0;
						mc.vx=0;
//						if(state=="bounce") { state="jump"; }
					}
					else
					{
						mc._x+=vvx;
					}
				}
				else
				{
					mc._x+=vvx;
				}
				
				
				if(lcy!=ncy) // y cell move
				{
					
					lcx=Math.floor((mc._x)/20);
					lid=getcol(lcx,lcy,1); // last type
					nid=getcol(lcx,ncy,1); // next type
					
//					dbgframe("ycell "+lcx+","+lcy+" : "+lid+"<br>");
//					dbgframe("ycell "+ncx+","+ncy+" : "+nid+"<br>");
					
					if(vvy<=0) // upwards always allowed
					{
						mc._y+=vvy;
					}
					else
					{
						if( ( (lid==0) && (nid!=0) ) || (nid==1) ) // hit edge
						{
							mc._y=lcy*20;
							mc.vy=0;
							vvy=0;
							
//							if(state!="onfloor") // landing
//							{
//							}
//							state="onfloor";

							_root.wetplay.PlaySFX("sfx_step",0);
										
							mc.atrest=true;
							xscore=1;
						}
						else
						{
							mc._y+=vvy;
						}
					}
				}
				else
				{
					mc._y+=vvy;
				}
				
				vv--;
			}
		}
	}
	
	function chuck(cxv)
	{
		pickup_wait=10;
		
		mc.vx=cxv*8;
		mc.vy=-1*12;
		
		mc.atrest=false;
	
	}
	
	function whine()
	{
	
		up.gen_talk.origin_mc=mc;
		
		up.gen_talk.display(tard_lines[ up.rndg()%(tard_lines.length-1) ],25);

	}

	static var tard_lines=[
#for line in io.lines("src/tard.txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];

}