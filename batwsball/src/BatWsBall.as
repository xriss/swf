/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class BatWsBall
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
	var high;
	var about;
	var code;
	
	var game_seed;
	var next_game_seed;
	
	var lv_wonderful;
	var wonderfulls;
	
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
		orset_root("host","batwsball.wetgenes.com");
		orset_root("wp_auto","0");
		orset_root("wp_back","0xcc000000");
		orset_root("wp_xspf","http://batwsball.wetgenes.com/swf/BatWsBall.xspf");

		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		


		_root._highquality=2; // default to high quality
		
		if( System.capabilities.version.split(" ")[0]=="WII" ) // set some defaults when run on the wii
		{
			_root._highquality=0; // low quality, performance is teh poopoo on teh wiiwii
			_root.wethidemochiads=true;
		}
		
		
		_root.mc=_root;
		
		_root.cacheAsBitmap=false;		
		_root.newdepth=1;
		
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		_root.updates=MainStatic.update_setup();	// a table of update functions
		
		_root.scalar=new Scalar(800,600);
		_root.poker=new Poker(false);
		
		_root.loading=new Loading(true);
		
		_root.replay=new Replay();
	
		_root.batwsball=new BatWsBall();
		
		_root.signals=new BetaSignals(_root.batwsball);
		_root.comms=new BetaComms(_root.batwsball);
		
		_root.wetplay=new WetPlayIcon();
/*		
		_root.sock=new WetSpewSock(_root);
		_root.talk=new WetSpewTalk(_root);
		_root.talk.setup();
		_root.talk.mc._x=800;
*/
		
	}



	function BatWsBall()
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
//		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
		

		
		
		_root.wtf=new WTF("show_nowplaying");
		
// ask for advert details from server

//		lv_wonderful=new LoadVars();
//		lv_wonderful.onLoad = delegate(lv_wonderful_post,lv_wonderful);
//		lv_wonderful.sendAndLoad('http://swf.wetgenes.com/swf/wonderful.php?id=2377',lv_wonderful,"POST");
		
		{
		var cm;
		var cmi;
		var f;
		
			cm=MainStatic.get_base_context_menu(this);

			f=function()
			{
				this.code.setup();
			};
			cmi = new ContextMenuItem("Get Embed Code!", delegate(f); );
			cm.customItems.push(cmi);
			
			f=function()
			{
				this.about.setup();
			};
			cmi = new ContextMenuItem("About?", delegate(f); );
			cm.customItems.push(cmi);
			
			_root.menu=cm;
		}
	}
	
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
		next_game_seed=null;
		
		state_last=null;
		state=null;
		state_next=null;

		login=new Login(this);
		play=new pung(this);
		menu=play;
		
		high =new PlayHigh(this);
		about=new PlayAbout(this);
		code=new PlayCode(this);

		
//		play=new WetDiamondsPlay(this);
		
		state_next="login";
		
		
// fake start...
//		pung.main_pung();
		
	}	

	function update()
	{
	
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
			
			if(next_game_seed)
			{
				game_seed=next_game_seed;
				next_game_seed=null;
			}
			
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
