/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#loadfile("../wetlinks/src/LinksData.lua")()

#CLASSVERSION = CLASSVERSION or ""

#GFX=GFX or "gfx"

class WetSpewTalk
{
	
	var mc_scalar;

	var mc;
	
	var mc_over;
	var mc_stream;
		
//	var mcbacks;

	var up;
	
	var fakepop;
	
	var tf_text;
	
	var frame;
	var num;
	
	var mct;
	
//	var sc;
	
	var txts;
	var lsts;
	
	var tfs;
	
	var state;
	
	var foreground=0x00ff00;
	var background=0x000000;
	
	var rgbpos=[
"bbffff","ffbbff","ffffbb",
"ddddff","ddffdd","ffdddd",
"aaddff","aaffdd","ffaadd",
"ddaaff","ddffaa","ffddaa"];

	var rgbarr=[];
	var rgbidx=0;
	
	var game_infos;
	var game_numof;
	
	var wetv;
	
	var opts;

	function WetSpewTalk(_up)
	{
	var dat;
	
		opts={};
		opts.pics=true;
		opts.avatars=true;
		
		_root.spew_opts=opts;
		
		up=_up;
		
		rgbarr["XIX"]="00ff00";
		rgbarr["shi"]="00ff00";
		rgbarr["me"]="cccccc";
		rgbarr["lieza"]="ff88ff";
		rgbarr["cthulhu"]="00ff00";
		rgbarr["reg"]="ff00ff";
		
		rgbarr["noir"]="0000ff";
		rgbarr["jeeves"]="ffffff";
		rgbarr["moon"]="ffff00";
		rgbarr["ygor"]="ff0000";
		rgbarr["meatwad"]="00ff00";

		
		game_infos=[];
		
		game_numof=0;
		
#for i,v in ipairs(LinksData) do

		dat={};
		
		dat.nam1="#(v.nam1)";
		dat.lnk1="#(v.lnk1)";
		dat.lnk2="#(v.lnk2)";
		dat.img3="#(v.img3)";
		
		dat.lnksml="#(v.lnksml)";
		
		dat.lnkid=#(v.lnkid);
		
		game_infos[game_numof++]=dat;		// fill array
		game_infos["#(v.nam1)"]=dat; 		// link bothways
		game_infos["#(v.nam1)".toLowerCase()]=dat; 		// link bothways
		
#end


	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup()
	{
	var s;
	
//dbg.print("talk setup");


		fakepop=false;

		frame=0;
		num=0;
	
		mc_scalar=#(GFX).create_clip(up.mc,null);
		mc=#(GFX).create_clip(mc_scalar,null);
//		mcbacks=#(GFX).create_clip(mc,null);
//		mcbacks.cacheAsBitmap=true;
//		mc.onEnterFrame=delegate(update,null);

//		mcbacks._alpha=5;
		
		mc._x=800;
		
//		mc.scrollRect=new flash.geom.Rectangle(0, 0, 400, 600);
		mc.cacheAsBitmap=true;
		
		#(GFX).clear(mc);
		
		if(!_root.transparent_chat)
		{
			mc.style.fill=0xff000000+background;
			#(GFX).draw_box(mc,0,0,0,400,600);
		}
		
		setup_gizmos();
		
		vmc=null;

		mc_stream=#(GFX).create_clip(gizmo_Tlist.mc,null,0,0);
		
		mc_over=#(GFX).create_clip(mc,null); // pop up info
		#(GFX).clear(mc_over);
		mc_over.style.fill=0xcc000000;
		#(GFX).draw_box(mc_over,0,0,0,400,120);
		mc_over._visible=false;
		mc_over.cacheAsBitmap=true;
		
		mc_over.avatar=#(GFX).create_clip(mc_over,null,10,10);
		#(GFX).clear(mc_over.avatar);
		mc_over.avatar.style.fill=0x44000088;
		#(GFX).draw_box(mc_over.avatar,0,0,0,100,100);
		
		mc_over.tf=#(GFX).create_text_html(mc_over,null,120,10,280,130);
		
/*
		sc=new ScrollOn#(CLASSVERSION)(this,-90);

		sc.setup();
		
		sc.mc.filters=null;
		
		sc.fntsiz=20;
		sc.fntcol=0xffff00;

		sc.mc._alpha=100;
		
//		sc.mc._rotation=-90;
		sc.mc._x=-24;
		sc.mc._y=100;
		sc.xp=-5;
		
		sc.w=400;
*/

		
		state="chat";
		
		
		s="<font size=\"18\" color=\"#ffffff\">";
		s+="Connecting..."
		s+="</font>";
		
		txts=[];
		lsts=[];
		tfs=[];
		
		txts["help"]=s;
		txts["chat"]=s;
		txts["users"]=s;
		txts["games"]=s;
		txts["rooms"]=s;
		txts["line"]=s;
		txts["opts"]=s;
		
		
// games
		
		s="<font size=\"18\" color=\"#ffffff\">";
		s+="<p></p>";
		
#for i,v in ipairs(LinksData) do

		s+="<p><img width=\"100\" height=\"100\" src=\"#(v.img3)\">";

		if(_root.home=="wetgenes")
		{
			s+="<a href=\"#(v.lnksml)\" target=\"_top\"><b>#(v.nam1)</b></a></p>"; // user jscript
		}
		else
		{
			s+="<a href=\"#(v.lnksml)\" target=\"_blank\"><b>#(v.nam1)</b></a></p>"; // full url
		}
		s+="<p><font size=\"14\">#(v.txt1)</font></p>";
		s+="<p></p>";
		s+="<p></p>";
#end
		s+="</font>";
		txts["games"]=s;

//help		
		
		s="<font size=\"18\" color=\"#ffffff\">";
		s+="<p></p>";
		s+="<p>Type /join roomname to join a room.</p>";
		s+="<p></p>";
		s+="<p>Type /find username to find out which room someone is in.</p>";
		s+="<p></p>";
		s+="<p>You may /ban /gag /dis people from your personal room. The easy way is to simply click on what they said and then make your choice.</p>";
		s+="<p></p>";
		s+="<p>Type /login name_you_want_to_have if you want to change your guest name.</p>";
		s+="<p></p>";
		s+="<p>Type /me does something. if you want to perform an act rather than a chat.</p>";
		s+="<p></p>";
		s+="<p>There is a list of other games you can play that also have this same chat built in, just click on the <b>GAMES</b> tab above and make your choice.</p>";
		s+="<p></p>";
		s+="<p>If this thing has popped up over half your screen then you can hide it again by just moving the mouse off of it.</p>";
		s+="<p></p>";
		s+="<p>If you find the public chat rooms to be full of loud and annoying people, then I recommend you change to your home room. Just click on the <b>ROOMS</b> tab above and then join your <b>personal home room</b> where you have admin rights.</p>";
		s+="<p></p>";
		s+="<p>There is only one enforced rule in public and I advise you to learn it's meaning before bothering the gods. The rule is <b>Fuck 'em if they can't take a joke.</b> .</p>";
		s+="<p></p>";
		s+="<p><a href=\"http://help.wetgenes.com/\" target=\"_BLANK\"><b>Click here to visit the full online help.</b></a></p>";
		s+="<p></p>";

// enable the call to some parent javascript if hosted on my site in one of my pages
if(_root.home=="wetgenes")
{
//			s+="<p><a href=\"javascript:toggle_swf_size();\"><b>Resize this flash window</b></a></p>"; // full url
}
		
		s+="</font>";
		txts["help"]=s;

		
		Key.addListener(this);
	}
	
	function clean()
	{
		Key.removeListener(this);
//		sc.clean();
		mc.removeMovieClip();
	}

//"http://data.wetgenes.com/game/s/spew/backs/xix.png"

	function set_back(url)
	{
/*
		if(!_root.transparent_chat)
		{
			mcbacks.back1=#(GFX).create_clip(mcbacks,1,0,-600);
			mcbacks.back2=#(GFX).create_clip(mcbacks,2,0,0);
			mcbacks.back3=#(GFX).create_clip(mcbacks,3,0,600);
			
			if(url and url!="" and url!="-") // load images or due to the power of flash, swf files that may kill everything, thanx for that
			{
				mcbacks.back1.loadMovie(url);
				mcbacks.back2.loadMovie(url);
				mcbacks.back3.loadMovie(url);
			}
		}
*/
	}
	
var last_users_stamp=0;
var last_rooms_stamp=0;

var popdelay; // delay popout
	
	function update(snapshot)
	{
	var s;
	var info;
	
//dbg.print("talk update");

/*
		if(_root.popup)
		{
			if(_root.popup!=this)
			{
				return;
			}
		}
*/
		
		if(wetv)
		{
			wetv.update();
		}
		
		if(_root.popup==this)
		{
			_root.popup=null;
		}
		
mc_over.avatar.mc.forceSmoothing=true; // retarted flash 8++ fix
		

		frame++;
		
// display current state

		switch(state)
		{
			case "users":
			
				if(last_users_stamp!=up.sock.users_stamp) // update userlist
				{
					update_users();
					
					last_users_stamp=up.sock.users_stamp;
				}
			
			break;
			
			case "rooms":
			
				if(last_rooms_stamp!=up.sock.rooms_stamp) // update userlist
				{
					update_rooms();
					
					last_rooms_stamp=up.sock.rooms_stamp;
				}
			
			break;
			
			case "opts":
			
				update_opts();
			
			break;
		}
		
		var yp=0; // reset top if we must
			
		if(lsts[state]) // have a display list rather than html text
		{
			gizmo_Tlist.str=""; // disable html
			
		var hh=8+gizmo_Tlist.text_height-gizmo_Tlist.h;
		
			yp=Math.floor((hh)*gizmo_Tlist.vgizmo.y_knob);
			if(yp<0) { yp=0; }
			
			mc_stream._visible=true;
		}
		else
		{
			if(gizmo_Tlist.str!=txts[state])
			{
				gizmo_Tlist.str=txts[state];
				
				mc_stream._visible=false;
			}
		}
		
		if(yp != gizmo_Tlist.mc.scrollRect.y) // check before change
		{
			#(GFX).setscroll(gizmo_Tlist.mc,0,yp,gizmo_Tlist.w,gizmo_Tlist.h);
		}
				
		

		if(mc._ymouse<300)
		{
			mc_over.dy=mc._ymouse+150+30;
		}
		else
		{
			mc_over.dy=mc._ymouse-300;
		}
		
		if(mc_over._visible) // check for any updated info to display
		{
			var diff=mc_over.dy-mc_over._y;
			if(diff<0) { diff=-diff; }
			
			if(diff>1)
			{
				mc_over._y+=Math.floor((mc_over.dy-mc_over._y)/4);
			}
			display_info_check();
		}
		
//		var snapshot=_root.poker.snapshot();
		gizmo.mc.globalToLocal(snapshot);
		gizmo.focus=gizmo.input(snapshot);		
		gizmo.update();
		
		
		/*
		if((newtext)&&(state=="chat"))
		{
		var tf=gizmo_Tlist.tf;
		
			dbg.print("***DUMP***");
		
			for(var nam in tf)
			{
			var	child=tf[nam];
			var depth=child.getDepth();
				
//				if(depth!=undefined)
				{
					dbg.print( nam + " : " + depth + " : " + typeof(child) + " : " + child);
				}
			}
		
		}
		*/
		var dopopout=false;
		
		// live fix incase these values are missing
		if(!_root.scalar.bx) { _root.scalar.bx=800; }
		if(!_root.scalar.by) { _root.scalar.by=600; }
		mc._xscale=100*_root.scalar.bx/800;
		mc._yscale=100*_root.scalar.by/600;
		
		if( (_root.scalar.ox==_root.scalar.bx*1.5) && (!_root.scalar.need_chat_pop) )
		{
			mc._x=_root.scalar.bx;
//			sc.mc._visible=false;
		}
		else
		if( (_root.scalar.ox==_root.scalar.bx) || (_root.scalar.need_chat_pop) )
		{
//			sc.mc._visible=true;
			
			if(_root.popup==null)
			{
				if((mc._x==_root.scalar.bx/2)||(fakepop)) // pop in?
				{
					if(mc._xmouse >= -20)
					{
						if(!fakepop)
						{
							dopopout=true;
						}
					}
					else
					{
						fakepop=false;
						mc._x=_root.scalar.bx;
					}
				}
				else // pop out?
				{
					if( ( (mc._xmouse > -20) && (mc._ymouse > _root.scalar.by*1/8) && (mc._ymouse < _root.scalar.by*7/8) ) )
					{
						if(_root.poker.poke_now)
						{
							fakepop=true;
						}
						else
						{
							dopopout=true;
						}
					}
					else
					{
						mc._x=_root.scalar.bx;
					}
				}
			}
			
		}
		else
		{
			mc._x=0;
//			sc.mc._visible=false;
			resize_chat();
		}

		
		if(dopopout)
		{
			popdelay--;
			if(popdelay<=0)
			{
				if(_root.popup==null)
				{
					_root.popup=this;
					mc._x=_root.scalar.bx/2;
				}
			}
		}
		else
		{
			popdelay=10;
		}

		
//		sc.update();
	}
	
	var extra_lines=-1;

// try and resize the chat vertically if we have screen space...
	function resize_chat_force()
	{
		extra_lines=-9999;
		resize_chat();
		chat(); // cause all chats to be rebuilt
		update();
	}
	
	function resize_chat()
	{
	var new_extra_lines;
//		new_extra_lines=Math.floor(_root.scalar.dy/((20/100)*_root.scalar.sy));
		
		new_extra_lines=0;

		if(new_extra_lines<0) { new_extra_lines=0; }
	
		if(extra_lines==new_extra_lines) { return; } // no change
		
		extra_lines=new_extra_lines;

	var w,h,ss;
	var hrats=[28,4,8];
	var ty;
	var g
	
		w=400;
		h=600;
		ss=20;
	
		ty=0-extra_lines;
		hrats[0]=28+extra_lines*2;
		
		if(opts.vids)
		{
			hrats[0]-=15;
			ty+=15;
			
			if(!wetv)
			{
				wetv=new WetVPlay2(this);
				wetv.setup(true,"400x300");
			}
		}
		else
		{
			if(wetv)
			{
				wetv.clean();
				wetv=null;
			}
		}
		
		gizmo_Tscroll.h=(hrats[0]-1)*ss;
		gizmo_Tlist.set_area(0,ss,380,(hrats[0]-1)*ss);
		
		gizmo_Tscroll.mc.clear();
		gizmo_Tscroll.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(gizmo_Tscroll.mc,0,0,gizmo_Tscroll.w,gizmo_Tscroll.h)
		
		gizmoT.set_area(0,ty*ss,w,hrats[0]*ss);
		ty+=hrats[0];
		
		
		
		gizmoM.set_area(0,ty*ss,w,hrats[1]*ss);
		ty+=hrats[1];

		gizmoB.set_area(0,ty*ss,w,hrats[2]*ss);
		ty+=hrats[2];
	
//		g=gizmo_Tscroll;
//		g.set_area(w-ss*1,ss,ss,(hrats[0]-1)*ss);
//		g.mc.clear();
//		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
//		g.draw_boxen(g.mc,0,0,g.w,g.h);
		gizmo_Tlist.clear_tf();
		
		typehere_box.set_area(0,0,w-ss*1,ss*2);
		
		gizmo_send.set_area(w-ss*1,0,ss*1,ss*2);
		
		
		gizmo_Tscroll_knob.set_knob(null,null);
	}
	
	var gizmo;
	
	var gizmoT;
	var gizmoM;
	var gizmoB;
	
	var gizmo_Tlist;
	var gizmo_Tscroll;
	var gizmo_Tscroll_knob;
	var gizmo_Blist;
	var gizmo_Bscroll;
	var gizmo_Bscroll_knob;
	
	var gizmo_Titems;
	var gizmo_Bitems;
	
	var gizmo_send;
	
	var typehere;
	var typehere_box;
	
	var keyListener;
	
	
	function setup_gizmos()
	{
	var i;
	
	var w,h,ss;
	var g,gmc,gp;
		
	var hrats=[28,4,8];
	var ty;
	
		w=400;
		h=600;
		ss=20;
	
// master gizmo
		gizmo=new GizmoMaster#(CLASSVERSION)(this);
		gizmo.top=gizmo;
		g=gizmo;
		g.set_area(0,0,w,h);
		
		ty=0;
		
		gp=gizmo;
		
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(0,ty*ss,w,hrats[0]*ss);
		gizmoT=g;
		
		ty+=hrats[0];
		
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(0,ty*ss,w,hrats[1]*ss);
		gizmoM=g;
		
		ty+=hrats[1];
		
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(0,ty*ss,w,hrats[2]*ss);
		gizmoB=g;
		
		gp=gizmoT;
// scroll slider container		
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(w-ss*1,ss,ss,(hrats[0]-1)*ss);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
	
		gizmo_Tscroll=g;
		
		gp=g;
// scroll slider knob
		g=gp.child(new GizmoKnob#(CLASSVERSION)(gp))
		g.set_area(0,gp.h-ss*4,ss,ss*4);
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss*4);
		g.mc_base=gmc;
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss*4);
		g.mc_over=gmc;
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss*4);
		g.mc_down=gmc;
		
