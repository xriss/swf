/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


// a simple WTF is this overlay layer thingy

class WTF
{

	var import_swf_name;
	var mc_import;
	
	var v
	
	var mc;
	var mc2;
	
	var tf;
	
	var sc;
	
	var display;
	
	var corner="BR";
	
	var ontarget=false;

	var last_track;
	var last_artist;

	var show_nowplaying;
	var scale_800x600;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	
	function get_width()
	{
		if(scale_800x600)
		{
			return 800;
		}
		else
		{
			return Stage.width;
		}
	}
	function get_height()
	{
		if(scale_800x600)
		{
			return 600;
		}
		else
		{
			return Stage.height;
		}
	}
	
	function WTF(stropts)
	{
	var i;
	var s;
	
		show_nowplaying=false;
		scale_800x600=false;
	
		if(stropts)
		{
		var aaopts;
		var opt;
	
			aaopts=stropts.split(",");
			for(i=0; i<aaopts.length ; i++ )
			{
				switch(aaopts[i])
				{
					case "show_nowplaying":
//						show_nowplaying=true;
					break;
					case "scale_800x600":
						scale_800x600=true;
					break;
				}
			}
		}
		
		v=[];
		v.name='#(VERSION_NAME)';
		v.site='#(VERSION_SITE)';
		v.number='#(VERSION_NUMBER)';
		v.stamp='#(VERSION_STAMP)';
		v.stamp_number='#(VERSION_STAMPNUMBER)';
		v.root='#(VERSION_ROOT)';
		
		
		System.security.allowDomain( _root._url );
		System.security.allowDomain( _root._url.split("/")[2] );
		System.security.allowDomain("data.wetgenes.com");
		System.security.allowDomain("s3.wetgenes.com");
		System.security.allowDomain("www.wetgenes.com");
		System.security.allowDomain("swf.wetgenes.com");
		System.security.allowDomain("www.wetgenes.local");
		System.security.allowDomain("swf.wetgenes.local");

// this doesnt work on flahs seven... so we need the above too		
		System.security.allowDomain("*");
		
//		System.security.loadPolicyFile("http://swf.wetgenes.com/crossdomain.xml"); // so we can load images and cache them...
//		System.security.loadPolicyFile("http://data.wetgenes.com/crossdomain.xml");

		System.security.loadPolicyFile("http://swf.wetgenes.com/crossdomain.xml");
		System.security.loadPolicyFile("http://data.wetgenes.com/crossdomain.xml");
		
//		System.security.loadPolicyFile("http://swf.wetgenes.local/crossdomain.xml");
//		System.security.loadPolicyFile("http://data.wetgenes.local/crossdomain.xml");

		//		System.security.loadPolicyFile("http://data.wetgenes.lg1.simplecdn.net/crossdomain.xml");

		
		mc_import=gfx.create_clip(_root,16384+32-18);
		
/*
		mc=gfx.create_clip(_root,16384+32-17);
		mc2=gfx.create_clip(mc,null);
		
		
		mc.onEnterFrame=delegate(update,null);
		gfx.dropshadow(mc2,2, 45, 0x000000, 1, 4, 4, 2, 3);
//	    mc.filters = [ new flash.filters.DropShadowFilter(2, 45, 0x000000, 1, 4, 4, 2, 3) ];
//		gfx.glow(mc , 0x000000, 1, 4, 4, 1, 3, false, false );
		
		tf=gfx.create_text_html(mc2,null,0,0,400,300);
*/				
				
		if(_root.host=="swf.wetgenes.local") // allow local server test, or internet disable
		{
			import_swf_name="http://swf.wetgenes.local/swf/WTF_import.swf?hash="+escape(_root.hash);
		}
		else
		{
			import_swf_name="http://swf.wetgenes.com/swf/WTF_import.swf?hash="+escape(_root.hash);
		}
					
/*
		display=-1;
				
		Mouse.addListener(this);
				
		if(show_nowplaying)
		{
			sc=new ScrollOn(this);
			sc.setup();
			sc.fntsiz=13;
			sc.mc._alpha=50;
			sc.mc._y=0;
			sc.mc._x=0;
			sc.w=get_width()-45;
		}
*/
		
#if VERSION_MOCHIBOT then

//		__com_mochibot__("#(VERSION_MOCHIBOT)", _root, 10301);

#end

		
	}

// called when login has finished, uhm, logging in by the login code
	var donelogindone=false;
	var loaded_import=false;

