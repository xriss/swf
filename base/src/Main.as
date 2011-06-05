/*+-----------------------------------------------------------------------------------------------------------------+*/
//
//
// generic main include
//
// expects lua vars to be setup first
// 
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


#MAINCLASS=MAINCLASS or "Main"

#SCALEFLAGS=SCALEFLAGS or "640x480"

#(

STATES=STATES or
	{

	login="Login",
	
	play="Play",
	
	about="PlayAbout",
	high="PlayHigh",
	
	menu=false,

	}

#)



class #(MAINCLASS)
{
	var state_last;
	var state;
	var state_next;

	var	setup_done;

	var mc;

#	for i,v in pairs(STATES) do
	var #(i);
#	end

	var over;
	
	var game_seed;
	
	var next_game_seed;
	
	var old_time;
	var update_time;
	
	var v;
	
	var fast_update=false;
	
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
		orset_root("host","swf.wetgenes.com");
				
		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		
// overide only basic wetplay settings

		orset_root("wp_xspf","http://swf.wetgenes.com/swf/#(MAINCLASS).xspf");
		orset_root("wp_auto",0);
		orset_root("wp_shuffle",0);
		orset_root("wp_back",0xff000000);
		orset_root("wp_fore",0xffffffff);
		
		
		_root.cacheAsBitmap=false;		
		_root.newdepth=1;
		
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		
		_root.updates=MainStatic.update_setup();	// a table of update functions
		
		_root.bmc=new bmcache();

		_root.replay=new Replay();
		
		_root.scalar=new Scalar(640,480);
		_root.scale="#( SCALE_MODE or 'fixed' )"; // please do not scale?
		
		_root.poker=new Poker(false);
		_root.loading=new Loading(true);
		
		_root.main=new #(MAINCLASS)();
		_root.signals=new BetaSignals(_root.main);
		_root.comms=new BetaComms(_root.main);
		
		_root.wetplay=new WetPlayIcon();
		
		_root.main.fast_update=false;

	}



	function #(MAINCLASS)()
	{
	var date=new Date();
	var i;
	var t;
	var tt;
	var lev;
	var idx;
	
		v=[];
		v.name='#(VERSION_NAME)';
		v.site='#(VERSION_SITE)';
		v.number='#(VERSION_NUMBER)';
		v.stamp='#(VERSION_STAMP)';
		v.stamp_number='#(VERSION_STAMPNUMBER)';
		
		setup_done=false;
		
		game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
		next_game_seed=null;
		
		
		mc=gfx.create_clip(_root,null);
		mc.onEnterFrame=delegate(update);
		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
				
		_root.wtf=new WTF();//"show_nowplaying");
		
		{
		var cm;
		var cmi;
		var f;
		
			cm=MainStatic.get_base_context_menu(this);
			
			_root.menu=cm;
		}
		
		MainStatic.choose_and_apply_scalar(this,"#(SCALEFLAGS)");
	}
	
	function setup()
	{
	
		
		state_last=null;
		state=null;
		state_next=null;

#	for i,v in pairs(STATES) do
#		if v then
			#(i)=new #(v)(this);
#		end
#	end

#	if not STATES.menu then
		menu=play;
#	end
		
#if STATES.login then
		state_next="login";
#elseif STATES.menu then
		state_next="menu";
#elseif STATES.play then
		state_next="play";
#end
		
	}

	function update()
	{		
	var code_time=((new Date()).getTime());
	
		var d=new Date();
		var new_time=d.getTime();
		
		
		
//demand a widescreen mode always, since chat is very important
	
		MainStatic.choose_and_apply_scalar(this,"#(SCALEFLAGS)");
		
		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) && (_root.loading.done) && (!_root.wetplay.first_time))
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
			
			new_time=d.getTime();
			old_time=new_time;
			update_time=0;
		}
		if(state)
		{
			update_time=Math.floor(update_time*3/4);
			update_time+=new_time-old_time;
			if(update_time>200) { update_time=200; }
			while(update_time>=20)
			{
				MainStatic.update_do(_root.updates);
		
				this[state].update();
								
				update_time-=20;
				
				if(fast_update) break;
				if(_root.swish) break;
			}
			old_time=new_time;
		}
		
	_root.code_time+=((new Date()).getTime())-code_time;
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
				_root.bmc.forget("Login_Img"); // need new image...
			break;
		}
	}
}
