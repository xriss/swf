/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#file_names={"game"}


class PlayMenu
{
	var up; // Main
	var mc;
	var mcs;
	
	var over;
				
	var show_menu=false;
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function PlayMenu(_up)
	{
		up=_up;
		
	}
			
	function makeclick(m)
	{
		m.onRelease=delegate(click,m);
		m.onRollOver=delegate(hover_on,m);
		m.onRollOut=delegate(hover_off,m);
		m.onReleaseOutside=delegate(hover_off,m);
		m.tabEnabled=false;
		m.useHandCursor=true;
	}
	
	var mcs_max;
	var file_name;
	var file_lines;
	
	
	function setup()
	{	
	
	var i;
	var line;
	var lin;
	var box;
	var nmc;
	var smc;
	var pidx;
//	var pmc;
	var under;
	var dash;
	var s;
	var dx,dy;
	var m;
	
	var v1,v2,v3,vd;
	var r;


	
		file_name="#(file_names[1])";
		file_lines=#(file_names[1])_lines;
		
		
		mc=gfx.create_clip(up.mc,null);
		mcs=new Array();
		
//		mcs[-1]=gfx.add_clip(mc,"menu_back",null,0,0);
		
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
			
			if(under[0]=="fullscreen") { continue; }
		
			mcs[i]=gfx.create_clip(mc,null);
			mcs[i].mc=gfx.add_clip(mcs[i],file_name,null,0,0);
			mcs[i].mc.gotoAndStop(i+1);
			mcs[i].active=true;
			mcs[i].mc.cacheAsBitmap=true;
			
			box=mcs[i].mc.getBounds(mc);
			
			switch(under[0])
			{
			}
					
			box.x=(box.xMin+box.xMax)/2;
			box.y=(box.yMin+box.yMax)/2;
			box.w=(box.xMax-box.xMin);
			box.h=(box.yMax-box.yMin);
			box.s= box.w/640; if( (box.h/480) >  box.s ) { box.s=box.h/480; }
			
//			mcs[i]._x=-320;
//			mcs[i]._y=-240;
			
			mcs[i].box=box;
			
			m=mcs[i];

//dbg.print(under[0]);
			switch(under[0])
			{
				case "window":
				
				case "help":
				case "quit":
				case "menu":
				case "soundon":
				case "soundoff":
				case "fullscreen":
				
			case "about":
			case "logoff":
			case "score":
			case "shuffle":
			case "restart":
			
					makeclick(mcs[i]);
				break;
			}
				
			mcs[i].idx=i;
			mcs[i].nam=lin[0];
			mcs[i].flavour=lin[2];
			
			mcs[i].under=under;
			mcs[i].dash=dash;
			mcs[i].nams=under;
			
//			mcs[i]._visible=false; // everything off by default
			
			mcs[lin[0]]=mcs[i]; // swing both ways?
			
		}
		
/*		
		mcs["sfx"]=gfx.create_clip(mc,null,8,480-24);
		mcs["sfx"].nam="sfx";
		mcs["sfx"].nams=["sfx"];
			
		mcs["sfx"]["on"]=gfx.add_clip(mcs["sfx"],"sfx_on");
		mcs["sfx"]["off"]=gfx.add_clip(mcs["sfx"],"sfx_off");
		makeclick(mcs["sfx"]);
*/							
		update_display();
				
		Mouse.addListener(this);
		
