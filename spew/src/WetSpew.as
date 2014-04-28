/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"




class #(VERSION_NAME)
{
	var state_last;
	var state;
	var state_next;

	var	setup_done;

	var mc;

	var talk;
	var sock;
	
	var game_seed;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	static function main()
	{
		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
		}
		orset_root("host","swf.wetgenes.com");

		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		
		_root.cacheAsBitmap=false;		
		_root.newdepth=1;
		
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		_root.updates#(CLASSVERSION)=MainStatic#(CLASSVERSION).update_setup();	// a table of update functions
		
		_root.scalar=new Scalar(400,600);
		_root.poker=new Poker(false);
		
		_root.spew=new #(VERSION_NAME)();
	}



	function #(VERSION_NAME)()
	{
		setup_done=false;
		
		mc=gfx.create_clip(_root,null);
		mc.onEnterFrame=this.delegate(update);
		gfx.setscroll(mc, 0, 0, _root.scalar.ox, _root.scalar.oy);
//		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
		
//	mc.cacheAsBitmap=true;

	}
		
	
	function setup()
	{
	var date=new Date();
	
		game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
		
		state_last=null;
		state=null;
		state_next=null;

		sock=new WetSpewSock(this);
		_root.sock=sock;
		
		talk=new WetSpewTalk(this);
		_root.talk=talk;
		
		_root.talk.setup();
		
		state_next="fake"; //fake state
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
			_root.poker.update();
			
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
			_root.poker.update();
			_root.sock.update();
			_root.talk.update(_root.poker.snapshot());
			
			this[state].update();
		}
	}
	
	function clean()
	{
	}

}
