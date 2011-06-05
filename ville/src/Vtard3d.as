/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class Vtard3d
{
	var up;
	
	var mc;
	
	var minion;
	
	var talk;

	var frame;
	
	var anim;
	
	var dx,dy,dz; // display x,y,z snap to 10px for animation
	
	var px,py,pz;
	var vx,vy,vz;
	
	var frame_wait;
	
	function Vtard3d(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup(nam)
	{
		mc=gfx.create_clip(up.mc,null);
		mc.cc=this;
		
// hitarea is too big by default, set it to something smaller...

		mc.hitArea=gfx.create_clip(mc,0xffff);
		gfx.clear(mc.hitArea);
		gfx.draw_box(mc.hitArea,0,-40,-70,60,70);
		mc.hitArea._visible=false;
		mc.hitArea=mc.hitArea;
		
		minion=new Minion(this);
		minion.setup(nam,50,94);
		
		px=0;
		py=0;
		pz=0;
		
		vx=0;
		vy=0;
		vz=0;
		
		anim=null;
				
		update();
	}
	
	function clean()
	{
		mc.cc=null;
		mc.removeMovieClip();
	}

	
	var rndsays=[
	"Can you smell this?",
	"Is today tuesday or wednesday?",
	"You can trust me.",
	"Do not trust me.",
	"You seem slow.",
	"I can count to four.",
	"Your a tard.",
	"I swim like a kitten.",
	"I sniff melons.",
	"I like cheese!",
	"Choose me!",
	"ZzZzZ",
	"MooMOO!"
	];


	var rndstate="";
	var rndcount=0;
	var rndpose=0;
	function update()
	{
	var f;
	var nx,ny,nz;
		
		vx=0;
		vz=0;
/*		
		if(_root.replay.key&Replay.KEYM_LEFT)
		{
			vx=-2.5;
		}
		else
		if(_root.replay.key&Replay.KEYM_RIGHT)
		{
			vx=2.5;
		}
		else
		{
			if(_root.replay.key&Replay.KEYM_UP)
			{
				vz=2.5;
			}
			else
			if(_root.replay.key&Replay.KEYM_DOWN)
			{
				vz=-2.5;
			}
		}
*/

		if(rndcount<=0)
		{
			rndcount=10+(up.rnd()%(25*5));
			switch(up.rnd()%14)
			{
				case 0: rndstate="idle"; break;
				case 1: rndstate="left"; break;
				case 2: rndstate="right"; break;
				case 3: rndstate="in"; break;
				case 4: rndstate="out"; break;
				case 5: rndstate="leftin"; break;
				case 6: rndstate="leftout"; break;
				case 7: rndstate="rightin"; break;
				case 8: rndstate="rightout"; break;
				default:
					rndstate="pose";
					if(rndcount>25*1)
					{
						rndcount=25*1;
					}
					switch(up.rnd()%19)
					{
						case 0:rndpose="bird";					break;
						case 1:rndpose="gunner";				break;
						case 2:rndpose="hiphands";				break;
						case 3:rndpose="teapot";				break;
						case 4:rndpose="angry";					break;
						case 5:rndpose="confused";				break;
						case 6:rndpose="determind";				break;
						case 7:rndpose="devious";				break;
						case 8:rndpose="embarrassed";			break;
						case 9:rndpose="energetic";				break;
						case 10:rndpose="excited";				break;
						case 11:rndpose="happy";				break;
						case 12:rndpose="indescribable";		break;
						case 13:rndpose="nerdy";				break;
						case 14:rndpose="sad";					break;
						case 15:rndpose="scared";				break;
						case 16:rndpose="sleepy";				break;
						case 17:rndpose="thoughtful";			break;
						case 18:rndpose="working";				break;
					}
					
					if((up.rnd()%4)==0)
					{
						talk.display(rndsays[up.rnd()%rndsays.length],rndcount);
					}
				break;
			}
		}
		else
		{
			rndcount--;
		}
		
		switch(rndstate)
		{
			case "pose":
				vx=0;
				vz=0;
			break;
			case "idle":
				vx=0;
				vz=0;
			break;
			case "left":
				vx=-2.5;
				vz=0;
			break;
			case "leftin":
				vx=-2.5;
				vz=-0.5;
			break;
			case "leftout":
				vx=-2.5;
				vz=0.5;
			break;
			case "right":
				vx=2.5;
				vz=0;
			break;
			case "rightin":
				vx=2.5;
				vz=-0.5;
			break;
			case "rightout":
				vx=2.5;
				vz=0.5;
			break;
			case "in":
				vx=0;
				vz=-2.5;
			break;
			case "out":
				vx=0;
				vz=2.5;
			break;
		}
		
		
		px+=vx;
		py+=vy;
		pz+=vz;
		
		if(px<up.x3_min+20)		{ px=up.x3_min+20; rndstate="right"; }
		if(py<up.y3_min+0)		{ py=up.y3_min+0; rndcount=0; }
		if(pz<up.z3_min+20)		{ pz=up.z3_min+20; rndstate="out"; }
		
		if(px>up.x3_max-20)		{ px=up.x3_max-20; rndstate="left"; }
		if(py>up.y3_max-0)		{ py=up.y3_max-0; rndcount=0; }
		if(pz>up.z3_max-20)		{ pz=up.z3_max-20; rndstate="in"; }
		
		nx=Math.floor((px+5)/10)*10;
		ny=Math.floor((py+5)/10)*10;
		nz=Math.floor((pz+5)/10)*10;
		
		if((vx==0)&&(vz==0))
		{
			if(anim!="idle")
			{
				anim="idle";
				frame=0;
				frame_wait=0;
				dx=nx;
				dy=ny;
				dz=nz;
			}
		}
		else
		if(vx*vx>=vz*vz) // left-right
		{
			if(vx>0) //right
			{
				if(anim!="right")
				{
					anim="right";
					frame=3;
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
					anim="left";
					frame=3;
					frame_wait=0;
					dx=nx;
					dy=ny;
					dz=nz;
				}
			}
		}
		else // in or out
		{
			if(vz>0) //in
			{
				if(anim!="in")
				{
					anim="in";
					frame=3;
					frame_wait=0;
					dx=nx;
					dy=ny;
					dz=nz;
				}
			}
			else // out
			{
				if(anim!="out")
				{
					anim="out";
					frame=3;
					frame_wait=0;
					dx=nx;
					dy=ny;
					dz=nz;
				}
			}
		}
		
		var fp;
		var ff;
		
		switch(anim)
		{
			case "idle":
			
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
				
				if( rndstate=="pose" )
				{
					minion.display(rndpose,frame);
				}
				else
				{
					minion.display("idle",frame);
				}
			break;
			
			case "left":
			
				frame_wait++;
				fp=(nx-dx)/-10;
				if(fp!=0)
				{
					frame+=fp;
					frame_wait=0;
				}
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				dx=nx;
				dy=ny;
				dz=nz;
				
				frame=frame%8;				
				minion.display("left",frame);
			break;
			
			case "right":
			
				frame_wait++;
				fp=(nx-dx)/ 10;
				if(fp!=0)
				{
					frame+=fp;
					frame_wait=0;
				}
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				dx=nx;
				dy=ny;
				dz=nz;
				
				frame=frame%8;				
				minion.display("right",frame);
			break;
			
			case "in":
			
				frame_wait++;
				fp=(nz-dz)/ 10;
				if(fp!=0)
				{
					frame+=fp;
					frame_wait=0;
				}
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				dx=nx;
				dy=ny;
				dz=nz;
				
				frame=frame%4;
				minion.display("in",frame);
			break;
			
			case "out":
			
				frame_wait++;
				fp=(nz-dz)/-10;
				if(fp!=0)
				{
					frame+=fp;
					frame_wait=0;
				}
				if(frame_wait>8)
				{
					frame+=1;
					frame_wait=0;
				}
				dx=nx;
				dy=ny;
				dz=nz;
				
				frame=frame%4;
				minion.display("out",frame);
			break;
		}
		
		
		mc._x=up.x2+dx+(dz/4);
		mc._y=up.y2-dy-(dz/4);
		
//		dbg.print( mc._x + " " + mc._y );
		
	}	
}