		gizmo_Tscroll_knob=g;

		gp=gizmoT;
//a TF scroll area
		g=gp.child(new GizmoText#(CLASSVERSION)(gp));
		g.set_area(0,ss,w-ss*1,(hrats[0]-1)*ss);
		g.str="";
		g.tf_fmt.size=ss-2;
		g.tf_fmt.color=0xff000000+foreground;
		g.vgizmo=gizmo_Tscroll_knob;
		
		gizmo_Tlist=g;
		
		
/*
		gp=gizmoT;
//list		
		g=gp.child(new GizmoList#(CLASSVERSION)(gp));
		g.set_area(0,0,w-ss*1,hrats[0]*ss);
		g.lh=ss;
		g.tf_fmt.size=ss-6;
		g.tf_fmt.color=0xff000000+foreground;
		g.base_alpha=100;
		g.vgizmo=gizmo_Tscroll_knob;
		
		gizmo_Tlist=g;
*/


/*		
		gp=gizmoB;
// scroll slider container		
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(w-ss*1,0,ss,hrats[2]*ss);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
	
		gizmo_Bscroll=g;
		
		gp=g;
// scroll slider knob
		g=gp.child(new GizmoKnob#(CLASSVERSION)(gp))
		g.set_area(0,0,ss,ss);
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss);
		g.mc_base=gmc;
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss);
		g.mc_over=gmc;
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss);
		g.mc_down=gmc;
		
		gizmo_Bscroll_knob=g;
		
		gp=gizmoB;
//list		
		g=gp.child(new GizmoList#(CLASSVERSION)(gp));
		g.set_area(0,0,w-ss*1,hrats[2]*ss);
		g.lh=ss;
		g.tf_fmt.size=ss-6;
		g.tf_fmt.color=0xff000000+foreground;
		g.base_alpha=100;
		g.vgizmo=gizmo_Bscroll_knob;
		
		gizmo_Blist=g;
		
		ty+=hrats[2];
		
*/
		
		gizmo_Bitems=[];		
		gizmo_Titems=[];
		
		
//		gizmo_Tlist.items=gizmo_Titems;
//		gizmo_Tlist.onClick=delegate(Tclick);
		
		gizmo_Blist.items=gizmo_Bitems;
		gizmo_Blist.onClick=delegate(Bclick);
		
		
		gp=gizmoM;
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(0,0,gp.w-ss*1,ss*2);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
		typehere_box=g;
		
		typehere=#(GFX).create_text_edit(gizmoM.mc,null,ss*0.25,ss*0.25,w-ss*1.5,ss*1.5);
		typehere.setNewTextFormat(#(GFX).create_text_format(ss+2,0xff000000+foreground));
		typehere.text="";
		
		typehere.onEnterKeyHasBeenPressed=delegate(onEnter);
		
		
		gp=gizmoM;
		g=gp.child(new GizmoButt#(CLASSVERSION)(gp))
		g.set_area(gp.w-ss*1,0,ss*1,ss*2);

		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*2);
		g.mc_base=gmc;
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*2);
		g.mc_over=gmc;
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xcc000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,ss,ss*2);
		g.mc_down=gmc;