	function logindone()
	{
		if(!donelogindone) // only do once
		{
			if(!_root.skip_wetimport) // turn off chat and extralinks?
			{
				if(_root.login.opt_chat) // make sure chat is on
				{
					mc_import.loadMovie(import_swf_name);			// generic import
					loaded_import=true;
				}
			}
			donelogindone=true;
		}
		else // not first time
		{
			if(!_root.skip_wetimport) // turn off chat and extralinks?
			{
				if(_root.login.opt_chat) // make sure chat is on
				{
					if(!loaded_import)
					{
						mc_import.loadMovie(import_swf_name);			// generic import
						loaded_import=true;
					}
				}
				else // make sure chat is off
				{
				}
			}
		}
	}
	
/*
	
	function onMouseDown()
	{
		if( (display) )
		{
			ontarget=true;
		}
	}
	
	function onMouseUp()
	{
		if( (display) && (ontarget) )
		{
			getURL("http://www.WetGenes.com","_blank")
		}
		ontarget=false;
	}
	
	
	function onRelease()
	{
	}
	


	var pop_state=false;
	var pop_disable=false;
	var pop_delay=0;
		
	function update()
	{
	var s;
//	var newdisplay;
	
		if(scale_800x600) // scale everything to standard size
		{
			_root.scalar.apply(mc);
		}
				
		var pop_state_new=false;
		var pop_mouse=false;
		
		if( (mc._xmouse>get_width()-128) && (mc._ymouse>get_height()-16) && (mc._xmouse<=get_width()) && (mc._ymouse<=get_height()))
		{
			pop_mouse=true;// mouse is over pop out area
		}
		
		if((pop_state)||(pop_disable)) // we are already out, or we are disabled
		{
			if(pop_mouse)
			{
				if(!pop_disable)
				{
					pop_state_new=true; // stay out
				}
			}
			else
			{
				pop_disable=false; // have moved off of area so allow popout if we move back
			}
		}
		else // not popped out yet
		{
			if(pop_mouse)
			{
				if(_root.poker.poke_now)
				{
					pop_disable=true; // mouse has been pressed or is held down so disable popout, this fixes accidental clicks/drags
				}
				else
				{
					pop_state_new=true;
				}
			}
		}
		
		if(pop_delay>0) { pop_delay--; }
		if(!pop_state_new) { pop_delay=10; }
		
		if(pop_delay==0) // we are popped out now
		{
			pop_state=true;
		}
		else // we are popped in now
		{
			pop_state=false;
		}
		
		
		

		if( pop_state!=display )
		{
			display=pop_state;
			if( display )
			{
				s="";
				
#VERSION_AUTH=VERSION_AUTH or "Shi+Kriss Daniels"
				s+="<p align='right'>#(VERSION_NAME) #(VERSION_NUMBER) (c) #(VERSION_AUTH) #(VERSION_STAMP)</p>";

#if		VERSION_BUILD=='4lfa' then
				s+="<p align='right'>Please do not redistribute.</p>";
				s+="<p align='right'>This is an 4lfa build and mostly broken.</p>";
#elseif	VERSION_BUILD=='cc' then
				s+="<p align='right'>Distributed under the CC Attribution-NoDerivs 2.5 Licence.</p>";
				s+="<p align='right'>http://creativecommons.org/licenses/by-nd/2.5/</p>";
#else
				s+="<p align='right'>Please do not redistribute.</p>";
				s+="<p align='right'>This is an 4lfa build and mostly broken.</p>";
#end
				s+="<p align='right'>Click the mouse button right now to visit</p>";
				s+="<p align='right'>www.WetGenes.com for more of everything.</p>";
				gfx.set_text_html(tf,13,0xffffff,s)
					
				gfx.clear(mc2);
				mc2.style.fill=0x80000000;
				gfx.draw_box(mc2,0,get_width()-tf.textWidth-24-6,get_height()-tf.textHeight-4-6,tf.textWidth+12,tf.textHeight+12);
					
			}
			else
			{
				gfx.clear(mc2);
				s="";
				s+="<p align='right'>www.WetGenes.com</p>";
				gfx.set_text_html(tf,13,0xffffff,s)
			}
		}
		
		if( display )
		{
			tf._x=get_width()-400-24;
			tf._y=get_height()-100-4;
			mc2._alpha=100;
		}
		else
		{
			tf._x=get_width()-400-2;
			tf._y=get_height()-15-4;
			mc2._alpha=25;
		}
		

		if(show_nowplaying)
		{
			var track=_root.wetplay.wetplayMP3.disp_title;
			var artist=_root.wetplay.wetplayMP3.disp_creator;
			var url=_root.wetplay.wetplayMP3.disp_info;
			
			sc.w=get_width()-45; // resize
			

			if( track!="" && artist!="" && ((track!=last_track) || (artist!=last_artist)) )
			{
				s="Now Playing <b>"+track+"</b> by <b>"+artist+"</b>. Click here to know more.";
//dbg.print( s );				
				sc.next={url:url,txt:s,target:"_blank"}
				
				last_track=track;
				last_artist=artist;
			}
			
			sc.update();
		}
		
	}
*/

	
// MochiBot.com -- Version 5
// Tested with with Flash 5-8, ActionScript 1 and 2
function __com_mochibot__(swfid, mc, lv)
{
	var x,g,s,fv,sb,u,res,mb,mbc;
	
	mb = '__mochibot__';
	mbc = "mochibot.com";
	g = _global ? _global : _level0._root;
	if (g[mb + swfid]) return g[mb + swfid];
	s = System.security;
	x = mc._root['getSWFVersion'];
	fv = x ? mc.getSWFVersion() : (_global ? 6 : 5);
	if (!s) s = {};
	sb = s['sandboxType'];
	if (sb == "localWithFile") return null;
	x = s['allowDomain'];
	if (x) s.allowDomain(mbc);
	x = s['allowInsecureDomain'];
	if (x) s.allowInsecureDomain(mbc);
	u = "http://" + mbc + "/my/core.swf?mv=5&fv=" + fv + "&v=" + escape(getVersion()) + "&swfid=" + escape(swfid) + "&l=" + lv + "&f=" + mc + (sb ? "&sb=" + sb : "");
	lv = (fv > 6) ? mc.getNextHighestDepth() : g[mb + "level"] ? g[mb + "level"] + 1 : lv;
	g[mb + "level"] = lv;
/*
	if (fv == 5)
	{
		res = "_level" + lv;
		if (!eval(res)) loadMovieNum(u, lv);
	}
	else
	{
*/
		res = mc.createEmptyMovieClip(mb + swfid, lv);
		res.loadMovie(u);
//	}
	return res;
}


}
