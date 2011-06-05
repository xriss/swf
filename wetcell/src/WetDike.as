/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// A Moist Klondike

class WetDike
{
//	var scores:pung_scores;

	var v;

	static var STATE_NONE      :Number =   0;
	static var STATE_PLAY      :Number =   1;

	var state_last;
	var state;
	var state_next;

	var	setup_done=false;

	var mc:MovieClip;
	var mcm:MovieClip;
	var mco:MovieClip;
	
//	var mc_popup;
	var mc_import;

//	var dikecomms:WetDikeComms;

	var dikeplay;
	var play;
	var login;
	
	var dikeswish:WetDikeSwish;
	var dikeaudit:WetDikeAudit;
	var replay:Replay;
	
	var dikescores;
	var dikestats;
	var dikeabout;
	
//	var talk;
//	var sock;
	
	
	
	var game_seed:Number=0;
	var game_replay=null;
	
	var showticker;
	// --- Main Entry Point
	
	static function main()
	{
		if(_root.kongregateServices!=undefined)
		{
			_root.kongregateServices.connect();
			_root.wethidemochiads=true; // kong disables them anyway
		}
		
		_root.cacheAsBitmap=false;

		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
		}
// overide only basic wetplay settings
//		orset_root("wp_vol",0);
		orset_root("wp_xspf","http://wetdike.wetgenes.com/swf/WetDike.xspf");
		orset_root("wp_auto",1);
		orset_root("wp_shuffle",1);
		orset_root("wp_back",0x00000000);

		orset_root("host","wetdike.wetgenes.com");
		System.security.allowDomain(_root.host);
		
		System.security.allowDomain("wetdike.wetgenes.com");
		System.security.allowDomain("swf.wetgenes.com");
		System.security.allowDomain("www.wetgenes.com");
		System.security.allowDomain("www.wetgenes.local");
		System.security.allowDomain("swf.wetgenes.local");

		_root.usecardgfxs="normal";
			
		if( System.capabilities.version.split(" ")[0]=="WII" ) // set some defaults when run on the wii
		{
			_root._highquality=2; // low quality, performance is teh poopoo on teh wiiwii
			_root.wethidemochiads=true;
			
			orset_root("wp_back",0xff000000);
			orset_root("wp_back_alpha",100);
			orset_root("wp_w",300);
			orset_root("wp_h",150);
			orset_root("wp_x",7);
			orset_root("wp_y",7);
			orset_root("wp_s",15);
			orset_root("wp_jpg","no.jpg");
			
//			_root.usecardgfxs="wii";
			
		}
		
// create popup space
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		
		_root.updates=MainStatic.update_setup();	// a table of update functions

		_root.bmc=new bmcache();

		_root.click_idx=0;
		_root.click_name='click0';
 
		_root.newdepth=1;
		_root.scalar=new Scalar(800,600);
		_root.loading=new Loading(true);
		_root.poker=new Poker(true);
		_root.wetdike=new WetDike();
		
		_root.signals=new BetaSignals(_root.wetdike);
		_root.comms=new BetaComms(_root.wetdike);
		
