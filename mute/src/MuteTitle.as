/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!


class MuteTitle
{

	var up; // Mute

	var mc_base;
	var mc;
	
	var state_last;
	var state;
	var state_next;
	
	var state_split;
	var state_file;
	var state_room;
	
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
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function MuteTitle(_up,_state,_play)
	{
		state_last=null;
		state=null;
		state_next=null;
		
		up=_up;		
		state_next=_state;
		
		dat=new MuteTitleDat(this,_play);		
		
		score=0;
				
		mc_base=gfx.create_clip(up.mc,null);
		talky_setup();

		
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
	var nam;
	var nams;
		
		

		if(state_next!=null)
		{
			state_last=state;	// change master state
			state=state_next;
			state_next=null;
		}
		
//		dbg.print("SETUP:"+state);
		
		state_split=state.split("_");
		state_file=state_split[0];
		state_room=state_split[1];
		
		switch(state_file)
		{
#for i,v in ipairs(file_names) do
			case "#(v)":
//				if(file_name=="#(v)")
//				{
//					preload=true;
//				}
//				else
				{
					preload=false;
				}
				file_name="#(v)";
				file_lines=#(v)_lines;
			break;
#end
		}
		
		dat.setup();
		dat.saves_reset_temps();
		
		if(!preload)
		{
			mc.removeMovieClip();
			mc=gfx.create_clip(mc_base,null);
						
			mcs=new Array();
			parallax=new Array();
		}
		
		pidx=0;
		pmc=null;
		
//dbg.print(file_name);
//dbg.print(file_lines[0]);
		
		mcs_max=file_lines.length-1;
		for(i=0;i<mcs_max;i++)
		{
			line=file_lines[i];
			lin=line.split(",");
			
			if(lin[0]=="") { lin[0]=null; }
			if(lin[1]=="") { lin[1]=null; }
			if(lin[2]=="") { lin[2]=null; }
			
			nam=lin[0];;
			nams=nam.split("_");
			
			if(!preload)
			{
				if( (lin[1]) || (pmc==null) ) // got a new depth
				{
					pmc=gfx.create_clip(mc,null,400,300);
					if(lin[1])
					{
						pmc.zoom= (lin[1])/100;
					}
					else
					{
						pmc.zoom=1;
					}
					parallax[pidx++]=pmc;
				}
			}
			
			{
				switch(nam)
				{
					default:
					
						if( (nams[2]!=null) && (nams[2]!="1") ) // ignore the anim frames, except for the first 1
						{
							break;
						}
					
						if(!preload)
						{
							if( (nam=="cage1")||(nam=="minion1") )	// hax
							{
								var t;
								
								t=gfx.create_clip(pmc,null,0,0);
								mcs[i]=gfx.add_clip(t,file_name,null,-400,-300);
								mcs[i].twistme=t;
							}
							else
							{
								mcs[i]=gfx.add_clip(pmc,file_name,null,-400,-300);
							}
							mcs[i].gotoAndStop(i+1);
							mcs[i].baseframe=i+1;
							mcs[i].active=true;
							mcs[i].cacheAsBitmap=true;
							
							mcs[i].onRelease=delegate(click,mcs[i]);
							mcs[i].onRollOver=delegate(hover_on,mcs[i]);
							mcs[i].onRollOut=delegate(hover_off,mcs[i]);
							mcs[i].onReleaseOutside=delegate(hover_off,mcs[i]);
							mcs[i].tabEnabled=false;
						}
												
					break;
				}
			}
			
			mcs[i].idx=i;
			mcs[i].nam=nam;
			mcs[i].nams=nams;
			
			mcs[i]._visible=false; // everything off by default
			
			mcs[lin[0]]=mcs[i]; // swing both ways?
		}
		
/*
		mc_score.removeMovieClip();
		mc_score=gfx.create_clip(mc,null);
		mc_score.tf1=gfx.create_text_html(mc_score,null,300,0,200,75);
		gfx.glow(mc_score , 0xffffff, .8, 16, 16, 1, 3, false, false );
		
		mc_title.removeMovieClip();
		mc_title=gfx.create_clip(mc,null);
		mc_title.tf1=gfx.create_text_html(mc_title,null,50,30,700,200);
		gfx.dropshadow(mc_title , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
*/
		
		update_display();
				
		Mouse.addListener(this);		
		
		update();
	}
	