		gizmo_send=g;
		
		gizmo_send.mc.tf=#(GFX).create_text(gizmo_send.mc,100,ss-1,0,ss*2,ss);
		gizmo_send.mc.tf.setNewTextFormat(#(GFX).create_text_format(ss-9,0xff000000+background,"bold"));
		gizmo_send.mc.tf.text="SEND";
		gizmo_send.mc.tf._rotation=90;
		gizmo_send.mc.tf.selectable=false;
		
		gizmo_send.onClick=delegate(onEnter);
		
		var butwidth=[38,40,47,50,38,52];
		var bx=2;
		
		create_gizmo_butt(gizmoT,bx,0,butwidth[0],ss,"HELP"); bx+=butwidth[0];
		create_gizmo_butt(gizmoT,bx,0,butwidth[1],ss,"CHAT"); bx+=butwidth[1];
		create_gizmo_butt(gizmoT,bx,0,butwidth[2],ss,"USERS"); bx+=butwidth[2];
		create_gizmo_butt(gizmoT,bx,0,butwidth[3],ss,"GAMES"); bx+=butwidth[3];
		create_gizmo_butt(gizmoT,bx,0,butwidth[5],ss,"ROOMS"); bx+=butwidth[5];
		create_gizmo_butt(gizmoT,bx,0,butwidth[4],ss,"OPTS"); bx+=butwidth[4];
		
		gizmo.update();
	}
	
