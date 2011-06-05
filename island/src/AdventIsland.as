/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class Island
{
	var state_last;
	var state;
	var state_next;

	var	setup_done=false;

	var mc;
	var mc2;

	var login;
	var play;
	var menu;
	var about;
	var code;
	var high;
	var isplay:IsPlay;
	
	var game_seed:Number=0;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	static function main()
	{
		if(_root.kongregateServices!=undefined)
		{
			_root.kongregateServices.connect();
//			_root.wethidemochiads=true; // kong disables them anyway
		}

		_root.cacheAsBitmap=false;

		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
			_root[a]=b;
		}
		
		orset_root("host","adventisland.wetgenes.com");
		
// overide only basic wetplay settings
//		orset_root("wp_vol",0);
		orset_root("wp_xspf","http://adventisland.wetgenes.com/swf/AdventIsland.xspf");
		orset_root("wp_shuffle",1);
		orset_root("wp_back",0xff000000);
		orset_root("wp_fore",0xffffffff);
		
		
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		_root.updates=MainStatic.update_setup();	// a table of update functions
		
		_root.newdepth=1;
	
		_root.bmc=new bmcache();
		
		_root.scalar=new Scalar(800,600);
		_root.poker=new Poker(false);
		_root.loading=new Loading(true);
		
		
		_root.island=new Island();
		_root.signals=new BetaSignals(_root.island);
		_root.comms=new BetaComms(_root.island);
		
		_root.onEnterFrame=function()
		{
			_root.island.update();
		}
		
		_root.wetplay=new WetPlayIcon();
		
		_root.wtf=new WTF("show_nowplaying");
		
	}

	
	
	function setup()
	{
	var date=new Date();
		game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;

		
		state_last=null;
		state=null;
		state_next=null;

		
		mc=gfx.create_clip(_root,null);
		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
		
		mc2=gfx.create_clip(_root,null);
		

		login=new Login(this);
		isplay=new IsPlay(this);
		play=isplay;
		menu=isplay;
		about=new PlayAbout(this);
		code=new PlayCode(this);
		high=new PlayHigh(this);
		
		state_next="login";


//		_root.wetplay.setup();

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
	
	
}


