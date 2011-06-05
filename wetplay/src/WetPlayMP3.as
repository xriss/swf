/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
// This file made available under the terms of The MIT License : http://www.opensource.org/licenses/mit-license.php
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "../wetplay/src/opts.as"


class WetPlayMP3
{

	var up; // WetPlay

	var mc;
	
	var mc_back_image;
	var mc_back_colour;
	var mc_back;
	
	var state;
	
	var w,h;
	var x,y;
	var row_size;
	
	
	var mc_image;
	var mc_image2;
	var mc_image3;
	
	var gizmo;
	
	var gizmo_title;
	var gizmo_list1;
	var gizmo_list2;
	
	var gizmo_backward;
	var gizmo_play;
	var gizmo_pause;
	var gizmo_forward;

	var gizmo_position;
	var gizmo_position_knob;
	var gizmo_position_knob_butt;
	
	var gizmo_volume;
	var gizmo_volume_knob;
	var gizmo_volume_knob_butt;
	
	var gizmo_scroll;
	var gizmo_scroll_knob;
	var gizmo_scroll_knob_butt;
	
	
	var xspfs;	// array of xspfs info to use as root for this player
	
	var xspf;
	
	var tracks_url; // for cached check
	
	var tracks;
	var tracks1;
	var tracks2;
	
	var track_id;
	var xspf_id;
		
	var image_url;
	
	var mcs1;
	var mcs2;
	
	var sfx_master;
	
	var sfx;
	var sfx_next;
	
	var sfx_load_stall_counter;

	var view;

	var foreground;
	
	var got_creator;
	
	var loop;
	var auto;
	var shuffle;
	var force;
	

	var options; // array of options / info to display


	var	disp_title="";
	var	disp_creator="";
	var	disp_info="";
	
	var throbe=0;
	
	var sfxs
	var sfxidx;
	
	var sfx_on;
	
	function delegate(f,d) { return com.dynamicflash.utils.Delegate.create(this,f,d); }
	
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function CheckSFX(nam,chan)
	{
	var sfx;
		sfx=sfxs[chan%6].sfx;
		if(nam)
		{
			if(sfx.nam!=nam)
			{
				return true;
			}
		}
		return sfx.complete;
	}
	
	function PlaySFX(nam,chan,loops,vol)
	{
		if(sfx_on==0) { return; }

//	dbg.print(nam);
		
	var sfx;
	
		if((chan!=undefined)&&(chan!=null))
		{
			sfx=sfxs[chan%6].sfx;
		}
		else
		{
			sfx=sfxs[sfxidx].sfx;
			sfxidx=(sfxidx+1)%6;
		}
	
		if(nam==null)
		{
			if(vol==undefined)
			{
				sfx.stop();
				sfx.complete=true;
			}
			else
			{
				sfx.setVolume(vol*100);
			}
		}
		else
		{
			sfx.nam=nam;
			sfx.stop();
			sfx.attachSound(nam);
			if(loops)
			{
				sfx.start(0,loops);
				sfx.complete=false;
			}
			else
			{
				sfx.start();
				sfx.complete=false;
			}
			
			if(vol==undefined)
			{
				sfx.setVolume(100);
			}
			else
			{
				sfx.setVolume(vol*100);
			}
		}
		return sfx;
	}
	
	
	

	function catchclicks()
	{
	}
	
	function onSoundComplete(i)
	{
		sfxs[i].sfx.complete=true;
	}
	
	function WetPlayMP3(_up)
	{
	var i;
		
		rnd_seed((new Date).getTime());
		
		up=_up;

		
		mc=gfx.create_clip(up.mc,null);
		setmenu(mc);
		
		
// create aray of sounds
		sfxs=new Array();
		for(i=0;i<6;i++)
		{
			sfxs[i]=gfx.create_clip(up.mc,null);
			sfxs[i].sfx=new Sound(sfxs[i]);
			sfxs[i].sfx.onSoundComplete=delegate(onSoundComplete,i);
			sfxs[i].sfx.complete=true;
		}
		sfxidx=0;
		

		mc_back=gfx.create_clip(mc,null);
		
		if( (_root.wp_jpg!=undefined) && (_root.wp_jpg!="") )
		{
			load_back_image(_root.wp_jpg);
		}
		else
		{
			mc_back_image=gfx.add_clip(mc,"WetPlayBack",null);
		}
		
		mc_back_colour=gfx.create_clip(mc,null);
		
		
		mc_back_image.onRelease=delegate(catchclicks);
		mc_back_colour.onRelease=delegate(catchclicks);
		
		
		if((_root.wp_w!=undefined)&&(_root.wp_w!="")) { w=int(_root.wp_w); } else {	w=380; }
		if((_root.wp_h!=undefined)&&(_root.wp_h!="")) { h=int(_root.wp_h); } else {	h=200; }
		if((_root.wp_x!=undefined)&&(_root.wp_x!="")) { mc._x=int(_root.wp_x); } else {	mc._x=10; }
		if((_root.wp_y!=undefined)&&(_root.wp_y!="")) { mc._y=int(_root.wp_y); } else {	mc._y=10; }
		if((_root.wp_s!=undefined)&&(_root.wp_s!="")) { row_size=int(_root.wp_s); } else {	row_size=20; }
		
		x=mc._x;
		y=mc._y;
		
		mc_back_image._x=-mc._x;
		mc_back_image._y=-mc._y;
		
		if( (_root.wp_fore!=undefined) && (_root.wp_fore!="") )
		{
			foreground=int(_root.wp_fore) & 0xffffff;
		}
		else
		{
			foreground=0xffffff;
		}
		
		if(_root.wp_jpg==undefined) // default tint if no image suplied
		{
			if( (_root.wp_back==undefined) || (_root.wp_back=="") )
			{
				_root.wp_back=0x40000080;
			}
		}
		
		if( (_root.wp_back_alpha!=undefined) && (_root.wp_back_alpha!="") )
		{
			_root.wp_back=((((_root.wp_back_alpha*255)/100)&0xff)<<24) | (_root.wp_back&0xffffff);
		}
		
		do_tint();
		
		xspf=new XML();
		xspf.ignoreWhite=true;
		xspf.onLoad=null;
		
		mcs1=gfx.create_clip(mc,null);
		sfx=new Sound(mcs1);
		mcs2=gfx.create_clip(mc,null);
		sfx_next=new Sound(mcs2);
		
		sfx_master=new Sound();
	}

