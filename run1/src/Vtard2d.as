/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#SPEED=2.0

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
	
	var hold;
	var chuckxv;
	var ignore_jump;
	
	function Vtard2d(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function dbgframe(s)	{	up.dbgframe(s);	}
	
	function setup(nam,_flavour)
	{
		chat_id=-1;
		
		hold=null;
		chuckxv=1;
		ignore_jump=false;
		
		flavour=_flavour;
		data={};
		
		mc=gfx.create_clip(up.mc,null);
		
		minion=new Minion(this);
		minion.setup(nam,50*1.0,94*1.0);
		
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

	
	
	var last_poke;
	function update()
	{
	var f;
	var nx,ny,nz;
	var ncx,ncy;
	var vvx,vvy,vv;
	
	var kup,kdn,klt,krt;

	// read keys/mouse	
			kup=_root.replay.key&Replay.KEYM_UP?true:false;
			kdn=_root.replay.key&Replay.KEYM_DOWN?true:false;
			klt=_root.replay.key&Replay.KEYM_LEFT?true:false;
			krt=_root.replay.key&Replay.KEYM_RIGHT?true:false;

/*			
			if(kup||kdn||klt||krt) // ignore mouse since we are pressing keys
			{
				ignore_mouse=true;
			}
							
			if(!ignore_mouse)
			{
				krt=krt||(mc._xmouse> 20?true:false);
				klt=klt||(mc._xmouse<-20?true:false);
			}
			
			if(_root.poker.poke_now)
			{
				ignore_mouse=false; // use mouse for left/right
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
*/
			
			if(krt) { chuckxv= 1; }
			if(klt) { chuckxv=-1; }
			
			if(ignore_jump) // wait till we release jump before we jump again
			{
				if(kup) { kup=false; }
				else ignore_jump=false;
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
		
//			vx=0;
							
			if(kup)
			{
				if(hold)
				{
					_root.wetplay.PlaySFX("sfx_jump",0);
								
					hold.chuck(chuckxv);
					
					ignore_jump=true;
					
					hold=null;
				}
				else
				{
					if(wet==1)
					{
						if(state=="onfloor")
						{
							vy=-12*#(SPEED);
							_root.wetplay.PlaySFX("sfx_jump",0);
						}
						state="jump";
					}
					else
					{
						if(state=="onfloor")
						{
							state="jump";
							vy=-12*#(SPEED);
							_root.wetplay.PlaySFX("sfx_jump",0);
						}
					}
				}
			}
			
			if(vx>20*#(SPEED))  { vx=20*#(SPEED);  }
			if(vx<-20*#(SPEED)) { vx=-20*#(SPEED); }
			if(vy>20*#(SPEED))  { vy=20*#(SPEED);  }
			if(vy<-20*#(SPEED)) { vy=-20*#(SPEED); }
			
			if( (kdn) && (state=="onfloor") )
			{
//			anim="splat";

				if( (up.getcol(cx,cy+1,1)!=0) && (up.getcol(cx,cy+2,1)==0) )
				{
					py=py+1;
					state="jump";
				}
				vx=vx*8/16;
			}
			else
			if(krt)
			{
				if(vx<0) { vx=0; }
				vx+=1*#(SPEED);
			}
			else
			if(klt)
			{
				if(vx>0) { vx=0; }
				
				vx-=1*#(SPEED);
			}
			else
			if(state=="onfloor")
			{
				vx=vx*10/16;
			}
			
			vx=vx*15/16;
		}

// clamp to 0 when going slow
		
		if((vx*vx)<1) {vx=0;}
		if((vy*vy)<1) {vy=0;}
		
		
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
						if(up.getcol(ncx,lcy-1,1)==0) // step up
						{
							px+=vvx;
							py=(lcy-1)*20+19;
							
							lcx=Math.floor((px)/20);
							lcy=Math.floor((py)/20);
							lid=up.getcol(lcx,lcy,1); // last type
							
							ncx=Math.floor((px+vvx)/20);
							ncy=Math.floor((py+vvy)/20);
						}
						else
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
							vx=0;
							if(state=="bounce") { state="jump"; }
						}
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
					
					if(vvy<=0) // upwards always allowed
					{
						py+=vvy;
					}
					else
					{
						if( ( (lid==0) && (nid!=0) ) || (nid==1) ) // hit edge
						{
							py=lcy*20+19;
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

// snap position the above may have caused some icky rounding errors

		px=Math.floor(px);
		py=Math.floor(py);
		
// check we are still standing on something

		cx=Math.floor((px)/20);
		cy=Math.floor((py)/20);
		
		if(state=="onfloor")
		{
			if( (up.getcol(cx,cy,1)==0) && (up.getcol(cx,cy+1,1)!=0) )
			{
			}
			else
			if(up.getcol(cx,cy+1,1)==1)
			{
			}
			else
			{
				state="jump";
			}
		}

		
		wet=up.getwet(cx,-cy)==1?1:0;

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
		
		
		if(state=="jump")
		{
			if(kup)
			{
				if(vy<0)
				{
					vy+=(5/8)*#(SPEED);
				}
				else
				{
					vy+=1*#(SPEED);
				}
			}
			else
			{
				vy+=3*#(SPEED);
			}
			vx*=31/32;
			vy*=31/32;
		}
		else
		if(state=="bounce")
		{
			vy+=3*#(SPEED);
			vx*=31/32;
			vy*=31/32;
		}
		
		if( (kdn)&&(state=="onfloor") )
		{
			anim="splat";
		}
		else
		if(/*(vx*vx)||*/(krt)||(klt)) // left-right
		{
			if(/*(vx>0)||*/(krt)) //right
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
		else
//		if((vx==0))
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
/*
		else // in or out
		{
		}
*/		
		var fp;
		var ff;
		
		switch(anim)
		{
			case "idle": // animation is handled in the talky script stuff
			
				frame_wait++;
				
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				
				minion.display("idle",frame);
				
			break;
			
			case "left":
						
				frame_wait++;
					
				if(((state=="jump")||(state=="bounce"))&&((frame==4)||(frame==0))) // lock animation here while in air
				{
				}
				else
				{
					fp=(nx-dx)/-10;
					if(fp!=0)
					{
						if(fp> 1) {fp= 1;}
						if(fp<-1) {fp=-1;}
						
						frame+=fp;
						frame_wait=0;
					}
					if(frame_wait>8)
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
					
				if(((state=="jump")||(state=="bounce"))&&((frame==4)||(frame==0))) // lock animation here while in air
				{
				}
				else
				{
					fp=(nx-dx)/ 10;
					if(fp!=0)
					{
						if(fp> 1) {fp= 1;}
						if(fp<-1) {fp=-1;}
						
						frame+=fp;
						frame_wait=0;
					}
					if(frame_wait>8)
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
				
				if((frame==1)||(frame==5))
				{
					if(step_bool==0)
					{
						if(state=="onfloor")
						{
							_root.wetplay.PlaySFX("sfx_step",0);
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
			break;
		}
		
		mc._x=up.x2+px;
		mc._y=up.y2+py;
				
		if(hold) // we are holding an item
		{
			hold.mc._x=mc._x;
			hold.mc._y=mc._y-80;
		}
		
		
		dbgframe("state :"+state+"<br>");
		dbgframe("anim :"+anim+"<br>");
		dbgframe("vtpos :"+showdigits(px,100)+","+showdigits(py,100)+"<br>");
		dbgframe("vtvel :"+showdigits(vx,100)+","+showdigits(vy,100)+"<br>");

	}	
	function showdigits(v,n)
	{
		return Math.round(v*n)/n;
	}
}