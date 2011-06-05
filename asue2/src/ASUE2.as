/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#MAINCLASS=MAINCLASS or "ASUE2"

#(

STATES=STATES or
	{

	login="Login",
	
	play="ASUE2Play",
	
	about="PlayAbout",
	high="PlayHigh",
	code="PlayCode",
	
	menu=false,

	}

#)


#include "../base/src/Main.as"



#--[[

/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class ASUE2
{
	var v;
	
	var state_last;
	var state;
	var state_next;

	var	setup_done;

	var mc;

	var login;
	var menu;
	var play;
	
	var about;
	var high;
	var code;
	
	
	var game_seed;
	
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	static function main()
	{
		if(_root.kongregateServices!=undefined)
		{
			_root.kongregateServices.connect();
			_root.wethidemochiads=true; // kong disables them anyway
		}
		
		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
		}
		orset_root("host","asue2.wetgenes.com");
		orset_root("wp_back","0xcc000000");
		orset_root("wp_xspf","http://asue2.wetgenes.com/swf/ASUE2.xspf");
		
//		_root.gofaster=1; // default anim speed multiplier
			
		if( System.capabilities.version.split(" ")[0]=="WII" ) // set some defaults when run on the wii
		{
			_root._highquality=0; // low quality, performance is teh poopoo on teh wiiwii
			_root.wethidemochiads=true
			_root.gofaster=2.5;
		}
		
		
		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		
		_root._highquality=2;
		_root.mc=_root;
		
		_root.cacheAsBitmap=false;		
		_root.newdepth=1;
		
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		_root.updates=MainStatic.update_setup();	// a table of update functions
		

		_root.bmc=new bmcache();
		
		_root.scalar=new Scalar(800,600);
		_root.poker=new Poker(true);
		
		_root.loading=new Loading(true);
		
		_root.replay=new Replay();
	
		_root.asue2=new ASUE2();
		_root.signals=new BetaSignals(_root.asue2);
		_root.comms=new BetaComms(_root.asue2);
		
		_root.wetplay=new WetPlayIcon();
		

	}



	function ASUE2()
	{
		v=[];
		v.name='#(VERSION_NAME)';
		v.site='#(VERSION_SITE)';
		v.number='#(VERSION_NUMBER)';
		v.stamp='#(VERSION_STAMP)';
		v.stamp_number='#(VERSION_STAMPNUMBER)';
		
		
		setup_done=false;
		
		
		mc=gfx.create_clip(_root,null);
		mc.onEnterFrame=delegate(update);
		gfx.setscroll(mc, 0, 0, _root.scalar.ox, _root.scalar.oy);
		
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation

				
		_root.wtf=new WTF();
		
// ask for advert details from server

//		lv_wonderful=new LoadVars();
//		lv_wonderful.onLoad = delegate(lv_wonderful_post,lv_wonderful);
//		lv_wonderful.sendAndLoad('http://swf.wetgenes.com/swf/wonderful.php?id=3489',lv_wonderful,"POST");
		
		
		_root.menu=MainStatic.get_base_context_menu(this);
		
	}


	var lv_wonderful;
	var wonderfulls;
	
	function lv_wonderful_post()
	{
	var i;
	
		wonderfulls=[];
	
		for(i=0;i<10;i++)
		{
			wonderfulls[i]={ url:lv_wonderful["url"+i] , txt:lv_wonderful["txt"+i] , img:lv_wonderful["jpg"+i] , target:"_blank" };
		}
	}
		
	
	function setup()
	{
	var date=new Date();
	
		game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
		
		state_last=null;
		state=null;
		state_next=null;

		about=new PlayAbout(this);
		high =new PlayHigh(this);
		code =new PlayCode(this);
		
		login=new Login(this);
		play=new ASUE2Play(this);
		menu=play;
		
		state_next="login";
		
// cach some stuffs
		
//		System.security.allowDomain("4lfa.com");
//		_root.bmc.clear_loading();

/*		_root.bmc.remember( "icon4lfa" , bmcache.create_url , 
		{
			url:"http://4lfa.com/random/pngthumbs.php/icon.png" ,
			bmpw:100 , bmph:100 , bmpt:true , 
			hx:0 , hy:0
		} );
*/		

	}	

	function update()
	{
//		_root.bmc.check_loading();
	
//pick which size we require depending on available space/aspect
	
		MainStatic.choose_and_apply_scalar(this);
		
			
		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) && (_root.loading.done) )
		{
			_root.gotoAndStop(2); // frame 1 is preload, frame 2 is everything loaded			
			setup();
			setup_done=true;
		}
		
// go no further until we are loged in, loaded and setup
		if(!setup_done)
		{
			MainStatic.update_do(_root.updates);
			return;
		}	
		
		
		if(state_next!=null)
		{
			if(state) { this[state].clean(); }
			
			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			
			if(state) { this[state].setup(); }
		}
		if(state) 
		{
			MainStatic.update_do(_root.updates);
			this[state].update();
		}
	}
	
	function clean()
	{
	}

	var background_loop=null;
	function play_background_loop(nam)
	{
		if(nam!=background_loop)
		{
			_root.wetplay.PlaySFX(nam,3,0x7fffffff);
			background_loop=nam;
		}
	}
	
	var sfx_idx=0;
	function play_sfx(nam)
	{
		sfx_idx++;
		sfx_idx=sfx_idx%3;
		_root.wetplay.PlaySFX(nam,sfx_idx);
	}


	function do_str(str)
	{
		switch(str)
		{
			case "restart":			
				state_next="play";
			break;
			
			case "logoff":
				state_next="login";
			break;
		}
	}	
}


#]]