	function setup()
	{	
	var cacheAsBitmap=_root.cacheAsBitmap;
	
		so_load();
		
		_root.cacheAsBitmap=false;
		
		var i;
		
		var g,gp,gmc;
		
		var ss=row_size;
		
		var s_wide;
		var s_high;
		var control_row;
		var xpxp;
		
		s_wide=Math.floor(w/ss); // number of columns to display
		s_high=Math.floor(h/ss); // number of rows to display
		
		if(s_high>=2)
		{
			control_row=1;
		}
		else
		{
			control_row=0;	// no room for title, put controls at top
		}
		
		
		sfx_load_stall_counter=0;
		
		image_url="";
		
//		gfx.clear(mc);
//		mc.style.fill=0xff000000;
//		gfx.draw_box(mc,undefined,0,0,w,h);
		
		mc_image=gfx.create_clip(mc,null);
		
		gfx.clear(mc_image);
//		mc_image.style.fill=0x80000000;
//		gfx.draw_box(mc_image,undefined,0,0,w,h);
		mc_image._alpha=25;
		
//		load_image("test_image");		
		
// master gizmo
		gizmo=new GizmoMaster(this);
		gizmo.top=gizmo;
		g=gizmo;
		g.set_area(0,0,w,h);
		
		
//top child
		gp=gizmo;
		

	
	xpxp=0;
	
	if(s_wide>=4)
	{
// backward
		g=gp.child(new GizmoButt(gp))
		g.set_area(ss*xpxp,ss*control_row,ss,ss);
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_backward(gmc,0,0,ss,ss);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_backward(gmc,0,0,ss,ss);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_backward(gmc,ss*0.1,ss*0.1,ss*0.8,ss*0.8);
		g.mc_down=gmc;
		
		g.id="backward";
		g.onClick=delegate(onClick,g);
		gizmo_backward=g;
		
		xpxp++;
	}
// play
		g=gp.child(new GizmoButt(gp))
		g.set_area(ss*xpxp,ss*control_row,ss,ss);
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_play(gmc,0,0,ss,ss);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_play(gmc,0,0,ss,ss);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_play(gmc,ss*0.1,ss*0.1,ss*0.8,ss*0.8);
		g.mc_down=gmc;
		
		g.id="play";
		g.onClick=delegate(onClick,g);
		gizmo_play=g;
		
// pause
		g=gp.child(new GizmoButt(gp))
		g.set_area(ss*xpxp,ss*control_row,ss,ss);
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_pause(gmc,0,0,ss,ss);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_pause(gmc,0,0,ss,ss);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_pause(gmc,ss*0.1,ss*0.1,ss*0.8,ss*0.8);
		g.mc_down=gmc;
		
		g.id="pause";
		g.onClick=delegate(onClick,g);
		gizmo_pause=g;

		xpxp++;
		
	if(s_wide>=3)
	{
		gp=gizmo;
		
// forward
		g=gp.child(new GizmoButt(gp))
		g.set_area(ss*xpxp,ss*control_row,ss,ss);
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_forward(gmc,0,0,ss,ss);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_forward(gmc,0,0,ss,ss);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_forward(gmc,ss*0.1,ss*0.1,ss*0.8,ss*0.8);
		g.mc_down=gmc;
		
		g.id="forward";
		g.onClick=delegate(onClick,g);
		gizmo_forward=g;
		
		xpxp++;
	}
	
	if(s_wide>=5)
	{
		gp=gizmo;
		
// position slider container		
		g=gp.child(new Gizmo(gp))
		g.set_area(ss*xpxp,ss*control_row,w-ss*(xpxp+1),ss);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_boxen(g.mc,0,0,w-ss*4,ss);
	
		gizmo_position=g;
		
		gp=g;
// position slider knob
		g=gp.child(new GizmoKnob(gp))
	if(s_wide>5)
	{
		g.set_area(0,0,ss,ss);
	}
	else
	{
		g.set_area(0,0,ss/2,ss);
	}
//		g.mc.style={	fill:0x40ffffff,	out:0x00ffffff,	text:0xffffffff		};
//		up.wetplayGFX.draw_puck(g.mc,0,0,ss,ss);
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_puck(gmc,0,0,g.w,ss);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_puck(gmc,0,0,g.w,ss);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_puck(gmc,0,0,g.w,ss);
		g.mc_down=gmc;
		
		g.id="position_knob";
		g.onClick=delegate(onClick,g);
		
		gizmo_position_knob=g;
	}
	
//	if(s_wide>=2)
	{
		gp=gizmo;
// volume slider container		
		g=gp.child(new Gizmo(gp))
	
	if(s_high>=2)
	{
		g.set_area(w-ss*1,0,ss,ss*2);
	}
	else
	{
		g.set_area(w-ss*1,0,ss,ss*1);
	}
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
//		up.wetplayGFX.draw_boxen(g.mc,0,0,g.w,g.h);
		gfx.draw_box(g.mc,undefined,ss*7/16,ss*1/16,ss*2/16,g.h-ss*2/16);
	
		gizmo_volume=g;
		
		gp=g;
// volume slider knob
		g=gp.child(new GizmoKnob(gp))
		g.set_area(0,0,ss,ss*10/16);
//		g.mc.style={	fill:0x80ffffff,	out:0x00ffffff,	text:0xffffffff		};
//		up.wetplayGFX.draw_puck(g.mc,0,0,ss,ss);
//		gfx.draw_box(g.mc,undefined,ss*3/16,ss*3/16,ss*10/16,g.h-ss*6/16);
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		gfx.draw_box(gmc,undefined,ss*3/16,ss*3/16,ss*10/16,g.h-ss*6/16);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		gfx.draw_box(gmc,undefined,ss*3/16,ss*3/16,ss*10/16,g.h-ss*6/16);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		gfx.draw_box(gmc,undefined,ss*3/16,ss*3/16,ss*10/16,g.h-ss*6/16);
		g.mc_down=gmc;
		
		gizmo_volume_knob=g;
		
		if(s_wide==1)
		{
			gizmo_volume.active=false;
		}
	}

	if(s_high>2)
	{
		gp=gizmo;
// scroll slider container		
		g=gp.child(new Gizmo(gp))
		g.set_area(w-ss*1,ss*2,ss,h-ss*2);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_boxen(g.mc,0,0,g.w,g.h);
	
		gizmo_scroll=g;
		
		gp=g;
// scroll slider knob
		g=gp.child(new GizmoKnob(gp))
		g.set_area(0,0,ss,ss);
//		g.mc.style={	fill:0x80ffffff,	out:0x00ffffff,	text:0xffffffff		};
//		up.wetplayGFX.draw_puck(g.mc,0,0,ss,ss);
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_puck(gmc,0,0,ss,ss);
		g.mc_base=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_puck(gmc,0,0,ss,ss);
		g.mc_over=gmc;
		
		gmc=gfx.create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		up.wetplayGFX.draw_puck(gmc,0,0,ss,ss);
		g.mc_down=gmc;
		
		gizmo_scroll_knob=g;
	}	
		
	if(s_high>=2)
	{
		gp=gizmo;
// title
		g=gp.child(new GizmoLine(gp))
		g.set_area(ss*0,ss*0,w-ss,ss);
		
		g.tf_fmt.size=ss-4;
		g.tf_fmt.color=0xff000000+foreground;
		g.str="";
		
		g.draw_mask();

		gizmo_title=g;
	}
	
// list

	if(s_high>2)
	{
		gp=gizmo;
		
		g=gp.child(new GizmoList(gp))
		g.set_area(ss*0,ss*2,(w-ss),h-ss*2);
		gp=g;
		
		g=gp.child(new GizmoList(gp));
		g.set_area(0,0,gp.w-ss,gp.h);
		g.lh=ss;
		g.tf_fmt.size=ss-6;
		g.tf_fmt.color=0xff000000+foreground;
		g.base_alpha=50;
		g.vgizmo=gizmo_scroll_knob;
		
		gizmo_list1=g;
		
		

		g=gp.child(new GizmoList(gp));
		g.set_area(gp.w-ss,0,ss,gp.h);
		g.lh=ss;
		g.tf_fmt.size=ss-6;
		g.tf_fmt.color=0xff000000+foreground;
		g.base_alpha=30;
		g.vgizmo=gizmo_scroll_knob;
		
		gizmo_list2=g;

	}

		
		
/*		
		up.wetplayGFX.draw_backward(mc,		ss*0,ss*1, ss,ss );
		up.wetplayGFX.draw_back(mc,	 		ss*1,ss*1, ss,ss );
		up.wetplayGFX.draw_play(mc,	 		ss*2,ss*1, ss,ss );
		up.wetplayGFX.draw_pause(mc,		ss*3,ss*1, ss,ss );
		up.wetplayGFX.draw_stop(mc,			ss*4,ss*1, ss,ss );
		up.wetplayGFX.draw_forward(mc, 		ss*5,ss*1, ss,ss );
*/

		gizmo_play.active=true;
		gizmo_pause.active=false;

		
// stuff to display		
		xspfs=new Array();
		
		if((_root.wp_mp3!=undefined) && (_root.wp_mp3!=""))
		{
			xspfs[0]={ url:"MP3" , str:_root.wp_mp3 };
		}
		else
		if((_root.wp_xspf!=undefined) && (_root.wp_xspf!=""))
		{
			xspfs[0]={ url:_root.wp_xspf , str:_root.wp_xspf };
		}
		
//add the following extra playlists unless kidsafe mode is on
		if(!_root.kidsafe)
		{
			
xspfs.push({ url:"http://swf.wetgenes.com/swf/WetDike.xspf" ,			str:"WetDike ProjectOpus Playlist" });
			

// scrape available html from last.fm for their hosted mp3 links...	
// you can use any last.fm page that contains mp3 links...

//xspfs.push({ url:"http://www.last.fm/music/+charts/free/" ,					str:"Top free tracks from Last.FM" });
			
			
//xspfs.push({ url:"http://grabb.it/charts/activity.xspf" ,				str:"Random tracks from grabb.it" });


//xspfs.push({ url:"http://grabb.it/users/XIX.xspf" ,						str:"XIX's favorite tracks on grabb.it" });
//xspfs.push({ url:"http://grabb.it/users/shi.xspf" ,						str:"shi's favorite tracks on grabb.it" });


//xspfs.push({ url:"grabb.it" ,	str:"Your favorite tracks on grabb.it" });


			
// a small redirection to a recent hour of slack

xspfs.push({ url:"http://swf.wetgenes.com/swf/hourofslack.php" ,		str:"Listen to a recent hour of slack." });


// need to add newgrounds top 5

//rss -> http://rss.ngfiles.com/weeklyaudiotop5.xml
//mp3 -> http://www.newgrounds.com/audio/download.php?which=single&id=109897

		}
	

// make names of xspf files less icky
	
		for(i=0;i<xspfs.length;i++)
		{
		var aa;
			aa=xspfs[i].str.split("/");
			if(aa.length>1)
			{
				if(aa[aa.length-1]=="")
				{
					xspfs[i].str=aa[aa.length-2];
				}
				else
				{
					xspfs[i].str=aa[aa.length-1];
				}
			}
		}
		
		xspfs[xspfs.length]={ url:"" , str:"Options" };
		
		force=0;
		if ( (_root.wp_force!=undefined) && (_root.wp_force!="") )
		{
			force=int(_root.wp_force)?1:0;
		}
		
		auto=0;
		if((	so.data.auto!=undefined) && (!force) )
		{
			auto=int(so.data.auto)?1:0;
		}
		else
		if ( (_root.wp_auto!=undefined) && (_root.wp_auto!="") )
		{
			auto=int(_root.wp_auto)?1:0;
		}
		
		shuffle=0;
		if( (_root.wp_shuffle!=undefined) && (_root.wp_shuffle!="") )
		{
			shuffle=int(_root.wp_shuffle)?1:0;
		}
			
		loop=1;
		if( (_root.wp_loop!=undefined) && (_root.wp_loop!="") )
		{
			loop=int(_root.wp_loop)?1:0;
		}
		
		sfx_on=1;
		if( (_root.wp_sfx!=undefined) && (_root.wp_sfx!="") )
		{
			sfx_on=int(_root.wp_loop)?1:0;
		}
		
/*
		for(i=0;i<32.i++)
		{
			xspfs[i]={ url:"http://www.projectopus.com/playlist/xspf/8835" , str:"Testing:"+i };
		}
*/		
		
		show_xspfs();
		
//		load_xml(xspfs[0].url);

		got_creator=1;

		track_id=-1;
		xspf_id=-1;
		
		gizmo_title.str="Select a playlist to play.";

		if( (	so.data.vol!=undefined) && (!force) )
		{
		var vol;
			vol=(so.data.vol)/100;
			if(vol<=0) {vol=0; auto=0; }
			if(vol>1) {vol=1;}
			gizmo_volume_knob.set_knob(0,1.0-vol);
		}
		else
		if(_root.wp_vol!=undefined)
		{
		var vol;
			vol=(_root.wp_vol)/100;
			if(vol<=0) {vol=0; auto=0; }
			if(vol>1) {vol=1;}
			gizmo_volume_knob.set_knob(0,1.0-vol);
		}
		else
		{
			gizmo_volume_knob.set_knob(0,1.0-0.5);
		}
		
		if(auto)
		{
			xspf_id=0;
			load_xml(xspfs[0].url);
			state="pause";
		}
		else
		if(xspfs.length==2)
		{
			xspf_id=0;
			load_xml(xspfs[0].url);
			state="pause";
		}
		
		
// stuff to display
		options=new Array();
		
		var o=options;
		
		o.push( { str:".. (click to go back)" } );
		o.push( { str:"This is WetPlay #(VERSION_NUMBER) : www.WetGenes.com" , url:"http://www.WetGenes.com" } );
		o.push( { str:"(c) Kriss Daniels 2007 : XIXs.com" , url:"http://XIXs.com" } );
		o.push( { str:"Powered by project opus / XSPF : ProjectOpus.com" , url:"http://www.projectopus.com" } );
//		o.push( { str:"Click the lines above for more info" } );
//		o.push( { str:"" } );
		o.push( { opt:"shuffle" } );
		o.push( { opt:"autoplay" } );
		o.push( { opt:"repeat" } );
		o.push( { opt:"sfx" } );
		
		
// turn off bitmap cache, it screws things up...

		_root.cacheAsBitmap=cacheAsBitmap;
		
		throbe=0;
	}

	
// setup context menu

var menu_mp3_name;
var menu_mp3_link;