	var vmc;
	var vmc_check_count;
	
	function create_gizmo_butt(gp,x,y,w,h,txt)
	{
	var ss=20;
	var g;
	var gmc;
	
		g=gp.child(new GizmoButt#(CLASSVERSION)(gp))
		g.set_area(x,y,w,h);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};

		gmc=#(GFX).create_clip(g.mc,null);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,w,h);
		g.mc_base=gmc;
		
		gmc.tf=#(GFX).create_text(gmc,null,1,2,w,h);
		gmc.tf.setNewTextFormat(#(GFX).create_text_format(ss-9,0xff000000+background,"bold"));
		gmc.tf.text=txt;
		gmc.tf.selectable=false;
		
		gmc=#(GFX).create_clip(g.mc,null);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,w,h);
		g.mc_over=gmc;
		
		gmc.tf=#(GFX).create_text(gmc,null,1,2,w,h);
		gmc.tf.setNewTextFormat(#(GFX).create_text_format(ss-9,0xff000000+background,"bold"));
		gmc.tf.text=txt;
		gmc.tf.selectable=false;
		
		gmc=#(GFX).create_clip(g.mc,null);
		gmc.style={	fill:0xcc000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_box(gmc,0,0,w,h);
		g.mc_down=gmc;

		gmc.tf=#(GFX).create_text(gmc,null,1,2,w,h);
		gmc.tf.setNewTextFormat(#(GFX).create_text_format(ss-9,0xff000000+background,"bold"));
		gmc.tf.text=txt;
		gmc.tf.selectable=false;
		
		g.onClick=delegate(onClick,txt);
		
		return g;
		
	}
	
	var focus;
	var enter_down;
	
	
	function onClick(g,s)
	{
		switch(s)
		{
			case "USERS":
				gizmo_Tlist.clear_tf();
			
				txts["users"]="<font size=\"18\" color=\"#ffffff\">Fetching...</font>";
		
				up.sock.chat("/users"); // request new list of users
				
				state="users";
			break;
			
			case "ROOMS":
				gizmo_Tlist.clear_tf();
			
				txts["rooms"]="<font size=\"18\" color=\"#ffffff\">Fetching...</font>";
		
				up.sock.chat("/rooms"); // request new list of users
				
				state="rooms";
			break;
			
			case "HELP":
				gizmo_Tlist.clear_tf();
			
				state="help";
			break;

			case "CHAT":
				gizmo_Tlist.clear_tf();
			
				state="chat";
			break;
				
			case "GAMES":
				gizmo_Tlist.clear_tf();
			
				state="games";
			break;
			
			case "OPTS":
				gizmo_Tlist.clear_tf();
			
				state="opts";
			break;
		}
	}
	
	
	var sortuser="rank";
	
	function set_user_sort(nam)
	{
		if(nam=="rank")
		{
			sortuser="rank";
		}
		else
		{
			sortuser="name";
		}
		last_users_stamp=0;
	}
	
	function user_compare_name(a,b)
	{
	var aa=a.user_name.toLowerCase();
	var bb=b.user_name.toLowerCase();
	
		if( aa < bb )
		{
			return -1;
		}
		else
		if( aa > bb )
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	function user_compare_rank(a,b)
	{
	var aa=Math.floor( a.formrank.substr(1) );
	var bb=Math.floor( b.formrank.substr(1) );
	
		if( aa < bb )
		{
			return -1;
		}
		else
		if( aa > bb )
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	
	function update_users()
	{
	var tab;
	var idx;
	var u;
	var s;
	var found_users;
	var fr;
	
		s="";
		tab=up.sock.users;
		
		s+="<font size=\"18\" color=\"#ffffff\">";
		
		s+="<p>Listing users in room <b>" + up.sock.room + "</b></p>";
		
		s+="<p></p>";
		
		found_users=false;
		
		if(sortuser=="rank")
		{
			tab.sort(user_compare_rank);
		}
		else
		{
			tab.sort(user_compare_name);
		}
		
		for( idx=0 ; idx<tab.length ; idx++ )
		{
			u=tab[idx];
			
			s+="<p>";
			
			fr="";
			if(u.formrank)
			{
				fr="("+u.formrank+")";
			}
				
			if(u.color) { s+="<font color=\"#"+u.color+"\">"; }
			s+="<a href=\"asfunction:_root.talk.lineclick,user/"+idx+"\">";
			s+="<b>" + u.user_name + "</b> "+fr+" is playing <b>" + u.game_name + "</b>";
			s+="</a>";
			if(u.color) { s+="</font>"; }
			
			s+="</p>";
			
			found_users=true;
		}
		
		if(!found_users)
		{
			s+="<p>";
			
			s+="There are no named users in this room.";
			
			s+="</p>";
		}
		else
		{
			s+="<p></p>";
			
			s+="<p>";
			s+="<a href=\"asfunction:_root.talk.lineclick,sortuser/rank\">";
			s+="Sort list by user rank.";		
			s+="</a>";
			s+="</p>";
			
			s+="<p>";
			s+="<a href=\"asfunction:_root.talk.lineclick,sortuser/name\">";
			s+="Sort list by user names.";
			s+="</a>";
			s+="</p>";
		}
					
		s+="</font>";
		
		txts["users"]=s;
	}
	
	var sortroom="members";
	
	function set_room_sort(nam)
	{
		if(nam=="members")
		{
			sortroom="members";
		}
		else
		{
			sortroom="name";
		}
		last_rooms_stamp=0;
	}
	
	function room_compare_name(a,b)
	{
	var aa=a.room_name.toLowerCase();
	var bb=b.room_name.toLowerCase();
	
		if( aa < bb )
		{
			return -1;
		}
		else
		if( aa > bb )
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	function room_compare_members(a,b)
	{
	var aa=Math.floor( a.room_members );
	var bb=Math.floor( b.room_members );
	
		if( aa < bb )
		{
			return -1;
		}
		else
		if( aa > bb )
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	
	function update_rooms()
	{
	var tab;
	var idx;
	var r;
	var s;
	
		s="";
		tab=up.sock.rooms;
		
		s+="<font size=\"18\" color=\"#ffffff\">";
		
		
		s+="<p>";
		s+="<a href=\"asfunction:_root.talk.lineclick,room/home\">";
		s+="<b>Click here to join your personal home room.</b> <font size=\"12\">This will be less noisy than the public rooms and you can ban people from it.</font>";
		s+="</a>";
		s+="</p>";
			
		s+="<p></p>";
		
		s+="<p>Listing available active rooms.</p>";
		
		s+="<p></p>";
		
		if(sortroom=="members")
		{
			tab.sort(room_compare_members);
		}
		else
		{
			tab.sort(room_compare_name);
		}
		
		for( idx=0 ; idx<tab.length ; idx++ )
		{
			r=tab[idx];
			
			s+="<p>";
			s+="<a href=\"asfunction:_root.talk.lineclick,room/"+idx+"\">";
			s+="<b>" + r.room_name + "</b> has <b>" + r.room_members + "</b> members";
			s+="</a>";
			s+="</p>";
		}
		
		s+="<p></p>";
		
		s+="<p>";
		s+="<a href=\"asfunction:_root.talk.lineclick,sortroom/members\">";
		s+="Sort list by number of users.";		
		s+="</a>";
		s+="</p>";
		
		s+="<p>";
		s+="<a href=\"asfunction:_root.talk.lineclick,sortroom/name\">";
		s+="Sort list by room names.";
		s+="</a>";
		s+="</p>";
		
		s+="</font>";
		
		txts["rooms"]=s;
	}
	
	function linedisplay(line_item)
	{
	var s,ss;
	var dat;
	var str;
	
		if( line_item.lnk ) // click to open link
		{
			getURL(line_item.lnk,"_blank");
			return;
		}
		
		state="line";

		s="";
		
		s+="<p><font size=\"18\" color=\"#ffffff\">";
		s+="Click chat above to return to the chat."
		s+="<br>";
		s+="</font></p>";
		
		if(line_item.txt)
		{
			if(line_item.frm!="*")
			{
				s+="<p><font size=\"24\" color=\"#ffffff\">";
				s+="<b>";
				s+=line_item.frm;
				s+="</b> says <br>";
				s+="</font></p>";
			}

// replace http:// with real links that open in a blank window
			
//			ss=		( new org.as2lib.regexp.Pattern('(((f|ht){1}tp://)[-a-zA-Z0-9@:%_+.~#?&//=()]+)',0) )
//					.getMatcher(line_item.txt).replaceAll("<a href=\"$1\" target=\"_blank\">$1</a>") ;

			var sss=line_item.txt;
			var aa,aaa,s1;
			
			aa=sss.split("http://");
			if(aa[1])
			{
				aaa=aa[1].split(" ");
				
				if(aaa[0]) // got a link
				{
					s1="<a href=\"http://"+aaa[0]+"\" target=\"_blank\">http://"+aaa[0]+"</a>";
					aaa[0]="";
					aa[1]=s1+aaa.join(" ");
					sss=aa.join(" ");
				}
			}

			s+="<p><font size=\"24\" color=\"#ffffff\">";
			s+=sss;
			s+="<br>";
			s+="</font></p>";
		}
		
		
		dat=null;
		
		if(line_item.gamename) // display game name
		{
		
			dat=null;
			
			if(line_item.gamename)
			{
				str=line_item.gamename.split(".")[0];
				dat=game_infos[str];
			}
		}
		
		
		var username=line_item.frm;
		
			if(username=="*")
			{
				if(line_item.usr)
				{
					username=line_item.usr;
				}
			}
		
		var gameid=up.sock.map_user_to_gameid[username];
		var gamename=up.sock.map_gameid_to_gamename[gameid];
		var gamelnk="http://like.wetgenes.com/-/game/"+gameid+"/"+gamename;
		
		if(!dat)
		{
			dat=game_infos[gamename];
		}
			
		if(dat)
		{
			s+="<p><font size=\"24\" color=\"#ff0000\">";
			if(_root.home=="wetgenes")
			{
				s+="<a href=\""+dat.lnksml+"\" target=\"_top\">"; // use jscript
			}
			else
			{
				s+="<a href=\""+dat.lnksml+"\" target=\"_blank\">"; // full url
			}
			s+="<img width=\"100\" height=\"100\" src=\""+dat.img3+"\">"
			s+="Click here to play <b>"+dat.nam1+"</b> with "+username;
			s+="</a>";
			s+="<br>";
			s+="</font></p>";
		}
		else
		{
			
			if( gameid>0 )
			{
				s+="<p><font size=\"24\" color=\"#ff0000\">";
				if(_root.home=="wetgenes")
				{
					s+="<a href=\""+gamelnk+"\" target=\"_top\">"; // use jscript
				}
				else
				{
					s+="<a href=\""+gamelnk+"\" target=\"_blank\">"; // full url
				}
				s+="Click here to play <b>"+gamename+"</b> with "+username;
				s+="</a>";
				s+="<br>";
				s+="</font></p>";
			}
		}
		
		
		if((line_item.frm)&&(line_item.frm!="*"))
		{
			s+="<p><font size=\"24\" color=\"#00ff00\">";			
			s+="<a href=\"http://like.wetgenes.com/-/profile/"+line_item.frm+"\" target=\"_blank\">"; // full url		
			s+="Click here to view <b>"+line_item.frm+"</b>s user profile page.";			
			s+="</a>";
			s+="<br>";
			
			
			s+="<p><font size=\"14\" color=\"#ffffff\">";
			s+="<br>";
			s+="These admin links will fill in the admin command, you still need to press return to activate it. This will also only have any effect in rooms you own.<br>";
			s+="<br>";
			
			s+="<a href=\"asfunction:_root.talk.set_kick,"+line_item.frm+"\">";
			s+="Kick <b>"+line_item.frm+"</b> into public.</a><br>";
			
			s+="<a href=\"asfunction:_root.talk.set_dis,"+line_item.frm+"\">";
			s+="Disemvowel <b>"+line_item.frm+"</b> when in your room.</a><br>";
			
			s+="<a href=\"asfunction:_root.talk.set_gag,"+line_item.frm+"\">";
			s+="Gag <b>"+line_item.frm+"</b> when in your room.</a><br>";
			
			s+="<a href=\"asfunction:_root.talk.set_ban,"+line_item.frm+"\">";
			s+="Ban <b>"+line_item.frm+"</b> when in your room.</a><br>";
			
			s+="<a href=\"asfunction:_root.talk.cthulhu_dis,"+line_item.frm+"\">Call cthulhu to dis "+line_item.frm+" (5c)</a><br>";
			s+="<a href=\"asfunction:_root.talk.cthulhu_gag,"+line_item.frm+"\">Call cthulhu to gag "+line_item.frm+" (10c)</a><br>";
			s+="<a href=\"asfunction:_root.talk.cthulhu_ban,"+line_item.frm+"\">Call cthulhu to ban "+line_item.frm+" (15c)</a><br>";
			
			s+="<a href=\"asfunction:_root.talk.cookie_give,"+line_item.frm+"\">Give a cookie to "+line_item.frm+" (1c)</a><br>";
			
			s+="<a href=\"asfunction:_root.talk.do_bites,"+line_item.frm+"\">Bite "+line_item.frm+" </a><br>";
			s+="<a href=\"asfunction:_root.talk.do_insertname,"+line_item.frm+"\">insert "+line_item.frm+" into editbox</a><br>";
			
			s+="</font></p>";
		}
	
		txts["line"]=s;
	}
	
	function do_insertname(nam)
	{
		typehere.text+=" "+nam;
	}
	function do_bites(nam)
	{
		typehere.text="/me bites "+nam+" ";
	}
	function set_kick(nam)
	{
		typehere.text="/kick "+nam+" ";
	}
	function set_kick_bonobos(nam)
	{
		typehere.text="/kick "+nam+" bonobos";
	}
	function set_dis(nam)
	{
		typehere.text="/dis "+nam+" 15";
	}
	function set_gag(nam)
	{
		typehere.text="/gag "+nam+" 15";
	}
	function set_ban(nam)
	{
		typehere.text="/ban "+nam+" 15";
	}
	
	function cookie_give(nam)
	{
		typehere.text="/me gives "+nam+" 1 cookie";
	}
	
	function cthulhu_dis(nam)
	{
		typehere.text="/me calls cthulhu to disemvowel "+nam;
	}
	function cthulhu_gag(nam)
	{
		typehere.text="/me calls cthulhu to gag "+nam;
	}
	function cthulhu_ban(nam)
	{
		typehere.text="/me calls cthulhu to ban "+nam;
	}
	
	function update_opts()
	{
	var tab;
	var idx;
	var r;
	var s;
	
		s="";
		tab=up.sock.rooms;
		
		s+="<font size=\"18\" color=\"#ffffff\">";
		
		
		s+="<p>";
		s+="</p>";
		
		s+="<p>";
		s+="<a href=\"asfunction:_root.talk.lineclick,opt/vids\">";
		if(opts.vids)
		{
			s+="<b>Display videos in this chat : ON</b>";
		}
		else
		{
			s+="Display videos in this chat : off";
		}
		s+="</a>";
		s+="</p>";
		s+="<p>";
		s+="</p>";


		s+="<p>";
		s+="<a href=\"asfunction:_root.talk.lineclick,opt/pics\">";
		if(opts.pics)
		{
			s+="<b>Display pictures in this chat : ON</b>";
		}
		else
		{
			s+="Display pictures in this chat : off";
		}
		s+="</a>";
		s+="</p>";
		s+="<p>";
		s+="</p>";

		s+="<p>";
		s+="<a href=\"asfunction:_root.talk.lineclick,opt/avatars\">";
		if(opts.avatars)
		{
			s+="<b>Display avatars in this chat : ON</b>";
		}
		else
		{
			s+="Display avatars in this chat : off";
		}
		s+="</a>";
		s+="</p>";
		s+="<p>";
		s+="</p>";

		s+="<p>";
		s+="<a href=\"asfunction:_root.talk.lineclick,opt/vids_hq\">";
		if(opts.vids_hq)
		{
			s+="<b>HQ videos are : ON</b>";
		}
		else
		{
			s+="HQ videos are : off";
		}
		s+="</a>";
		s+="</p>";
		s+="<p>";
		s+="</p>";

		
		s+="</font>";
		
		txts["opts"]=s;
	}


	function lineclick(str_in)
	{
	var s;
	var str;
	var dat;
	
	var str_ar;
	var typ;
	var idx;
	var r;
	var i,it;
	
		str_ar=str_in.split("/");
		typ=str_ar[0];
		idx=str_ar[1];
	
	
		if(typ=='opt')
		{
			if(idx=="vids")
			{
				opts.vids=!opts.vids;
			}
			else
			if(idx=="pics")
			{
				opts.pics=!opts.pics;
			}
			else
			if(idx=="avatars")
			{
				opts.avatars=!opts.avatars;
			}
			else
			if(idx=="vids_hq")
			{
				opts.vids_hq=!opts.vids_hq;
			}
			update_opts();
			for(i=0;i<gizmo_Titems.length;i++)
			{
				it=gizmo_Titems[i];
				it.rebuild=true;
			}
			resize_chat_force(); // display?
		}
		else
		if(typ=="room")
		{
			if(idx=="home")
			{
				state="chat";				
				up.sock.chat("/join "+_root.Login_Name);
			}
			else
			{
				idx=Math.floor(idx);
				r=up.sock.rooms[idx];
				
				if(r.room_name)
				{
					state="chat";				
					up.sock.chat("/join "+r.room_name);
				}
			}
		}
		else
		if(typ=="sortroom")
		{
			set_room_sort(str_ar[1]);
		}
		else
		if(typ=="sortuser")
		{
			set_user_sort(str_ar[1]);
		}
		else
		if(typ=="user")
		{
			idx=Math.floor(idx);
			r=up.sock.users[idx];
			
			linedisplay( { frm:r.user_name , txt:"" , gamename:r.game_name } );
		}
		else
		if(typ=="chat")
		{
			idx=Math.floor(idx);
			
			linedisplay( gizmo_Titems[idx] );
		}

	}
		
	function get_new_tfid()
	{
	var i,it;
	
		if(!tfs[0]) { tfs[0]={}; }
			
		for(i=1;i<tfs.length;i++) // find an old one
		{
			it=tfs[i];
			
			if(!it.used)
			{
				it.used=true;
				return it.tfid;
			}
		}
		
// make a new one
		
		
		it={};
		it.mc=#(GFX).create_clip(mc_stream,null,0,0);
		it.mc.cacheAsBitmap=true;
		it.tf=#(GFX).create_text_html(it.mc,null,0,0,380,100);
		it.tf.setNewTextFormat(#(GFX).create_text_format(it.fntsiz,0xffffffff));
		it.tfid=tfs.length;
		it.used=true;
		it.mc.mc=#(GFX).create_clip(it.mc,null,0,0);
				
		tfs[it.tfid]=it;
		return it.tfid;
	}

	function display_info_check()
	{
	var	info=get_user_info(mc_over.info.name);
		
		if( info.avatar != mc_over.info.avatar ) // new avatar
		{
			mc_over.info.avatar = info.avatar;
			
			display_info_avatar();
		}
		
		if( ( info.stat != mc_over.info.stat ) || ( info.joined != mc_over.info.joined ) ) // new stat
		{
			mc_over.info.stat = info.stat;
			mc_over.info.joined = info.joined;
			
			display_info_text();
		}
	}

	function display_info_avatar()
	{
	var info=mc_over.info;
	
	
		if(info.avatar) // show img
		{
			if( mc_over.avatar.mc && mc_over.avatar.url==info.avatar ) // just redisplay
			{
				mc_over.avatar.mc._visible=true;
			}
			else
			{
				mc_over.avatar.mc=#(GFX).create_clip(mc_over.avatar,1,0,0);
				mc_over.avatar.mc.forceSmoothing=true;
				mc_over.avatar.mc.loadMovie(info.avatar);
				mc_over.avatar.url=info.avatar;
			}
		}
		else // hide img
		{
			mc_over.avatar.mc._visible=false;
		}
	}
	
	function display_info_text()
	{
	var info=mc_over.info;
	
	var username=info.name;
	var gameid=up.sock.map_user_to_gameid[username];
	var gamename=up.sock.map_gameid_to_gamename[gameid];
	var rankname;
		
	var s;
	
		s="<b>"+username.toLowerCase()+"</b>";
		
		rankname=mc_over.info.stat
		
		if( rankname && rankname!="-" )
		{
			s+=" "+rankname;

			if(gamename && gamename!="*" && gamename!="chat")
			{
				s+=" is playing "+gamename;
			}

		}
		else
		if( rankname=="-" )
		{
			s+=" is not logged in";
		}
		
		if(info.joined>0)
		{
			var d=new Date(info.joined*1000);
			var month=(d.getUTCMonth()+1);
			var day=d.getUTCDate();
			
			if(month<10) { month="0"+month; }
			if(day<10) { day="0"+day; }
			s+="<br>Wet since "+d.getUTCFullYear()+"/"+month+"/"+day;
		}
		
		
		#(GFX).set_text_html(mc_over.tf,16,0xffffff,s);
	}
	
	function get_user_info(name)
	{
		if( up.sock.map_user_to_info[ name ] )
		{
			return up.sock.map_user_to_info[ name ]; // return what we already know which may be nothing
		}
		
		up.sock.map_user_to_info[ name ]={}; // mark info as pending so we dont request it again
		
		up.sock.chat("/info user "+name); // request info
		
		return up.sock.map_user_to_info[ name ];
	}
	
	function hover_on(it)
	{
	var s;
	var oldname;
	
		if( it.frm=="*" || it.frm=="*mux" )
		{
			mc_over._visible=false;
			return
		}
		var username=it.frm;

		oldname=mc_over.info.name;
		
// remember this to poll user info if it changes		
		mc_over.info={};
		mc_over.info.info="user";
		mc_over.info.name=username;
		mc_over._visible=true;
		
		if(oldname!=username)
		{
			if(up.sock.map_user_to_info[ username ])
			{
				var date=new Date();
				if( date.getTime() > up.sock.map_user_to_info[ username ].t + 60 ) // update only once a min
				{
					up.sock.map_user_to_info[ username ]=null; // force request info update
				}
			}
		}
		
		display_info_check();
		
		display_info_avatar();
		display_info_text();
		
	}
	function hover_off(it)
	{
		mc_over._visible=false;
//		#(DBG).print(it.tfid);
	}
	function click(it)
	{
		mc_over._visible=false;
//		#(DBG).print(it.tfid);

		linedisplay(it);

	}
	
	var image_exts=[".png",".PNG",".jpg",".JPG",".jpeg",".JPEG",".gif",".GIF"];

	function build_tf_from_it(it)	
	{
	var tf,ii;
	var imgurl;
	var lnkurl;
	var ss,s1,s2,s3;
	
		it.rebuild=false;
	
		tf=tfs[it.tfid];
		
		tf.tf._height=600;
	
		it.w=380;
		it.h=20;
				
		tf.mc.onRelease=delegate(click,it);
		tf.mc.onRollOver=delegate(hover_on,it);
		tf.mc.onRollOut=delegate(hover_off,it);
		tf.mc.onReleaseOutside=delegate(hover_off,it);
				
		tf.tf.htmlText=it.display_html;
		
		if(it.link_only_text) // possible image
		{
			
			s1=it.txt.split("http://");
			s1=s1[1];
			
			if(s1)
			{
				for(ii=0;ii<image_exts.length;ii++)
				{
					if(s1.indexOf(image_exts[ii])>=0)
					{
						s2=s1.split(image_exts[ii]);
						s2[1]=image_exts[ii];
						break;
					}
				}
			}
						
			if( s2[0] )
			{
				imgurl="http://wet.appspot.com/thumbcache/375/150/"+s2[0]+s2[1];
				lnkurl="http://"+s2[0]+s2[1];
				tf.tf.htmlText=it.link_only_text;
			}
		}
		
		if(!opts.pics)
		{
			tf.tf.htmlText=it.display_html;
			imgurl=null;
		} // what is seen can not be unseen so lets not look
		
		ss=tf.tf.htmlText;
		tf.tf.htmlText="";
		tf.tf.htmlText=ss;
		it.h=tf.tf.textHeight;
		tf.tf._height=it.h+8; // bug hack fix so text will actually display.
		if((it.cmd=="say")&&(!imgurl))
		{
			if(it.avatar)
			{
				if(tf.tf._height<50) {tf.tf._height=50;}
				if(it.h<50) {it.h=50;}
			}
		}
		tf.tf.htmlText=ss;
		
// http://wet.appspot.com/img/375x150/swf.wetgenes.com/swf/wetlinks/basement.cookies.300x80.png

		if(tf.mc.mc)
		{
//			tf.mc.mc.unloadMovie();
			tf.mc.mc.removeMovieClip();
			tf.mc.mc=null;
//			tf.mc.mc._alpha=0;
//			tf.mc.mc._visible=false;
		}
		
		if(imgurl)
		{
			tf.mc.mc=#(GFX).create_clip(tf.mc,null,0,0);
			tf.mc.mc.loadMovie(imgurl);
			tf.mc.mc._y=it.h;
			it.h+=150;
			tf.mc.mc._alpha=100;
			tf.mc.mc._visible=true;
			
			if(!it.lnk)
			{
				it.lnk=lnkurl;
			}
		}
		
	}
		
	function chat_status(t) // print a basic system status msgs with no extra info
	{
		return chat({frm:"*",txt:t});
	}
	
	function chat_mux(t) // print mux html
	{
		return chat({frm:"*mux",txt:t});
	}
	
	
	function chat(t) // add a table to the chat display list
	{
		var i,s,ss;
		
		if(t)
		{
	
			if(up.sock.watch_chat) { up.sock.watch_chat(t); } // callback
		
		
	//	#(DBG).print(gizmo_Titems.length);
			gizmo_Titems[gizmo_Titems.length]=t;
			
			t.avatar=undefined;
			
			if(t.frm)
			{
				if(up.sock.map_user_to_color[t.frm]) // server assigned
				{
					t.rgb=up.sock.map_user_to_color[t.frm];
	//	#(DBG).print(t.rgb);
				}
				else
				if(rgbarr[t.frm]) // assigned?
				{
					t.rgb=rgbarr[t.frm];
				}
				else
				{
					t.rgb=rgbpos[rgbidx%rgbpos.length];	// pick a new color
					rgbarr[t.frm]=t.rgb;
					rgbidx++;
				}
			}
			else
			{
				t.rgb=rgbpos[0];
			}
		}
		
	var it;
	
		while(gizmo_Titems.length>64)
		{
			it=gizmo_Titems[0];
			
			if(it.tfid)
			{
				tfs[it.tfid].used=false;
				it.tfid=null;
			}
		
			gizmo_Titems.splice(0,1);
		}
		

		ss="";
		
	var linecol;
	var img,lnk;
	var tf;
	var yy=0;
	var simg;
	
		for(i=0;i<gizmo_Titems.length;i++)
		{
			it=gizmo_Titems[i];
			
			if(it.frm.substr(0,1)!="*")
			{
				if(opts.avatars)
				{
					var	info=get_user_info(it.frm);
					if(info)
					{
						if(info.avatar)
						{
							if(info.avatar.substring(0,41)!="http://swf.wetgenes.com/wavys/random.php/") // only if real?
							{
								if(it.avatar!=info.avatar)
								{
									it.avatar=info.avatar;
									it.rebuild=true;
								}
							}
						}
					}
				}
				else
				{
					if(it.avatar)
					{
						it.avatar=null;
						it.rebuild=true;
					}
				}
			}
			
			s="<font size=\"18\" color=\"#ffffff\">";
			it.fntsiz=18;
			
			linecol=gizmo_Titems[i].rgb;//linecols[(i+collinefix)&7];
			
			simg=null;
		
			if( (gizmo_Titems[i].frm=="*mux") && (gizmo_Titems[i].txt) )
			{
				s+=gizmo_Titems[i].txt;
			}
			else
			if( (gizmo_Titems[i].frm=="*") && (gizmo_Titems[i].txt) )
			{
				s+="<p><a href=\"asfunction:_root.talk.lineclick,chat/"+i+"\"><font size=\"14\" color=\"#bbbbbb\">"+gizmo_Titems[i].txt+"</font></a></p>";
				it.fntsiz=14;
			}
			else
			if(gizmo_Titems[i].cmd=="act")
			{
				s+="<p><a href=\"asfunction:_root.talk.lineclick,chat/"+i+"\"><font size=\"18\" color=\"#"+linecol+"\">**"+gizmo_Titems[i].frm+" "+gizmo_Titems[i].txt+"**</font></a></p>";
				it.fntsiz=18;
			}
			else
			{
				lnk="<a href=\"asfunction:_root.talk.lineclick,chat/"+i+"\">";
				if(gizmo_Titems[i].avatar)
				{
					img="<img width=\"50\" height=\"50\" hspace=\"0\" vspace=\"0\" align=\"left\" src=\""+gizmo_Titems[i].avatar+"\">";
				}
				else
				{
					img="";
				}
				
				if( (gizmo_Titems[i].lnk) && (gizmo_Titems[i].lnk!="") )
				{
					lnk="<a target=\"_blank\" href=\""+gizmo_Titems[i].lnk+"\">";
				}
				
				if( (gizmo_Titems[i].img) && (gizmo_Titems[i].img!="") )
				{
					img=lnk+"<img width=\"375\" height=\"100\" hspace=\"0\" vspace=\"0\" align=\"left\" src=\""+gizmo_Titems[i].img+"\"></a><br><br><br><br><br>";
				}
				
				s+=img+"<p>"+lnk+"<font size=\"18\" color=\"#"+linecol+"\"><b>"+gizmo_Titems[i].frm+": </b>"+gizmo_Titems[i].txt+"</font></a></p>";
				
				simg="<p><font size=\"18\" color=\"#"+linecol+"\"><b>"+gizmo_Titems[i].frm+": </b></font></p>";
				
				it.fntsiz=18;
			}
			
			s+="</font>";
			
			it.display_html=s;
			it.link_only_text=simg;
			
			ss+=s;
			
			
			if(!it.tfid) // need to allocate
			{
				it.tfid=get_new_tfid();
				build_tf_from_it(it);
			}
			
			if(it.rebuild)
			{
				build_tf_from_it(it);
			}
			
			tf=tfs[it.tfid];
			
			tf.mc._y=yy;
			yy+=it.h;
						
//			#(DBG).print("pos : "+tf._y+" : ");
			
		}
		gizmo_Tlist.text_height=yy;
		
		
		txts["chat"]="";
		lsts["chat"]=gizmo_Titems;
		
/*
		if(!sc.next)
		{
			if( (mc._x==800) && (_root.scalar.ox==800) )
			{
				if( (t.frm=="*") && (t.txt) )
				{
					sc.next={url:"",txt:t.txt,target:""};
				}
				else
				{
					sc.next={url:"",txt:t.frm+": "+t.txt,target:""};
				}
			}
			
		}
*/
		
//dbg.print(gizmo_Tlist.str);

		return t;

	}
	
	function onKeyDown()
	{
		if(Key.isDown(Key.ENTER))
		{
			focus=eval(Selection.getFocus());
			enter_down=true;
			
//			dbg.print("ENTER on");
		}
		else
		{
			focus=false;
			enter_down=false;
		}
	}
	function onKeyUp()
	{
		if(enter_down)
		{
//			dbg.print("ENTER off");
			
			focus.onEnterKeyHasBeenPressed();
			focus=false;
			enter_down=false;
		}
	}
			
	function onEnter()
	{
	var s;
	
//		if(up.sock.connected)
		{
			s=typehere.text;
			if(s!="")
			{
				up.sock.chat(s);
			}
			typehere.text="";
		}
	}

	function Tclick()
	{
	}
	
	function Bclick()
	{
	}
	
	function draw_boxen( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.endFill();
	}
	
	function draw_puck( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss*3,y+ss*3);
		mc.lineTo(x+w-ss*3,y+ss*3);
		mc.lineTo(x+w-ss*3,y+h-ss*3);
		mc.lineTo(x+ss*3,y+h-ss*3);
		mc.lineTo(x+ss*3,y+ss*3);
		
		mc.endFill();
	}

	function draw_box( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss*1,y+ss*1);
		mc.lineTo(x+w-ss*1,y+ss*1);
		mc.lineTo(x+w-ss*1,y+h-ss*1);
		mc.lineTo(x+ss*1,y+h-ss*1);
		mc.lineTo(x+ss*1,y+ss*1);
		
		mc.endFill();
	}

	
}
