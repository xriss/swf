/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#file_names={"title"}


class #(VERSION_BASENAME)Menu
{

	var up; // Main

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
	
	
	
//	var dat;
	

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


	function #(VERSION_BASENAME)Menu(_up,_state)
	{
		up=_up;		

		state_last=null;
		state=null;
		state_next=null;
		
//		dat=new EsMenuDat(this);		
//		about=new PlayAbout(this);
//		high =new PlayHigh(this);
		
		state="interface";
		
		score=0;
				
		mc_base=gfx.create_clip(up.mc,null);

		
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
		
		
//		dbg.print("SETUP:"+state);
		
		state_split=state.split("_");
		state_file=state_split[0];
		state_room=state_split[1];
		
		preload=false;
					
		file_name="interface";
		file_lines=interface_lines;
				
//		dat.saves_reset_temps();
		
		if(!preload)
		{
			mc.removeMovieClip();
			mc=gfx.create_clip(mc_base,null);
						
			mcs=new Array();
			parallax=new Array();
		}
		
		pidx=0;
		pmc=null;
		
//dbg.print(state_file);
//dbg.print(file_name);
//dbg.print(file_lines[0]);
		
		mcs_max=file_lines.length-1;
		for(i=0;i<mcs_max;i++)
		{
			line=file_lines[i];
			lin=line.split(",");
			
//dbg.print(line);

			if(lin[0]=="") { lin[0]=null; }
			if(lin[1]=="") { lin[1]=null; }
			if(lin[2]=="") { lin[2]=null; }
			
			if(!preload)
			{
				if( (pmc==null) ) // got a new depth
				{
					pmc=gfx.create_clip(mc,null,400,300);
					pmc.zoom=1;
					parallax[pidx++]=pmc;
				}
			}
			
			{
				switch(lin[0])
				{
					case "menu":
					break;
					
					case "title":
							mcs[i]=gfx.add_clip(pmc,file_name,null,-400,-300);
							mcs[i].gotoAndStop(i+1);
							mcs[i].active=true;
							mcs[i].cacheAsBitmap=true;
							
							if(lin[1]!="none")
							{
								make_button(mcs[i]);
							}
					break;
					
					default:
					
							mcs[i]=gfx.add_clip(pmc,file_name,null,-400,-300);
							mcs[i].gotoAndStop(i+1);
							mcs[i].active=true;
							mcs[i].cacheAsBitmap=true;
					
					break;
				}
			}			
			mcs[i].idx=i;
			mcs[i].nam=lin[0]+"_"+lin[1];
			
			mcs[i].nams=lin;
			
//			mcs[i]._visible=false; // everything off by default
			
			mcs[ mcs[i].nam ]=mcs[i]; // swing both ways?

/*
			if(mcs[i].nams[0]=="background")
			{
				mcs[i].useHandCursor=false;
				mcs[i]._alpha=100;
			}
*/
		}
		
/*
		mc_score.removeMovieClip();
		mc_score=gfx.create_clip(mc,null);
		mc_score.tf1=gfx.create_text_html(mc_score,null,300,0,200,75);
		gfx.glow(mc_score , 0xffffff, .8, 16, 16, 1, 3, false, false );
*/
		
/*
		mc_title.removeMovieClip();
		mc_title=gfx.create_clip(mc,null);
		mc_title.tf1=gfx.create_text_html(mc_title,null,50,30,700,200);
		gfx.dropshadow(mc_title , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
*/
		
		update_display();
				
		Mouse.addListener(this);		
		
		
		
		update();
		
		_root.noskipfps=true;
		
#if VERSION_INTRO=="addicting" then
//		if(_root.hosted_domain_test=="addictinggames")
//		{
			mc.intro=gfx.add_clip(mc,"button_addicting",null,240,410);
//		}
#end
	}
	
	function clean()
	{
		_root.swish.clean();
		_root.swish=(new Swish({style:"slide_left",mc:mc})).setup();
		
		Mouse.removeListener(this);
		
		mc.removeMovieClip(); mc=null;	
		
		_root.noskipfps=false;
	}
	
	function make_button(m)
	{
		m.onRelease=delegate(click,m);
		m.onRollOver=delegate(hover_on,m);
		m.onRollOut=delegate(hover_off,m);
		m.onReleaseOutside=delegate(hover_off,m);
		m.tabEnabled=false;
		
		m._alpha=75;
	}
		
	
	function onMouseDown()
	{
		if(_root.popup) return;
		
	}
	function onMouseUp()
	{
		if(_root.popup) return;
	}
	
	function update_display()
	{
//		dat.update_display();

	var i;
	var m;
	var nams;
	
		
		for(i=0;i<mcs_max;i++)
		{
			m=mcs[i];
			
//			nams=m.nam.split("_");
			
//			if(nams[0]==state_room) // only show layers that begin with the room name
			{
				m._visible=true;
			}

// hide second button state			
			if(nams[1]=="over")
			{
//				m._visible=false;
			}
			
		}
	}
	
	function do_this(me,act)
	{
		switch(me.nams[1])
		{
			case "about":
			case "play":
			case "scores":
			case "tshirt":
			case "code":
			case "getcode":
			case "shop":
			case "wetgenes":
			case "options":
			case "logout":
			case "moregames":
			var base_name=me.nams[0];

				switch(act)
				{
					case "off" :
						me._alpha=75;
						gfx.clear_filters(me);
						_root.poker.ShowFloat(null,0);
					break;
					case "on" :
						_root.wetplay.PlaySFX("sfx_swish");
						
						me._alpha=100;
						gfx.glow(me , 0xffffff, .8, 16, 16, 1, 3, false, false );
						switch(me.nams[1])
						{
							case "about":
								_root.poker.ShowFloat("Did you know this game was made by real people?",250);
							break;
							case "shop":
								_root.poker.ShowFloat("Because you love us and we love you, all night long baby.",250);
							break;
							case "getcode":
								_root.poker.ShowFloat("Get the code to place this game on your blog profile or website.",250);
							break;
							case "logout":
								_root.poker.ShowFloat("Logout to change your name and options.",250);
							break;
						}
					break;
					case "click" :
						_root.wetplay.PlaySFX("sfx_object");
						
						me._alpha=75;
						gfx.clear_filters(me);
						switch(me.nams[1])
						{
							case "about":
								up.about.setup();
							break;
							case "play":
								up.state_next="lobby";
							break;
							case "scores":
								up.high.setup();
							break;
							case "tshirt":
							case "shop":
								getURL("http://link.WetGenes.com/link/#(VERSION_NAME).shop","_bank");
							break;
							case "code":
							case "getcode":
								up.code.setup();
							break;
							case "logout":
							case "options":
								up.state_next="login";
							break;
							case "moregames":
							case "wetgenes":
								getURL("http://games.wetgenes.com/","_bank");
							break;
						}
					break;
				}
			break;
		}
	}
	
	function hover_off(me)
	{
		if(_root.popup) return;
		
		
		if(over==me)
		{
			do_this(me,"off");
			over=null;
		}
	}
	
	function hover_on(me)
	{
		if(_root.popup) return;
		
		if(over!=me)
		{
			do_this(me,"on");
			over=me;
		}
	}

	function click(me)
	{
		if(_root.popup) return;
		
		do_this(me,"click");
		
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
	
	
	
#for i,v in ipairs({"interface"}) do
	static var #(v)_lines=[
#for line in io.lines("art/"..v..".txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];	
#end

}