	function premenu(obj,cm)
	{
	var show=true;
	var t;
	
//		dbg.print("you"+obj);
		
		t=gizmo_list1.hover;
/*
		if(!t)
		{
			t=gizmo_list2.hover;
		}
*/
		
//		dbg.print("1="+t);
//		dbg.print("2="+t.item);

		if(t.item>0)
		{
			t=tracks[t.item];
		}
		else
		{
			t=null;
		}
		
		if( (view=="tracks") && (t) )
		{
			show=true;
		}
		else
		{
			show=false;
		}
		
		if (show == false)
		{
			cm.customItems[0].enabled=false;
			cm.customItems[0].caption="Download MP3";
			cm.customItems[1].enabled=false;
			cm.customItems[1].caption="Remember MP3";
		}
		else
		{
			
			menu_mp3_name=""+t.title;
			menu_mp3_link=""+t.location;

			cm.customItems[0].enabled=true;
			cm.customItems[0].caption="Download "+menu_mp3_name;
			cm.customItems[1].enabled=false;
			cm.customItems[1].caption="Remember "+menu_mp3_name;
		}
	}
	
	function setmenu(mc)
	{
	var cm;
	var ci;
	var cf;

		cm=new ContextMenu(delegate(premenu));
		cm.hideBuiltInItems();

		cf=delegate(menu_download);
		ci=new ContextMenuItem("Download this MP3", cf);
		cm.customItems.push(ci);
		
		cf=delegate(menu_remember);
		ci=new ContextMenuItem("Remember this MP3", cf);
		cm.customItems.push(ci);
		
		cf=delegate(menu_do,"pp");
		ci=new ContextMenuItem("Play / Pause", cf);
		cm.customItems.push(ci);
		
		cf=delegate(menu_do,"forward");
		ci=new ContextMenuItem("Next Track", cf);
		cm.customItems.push(ci);
		
		cf=delegate(menu_do,"backward");
		ci=new ContextMenuItem("Previous Track / Rewind", cf);
		cm.customItems.push(ci);
		
		cf=delegate(menu_vol,100);
		ci=new ContextMenuItem("Set Volume to 100%", cf);
		cm.customItems.push(ci);
		cf=delegate(menu_vol,75);
		ci=new ContextMenuItem("Set Volume to 75%", cf);
		cm.customItems.push(ci);
		cf=delegate(menu_vol,50);
		ci=new ContextMenuItem("Set Volume to 50%", cf);
		cm.customItems.push(ci);
		cf=delegate(menu_vol,25);
		ci=new ContextMenuItem("Set Volume to 25%", cf);
		cm.customItems.push(ci);
		cf=delegate(menu_vol,0);
		ci=new ContextMenuItem("Set Volume to 0%", cf);
		cm.customItems.push(ci);

		mc.menu=cm;		
	}
	
