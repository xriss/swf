/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class Vtard2d
{
	var up;
	
	var mc;
	
	var flavour;
	var data;
	
	var minion;
	
	var frame;
	
	var anim;
	
	var dx,dy,dz; // display x,y,z can snap to 10px for animation
	
	var px,py,pz;
	var vx,vy,vz;
	
	var dest_rot;
	
	var cx,cy;		// current collision sqr
	
	var frame_wait;
	
	var state;
	
	var wet;
	
// splash stuff
	var wet_last;
	var wet_last_wait;
	
	var step_bool;
	
	var ignore_mouse;
	var bounce_wait;
	
	var inout_frame;
	var inout_from;
	var inout_to;
	
	var talk;
	var chat_id;
	
	
	function Vtard2d(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function dbgframe(s)	{	up.dbgframe(s);	}
	
	function setup(nam,_flavour)
	{
		chat_id=-1;
		
		flavour=_flavour;
		data={};
		
		mc=gfx.create_clip(up.mc,null);
		
		minion=new Minion(this);
		minion.setup(nam,50*1.0,94*1.0);
/*		
		tmc=gfx.add_clip(mc, nam ,null,-50*1.0,-90*1.0,100*1.0,100*1.0);
		tmc.cacheAsBitmap=true;
		tmc.scrollRect=new flash.geom.Rectangle(0*100, 0*100, 100, 100);
*/		
		dest_rot=0;
		
		px=0;
		py=0;
		pz=0;
		
		vx=0;
		vy=0;
		vz=0;
		
		frame=0;
		
		wet=0;
		wet_last=0;
		wet_last_wait=0;
		step_bool=0;
		
		anim="warp";
		
		state="jump";
		
		ignore_mouse=true;
		
		_root.poker.clear_clicks();
		
		update();
	}
	
	function clean()
	{
		mc.removeMovieClip();
	}

	
	function update_talker()
	{
	var ff;
	var ch;
	
	
		if(up.gamemode=="story") // only do the talky thing in story mode
		{
			if(up.chat_idx<up.chat.length)
			{
				ch=up.chat[up.chat_idx];
			}
			else
			{
				ch=null;
			}
		}
		else
		{
			chat_id=0;
			ch=null;
		}

		if(up.chat_idx<0) // setupframe
		{
			if(chat_id==0)
			{
			
				if(data.done_setup)
				{
					up.chat_idx=0;
					up.chat_tim=0;
				}
				else
				{
					data.done_setup=true;
				}
			}
			
			data.frame_wait=0;
			data.frame=0;
			data.anim="idle";
		}
		else
		if(ch)
		{

			if( ch.id == chat_id )
			{
				if(ch.txt)
				{
					talk.display(ch.txt,2);
				}
				
				if(ch.anim=="rotoff") // check for special anim types
				{
					if(data.chatstate!="rotoff")
					{
						dest_rot=0;
						data.dd=true;
						data.dx=0;
						data.dy=620;
						data.chatstate="rotoff";
						data.anim="idle";
					}
				}
				else
				if(ch.anim=="start")
				{
					if(data.chatstate!="start")
					{
//						state="jump";
						data.chatstate="start";
						data.anim="idle";
						
						if(flavour=="chucker")
						{
							data.idlefor=25*3;
						}						
					}
				}
				else
				if(ch.anim=="roton")
				{
					if(data.chatstate!="roton")
					{
						dest_rot=90+30;
						
						px=0;
						py=600;
						data.dd=true;
						data.dx=20;
						data.dy=600;
						
						mc._xscale=200;
						mc._yscale=200;
						
						data.chatstate="roton";
						data.anim="idle";
					}
				}
				else
				{
					data.anim=ch.anim;
				}
			}
				
			if(chat_id==0)
			{		
				up.chat_tim++;
				
				if(_root.replay.key&(Replay.KEYM_UP|Replay.KEYM_DOWN|Replay.KEYM_LEFT|Replay.KEYM_RIGHT) ) // moving speeds up the text
				{
					up.chat_tim+=4;
				}
				
				if	(
						( up.chat_tim >= ch.tim )
						||
						(
							_root.poker.anykey // anykey or mouse press ends this text
							&&
							(	// except the curser movement keys
								!(_root.replay.key&(Replay.KEYM_UP|Replay.KEYM_DOWN|Replay.KEYM_LEFT|Replay.KEYM_RIGHT))
							)
						)
					)
				{
					up.chat_idx++;
					up.chat_tim=0;
				}
			}
		}
		else
		{
			if(data.chatstate=="rotoff")
			{
				if( (mc._rotation-dest_rot)*(mc._rotation-dest_rot) < 4 )
				{
					mc._visible=false;
				}
			}
		}
		
		if(data.dd)
		{
			mc._rotation=(mc._rotation*15+dest_rot*1)/16;
// use dx as destination in this mode...
			px=(px*15+data.dx*1)/16;
			py=(py*15+data.dy*1)/16;
		}
		
		data.frame_wait++;
		if(data.frame_wait>8)
		{
			data.frame+=1;
			data.frame_wait=0;
		}
		
		
		if( (data.chatstate=="roton")||(data.chatstate=="rotoff") )
		{
			mc._x=up.x2+px;
			mc._y=up.y2-py;
			minion.display(data.anim,data.frame);
			return true;
		}
		
		return false;
	}
	
	var last_poke;
	function update()
	{
	var f;
	var nx,ny,nz;
	var ncx,ncy;
	var vvx,vvy,vv;
	
	var kup,kdn,klt,krt;

		if( update_talker() )
		{
			return;
		}

		if(flavour=="chucker")
		{
			kup=false;
			kdn=false;
			klt=false;
			krt=false;
			
			if((data.chatstate=="start") || (up.gamemode=="race") )// wait for talking to finish
			{
				if(data.idlefor>0)
				{
					if(data.idlefor>25*2.2)
					{
						data.anim="idle";
					}
					else
					if(data.idlefor>25*2)
					{
						data.anim="angry";
					}
					else
					if(data.idlefor>25*2-1)
					{
						data.anim="energetic";
						
						data.whirl1.mc._x=up.x2+px;
						data.whirl1.mc._y=up.y2-py;
						
						data.whirl1.mc.vx=null; // use as flag to reset towards player
						data.whirl1.mc.vy=null;
						
						data.whirl1.flavour="thrown";

						data.whirl1.activate();
						
						_root.wetplay.PlaySFX("sfx_wikwikwik",0);
					}
					else
					{
						data.anim="idle";
					}
					data.idlefor--;
				}
				else
				{
					if(data.vx>=0)
					{
						data.vx=1;
						krt=true;
					}
					else
					{
						data.vx=-1;
						klt=true;
					}
					
					if(state=="onfloor") // skip :)
					{
						kup=true;
					}
					
					if(px>800-60)
					{
						if(data.vx!=-1)
						{
							data.vx=-1;
							data.idlefor=25*3;
							krt=false;
							klt=false;
						}
					}
					if(px<60)
					{
						if(data.vx!=1)
						{
							data.vx=1;
							data.idlefor=25*3;
							krt=false;
							klt=false;
						}
					}
				}
			}
		}
		else
		{
	// read keys/mouse	
			kup=_root.replay.key&Replay.KEYM_UP?true:false;
			kdn=_root.replay.key&Replay.KEYM_DOWN?true:false;
			klt=_root.replay.key&Replay.KEYM_LEFT?true:false;
			krt=_root.replay.key&Replay.KEYM_RIGHT?true:false;
					
			if(kup||kdn||klt||krt) // ignore mouse since we are pressing keys
			{
				ignore_mouse=true;
			}
			
			if(Selection.getCaretIndex()!=-1) // actually ignore keys when a text box is selected
			{
				kup=false;
				kdn=false;
				klt=false;
				krt=false;
			}
			
			if(!ignore_mouse)
			{
				krt=krt||(mc._xmouse> 20?true:false);
				klt=klt||(mc._xmouse<-20?true:false);
			}
			
			if(_root.poker.poke_now)
			{
				if(up.mc._xmouse>0)&&(up.mc._ymouse>0)&&(up.mc._xmouse<800)&&(up.mc._ymouse<600) // only if click on screen
				{
					ignore_mouse=false; // use mouse for left/right
				}
				
				if(!ignore_mouse)
				{
					if(last_poke==0) // up/down remembered and retained on first press
					{
						if(mc._ymouse<=0)
						{
							last_poke=1;
						}
						else
						{
							last_poke=-1;
						}
					}
					
					kup=kup||(last_poke== 1?true:false);
					kdn=kdn||(last_poke==-1?true:false);
				}
				else
				{
					last_poke=0;
				}
			}
			else
			{
				last_poke=0;
			}
		}
			
			
		if(state=="inout") // do warp
		{
		var s;
		var dx,dy;
		
			if(inout_frame==0)
			{
				_root.wetplay.PlaySFX("sfx_wikwikwik",0);
			}
			else
			if(inout_frame==25)
			{
				_root.wetplay.PlaySFX("sfx_teleport",0);
			}
			
			if(inout_frame<25)
			{
				minion.display("scared",0);
//				tmc.scrollRect=new flash.geom.Rectangle(4*100, 5*100, 100, 100);
				
				s=((25-inout_frame)*4)/100;
				
				dx=(inout_from.x*20+10)-px;
				dy=(inout_from.y*20+10)-py;
			
				mc._x=up.x2+(px+dx*(1-s));
				mc._y=up.y2-(py+dy*(1-s));
				
				mc._xscale=s*100;
				mc._yscale=s*100;
				mc._rotation=s*360;
			}
			else
			if(inout_frame<50)
			{
				minion.display("excited",0);
//				tmc.scrollRect=new flash.geom.Rectangle(7*100, 4*100, 100, 100);
				
				s=((inout_frame-25)*4)/100;
				
				px=inout_to.x*20+10;
				py=inout_to.y*20+10;
				
				mc._x=up.x2+px;
				mc._y=up.y2-py;
				
				mc._xscale=s*100;
				mc._yscale=s*100;
				mc._rotation=s*360;
			}
			else
			{
				vx=0;
				vy=0;
				dx=px;
				dy=py;
				mc._xscale=100;
				mc._yscale=100;
				mc._rotation=0;
				state="jump";
				anim="warp";
			}
			inout_frame++;
			return;
		}

		if(state=="bounce")
		{
			if(bounce_wait>0)
			{
				bounce_wait--;
			}
			
			if(bounce_wait==0)
			{
				if(kup||kdn||klt||krt)
				{
					state="jump";
				}
			}
		}
		else
		{
		
			vx=0;
							
			if(kup)
			{
				if(wet==1)
				{
					if(state=="onfloor")
					{
						vy=12;
						if(flavour!="chucker")
						{
							_root.wetplay.PlaySFX("sfx_jump",0);
						}
					}
					state="jump";
				}
				else
				{
					if(state=="onfloor")
					{
						state="jump";
						vy=12;
						if(flavour!="chucker")
						{
							_root.wetplay.PlaySFX("sfx_jump",0);
						}
					}
				}
			}
			
			if(vx>20)  { vx=20;  }
			if(vx<-20) { vx=-20; }
			if(vy>20)  { vy=20;  }
			if(vy<-20) { vy=-20; }
			
			if( (kdn) && (state=="onfloor") )
			{
//			anim="splat";

				if( (up.getcol(cx,cy-1,1)!=0) && (up.getcol(cx,cy-2,1)==0) )
				{
					py=py-1;
					state="jump";
				}
			}
			else
			if(klt)
			{
				if(wet==1)
				{
					if(state=="onfloor")
					{
						vx=-3;
					}
					else
					{
						vx=-2;
					}
				}
				else
				{
					vx=-5;
				}
			}
			else
			if(krt)
			{
				if(wet==1)
				{
					if(state=="onfloor")
					{
						vx=3;
					}
					else
					{
						vx=2;
					}
				}
				else
				{
					vx=5;
				}
			}
			else
			{
			}
		}
		
// check collison, between cx,cy and ncx,ncy

/*
		if(bounce_wait>0) // move through everything?
		{
			px+=vx;
			py+=vy;
		}
		else
*/
		{
		
		vv=Math.floor((Math.sqrt(vx*vx+vy*vy))/20)*2+1;
		
		if(vv>0)
		{
		var vs;
		var vcx,vcy;
		var vpx,vpy;
		var tcx,tcy;
		var lcx,lcy;
		
		var first_col;
		var lid,nid;
		
			vvx=vx/vv;
			vvy=vy/vv;
		
/*
			dbgframe("vv :"+vv+"<br>");
			dbgframe("vvx :"+vvx+"<br>");
			dbgframe("vvy :"+vvy+"<br>");
*/
			while(vv>0)
			{
				lcx=Math.floor((px)/20);
				lcy=Math.floor((py)/20);
				lid=up.getcol(lcx,lcy,1); // last type
				
				ncx=Math.floor((px+vvx)/20);
				ncy=Math.floor((py+vvy)/20);
					
				if(lcx!=ncx)// x cell move
				{
//					dbgframe("xcell<br>");
			
					nid=up.getcol(ncx,lcy,1); // next type
										
					if( ( (lid==0) && (nid!=0) ) || (nid==1) ) // hit edge
					{
						if(vvx>0) // right edge
						{
							px=lcx*20+19;
						}
						else
						if(vvx<0) // left edge
						{
							px=lcx*20;
						}
						
						vvx=0;
						if(state=="bounce") { state="jump"; }
					}
					else
					{
						px+=vvx;
					}
				}
				else
				{
					px+=vvx;
				}
				
				
				if(lcy!=ncy) // y cell move
				{
					
					lcx=Math.floor((px)/20);
					lid=up.getcol(lcx,lcy,1); // last type
					nid=up.getcol(lcx,ncy,1); // next type
					
//					dbgframe("ycell "+lcx+","+lcy+" : "+lid+"<br>");
//					dbgframe("ycell "+ncx+","+ncy+" : "+nid+"<br>");
					
					if(vvy>=0) // upwards always allowed
					{
						py+=vvy;
					}
					else
					{
						if( ( (lid==0) && (nid!=0) ) || (nid==1) ) // hit edge
						{
							py=lcy*20;
							vy=0;
							vvy=0;
							
							if(state!="onfloor") // landing
							{
								if(wet)
								{
//									_root.wetplay.PlaySFX("sfx_splash",1,0,0.25);
								}
								else
								{
									if(flavour!="chucker")
									{
										_root.wetplay.PlaySFX("sfx_step",0);
									}
								}
								step_bool=4;//wait a bit?
							}
							state="onfloor";
						}
						else
						{
							py+=vvy;
						}
					}
				}
				else
				{
					py+=vvy;
				}
				
				vv--;
			}
		}
		}

// snap position the above may have caused some icky rounding errors

		px=Math.floor(px+0.5);
		py=Math.floor(py+0.5);
		
// check we are still standing on something

		cx=Math.floor((px)/20);
		cy=Math.floor((py)/20);
		
		if(state=="onfloor")
		{
			if( (up.getcol(cx,cy,1)==0) && (up.getcol(cx,cy-1,1)!=0) )
			{
			}
			else
			if(up.getcol(cx,cy-1,1)==1)
			{
			}
			else
			{
				state="jump";
			}
		}

// stay wet until we touch dry floor...		
//		if(state=="onfloor") { wet=0; }		
//		if(wet!=1) { wet=up.getwet(cx,cy)==1?1:0; }
		
		wet=up.getwet(cx,cy)==1?1:0;
		
// should we play a splash?

		if(wet_last!=wet) // transition in or out of water
		{
			wet_last=wet;
			
			if(wet)
			{				
				_root.wetplay.PlaySFX("sfx_splash",1,0,1-(wet_last_wait/50));				
				wet_last_wait=50;
			}
		}
		
		if(wet_last_wait>0) { wet_last_wait--; }
		
		
// warp or clip at sides of screen?
		
		while(px<up.x3_min)		{ px+=800;	anim="warp"; }
		while(px>up.x3_max)		{ px-=800;	anim="warp"; }
		
		while(py<up.y3_min)		{ py+=600;	anim="warp"; }
/*
		while(pz<up.z3_min)		{ pz+=0;	anim="warp"; }
		
		while(py>up.y3_max)		{ py-=600;	anim="warp"; }
		while(pz>up.z3_max)		{ pz-=0;	anim="warp"; }
*/		

		
		
		nx=Math.floor((px+5)/10)*10;
		ny=Math.floor((py+5)/10)*10;
		nz=Math.floor((pz+5)/10)*10;
		
		if(anim=="warp")
		{
			dx=nx;
			dy=ny;
			dz=nz;
			
			cx=ncx;
			cy=ncy;
		}
		
		
// make bubbles?
		if( up.getwet( Math.floor((px)/20) , Math.floor((py+40)/20) ) == 1 )
		{
			if((up.frame%20)==0)
			{
				up.blub_add(px,600-py-40);
			}
		}
		
		if(state=="jump")
		{
//			if(up.getwet(cx,cy)==1)
			if(wet)
			{
				if(kup)
				{
					vy+=2;
				}
				else
				{
					vy-=1;
				}
				vx*=3/4;
				vy*=3/4;
			}
			else
			{
				if(kup)
				{
					if(vy>0)
					{
						vy-=5/8;
					}
					else
					{
						vy-=1;
					}
				}
				else
				{
					vy-=3;
				}
				vx*=31/32;
				vy*=31/32;
			}
		}
		else
		if(state=="bounce")
		{
//			if( up.getwet(cx,cy)==1 ) // slowdown whilst really in water
			if(wet)
			{
				vy-=1;
				vx*=3/4;
				vy*=3/4;
			}
			else
			{
				vy-=3;
				vx*=31/32;
				vy*=31/32;
			}
		}
/*		
		if( up.getwet(cx,cy)==1 ) // slowdown whilst really in water
		{
			if(vy< -2) { vy= -2; }
			if(vy> 10) { vy= 10; }
			if(vx> 10) { vx= 10; }
			if(vx<-10) { vx=-10; }
		}
*/
		
		if( (kdn)&&(state=="onfloor") )
		{
			anim="splat";
		}
		else
		if((vx==0))
		{
			if(anim!="idle")
			{
				frame=frame%6;
				frame_wait=0;
	
				anim="idle";
				dx=nx;
				dy=ny;
				dz=nz;
			}
		}
		else
		if(vx*vx) // left-right
		{
			if(vx>0) //right
			{
				if(anim!="right")
				{
					frame=frame%8;
					if(frame<4)	{ frame=1; }
					else		{ frame=5; }
					anim="right";
					frame_wait=0;
					dx=nx;
					dy=ny;
					dz=nz;
				}
			}
			else // left
			{
				if(anim!="left")
				{
					frame=frame%8;
					if(frame<4)	{ frame=1; }
					else		{ frame=5; }
					anim="left";
					frame_wait=0;
					dx=nx;
					dy=ny;
					dz=nz;
				}
			}
		}
		else // in or out
		{
		}
		
		var fp;
		var ff;
		
		switch(anim)
		{
			case "idle": // animation is handled in the talky script stuff
			
				minion.display(data.anim,data.frame);
/*			
				frame_wait++;
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				
				dx=nx;
				dy=ny;
				dz=nz;
				
				frame=frame%6;
//				ff=frame;
//				if(ff>3) { ff=6-ff; }
				
				minion.display("idle",frame);
//				tmc.scrollRect=new flash.geom.Rectangle(ff*100, 3*100, 100, 100);
*/			
			break;
			
			case "left":
						
				frame_wait++;
					
				if((wet!=1)&&((state=="jump")||(state=="bounce"))&&((frame==4)||(frame==0))) // lock animation here while in air
				{
				}
				else
				{
					fp=(nx-dx)/-10;
					if(fp!=0)
					{
						frame+=fp;
						frame_wait=0;
					}
					if(frame_wait>3)
					{
						frame+=1;
						frame_wait=0;
					}
				}
				
				frame=frame%8;				
				
				dx=nx;
				dy=ny;
				dz=nz;
				
				minion.display("left",frame);
//				tmc.scrollRect=new flash.geom.Rectangle(frame*100, 1*100, 100, 100);
			
					
				if((frame==1)||(frame==5))
				{
					if(step_bool==0)
					{
						if(state=="onfloor")
						{
							if(wet)
							{
								_root.wetplay.PlaySFX("sfx_splash",1,0,0.25);
							}
							else
							{
								if(flavour!="chucker")
								{
									_root.wetplay.PlaySFX("sfx_step",0);
								}
							}
						}
					}
					step_bool=1;
				}
				else
				{
					if(step_bool>0) { step_bool--; };
				}
				
			break;
			
			case "right":
							
				frame_wait++;
					
				if((wet!=1)&&((state=="jump")||(state=="bounce"))&&((frame==4)||(frame==0))) // lock animation here while in air
				{
				}
				else
				{
					fp=(nx-dx)/ 10;
					if(fp!=0)
					{
						frame+=fp;
						frame_wait=0;
					}
					if(frame_wait>3)
					{
						frame+=1;
						frame_wait=0;
					}
				}
				
				frame=frame%8;
				
				dx=nx;
				dy=ny;
				dz=nz;
				
				minion.display("right",frame);
//				tmc.scrollRect=new flash.geom.Rectangle(frame*100, 0*100, 100, 100);
				
				if((frame==1)||(frame==5))
				{
					if(step_bool==0)
					{
						if(state=="onfloor")
						{
							if(wet)
							{
								_root.wetplay.PlaySFX("sfx_splash",1,0,0.25);
							}
							else
							{
								_root.wetplay.PlaySFX("sfx_step",0);
							}
						}
					}
					step_bool=1;
				}
				else
				{
					if(step_bool>0) { step_bool--; };
				}
				
			break;
			
			case "splat":
				minion.display("splat",0);
//				tmc.scrollRect=new flash.geom.Rectangle(4*100, 3*100, 100, 100);
			break;
		}
		
		if( (anim=="idle") || (anim=="splat") || (state=="jump") || (state=="bounce") )
		{			
			mc._x=up.x2+px;
			mc._y=up.y2-py;
		}
		else
		{
			mc._x=up.x2+dx;
			mc._y=up.y2-dy;
		}
		
		
		
/*
		dbgframe("state :"+state+"<br>");
		dbgframe("anim :"+anim+"<br>");
		dbgframe("vtpos :"+px+","+py+"<br>");
		dbgframe("vtvel :"+vx+","+vy+"<br>");
*/
	}	
}