		update();
		
/*
		mc.ver=gfx.create_text_html(mc,undefined,640-320,480-20,316,32);
		gfx.set_text_html(mc.ver,10,0xffffff,"<p align=\"right\"><b>version #(VERSION_STAMP)</b></p>")
*/
	}
	
	
	function clean()
	{		
		_root.poker.ShowFloat(null,0);
						
//		_root.swish.clean();
//		_root.swish=(new Swish({style:"sqr_plode",mc:mc,s:800/640})).setup();
		
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
	
	
	function update_display()
	{
	var i;
	var m;
	var nams;
	
		
		for(i=0;i<mcs_max;i++)
		{
			m=mcs[i];
			
			nams=m.nam.split("_");
			
			switch(nams[0])
			{
				case "menu":
//					m._visible=true;
//					do_this(m,"off");
					
					if(show_menu)
					{
						m._visible=false;
					}
					else
					{
						m._visible=true;
					}
					
				break;
				
				case "window":
				case "help":
				case "quit":
				case "soundon":
				case "soundoff":
				case "fullscreen":
				
			case "about":
			case "logoff":
			case "score":
			case "shuffle":
			case "restart":
			
					
					if(show_menu)
					{
						m._visible=true;
					}
					else
					{
						m._visible=false;
					}
					
					
					if(nams[0]=="soundon")
					{
						if(!_root.sfx.sound)
						{
							m._visible=false;
						}
					}
					if(nams[0]=="soundoff")
					{
						if(_root.sfx.sound)
						{
							m._visible=false;
						}
					}
					
					do_this(m,"off");
					
					
				break;
				
				default:
					do_this(m,"off");
				break;
			}
			
		}
	}
	
	function do_this(me,act)
	{
		switch(me.nams[0])
		{
			case "window":
			case "menu":
			case "quit":
			case "help":
			case "soundon":
			case "soundoff":
			case "fullscreen":
			
			case "about":
			case "logoff":
			case "score":
			case "shuffle":
			case "restart":
			
			var base_name=me.nams[0];

				switch(act)
				{
					case "off" :
						gfx.clear_filters(me);
						if(base_name=="menu")
						{
//							me._alpha=50;
						}
						else
						{
							if(!show_menu)
							{
								mcs[ me.nams[0] ]._visible=false;
								mcs[ me.nams[0]+"_over" ]._visible=false;
							}
							else
							{
								mcs[ me.nams[0] ]._visible=true;
								mcs[ me.nams[0]+"_over" ]._visible=false;
							}
						}
//						gfx.clear_filters(me);
						_root.poker.ShowFloat(null,0);
					break;
					case "on" :
//						_root.wetplay.PlaySFX("sfx_swish");
						
//						me._alpha=100;
						if(base_name=="menu")
						{
							gfx.glow(me , 0xffffff, .8, 16, 16, 1, 3, false, false );
						}
						else
						{
							if(!show_menu)
							{
								mcs[ me.nams[0] ]._visible=false;
								mcs[ me.nams[0]+"_over" ]._visible=false;
							}
							else
							{
								mcs[ me.nams[0] ]._visible=true;
								mcs[ me.nams[0]+"_over" ]._visible=true;
							}
						}
						switch(me.nams[0])
						{
							case "play":
							break;
						}
					break;
					case "click" :
//						_root.wetplay.PlaySFX("sfx_object");
						
//						me._alpha=75;
						gfx.clear_filters(me);
						switch(me.nams[0])
						{
							case "quit":
								show_menu=false;
								update_display();
								up.up.final_scores();
								up.up.up.state_next="menu";
							break;
							
							case "restart":
								show_menu=false;
								update_display();
								up.up.final_scores();
								up.up.up.state_next="play";
							break;
							
							case "shuffle":
								show_menu=false;
								update_display();
								up.up.final_scores();
								up.up.up.state_next="play";
								up.up.up.next_game_seed=Math.floor(Math.random()*65536)&0xffff;
							break;
							
							case "logoff":
								show_menu=false;
								update_display();
								up.popup_won.setup("lost");
							break;
							
							case "score":
								show_menu=false;
								update_display();
								up.up.show_scores();
							break;
							
							
							case "soundon":
							case "soundoff":
								_root.sfx.sound_toggle();
								update_display();
							break;
							
							case "fullscreen":
								if( Stage["displayState"] == "normal" )
								{
									Stage["fullScreenSourceRect"] = new flash.geom.Rectangle( 0,0 , 640,480 );
									Stage["displayState"] = "fullScreen";
								}
								else
								{
									Stage["displayState"] = "normal";
								}
								update_display();
							break;
							
							case "help":
								show_menu=false;
								update_display();
							break;
							
							case "menu":
							case "window":
								show_menu=show_menu?false:true;
								update_display();
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

	
		if(show_menu)
		{
			if( (mcs["window"].box.xMax<mc._xmouse-16) || (mcs["window"].box.yMax<mc._ymouse-16)
				|| (mcs["window"].box.yMin>mc._ymouse+16) || (mcs["window"].box.xMin>mc._xmouse+16) ) // hidemenu
//			if( (mc._xmouse>200) || (mc._ymouse>200) )
			{
				show_menu=false;
				update_display();
			}
		}


	}
	
#for i,v in ipairs(file_names) do
	static var #(v)_lines=[
#for line in io.lines("art/bitmaps/"..v..".txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];	
#end

}