	function menu_download()
	{
		getURL(menu_mp3_link,"_blank")
	}
	
	function menu_remember()
	{
	}
	
	function menu_vol(a,b,c)
	{
//		dbg.print(c);
		gizmo_volume_knob.set_knob(0,1.0-(c/100));
	}
	
	function set_vol(v)
	{
		gizmo_volume_knob.set_knob(0,1.0-(v/100));
	}
	
	function set_vol_start(v,g)
	{
		gizmo_volume_knob.set_knob(0,1.0-(v/100));
		if(g)
		{
			if(state=="pause")
			{
				onClick_id("play");
			}
			auto=1;
		}
		else
		{
			if(state=="play")
			{
				onClick_id("pause");
			}
			auto=0;
		}
	}
	
	function menu_do(a,b,c)
	{
		if(c=="pp")
		{
			if(state=="play")
			{
				onClick_id("pause");
			}
			else
			{
				onClick_id("play");
			}
		}
		else
		{
			onClick_id(c);
		}
	}
	
	
	function split_list_view()
	{
		var tw;
		
		tw=gizmo_list1.up.w; // total width


		if( (view=="xspfs") || (got_creator < (tracks.length/2) ) || (view=="options") )
		{
			gizmo_list1.w=tw;
			gizmo_list2.w=0;
		}
		else
		if(got_creator)
		{
			gizmo_list1.w=tw-row_size;
			gizmo_list2.x=gizmo_list1.w;
			gizmo_list2.w=row_size;
		}
		
		gizmo_list1.draw_mask();
		gizmo_list2.draw_mask();
	}
	
