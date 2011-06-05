/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!


class #(VERSION_NAME)Play
{

	var up; // RomZom

	var mc_base;
	var mc;
	var zmc;
	var omc;
	var oldmc;
	
	var state;
	
	var state_split;
	
	var over; //which layer is currently under the mouse
	
	var mcs;
	var parallax;
	var mcs_max;
	
	var saves=null;
	
	
	
	var dat;
	

	var file_name;
	var file_lines;
	
	var mc_score;
	var score;
	
	var mc_title;
	
	var snapbmp;
	var snapfrom;
	
	var topmc;
	
	var gameover;
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function #(VERSION_NAME)Play(_up,_state)
	{
		up=_up;		

		state=null;
		
		dat=new #(VERSION_NAME)PlayDat(this);		
		
		state="Take1_start";
		
				
		mc_base=gfx.create_clip(up.mc,null);

		snapfrom="";
	}
			

	function update_display()
	{
		dat.update_display();
	}
	
	
	
	var preload=false;
	
	function setup()
	{	
	var i;
	var line;
	var lin;
	var box;
	var nmc;
	var smc;
	var pidx;
	var pmc;		
		
		gameover=null;
		
		score=0;
		
//		dbg.print("SETUP:"+state);
		
		state_split=state.split("_");
		
		switch(state_split[0])
		{
#for i,v in ipairs(file_names) do
			case "#(v)":
				if(file_name=="#(v)")
				{
					preload=true;
				}
				else
				{
					preload=false;
				}
				file_name="#(v)";
				file_lines=#(v)_lines;
			break;
#end
		}
		
		dat.saves_reset();
		
//		if(!preload)
		{
			mc.removeMovieClip();
			mc=gfx.create_clip(mc_base,null);
			zmc=gfx.create_clip(mc,null);
			omc=gfx.create_clip(mc,null,400,300);
						
			mcs=new Array();
			parallax=new Array();
		}
		
		pidx=0;
		pmc=null;
		
//dbg.print(file_name);
//dbg.print(file_lines[0]);
		
//		if(!preload)
		{
			oldmc=gfx.create_clip(zmc,null,0,0); // the old room, for scrolling from
		}
		
		if(snapfrom!="")
		{
			switch(snapfrom)
			{
				case "right":
					oldmc.snap=gfx.create_clip(oldmc,null,-600,0);
					zmc._x=600;
				break;
				case "left":
					oldmc.snap=gfx.create_clip(oldmc,null,600,0);
					zmc._x=-600;
				break;
				case "down":
					oldmc.snap=gfx.create_clip(oldmc,null,0,-600);
					zmc._y=600;
				break;
				case "up":
					oldmc.snap=gfx.create_clip(oldmc,null,0,600);
					zmc._y=-600;
				break;
			}
			
			oldmc.snap.attachBitmap(snapbmp,0,"auto",true);

		}
		
		mcs_max=file_lines.length-1;
		for(i=0;i<mcs_max;i++)
		{
			line=file_lines[i];
			lin=line.split(",");
			
			if(lin[0]=="") { lin[0]=null; }
			if(lin[1]=="") { lin[1]=null; }
			if(lin[2]=="") { lin[2]=null; }
			
			
//dbg.print(lin[0]);
			
//			if(!preload)
			{
				if( (lin[1]) || (pmc==null) ) // got a new depth
				{
					pmc=gfx.create_clip(zmc,null,400,300);
					if(lin[1])
					{
						pmc.zoom= (lin[1])/100;
					}
					else
					{
						pmc.zoom=1;
					}
					parallax[pidx++]=pmc;
					
					pmc.cacheAsBitmap=true;
				}
								
				mcs[i]=gfx.create_clip(pmc,null);
				nmc=mcs[i];
				
				if(lin[0]=="instructions")
				{
					nmc.mc=gfx.add_clip(nmc,"instructions",null);				
					nmc.mc.gotoAndStop(1);
					nmc.mc.cacheAsBitmap=true;
				}
				else
				{
					nmc.mc=gfx.add_clip(nmc,file_name,null);				
					nmc.mc.gotoAndStop(i+1);
					nmc.mc.cacheAsBitmap=true;
				}
				
				box=nmc.mc.getBounds(nmc);
				box.x=(box.xMin+box.xMax)/2;
				box.y=(box.yMin+box.yMax)/2;
				box.w=(box.xMax-box.xMin);
				box.h=(box.yMax-box.yMin);
				
				nmc._x=box.x-400;
				nmc._y=box.y-300;
				nmc.vx=0;
				nmc.vy=0;
				nmc.ax=0;
				nmc.ay=0;
				
				nmc.ox=nmc._x; // default location
				nmc.oy=nmc._y;

				nmc.mc._x=-box.x;
				nmc.mc._y=-box.y;

				nmc.weight=Math.floor(Math.sqrt(box.w*box.h)); // area, for relative checks
				
				nmc.active=true;

				nmc.state="fixed";
				
				nmc.onPress=delegate(press,nmc);
				nmc.onRelease=delegate(click,nmc);
				nmc.onRollOver=delegate(hover_on,nmc);
				nmc.onRollOut=delegate(hover_off,nmc);
				nmc.onReleaseOutside=delegate(hover_off,nmc);
				nmc.tabEnabled=false;
				nmc.useHandCursor=false;
				
			}
			
			
			
			mcs[i].idx=i;
			mcs[i].nam=lin[0];
			mcs[i].flavour=lin[2];
			
			mcs[i].nams=mcs[i].nam.split("_");
			
			mcs[i]._visible=true; // everything on by default
			
			mcs[lin[0]]=mcs[i]; // swing both ways?
			
			topmc=pmc;//gfx.create_clip(pmc,null);
		}
		
		mc_score.removeMovieClip();
		mc_score=gfx.create_clip(mc,null);
		mc_score.tf1=gfx.create_text_html(mc_score,null,300,0,200,75*4);
		gfx.glow(mc_score , 0xffffff, .8, 16, 16, 1, 3, false, false );
		
		mc_title.removeMovieClip();
		mc_title=gfx.create_clip(mc,null);
		mc_title.tf1=gfx.create_text_html(mc_title,null,50,30,700,200);
		gfx.dropshadow(mc_title , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
		
		_root.signals.signal("#(VERSION_NAME)","start",this);
		
		update_display();
				
		Mouse.addListener(this);		
		
		update();
	}
	
	function clean()
	{
		zmc._x=0;
		zmc._y=0;
		
		if(oldmc.snap)
		{
			oldmc.snap.removeMovieClip();
			oldmc.snap=null;
		}
		
		Mouse.removeListener(this);
		
		mc.removeMovieClip(); mc=null;	
	}
	
	function onMouseDown()
	{
		if(_root.popup) return;
		
	}
	function onMouseUp()
	{
		if(_root.popup) return;
	}
	
	function hover_off(me)
	{
		if(_root.popup) return;
		
		
		if(over==me)
		{
			dat.do_this(me,"off");
			over=null;
		}
	}
	
	function hover_on(me)
	{
		if(_root.popup) return;
		
		if(over!=me)
		{
			dat.do_this(me,"on");
			over=me;
		}
	}

	function press(me)
	{
		if(_root.popup) return;
		
		dat.do_this(me,"press");
		
	}
	
	function click(me)
	{
		if(_root.popup) return;
		
		dat.do_this(me,"click");
		
	}

	function update()
	{
		if(_root.popup) return;
		
		if(gameover)
		{
			switch(gameover)
			{
				case "scores": // wait for scores
				
					if(!_root.popup)
					{
						gameover="done";
						up.state_next="menu";
					}
					
				break;
			}
			
			return;
		}
	
		_root.signals.signal("#(VERSION_NAME)","update",this);


// scroll room over		
		if( zmc._y != 0 )
		{
			zmc._y*=0.80;
			if( zmc._y<1 && zmc._y>-1 ) { zmc._y=0; }
		}
		if( zmc._x != 0 )
		{
			zmc._x*=0.80;
			if( zmc._x<1 && zmc._x>-1 ) { zmc._x=0; }
		}
		if( ( zmc._x == 0 ) && ( zmc._y == 0 ) )
		{
			if(oldmc.snap)
			{
				oldmc.snap.removeMovieClip();
				oldmc.snap=null;
			}
		}
		
		
		
	var pmc;
	
		if((score>0))//&&(pickups.length>0))
		{
			score--;
		}
		
		{
//			gfx.set_text_html(mc_score.tf1,18,0xffffff,"<p align=\"center\"><b>"+score+"</b></p>");
			gfx.set_text_html(mc_score.tf1,18,0xffffff,"<p align=\"center\"><b>"+dat.score_str+"</b></p>");
		}

	var i;
	var f;
	var dx,dy,dd;
	
	var mx,my;
	
	
/*
		mx=mc._xmouse;
		my=mc._ymouse;
		mx=(mx-400)/400;
		my=(my-300)/300;
		if(mx<-1) mx=-1;
		if(mx> 1) mx= 1;
		if(my<-1) my=-1;
		if(my> 1) my= 1;
			
		for(i=0;i<parallax.length;i++)
		{
			pmc=parallax[i];
			
			pmc._xscale=pmc.zoom*100;
			pmc._yscale=pmc._xscale;
			
			pmc._x=400+(-400*(pmc.zoom-1)*mx);
			pmc._y=300+(-300*(pmc.zoom-1)*my);
		}
*/
		
//		hand_update();

		dat.update_takes();
		
		dat.update();
		
//dbg.print(dat.notgone);
		
		if(dat.notgone==0) // everything has been taken
		{
			_root.wetplay.PlaySFX("sfx_rainbow",2);
			_root.signals.signal("#(VERSION_NAME)","end",this);
			gameover="scores";
			up.high.setup();
		}
	}

	function do_str(str)
	{
		switch(str)
		{
			default:
				up.do_str(str)
			break;
		}
	}
	


	
	
	
#for i,v in ipairs(file_names) do
	static var #(v)_lines=[
#for line in io.lines("art/"..v..".txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];	
#end

}
