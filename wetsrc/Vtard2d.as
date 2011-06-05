/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2010
//
// This file made available under the terms of The MIT License : http://www.opensource.org/licenses/mit-license.php
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
///*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#SPEED=1.0

class Vtard2d
{
	var up;
	
	var mc;
	
	var flavour;
	var data;
	
	var minion;
	
	var frame;
	
	var anim;
	
	var dx,dy,dz; // display x,y,z (can snap to 10px for animation)
	
	var px,py,pz; // real position
	var vx,vy,vz; // real velocity
	
	var dest_rot;
	
	var cx,cy;		// current collision sqr
	
	var frame_wait;
	var frame_add;
	
	var state;
	
	var step_bool;
	
	var inout_frame;
	var inout_from;
	var inout_to;
	
	var overitem; // item we are standing on
	var hold;
	var chuckxv;
	var ignore_jump;
	
	var wait;
	var idle_anim;
	
	var ignore_items;
	var alow_air_jump;
	
	var fizix;
	
	var brain;
	var react;
	
	var fizix_base={ // max jumo , up 5 , accross 18 with run up
		jump_start:		22,
		splat_speed:	22,
		gravity_jump1:	6/8,
		gravity_jump2:	20/8,
		gravity:		24/8,
		left:			10/8,
		right:			10/8,
		friction_air:	29/32,
		friction_stop:	8/16,
		friction_down:	16/16,
		friction_splat:	29/32,
		max:			40
		};
	
	var fizix_heavy={ // max jumo , up 5 , accross 18 with run up
		jump_start:		11,
		splat_speed:	5,
		gravity_jump1:	6/8,
		gravity_jump2:	20/8,
		gravity:		24/8,
		left:			5/8,
		right:			5/8,
		friction_air:	29/32,
		friction_stop:	8/16,
		friction_down:	16/16,
		friction_splat:	29/32,
		max:			40
		};

	var fizix_slow={ // max jumo , up 5 , accross 18 with run up
		jump_start:		22,
		splat_speed:	22,
		gravity_jump1:	6/8,
		gravity_jump2:	20/8,
		gravity:		24/8,
		left:			6/8,
		right:			6/8,
		friction_air:	29/32,
		friction_stop:	8/16,
		friction_down:	16/16,
		friction_splat:	29/32,
		max:			40
		};

	var fizix_walk={ // max jumo , up 5 , accross 18 with run up
		jump_start:		22,
		splat_speed:	22,
		gravity_jump1:	6/8,
		gravity_jump2:	20/8,
		gravity:		24/8,
		left:			4/8,
		right:			4/8,
		friction_air:	29/32,
		friction_stop:	8/16,
		friction_down:	16/16,
		friction_splat:	29/32,
		max:			40
		};
		
	var fizix_light={ // max jumo , up 5 , accross 18 with run up
		jump_start:		33,
		splat_speed:	33,
		gravity_jump1:	6/8,
		gravity_jump2:	20/8,
		gravity:		24/8,
		left:			15/8,
		right:			15/8,
		friction_air:	29/32,
		friction_stop:	8/16,
		friction_down:	16/16,
		friction_splat:	29/32,
		max:			40
		};