	function show_options()
	{
	var i,o;
		view="options";
		
		for(i=0;i<options.length;i++)
		{
			o=options[i];
			
			if(o.opt)
			{
				o.str=get_option_str(o.opt);
			}
		}
		
		gizmo_list1.items=options;
		gizmo_list1.onClick=delegate(select_option);
		gizmo_list2.items=[];
		gizmo_list2.onClick=null;
		
		split_list_view();
		
	}
	
	function get_option_str(s)
	{
		switch(s)
		{
			case "shuffle" :	return "Shuffle is " +			(shuffle?"ON":"OFF");	break;
			case "autoplay" :	return "Autoplay is " +			(auto?"ON":"OFF");		break;
			case "repeat" :		return "Repeat is " +			(loop?"ON":"OFF");		break;
			case "sfx" :		return "Sound effects are " +	(sfx_on?"ON":"OFF");	break;
		}
		
		return "";
	}
	
	function toggle_option(s)
	{
		switch(s)
		{
			case "shuffle" :	shuffle=(shuffle?0:1);	break;
			case "autoplay" :	auto=(auto?0:1);		break;
			case "repeat" 	:	loop=(loop?0:1);		break;
			case "sfx" :		sfx_on=(sfx_on?0:1);		break;
		}
		
		show_options();
	}
	
	function show_xspfs()
	{
		view="xspfs";
		
		gizmo_list1.items=xspfs;
		gizmo_list1.onClick=delegate(select_xspf);
		gizmo_list2.items=[];
		gizmo_list2.onClick=null;
		
//		gizmo_title.str="Select a playlist to play.";

		split_list_view();
	}
	function show_tracks()
	{
		view="tracks";
		
		gizmo_list1.items=tracks1;
		gizmo_list2.items=tracks2;

		gizmo_list1.onClick=delegate(select_mp3);
		gizmo_list2.onClick=delegate(select_mp3_artist);
		
		split_list_view();
	}


	
	function select_option(ln)
	{
	var id,o;
		
		id=ln.item;
		
		if(id==0) // pop back up to playlist select
		{
			show_xspfs();
			return;
		}
		
		o=options[id];
		
		if(o.url)
		{
			getURL(o.url,"BOT");
		}
		else
		if(o.opt)
		{
			toggle_option(o.opt);
		}

	}
	
	function select_xspf(ln)
	{
	var id;
		
		id=ln.item;
		
		if( (id>=xspfs.length-1) || (id<0) )
		{
			show_options();
		}
		else
		{
			xspf_id=id;

			load_xml(xspfs[id].url);
			state="pause";

				
//			dbg.print("id="+id);
		}
		
	}
	
	function select_mp3(ln)
	{
		select_mp3_id(ln.item);
	}
	function select_mp3_id(id)
	{
		
//		dbg.print("mp3 id="+id);
		
		if(id==0) // pop back up to playlist select
		{
			show_xspfs();
		}
		else
		{
			track_id=id;
			play_mp3(tracks[track_id]);
			gizmo_play.active=false;
			gizmo_pause.active=true;
			state="play";
		}
	}
	
	function select_mp3_artist(ln)
	{
	var id;
		
		id=ln.item;
	
//		dbg.print("artist id="+id);
		
		show_artist(tracks[id]);
	}
	
	function play_mp3(t)
	{
		if(t==undefined) { return; }
		
		load_image(t.image);
		if(t.creator=="")
		{
			set_title(t.title);
		}
		else
		{
			set_title(t.title + " (by) " + t.creator);
		}
		
		disp_title=t.title;
		disp_creator=t.creator;
		disp_info=t.info;
		
		sfx.stop();
		sfx.start(0);	// flash bug hack fix?
		sfx.stop();
		sfx.loadSound(t.location,true);
		
		gizmo_position_knob.set_knob(0,0);
		
		sfx_load_stall_counter=0;
	}
	
	function stop_mp3()
	{
		sfx.stop();
		sfx_next.stop();

		gizmo_position_knob.set_knob(0,0);
		
		gizmo_play.active=true;
		gizmo_pause.active=false;
		
		state="pause";
	}
	