	function clean()
	{
		dat.clean();
		
		Mouse.removeListener(this);
		
		mc.removeMovieClip(); mc=null;	
	}
	
	function onMouseDown()
	{
		if(_root.popup) return;
		
		talky_hide();
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

	function click(me)
	{
		if(_root.popup) return;

//dbg.print(me.nam);
		
		dat.do_this(me,"click");
		
	}

	function update()
	{
		if(_root.popup) return;
	
		
		if(state_next!=null)
		{
			if(state) { clean(); }
			
			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			
			if(state) { setup(); }
		}
		
		dat.update();
		
	var pmc;
	
/*
		if((score>0))//&&(pickups.length>0))
		{
			if(state!="ASUE1_rainbow")
			{
				score--;
			}
		}
		if(state=="ASUE1_title") // hide score?
		{
			gfx.set_text_html(mc_score.tf1,18,0xffffff,"");
		}
		else
		{
			gfx.set_text_html(mc_score.tf1,18,0xffffff,"<p align=\"center\"><b>"+score+"</b></p>");
		}
*/

	var i;
	var f;
	var dx,dy,dd;
	
	var mx,my;
	
	
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
		
//		hand_update();

		talky_update();
		
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
	


	
var talky_mc;
var talky_tf;
var talky_state;
	
	function talky_setup()
	{
		talky_mc=gfx.create_clip(up.mc,null,400,200);
//		talky_mc.onRelease=delegate(click,"talky",-1);
		
		talky_tf=gfx.create_text_html(talky_mc,null,-250,-150,500,300);
		
		talky_hiden();
	}
	
	function talky_hiden()
	{
		talky_mc._xscale=0;
		talky_mc._yscale=0;
		talky_state="hiden";
		talky_mc._visible=false;
	}
	
	function talky_display(str)
	{
		talky_mc._visible=true;
		talky_mc._xscale=0;
		talky_mc._yscale=0;
		talky_state="show";
		
		gfx.set_text_html(talky_tf,32,0x000000,"<b>"+str+"</b>");
		
		gfx.clear(talky_mc);
		talky_mc.style.out=0xc0ffffff;
		talky_mc.style.fill=0xc0ffffff;
		talky_tf._x=-(talky_tf.textWidth/2);
		talky_tf._y=-(talky_tf.textHeight/2);
		talky_mc.topy=50-((talky_tf._y-16)*1);
		talky_mc.midy=50-((talky_tf._y-16)*2);
		talky_mc.boty=50-((talky_tf._y-16)*3);
		talky_mc._y=talky_mc.topy;
		gfx.draw_rounded_rectangle(talky_mc,16,16,0,-(talky_tf.textWidth/2)-24,-(talky_tf.textHeight/2)-16,(talky_tf.textWidth)+48,(talky_tf.textHeight)+32+8);
	}
	
	function talky_update()
	{
		if(talky_state=="show")
		{
			talky_mc._xscale+=20;
			talky_mc._yscale+=20;
			
			if(talky_mc._xscale>=100)
			{
				talky_mc._xscale=100;
				talky_mc._yscale=100;
				talky_state="shown";
			}
		}
		else
		if(talky_state=="hide")
		{
			talky_mc._xscale-=20;
			talky_mc._yscale-=20;
			
			if(talky_mc._xscale<=0)
			{
				talky_hiden();
			}
		}
	
		if(mc._ymouse>talky_mc.midy)
		{
			talky_mc._y=talky_mc.topy;
		}
		else
		{
			talky_mc._y=talky_mc.boty;
		}
		
	}
	
	function talky_hide()
	{
		if(talky_state!="hiden")
		{
			talky_state="hide";
		}
	}
		
	function talky_clean()
	{
		talky_mc.removeMovieClip();
	}
	
	
	
#for i,v in ipairs(file_names) do
	static var #(v)_lines=[
#for line in io.lines("art/screens/"..v..".txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];	
#end

}