	function Vtard2d(_up)
	{
		up=_up;
		
		fizix=fizix_base;
		
		react=new Vtard2d_react(this);
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function dbgframe(s)	{	up.dbgframe(s);	}
	
	function setup(nam,_flavour)
	{
		ignore_items=false;
		hold=null;
		chuckxv=1;
		ignore_jump=false;
		alow_air_jump=false;
		
		flavour=_flavour;
		data={};
		
		mc=gfx.create_clip(up.mc,null);
		
		minion=new Minion(this);
		minion.setup(nam,50,94);
		
		dest_rot=0;
		
		px=0;
		py=0;
		pz=0;
		
		vx=0;
		vy=0;
		vz=0;
		
		frame=0;
		
		step_bool=0;
		
		anim="warp";
		
		state="jump";
		
		idle_anim="idle";
		wait=0;
		
		update();
	}
	
	function clean()
	{
		mc.removeMovieClip();
	}

	
	
	var last_poke;
	function update(replay)
	{
	var f;
	var nx,ny,nz;
	var ncx,ncy;
	var vvx,vvy,vv;
	
	var kbt,kup,kdn,klt,krt,kup1;
	var kup_on,kbt_on;
	
		if(brain)
		{
			replay=brain.think();
		}
		else
		{
			if(!replay)
			{
				replay=_root.replay;
			}
		}
		
		if(react)
		{
			replay=react.think(replay); // replace replay dats with frced reactions?
		}

		kup_on=replay.key_on&Replay.KEYM_UP?true:false;
		kbt_on=replay.key_on&Replay.KEYM_FIRE?true:false;
		
	// read keys/mouse	
		kbt=replay.key&Replay.KEYM_FIRE?true:false;
		kup=replay.key&Replay.KEYM_UP?true:false;
		kdn=replay.key&Replay.KEYM_DOWN?true:false;
		klt=replay.key&Replay.KEYM_LEFT?true:false;
		krt=replay.key&Replay.KEYM_RIGHT?true:false;
		
/*
if(brain)
{
dbg.clear_tf();
dbg.print("left :"+klt);
dbg.print("right :"+krt);
}
*/

		if(up.focus.force) // hold still
		{
			kdn=false;
			klt=false;
			krt=false;
		}
		

		if(ignore_jump) // wait till we release jump before we jump again
		{
			if(kup) { kup=false; }
			else ignore_jump=false;
		}
		
		// the ignore_items flag is used to test if we are "active" or should be talked at on the way past
		if((kup)||(kbt))
		{
			ignore_items=true;
		}
		else
		{
			if(state=="onfloor")
			{
				ignore_items=false;
			}
			else
			{
				ignore_items=true;
			}
		}
						
		var skip_jump=false;
		if(kup_on )
		{
			skip_jump=overitem.jump();
			ignore_jump=skip_jump;
		}
		if(skip_jump)
		{
			ignore_items=false;
		}
		
		if(kup)
		{
			if( (state=="onfloor") || (alow_air_jump) ) // if we walk off of a platform we may perform an airjump
			{
				if(!skip_jump)
				{
					state="jump";
					vy=-fizix.jump_start;
					_root.sfx("jump");
					alow_air_jump=false;
				}
			}
			
		}
				
		if(state=="splat")
		{
			vx=vx*fizix.friction_splat;
			
			wait=wait-1.0;
			if(wait<=0)
			{
				state="onfloor";
				alow_air_jump=true;
			}
		}
		else		
		if( (kdn) && (state=="onfloor") )
		{
			var kdn_check=up.getcol(cx,cy+1,1);
			if( (kdn_check!=1) && (kdn_check!=0) && (up.getcol(cx,cy+2,1)==0) )
			{
				py=py+1;
				state="jump";
			}
			else
			{
				vx=vx*fizix.friction_down;
			}
		}
		else
		if(krt)
		{
			if(vx<0) { vx=0; }
			vx+=fizix.right;
		}
		else
		if(klt)
		{
			if(vx>0) { vx=0; }
			
			vx-=fizix.left;
		}
		else
		if(state=="onfloor")
		{
			vx=vx*fizix.friction_stop;
		}
		

		if(state=="onfloor")
		{
			vx=vx*fizix.friction_air;
			vy=0;
		}
		else		
		if(state=="jump")
		{
			if(kup)
			{
				if(vy<0)
				{
					vy+=fizix.gravity_jump1;
				}
				else
				{
					vy+=fizix.gravity_jump2;
				}
			}
			else
			{
				vy+=fizix.gravity;
			}
			vx*=fizix.friction_air;
			vy*=fizix.friction_air;
		}
		
// lmit maximum speed

		if(vx>fizix.max)  { vx=fizix.max;  }
		if(vx<-fizix.max) { vx=-fizix.max; }
		if(vy>fizix.max)  { vy=fizix.max;  }
		if(vy<-fizix.max) { vy=-fizix.max; }

// clamp to 0 when going slow
		
		if((vx*vx)<0.125*#(SPEED)) {vx=0;}
		if((vy*vy)<0.125*#(SPEED)) {vy=0;}
		
		
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
			while(vv>0)
			{
				lcx=Math.floor((px)/20);
				lcy=Math.floor((py)/20);
				lid=up.getcol(lcx,lcy,1); // last type
//dbg.print("tard :"+lcx+" , "+lcy+" = "+lid);
				
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
							
							if(state!="onfloor") // landing
							{
								_root.sfx("step");
//								_root.wetplay.PlaySFX("sfx_step",0);
									
								step_bool=4;//wait a bit?
								

								if(vy>fizix.splat_speed)
								{
									state="splat";
									wait=vy;
									_root.sfx("splat");
								}
								else
								{
									state="onfloor";
									alow_air_jump=true;
								}
							}
							
							py=lcy*20+19;
							vy=0;
							vvy=0;
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
		
		if( (state=="onfloor") || (state=="splat") )
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
		
		
		
		if( ( (kdn)&&(state=="onfloor") ) || (state=="splat") )
		{
			anim="splat";
		}
		else
		if((krt)||(klt)) // left-right
		{
			if((krt)) //right
			{
				if(anim!="right")
				{
					frame_add=0;
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
					frame_add=0;
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
				
				minion.display(idle_anim,frame);
				
			break;
			
			case "left":
						
				frame_wait++;
					
				if(((state=="jump")||(state=="bounce"))&&((frame==4)||(frame==0))) // lock animation here while in air
				{
				}
				else
				{
					frame_add+=( (nx-dx)/-20 );
					if(frame_add>=1)
					{
						frame+=1;
						frame_wait=0;
						frame_add=0;
						if((frame%4==0)&&(state=="onfloor"))
						{
							_root.sfx("step");
						}
					}
					if(frame_wait>8)
					{
						frame+=1;
						frame_wait=0;
						if((frame%4==0)&&(state=="onfloor"))
						{
							_root.sfx("step");
						}
					}
				}
				
				frame=frame%8;				
				
				dx=nx;
				dy=ny;
				dz=nz;
				
				minion.display("left",frame);
			
			break;
			
			case "right":
							
				frame_wait++;
					
				if(((state=="jump")||(state=="bounce"))&&((frame==4)||(frame==0))) // lock animation here while in air
				{
				}
				else
				{
					frame_add+=( (nx-dx)/ 20 );
					if(frame_add>=1)
					{
						frame+=1;
						frame_wait=0;
						frame_add=0;
						if((frame%4==0)&&(state=="onfloor"))
						{
							_root.sfx("step");
						}
					}
					if(frame_wait>8)
					{
						frame+=1;
						frame_wait=0;
						if((frame%4==0)&&(state=="onfloor"))
						{
							_root.sfx("step");
						}
					}
					
				}
				
				frame=frame%8;
				
				dx=nx;
				dy=ny;
				dz=nz;
				
				minion.display("right",frame);
				
			break;
			
			case "splat":
				minion.display("splat",0);
			break;
		}
		
		mc._x=up.x2+px;
		mc._y=up.y2+py;
				
		checkhold(replay);
		
//		dbgframe("state :"+state+"<br>");
//		dbgframe("anim :"+anim+"<br>");
//		dbgframe("vtpos :"+showdigits(px,100)+","+showdigits(py,100)+"<br>");
//		dbgframe("vtvel :"+showdigits(vx,100)+","+showdigits(vy,100)+"<br>");

	}	
	function showdigits(v,n)
	{
		return Math.round(v*n)/n;
	}
	function checkhold(replay)
	{
		if(hold) // we are holding an item
		{
			
//			hold.mc._x=mc._x;
			if(anim=="splat")
			{
				hold.hold_setpos(mc._x,mc._y-40);
//				hold.mc._y=mc._y-40;
			}
			else
			{
				hold.hold_setpos(mc._x,mc._y-80);
//				hold.mc._y=mc._y-80;
			}
			
			
			hold.hold_update( this, replay.key&Replay.KEYM_FIRE?true:false , replay.key_on&Replay.KEYM_FIRE?true:false , replay.key_off&Replay.KEYM_FIRE?true:false );

		}
	}
}
