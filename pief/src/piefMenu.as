/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#file_names={"pief"}


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
	
	var order;
	var count;
	var sfxlookup;
		
				
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
	var i;
		order=[
			"pearls",
			"belt",
			"wings",
			"chaps",
			"vest",
			"watch",
			"shoe",
			"jacket",
			"pants",
			"ears"
			];
		for(i=0;i<10;i++)
		{
			order[ order[i] ] = i;
		}
	
		sfxlookup={
			pearls:"rightthere",
			belt:"ohyea",
			wings:"rightthere",
			chaps:"ohyea",
			vest:"rightthere",
			watch:"ohyea",
			shoe:"rightthere",
			jacket:"ohyea",
			pants:"rightthere",
			ears:"ohyea"
		};
		
		
		up=_up;		

		state_last=null;
		state=null;
		state_next=null;
		
//		dat=new EsMenuDat(this);		
//		about=new PlayAbout(this);
//		high =new PlayHigh(this);
		
		state="pief_"+_state;
		
		score=0;
				
		mc_base=gfx.create_clip(up.mc,null);

		var d=new Date();
		rnd_seed(d.getTime()&0xffff);
		
	}
			

	
	
	var preload=false;
	
	function makeclick(m)
	{
		m.onRelease=delegate(click,m);
		m.onRollOver=delegate(hover_on,m);
		m.onRollOut=delegate(hover_off,m);
		m.onReleaseOutside=delegate(hover_off,m);
		m.tabEnabled=false;
		m.useHandCursor=false;
	};
		
		
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
	var under;
	var dash;
	var s;
	var dx,dy;
	
	dx=-400;
	dy=-300;
		
		_root.signals.signal("#(VERSION_NAME)","set",this);
		
		count=0;
		score=0;
	
//		dbg.print("SETUP:"+state);
		
		state_split=state.split("_");
		state_file=state_split[0];
		state_room=state_split[1];
		
		preload=false;
					
		switch(state_file)
		{
#for i,v in ipairs(file_names) do
			case "#(v)":
				if(file_name=="#(v)")
				{
//					preload=true;
				}
				file_name="#(v)";
				file_lines=#(v)_lines;
			break;
#end
		}
		
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
			
			under=lin[0].split("_");
			dash=under[1].split("-");

//dbg.print(dash[0]);

			
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
			
		
			if(!preload)
			{
				mcs[i]=gfx.add_clip(pmc,file_name,null,0,0);
				mcs[i].gotoAndStop(i+1);
				mcs[i].active=true;
				mcs[i].cacheAsBitmap=true;
				
				box=mcs[i].getBounds(pmc);
				box.x=(box.xMin+box.xMax)/2;
				box.y=(box.yMin+box.yMax)/2;
				box.w=(box.xMax-box.xMin);
				box.h=(box.yMax-box.yMin);
				box.s= box.w/800; if( (box.h/600) >  box.s ) { box.s=box.h/600; }
				
				mcs[i]._x=-400;
				mcs[i]._y=-300;
				
				mcs[i].box=box;
	
				
				
				if(state_room=="play")
				{
					if( under[0]=="menu" )
					{
						mcs[i]._visible=false;
					}
					else
					{
						switch( under[1] )
						{
							case "score":
							case "win":
								mcs[i]._visible=false;
							break;
						}
						
						if( dash[0]=="part" )
						{
							makeclick(mcs[i]);
							
							mcs[i].useHandCursor=true;
							mcs[i].plopup="play_wank-"+dash[1];
							
							mcs[i].sfx="sfx_"+sfxlookup[ dash[1] ];
					
							if( dash[2]=="1" ) // multipart
							{
								mcs[i].link="play_part-"+dash[1]+"-2"
							}
							else
							if( dash[2]=="2" )
							{
								mcs[i].link="play_part-"+dash[1]+"-1"
							}
								
							mcs[i]._x=dx;
							mcs[i]._y=dy;
							
							
							mcs[i]._xscale=20;
							mcs[i]._yscale=20;
							
							if( dash[2]=="2" ) // second part
							{
								mcs[i]._x=mcs[mcs[i].link]._x;
								mcs[i]._y=mcs[mcs[i].link]._y;
								mcs[i]._xscale=mcs[mcs[i].link]._xscale;
								mcs[i]._yscale=mcs[mcs[i].link]._yscale;
							}
							else
							{
								dy+=120;
								if(dy>=(-300+(5*120)))
								{
									dx+=640;
									dy=-300;
								}
								
								s=0.15/mcs[i].box.s;
								mcs[i]._xscale=100*s;
								mcs[i]._yscale=100*s;
								mcs[i]._x+=-mcs[i].box.xMin*s;
								mcs[i]._y+=-mcs[i].box.yMin*s;
								
								if( mcs[i].box.w*mcs[i]._xscale/100 < 160 )
								{
									mcs[i]._x+=(160-(mcs[i].box.w*mcs[i]._xscale/100))/2;
								}
								if( mcs[i].box.h*mcs[i]._xscale/100 < 120 )
								{
									mcs[i]._y+=(120-(mcs[i].box.h*mcs[i]._xscale/100))/2;
								}
							}
							
							
							
						}
						else
						if( dash[0]=="wank" )
						{
							mcs[i]._visible=false;
						}
					}
				}
				else
				if(state_room=="menu")
				{
					if( under[0]=="play" )
					{
						switch( under[1] )
						{
							case "score":
							case "win":
								mcs[i]._visible=false;
							break;
						}
						if( dash[0]=="part" )
						{
	//						mcs[i].useHandCursor=false;
						}
						else
						if( dash[0]=="wank" )
						{
							mcs[i]._visible=false;
						}
					}
					else
					{
						switch(under[1])
						{
							case "play":
							case "more":
							case "about":
							case "code":
								makeclick(mcs[i]);
							break;
						}
					}
				}
			}
		
			mcs[i].idx=i;
			mcs[i].nam=lin[0];
			mcs[i].flavour=lin[2];
			
			mcs[i].under=under;
			mcs[i].dash=dash;
			mcs[i].nams=under;
			