		_root.onEnterFrame=function()
		{
			_root.wetdike.update();
		}
		

	}

	function WetDike()
	{
		v=[];
		v.name='#(VERSION_NAME)';
		v.site='#(VERSION_SITE)';
		v.number='#(VERSION_NUMBER)';
		v.stamp='#(VERSION_STAMP)';
		v.stamp_number='#(VERSION_STAMPNUMBER)';
		
				
		_root.wtf=new WTF();
		
		showticker=false;
		
		
// load version check in
//		mc_import=gfx.create_clip(_root,16384+32-18);
//		mc_import=gfx.create_clip(mc_popup,null);
//		_root.import_swf_name="http://wetdike.wetgenes.com/swf/WTF_import.swf";
//		_root.import_swf_name="http://www.wetgenes.local/swf/WTF_import.swf";
//		_root.import_swf_name="WTF_import.swf";
//		mc_import.loadMovie(_root.import_swf_name);
//		MochiAd.showPreloaderAd({id:"fd4f2c92a4131351", res:"640x480"});

	}
		
		
	function setup()
	{
				
		state_last=STATE_NONE;
		state=STATE_NONE;

// create master layout mc, I will do smart positioning and scaling
//		Stage.scaleMode="noScale";
//		Stage.align="TL";
		mc=gfx.create_clip(_root,null);
		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
		mc.cacheAsBitmap=true;

		
// mask off the master mc, unfortunatly this creates extra extra slowdown...
/*
		mcm=gfx.create_clip(_root,null);
		mc.setMask(mcm);
		gfx.clear(mcm);
		gfx.draw_box(mcm,null,0,0,800,600);
*/
		
		login=new Login(this);
		
		dikeabout=new PlayAbout(this);
		dikescores=new PlayHigh(this);
		
//		dikecomms=new WetDikeComms(this);

		dikeplay=new WetDikePlay(this);
		play=dikeplay; // dupe so new standard code finds it
		
		dikestats=new WetDikeStats(this);
		dikeswish=new WetDikeSwish(this);
		replay=new Replay(this);
		
		dikeaudit=new WetDikeAudit(this);
		
//		sock=new WetSpewSock(this);
//		talk=new WetSpewTalk(this);
		
//		dikecomms.setup();
		
		dikeswish.setup();

//		talk.setup();
//		talk.mc._x=800;
		
		var date=new Date();

//		game_seed=(Math.floor(((date.getTime()/1000))/(24*60*60))-10)&0xffff;
		game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
//		game_seed=Math.floor(Math.random()*65536)&0xffff;
//		state_next=STATE_PLAY;
		state_next="login";
		
//		Mouse.addListener(this);
//		Stage.addListener(this);

		_root.wetplay=new WetPlayIcon(_root);

		
//Mochi goood?
		__com_mochibot__("#(VERSION_MOCHIBOT)", _root, 10301);
	}
	
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
	
	function onMouseDown()
	{
//		replay.prekey_on(Replay.KEY_MBUTTON);
	}
	
	function onMouseUp()
	{
//		replay.prekey_off(Replay.KEY_MBUTTON);
	}

	function update()
	{
	
//pick which size we require depending on available space/aspect

		MainStatic.choose_and_apply_scalar(this);
/*
	
		if( ( Stage.width / Stage.height ) > (((800/600)+(1200/600))/2) )
		{
			if(_root.scalar.ox!=1200)
			{
				mc.scrollRect=new flash.geom.Rectangle(0, 0, 1200, 600);
				_root.scalar.ox=1200;
				_root.scalar.oy=600;
			}
		}
		else
		{
			if(_root.scalar.ox!=800)
			{
				mc.scrollRect=new flash.geom.Rectangle(0, 0, 800, 600);
				_root.scalar.ox=800;
				_root.scalar.oy=600;
			}
		}
	
	
		_root.scalar.apply(mc);
		_root.scalar.apply(mc_popup);
//		_root.scalar.apply(talk.mc_scalar);
*/

		if(!setup_done)
		{
//dbg.print("setup");

			if( (_root.loading.done) )
			{
				setup();
				setup_done=true;
				dikeplay.mc._y=600;				
				
//				dikeplay.clean();
//				dikeplay.setup(game_seed);
//				dikeplay.update();
				
			}
			
			MainStatic.update_do(_root.updates);
			return;
		}

		
		if( (_root.popup) || (dikeplay.mc._y!=0) )
		{
			showticker=false;
		}
		else
		{
			showticker=true;
		}
		
//dbg.print("here be dragons");

				
//		replay.premouse_x=mc._xmouse-400;	// use center of layout as zero
//		replay.premouse_y=mc._ymouse-300;
		
		if(state_next!=STATE_NONE)
		{
			_root[_root.click_name]=null;
			_root.click_idx++;
			if(_root.click_idx>4) { _root.clickfuncs_idx=0; }
			_root.click_name="click"+_root.click_idx;
			_root[_root.click_name]=null;
			
			switch(state)	// clean
			{
				case "play":
				case "menu":
				case STATE_PLAY:		dikeplay.clean();		break;
				
				case "login":			login.clean();		break;
			}
			
			state_last=state;	// change master state
			state=state_next;
			state_next=STATE_NONE;
			
// always do a layout thunk on state change
//			onResize();

			switch(state)	// setup
			{
				case "play":
				case "menu":
				case STATE_PLAY:		dikeplay.setup(game_seed);		break;
				
				case "login":			login.setup();		break;
			}
		}
			switch(state)	// update
			{
				case "play":
				case "menu":
				case STATE_PLAY:		dikeplay.update();		break;
				
				case "login":			login.update();		break;
			}
			
			MainStatic.update_do(_root.updates);
			
			dikeswish.update();
			dikeaudit.update();
//			talk.update();
	}
	
	function clean()
	{
	}
	
	static function setup_login()
	{
	}
	
	function do_str(str)
	{
		switch(str)
		{
			default:
			break;
			
			case "won":
			
				play.final_scores(null);
//				state_next=WetDike.STATE_PLAY;
				
			break;
			
			case "restart":
			
				play.final_scores(null);
				
//				state_next=WetDike.STATE_PLAY;
				
			break;
			
			case "shuffle":

				play.final_scores(Math.floor(Math.random()*65536)&0xffff);
				
//				game_seed=Math.floor(Math.random()*65536)&0xffff;
//				state_next=WetDike.STATE_PLAY;
				
			break;
			
			case "logoff":
			
				state_next="login";
			
			break;
		}
	}		
}


