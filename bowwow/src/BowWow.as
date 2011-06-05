/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class #(VERSION_NAME)
{
	var v;
	
	var state_last;
	var state;
	var state_next;

	var	setup_done=false;

	var mc;

	var login;
	var menu;
	var play;
	var about;
	var high;
	var code;
	
	var game_seed:Number=0;
	var next_game_seed;
	
	var old_time;
	var update_time;
	
	var logs={};
	
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
		orset_root("host","#(string.lower(VERSION_NAME)).wetgenes.com");
				
		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		
// overide only basic wetplay settings

		orset_root("wp_xspf","http://#(string.lower(VERSION_NAME)).wetgenes.com/swf/#(VERSION_NAME).xspf");
		orset_root("wp_auto",0);
		orset_root("wp_shuffle",0);
		orset_root("wp_back",0xff000000);
		orset_root("wp_fore",0xffffffff);
		
				
		_root.mc=_root;
		_root.cacheAsBitmap=false;		
		_root.newdepth=1;

		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		_root.updates=MainStatic.update_setup();	// a table of update functions
		
		_root.bmc=new bmcache();
		
		_root.scalar=new Scalar(800,600);
		_root.poker=new Poker(false);
		
		_root.loading=new Loading(true);
		
		_root.#(VERSION_ROOT)=new #(VERSION_NAME)();
		_root.signals=new BetaSignals(_root.#(VERSION_ROOT));
		_root.comms=new BetaComms(_root.#(VERSION_ROOT));
		
		_root.wetplay=new WetPlayIcon();
	}



	function #(VERSION_NAME)()
	{
		v=[];
		v.name='#(VERSION_NAME)';
		v.root='#(VERSION_ROOT)';
		v.site='#(VERSION_SITE)';
		v.number='#(VERSION_NUMBER)';
		v.stamp='#(VERSION_STAMP)';
		v.stamp_number='#(VERSION_STAMPNUMBER)';
				
		setup_done=false;
		
		
		mc=gfx.create_clip(_root,null);
		mc.onEnterFrame=delegate(update);
		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
		
				
		_root.wtf=new WTF("show_nowplaying");
		
// ask for advert details from server

//		lv_wonderful=new LoadVars();
//		lv_wonderful.onLoad = delegate(lv_wonderful_post,lv_wonderful);
//		lv_wonderful.sendAndLoad('http://swf.wetgenes.com/swf/wonderful.php?id=3489',lv_wonderful,"POST");
		
		{
		var cm;
		var cmi;
		var f;
		
			cm=MainStatic.get_base_context_menu(this);

			f=function()
			{
				this.state_next="menu";
			};
			cmi = new ContextMenuItem("Quit to Main Menu. (Retry)", delegate(f); );
			cm.customItems.push(cmi);
			
			_root.menu=cm;
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
		
		play=new #(VERSION_BASENAME)Play(this);
		menu=new #(VERSION_BASENAME)Menu(this);
		
		about=new PlayAbout(this);
		high =new PlayHigh(this,"results=bowwow");
		code=new PlayCode(this);
		
		
		state_next="login";
		
		_root.signals.signal("#(VERSION_NAME)","set",this);
	}	

	function update()
	{		
		var d=new Date();
		var new_time=d.getTime();
		
//dbg.print(Stage.width+" x "+Stage.height)

		MainStatic.choose_and_apply_scalar(this);

		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) && (_root.loading.done) && (!_root.wetplay.first_time))
//		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) )
		{
			_root.gotoAndStop(2); // frame 1 is preload, frame 2 is everything loaded
			setup();
			setup_done=true;
		}
		
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
			
			if(state)
			{
				this[state].setup();
			}
			
			old_time=new_time;
			update_time=0;
		}
		if(state)
		{
			update_time=Math.floor(update_time*3/4);
			update_time+=new_time-old_time;
//			if(update_time>=80) { dbg.print(update_time); }
			if(update_time>200) { update_time=200; }
			
			if(_root.noskipfps)
			{
				update_time=40;
			}
			
			while(update_time>=40)
			{
				MainStatic.update_do(_root.updates);
				
				this[state].update();
				
				update_time-=40;
			}
			
			old_time=new_time;
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