//			mcs[i]._visible=false; // everything off by default
			
			mcs[lin[0]]=mcs[i]; // swing both ways?

/*
			if(mcs[i].nams[0]=="background")
			{
				mcs[i].useHandCursor=false;
				mcs[i]._alpha=100;
			}
*/
		}
		
		mc_score.removeMovieClip();
		mc_score=gfx.create_clip(mc,null);
		mc_score.tf1=gfx.create_text_html(mc_score,null,300,0,200,75);
		gfx.glow(mc_score , 0xffffff, .8, 16, 16, 1, 3, false, false );
		
/*		
		mc_title.removeMovieClip();
		mc_title=gfx.create_clip(mc,null);
		mc_title.tf1=gfx.create_text_html(mc_title,null,260,296,500,50);
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


		if(state_room=="menu")
		{
			_root.wetplay.PlaySFX(null,3);
		}
		else
		{
			_root.wetplay.PlaySFX("sfx_back",3,65536,1);
		}
	}
	
	
	function clean()
	{		
		_root.wetplay.PlaySFX(null,3);
		
		_root.poker.ShowFloat(null,0);
						
		_root.swish.clean();
//		_root.swish=(new Swish({style:"slide_left",mc:mc})).setup();
		_root.swish=(new Swish({style:"sqr_plode",mc:mc})).setup();
		
		Mouse.removeListener(this);
		
		mc.removeMovieClip(); mc=null;	
		
		_root.noskipfps=false;
	}
	
	function onMouseDown()
	{
		if(_root.popup) return;
		
	}
	function onMouseUp()
	{
		if(_root.popup) return;
		
		if(count==10) // game over man
		{
			if(score==100)
			{
				count=11;
				_root.wetplay.PlaySFX("sfx_win",3,65536,1);
			}
			else
			{
				count=12;
				_root.signals.signal("#(VERSION_NAME)","won",this);
				up.high.setup();
			}
		}
		else
		if(count==11) // win screen?
		{
			count=12;
			_root.signals.signal("#(VERSION_NAME)","end",this);
			up.high.setup();
		}
		else
		if(count==12) // highscores
		{
		}
	}
	
	function update_display()
	{
	var i;
	var m;
	var nams;
	
		
		for(i=0;i<mcs_max;i++)
		{
			m=mcs[i];
			
			nams=m.nam.split("_");
			
			do_this(m,"off");
		}
	}
	
	function wear_item(m)
	{
	var s;
	
//		m._x=-400;
//		m._y=-300;
//		m._xscale=100;
//		m._yscale=100;
		m.swish=true;
		m.plopup=null;
		m.useHandCursor=false;
		
		if(m.dash[2]=="2") { return; }
		
		s=count-order[m.dash[1]];
		s=Math.abs(s);
		
		score+=10-s;
		
		gfx.set_text_html(mc_score.tf1,24,0xffffffff,"<p align=\"center\">"+score+"%</p>");
		
		count++;
	}
					
	function do_this(me,act)
	{
		if( me.plopup)
		{
			switch(act)
			{
				case "off" :
					mcs[me.plopup]._visible=false;
				break;
				case "on" :
//						_root.wetplay.PlaySFX("sfx_swish");
					mcs[me.plopup]._visible=true;
				break;
				case "click" :
					mcs[me.plopup]._visible=false;
//dbg.print(me.sfx);					
					_root.wetplay.PlaySFX(me.sfx,2);
					
					wear_item(me);
					if(me.link)
					{
						wear_item(mcs[me.link]);
					}
				break;
			}
			return;
		}
		
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
			case "more":

			var base_name=me.nams[1];

				switch(act)
				{
					case "off" :
						me._alpha=50;
//						gfx.clear_filters(me);
						_root.poker.ShowFloat(null,0);
					break;
					case "on" :
//						_root.wetplay.PlaySFX("sfx_swish");
						
						me._alpha=100;
//						gfx.glow(me , 0xffffff, .8, 16, 16, 1, 3, false, false );
						switch(me.nams[1])
						{
							case "about":
								_root.poker.ShowFloat("Did you know this game was made by real people?",250);
							break;
							case "shop":
								_root.poker.ShowFloat("Because you love us and we love you, all night long baby.",250);
							break;
							case "code":
							case "getcode":
								_root.poker.ShowFloat("Get the code to place this game on your blog profile or website.",250);
							break;
							case "logout":
								_root.poker.ShowFloat("Logout to change your name and options.",250);
							break;
							case "moregames":
							case "more":
								_root.poker.ShowFloat("Over twenty thousand games under the sea.",250);
							break;
							case "play":
								_root.poker.ShowFloat("Click here to play.",250);
							break;
						}
					break;
					case "click" :
//						_root.wetplay.PlaySFX("sfx_object");
						
						me._alpha=75;
						gfx.clear_filters(me);
						switch(me.nams[1])
						{
							case "about":
								up.about.setup();
							break;
							case "play":
								up.state_next="play";
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
							case "more":
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
	var pmc;
	
	var i,m;
	var f;
	var dx,dy,dd;
	
	var mx,my;
	
	var swishing=false;
	
		for(i=0;i<mcs_max;i++)
		{
			m=mcs[i];
			
			if(m.swish)
			{
				m._x+=(((-400)-m._x)*0.10);
				m._y+=(((-300)-m._y)*0.10);
				m._xscale+=(((100)-m._xscale)*0.10);
				m._yscale+=(((100)-m._yscale)*0.10);
				
				if( (m._x>-400.5) && (m._x<-399.5) && (m._y>-300.5) && (m._y<-299.5) )
				{
					m._x=-400;
					m._y=-300;
					m._xscale=100;
					m._yscale=100;
					m.swish=false;
				}
				swishing=true;
			}
		}
		
		
		if(_root.popup) return;
	
		
		if(state_next!=null)
		{
			if(state) { clean(); }
			
			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			
			if(state) { setup(); }
		}
		
		
	
	
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
		
		
		
		if(count==10) // game over man
		{
			if(!swishing)
			{
				if( mcs["play_score"]._visible!=true )
				{
					mcs["play_score"]._visible=true;
					mcs["play_win"]._visible=false;
					_root.wetplay.PlaySFX("sfx_smooch",3);
				}
			}
		}
		else
		if(count==11) // win screen?
		{
			mcs["play_score"]._visible=false;
			mcs["play_win"]._visible=true;
		}
		else
		if(count==12) // highscores
		{
			mcs["play_score"]._visible=false;
			mcs["play_win"]._visible=false;
			
			if( up.state_next!="menu" )
			{
				up.state_next="menu";
			}
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