	function show_artist(t)
	{
		getURL(t.info,"BOT");
	}
	
	function set_title(str)
	{
		gizmo_title.str=str;
	}
	
	function load_back_image(url)
	{
		mc_back_image.removeMovieClip();
		mc_back_image=gfx.create_clip(mc_back);
		mc_back_image._lockroot=true;
		mc_back_image.loadMovie(url);
//		dbg.print("Loading '"+url+"'");
	}
	
	function do_tint()
	{
		if( (_root.wp_back!=undefined) && (_root.wp_back!="") )
		{
			gfx.clear(mc_back_colour);
			mc_back_colour.style.fill=int(_root.wp_back);
			gfx.draw_box(mc_back_colour,undefined,-x,-y,w+x*2,h+y*2);
		}
	}
	
	function load_image(url)
	{
/*
		if(mc_image.onEnterFrame)
		{
			mc_image3.removeMovieClip();
			mc_image3=null;
		}
*/	
	
		if(image_url==url) { return; } // no image change
		if(image_url=="") { return; } // no image change
		if(image_url=="undefined") { return; } // no image change
		if(image_url==undefined) { return; } // no image change
		
		image_url=url;
	
	
		
//		mc_image2.unloadMovie();
//		mc_image2.removeMovieClip();
		
		mc_image3=gfx.create_clip(mc_image);
		mc_image3._lockroot=true;
		mc_image3.loadMovie(url);
		mc_image.onEnterFrame=delegate(load_image_check);
		
		mc_image2.removeMovieClip();
		mc_image2=mc_image3;
		mc_image3=null;
	}
	
	
	function load_image_check()
	{
	var tot,lod;
		
		tot=mc_image2.getBytesTotal();
		lod=mc_image2.getBytesLoaded();
	
//		dbg.print("load check??? " + lod + " : " + tot );
		
		if( tot == -1 )
		{
			mc_image.onEnterFrame=null;
			return;
		}
		
		if( ( lod != tot ) || ( tot == 0 ) || (mc_image2._width==0) || (mc_image2._height==0) )
		{
			return; // do nothing until we are loaded
		}
	
		var sx,sy,sxy;
		var sxp,syp;
		
		mc_image.onEnterFrame=null;
		
		
//		dbg.print("loaded");
		
		sx=100*w/mc_image2._width;
		sy=100*h/mc_image2._height;
		sxy=sx; if(sy<sxy) { sxy=sy; }
		sxp=sxy*mc_image2._width/100;
		syp=sxy*mc_image2._height/100;
		sxp=(w-sxp)/2;
		syp=(h-syp)/2;
		mc_image2._xscale=sxy;
		mc_image2._yscale=sxy;
		mc_image2._x=sxp;
		mc_image2._y=syp;
		
	}
	
	function clean()
	{
	}

	function onClick(g)
	{
		onClick_id(g.id)
	}
	function onClick_id(g_id)
	{
	var ms;
	
		switch(g_id)
		{
			case "forward":
				gizmo_play.active=false;
				gizmo_pause.active=true;
				click_forward();
				state="play";
			break;
			
			case "backward":
				gizmo_play.active=false;
				gizmo_pause.active=true;
				click_backward();
				state="play";
			break;
			
			case "play":
				if(state!="play")
				{
					gizmo_play.active=false;
					gizmo_pause.active=true;
					sfx.start( ((sfx.played_frac/sfx.loaded_frac)*sfx.duration)/1000 );	// flash bug hack fix?
					state="play";
				}
			break;
			
			case "pause":
				if(state!="pause")
				{
					gizmo_play.active=true;
					gizmo_pause.active=false;
					sfx.stop();
					state="pause";
				}
			break;
			
			case "position_knob":
				gizmo_play.active=false;
				gizmo_pause.active=true;
				sfx.stop();
				ms=((gizmo_position_knob.x_knob/sfx.loaded_frac)*sfx.duration);
				if(ms>sfx.duration-500) { ms=sfx.duration-500; }	// check we dont ask to play past what is loaded
				if(ms<0) { ms=0; }
				sfx.start( ms/1000 );
				state="play";
			break;
		}
	}


