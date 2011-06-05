/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class WetLinks
{
	var state_last;
	var state;
	var state_next;

	var	setup_done;

	var mc;

	var play;
	var login;
	var menu;
	
	var game_seed;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	static function main()
	{
		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		
		_root.cacheAsBitmap=false;		
		_root.newdepth=1;
		
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		
		_root.updates=MainStatic.update_setup();	// a table of update functions
		
		_root.scalar=new Scalar(468,60);
		_root.poker=new Poker(false);
		_root.loading=new Loading(false);
		
		_root.links=new WetLinks();		
	}



	function WetLinks()
	{
		setup_done=false;
		
		mc=gfx.create_clip(_root,null);
		mc.onEnterFrame=function(){_root.links.update()};//this.delegate(update);
		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
	}
		
	function setsize(x,y)
	{
		_root.scalar.ox=x;
		_root.scalar.oy=y;
		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
		_root.scalar.update();
		_root.scalar.apply(mc);
	}
	
	function setup()
	{
	var date=new Date();
	
		game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
		
		state_last=null;
		state=null;
		state_next=null;

		play=new WetLinksPlay(this);
		login=new Login(this,_root.style=="join"?"join":"");
		menu=play;
		
		if(_root.style=="join")
		{
			setsize(800,600);
			state_next="login";
		}
		else
		{
			state_next="play";
		}
		
	}	

	function update()
	{		
		_root.scalar.apply(mc);
		
		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) )
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
			
			if(state) { this[state].setup(); }
		}
		
		MainStatic.update_do(_root.updates);
		
		if(state)
		{
			this[state].update();
		}
	}
	
	function clean()
	{
	}

}