	function update()
	{
		var sfx_loaded_frac=(sfx.getBytesTotal()>0) ? (sfx.getBytesLoaded()/sfx.getBytesTotal()) : 0 ;
		var sfx_played_frac=(sfx.duration>0) ? ((sfx.position/sfx.duration)*sfx.loaded_frac) : 0 ;


		if(mc._visible) // dont do stuff you cant see anything
		{
			var ss=row_size;
			var g;
			
			
			if(view=="tracks")
			{
				gizmo_list1.selected=track_id;
				gizmo_list2.selected=track_id;
			}
			else
			if(view=="xspfs")
			{
				gizmo_list1.selected=xspf_id;
				gizmo_list2.selected=xspf_id;
			}
			
//		gizmo_title.str="ABCDEFwxyz:"+mc._xmouse;
			
/*
			var snapshot=up.poker.snapshot();
			mc.localToGlobal(snapshot);
			gizmo.mc.globalToLocal(snapshot);
			gizmo.focus=gizmo.input(snapshot);
*/
			var snapshot=_root.poker.snapshot();
			_root.localToGlobal(snapshot);
			gizmo.mc.globalToLocal(snapshot);
			gizmo.focus=gizmo.input(snapshot);
			
			gizmo.update();
			
			
//		gizmo_position_knob.set_knob(sfx.getBytesLoaded()/sfx.getBytesTotal(),0);

			sfx.played_frac_last=sfx.played_frac;
			sfx.loaded_frac_last=sfx.loaded_frac;
			sfx.loaded_frac=sfx_loaded_frac; // pre calced above
			sfx.played_frac=sfx_played_frac;
			
//		dbg.print( sfx.position +" / "+ sfx.duration);
			
			if( sfx.played_frac != sfx.played_frac_last )
			{
				gizmo_position_knob.set_knob( sfx.played_frac  ,0);
			}
			
			if( sfx.loaded_frac != sfx.loaded_frac_last )
			{
				g=gizmo_position;
				g.mc.clear();
				g.mc.style={	fill:0x20000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
				gfx.draw_box(g.mc,undefined,ss*1/16,ss*1/16,(g.w-ss*2/16)*sfx.loaded_frac,g.h-ss*2/16);
				g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
				up.wetplayGFX.draw_boxen(g.mc,0,0,g.w,g.h);

				sfx_load_stall_counter=0;
			}
			else
			{
				if( (sfx.loaded_frac!=1) && ( sfx.played_frac == sfx.played_frac_last) )
				{
					sfx_load_stall_counter++;
				}
				else
				{
					sfx_load_stall_counter=0;
				}
			}
			
//		dbg.print(sfx.loaded_frac + " : stall : "+sfx_load_stall_counter);
		
		}
		
		if(state=="play")
		{
		
 // check for end of track or if streaming has stalled and then jump to next
 
			throbe*=1.0-(0.05*(1.0-gizmo_volume_knob.y_knob));
			if(throbe<=0.05)
			{
				throbe=1.0-gizmo_volume_knob.y_knob;
			}

 
			if	(
					( ( (sfx_loaded_frac==1) && (sfx.getBytesTotal()!=undefined) ) && ( sfx.position>=sfx.duration-1 ) )
					||
					( sfx_load_stall_counter > 31*5 )
				)
			{
				if(gizmo_volume_knob.y_knob != 1.0) // volume set to 0 then dont bother moving to the next track
				{
					sfx_load_stall_counter=0;
					play_next_track();
				}
				else
				{
					throbe=0;
				}
			}
			
		}
		else
		{
			throbe=0;
		}
		
		var vt=((1.0-gizmo_volume_knob.y_knob)*2);
		vt=vt*vt*vt;
		vt=vt/2; // now in range of 0-4 not 0-1 but dfault volume of 0.5 is still 0.5
		sfx_master.setVolume(vt*100);
		
		if(!gizmo.focus)
		{
			so_save();
		}
	}
	
	function click_forward()
	{
		play_next_track();
	}
	
	function play_next_track()
	{
		if(tracks.length==0) { return; }
		
		track_id++;
		if( (track_id>=tracks.length) )
		{
			track_id=1;
			if(shuffle)
			{
				shuffle_tracks();
			}
			if(!loop) 
			{
				play_mp3(tracks[track_id]);
				stop_mp3();
				return;
			}
		}
		else
		if( (track_id<=0) )
		{
			track_id=1;
			if(shuffle)
			{
				shuffle_tracks();
			}
		}
		play_mp3(tracks[track_id]);
	}
	
	function click_backward()
	{
		if(sfx.position<2000)
		{
			play_prev_track();
		}
		else
		{
//			sfx.stop();
			sfx.start(0); // restart this track
		}
		
	}
	
	function play_prev_track()
	{
		track_id--;
		if( (track_id<=0) || (track_id>=tracks.length) )
		{
			track_id=tracks.length-1;
			if(shuffle)
			{
				shuffle_tracks();
			}
		}
		play_mp3(tracks[track_id]);
		state="play";
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
	

	function load_xml(s)
	{
	var ss;
	var st;
	var sd;
	
		if(xspf.onLoad) // dont queue up multiple loads
		{
			return;
		}
		if(tracks_url==s) // dont reload
		{
			show_tracks();
			return;
		}
		
		tracks_url=s;
		
		st=tracks_url.split("/");
		sd=st[st.length-1].split(".");
	
		if(s=="MP3")
		{
		var str=
'<?xml version="1.0" encoding="UTF-8" ?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
<trackList>
<track>
<title>'+_root.wp_mp3+'</title>
<location>'+_root.wp_mp3+'</location>
</track>
</trackList>
<playlist>
';

			xspf.parseXML(str);
			
			loaded_xml();
		}
		else
		if( sd[sd.length-1].toLowerCase()=="mp3" )
		{
		var str=
'<?xml version="1.0" encoding="UTF-8" ?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
<trackList>
<track>
<title>'+s+'</title>
<location>'+s+'</location>
</track>
</trackList>
<playlist>
';

			xspf.parseXML(str);
			
			loaded_xml();
		}
		else
		if(st[2]=="www.last.fm")
		{
			ss=s.split("%20");
			s=ss.join("+");
			ss=s.split(" ");
			s=ss.join("+");
//			dbg.print(s);
		
			xspf.noData=xspf.onData;
			xspf.onData=delegate(loaded_html);
			xspf.onLoad=delegate(loaded_html);
			xspf.load(s);
		
//		dbg.print("xml loading "+s);
		
			set_title("scraping html");
		}
		else
		if(s=="grabb.it")
		{
			xspf.onData=delegate(loaded_grabbit);
			xspf.load("http://grabb.it/sessions.js");
			set_title("Getting username");
		}
		else
		{
			xspf.onLoad=delegate(loaded_xml);
			xspf.load(s);
			set_title("Loading Playlist");
		}
		
	}
	
	function loaded_html(txt)
	{
	var dots;
	var hits;
	var dash;
	var s;
	var i,j;
	var m,n;
	var tr;
	
		track_preload();
		
		m=null;
		
		xspf.onData=xspf.noData;
		xspf.onLoad=null;
		
		dots=txt.split(".mp3");
		
		for(i=0;i<dots.length;i++)
		{
			hits=dots[i].split("http:");
			
			s=hits[hits.length-1];
			
			if(s.substring(0,2)=="//")
			{
				dash=s.split("/");
				if(dash[3]=="download")
				{
					n="http:"+s+".mp3";
					if(m!=n)
					{
						m=n;
//						dbg.print(m);
						
						tr=new Object();
						tr.location=n;
						tr.creator=" on Last.FM";
						add_tr(tr);
						tr.info="http://www.last.fm/music/?m=tracks&q="+tr.titleurl;

					}
				}
			}
		
		}
		
		track_postload();
	}
		
	function track_preload()
	{
		tracks=new Array();
		
		tracks1=new Array();
		tracks2=new Array();
		
		tracks[0]={str:".. (click to go back)"};
		tracks1[0]={str:".. (click to go back)"};
		tracks2[0]={str:""};
		
		got_creator=0;
		
	}
	
	function track_postload()
	{
		show_tracks();
		
		stop_mp3();
		set_title("Loaded "+ (tracks.length-1) +" tracks.");
		
		show_tracks();
		
		track_id=-1;
		
// the GC kills us ???

		if(shuffle)
		{
			shuffle_tracks();
		}
		
		if(auto)
		{
			select_mp3_id(1);
		}
	}
	
	function loaded_grabbit(src)
	{
	var nam;
		
		nam=src.split("\"")[3]; // icky parse hax :)
		
		xspf=new XML();
		xspf.ignoreWhite=true;
		xspf.onLoad=delegate(loaded_xml);
		if(nam)
		{
			xspf.load("http://grabb.it/users/"+nam+".xspf");
		}
		else
		{
			xspf.load("http://grabb.it/charts/activity.xspf");
		}
		set_title("Loading Playlist");
	}
	
	function loaded_xml()
	{
		xspf.onLoad=null;
		
//		dbg.print("xml parsing zZzZz");
		
//		dbg.print(xspf.status);
		
		
		track_preload();
		
		parse_xml(xspf);
		
		track_postload();
		
	}
	
		
	function parse_xml(n)
	{
		var i,t;
		
		if(n.nodeName=="track")
		{
			add_track_from_xml(n);
		}
		else
		{
			t=n.childNodes;
			
			for(i=0;i<t.length;i++)
			{
				parse_xml(t[i]);
			}
		}
	}
	
	function add_tr(tr)
	{
	var i,j;
	var t,tt;
	var s,s1,s2;
	var aa;



// build readable title from url
		s=tr.location;
//dbg.print(s);
		aa=s.split("/");
		if(aa.length>1)
		{
			if(aa[aa.length-1]=="")
			{
				s=aa[aa.length-2];
			}
			else
			{
				s=aa[aa.length-1];
			}
		}
//dbg.print(s);
		s=unescape(s);
		
		aa=s.split("+");
		s=aa.join(" ");
				
		aa=s.split("%");
		for(j=1;j<aa.length;j++)
		{
			aa[j]=aa[j].substr(2); // skip next two chars after %
		}
		s=aa.join(" ");
		
		aa=s.split(".mp3");
		s=aa.join(" ");
		
		aa=s.split(" ");
		for(i=1;i<aa.length;i++)
		{
			if((aa[i]=="")&&(aa[i-1]=="")) // remove multiple spaces
			{
				aa.splice(i,1);
				i--;
			}
		}
		s=aa.join(" ");
		
		tr.titleurl=s;
		
		
		
			
			
		if( tr.title == undefined )
		{
			tr.title=tr.annotation;
		}
		
		if(tr.title==undefined)
		{
		
//			tr.title="unknown "+(tracks.length+1);
			tr.title=tr.titleurl;
		}
		
		s=tr.title;
		
		aa=s.split("\n");
		s=aa.join(" ");
		
		aa=s.split(" ");
		for(i=1;i<aa.length;i++)
		{
			if((aa[i]=="")&&(aa[i-1]=="")) // remove multiple spaces
			{
				aa.splice(i,1);
				i--;
			}
		}
		s=aa.join(" ");
		
		tr.title=s;

		if(tr.creator==undefined)
		{
			tr.creator="";
			if(tr.info) // got a link
			{
				tr.creator="?";
				got_creator++;
			}
		}
		else
		{
			got_creator++;
		}
		
		s1="" + tr.title;
		s2="" + tr.creator;
		
		tracks[tracks.length]=tr;
		
		tracks1[tracks1.length]={str:s1};
		tracks2[tracks2.length]={str:s2};
	}
	
	function add_track_from_xml(n)
	{
	var i;
	var t,tr,tt;
	var s1,s2;
	
		tr=new Object();
	
		t=n.childNodes;
		
		for(i=0;i<t.length;i++)
		{
			tt=t[i];
			
			if( (tt.nodeName) && (tt.firstChild.nodeValue) )
			{
//				dbg.print(tt.nodeName + ":" + tt.firstChild.nodeValue );
				
				tr[tt.nodeName]=tt.firstChild.nodeValue;
			}
		}
		
//		tr.str=" " + tr.creator + "   |   " + tr.title ;
		
		add_tr(tr);		
	}
	
	function shuffle_tracks()
	{
	var i,r,l;
	
//		dbg.print("shuffling");
	
	
		l=tracks.length-1;
	
		for(i=0;i<l;i++)
		{
			r=rnd()%l;
			
			tracks.splice(1,0,tracks[r+1]);
			tracks.splice(r+2,1);
			
			tracks1.splice(1,0,tracks1[r+1]);
			tracks1.splice(r+2,1);
			
			tracks2.splice(1,0,tracks2[r+1]);
			tracks2.splice(r+2,1);
			
		}
	}
	
	
	var so;
	var so_loaded=false;
	
	function so_load()
	{
		so=SharedObject.getLocal("www.wetgenes.com/WetPlay");
		
		var t=so.data;
		
		so_loaded=false;
		
		if( t.sfx!=undefined )	{ sfx_on=t.sfx; so_loaded=true; }
	}
	
	function so_save()
	{
	var flush=false;
	
		var t=so.data;
		
		var v=Math.floor((1.0-gizmo_volume_knob.y_knob)*100);
		
		if( t.vol!=v )			{ flush=true; t.vol=v; }
		if( t.sfx!=sfx_on )		{ flush=true; t.sfx=sfx_on; }
		if( t.auto!=auto )		{ flush=true; t.auto=auto; }
		
		if(flush)
		{
			so.flush();
		}
	}
	
	
}
